#import "TFRecord.h"
#import "TFAddressBook.h"
#import "TFMultiValue.h"

@implementation TFRecord

@synthesize _record;

- (id)initWithRef:(ABRecordRef)record addressbook:(TFAddressBook *)addressbook {
	if (self = [super init]) {
		_record = record;
		CFRetain(_record);
		_addressbook = addressbook;
	}
	return self;
}

- (id)init {
	return [self initWithAddressBook:[TFAddressBook sharedAddressBook]];
}

- (id)initWithAddressBook:(TFAddressBook *)addressbook {
	if ((self = [super init])) {
		_addressbook = addressbook;
	}
	return self;
}

- (void)dealloc {
	if (_record) {
		CFRelease(_record);
	}
}


- (TFRecordID)uniqueId {
	ABRecordID recordId = ABRecordGetRecordID(_record);
	if (recordId == kABRecordInvalidID) {
		return nil;
	} else {
		return [NSString stringWithFormat:@"%d", recordId];
	}
}

- (BOOL)isReadOnly {
	return NO;
}

- (BOOL)removeValueForProperty:(TFPropertyID)property {
	CFErrorRef error;
	BOOL success = (BOOL)ABRecordRemoveValue(_record, property, &error);
/*
	if (success) {
		NSDictionary *changedDict = [NSDictionary dictionaryWithObjectsAndKeys:[NSArray arrayWithObject:[self uniqueId]], kTFUpdatedRecords, nil];
		[[NSNotificationCenter defaultCenter] postNotificationName:kTFDatabaseChangedNotification object:nil userInfo:changedDict];
	}
 */
	return success;
}

- (BOOL)setValue:(id)value forProperty:(TFPropertyID)property {
	NSError *error;
	return [self setValue:value forProperty:property error:&error];
}

- (BOOL)setValue:(id)value forProperty:(TFPropertyID)property error:(NSError **)error {
	if ([value isKindOfClass:[TFMultiValue class]]) {
		value = (__bridge id)((TFMultiValue *)value).nativeObject;
	}

	CFErrorRef err = (__bridge CFErrorRef)*error;
	BOOL success = (BOOL)ABRecordSetValue(_record, property, (__bridge CFTypeRef)value, &err);
/*
	if (success) {
		NSDictionary *changedDict = [NSDictionary dictionaryWithObjectsAndKeys:[NSArray arrayWithObject:[self uniqueId]], kTFUpdatedRecords, nil];
		[[NSNotificationCenter defaultCenter] postNotificationName:kTFDatabaseChangedNotification object:nil userInfo:changedDict];
	}
 */
	return success;
}

- (id)valueForProperty:(TFPropertyID)property {
	[self doesNotRecognizeSelector:_cmd];
	return nil;
}

- (BOOL)isEqual:(id)obj {
	return (obj == self || ([obj isKindOfClass:[self class]] && _record == ((TFRecord *)obj).nativeObject));
}

@end
