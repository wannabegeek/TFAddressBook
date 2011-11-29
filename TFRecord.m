#import "TFRecord.h"

@implementation TFRecord

- (id)initWithRef:(ABRecordRef)record {
	if (self = [super init]) {
		_record = record;
		CFRetain(_record);
	}
	return self;
}

- (id)init {
	return [self initWithAddressBook:[TFAddressbook sharedAddressbook]];
}

- (id)initWithAddressBook:(TFAddressBook *)addressBook {
	[self doesNotRecognize:_cmd];
}

- (void)dealloc {
	CFRelease(_record);
}


- (TFRecordID)uniqueId {
	return ABRecordGetRecordID(_record);
}

- (BOOL)isReadOnly {
	return NO;
}

- (BOOL)removeValueForProperty:(NSString *)property {
	CFErrorRef error;
	return (BOOL)ABRecordRemoveValue(_record, property, error);
}

- (BOOL)setValue:(id)value forProperty:(NSString *)property {
	NSError *error;
	return [self setValue:value forProperty:property error:&error];
}

- (BOOL)setValue:(id)value forProperty:(NSString *)property error:(NSError **)error {
	if ([value isKindOfClass:[TFMultiValue class]]) {
		value = (id)((TFMultiValue *)value).nativeObject;
	}

	return (BOOL)ABRecordSetValue(_addressbook, property, (__bridge CFTypeRef)value, (__bridge CFErrorRef *)error);
}

- (id)valueForProperty:(NSString *)property {
	CFTypeRef value = ABRecordCopyValue(_record, property);
	if (value == NULL) {
		return nil;
	}
	id result = nil;

	// check the property type & convert as appropriate

	return result;
}

- (NSString *)compositeName {
	return (__bridge_transfer NSString *)ABRecordCopyCompositeName(_record);
}

@end
