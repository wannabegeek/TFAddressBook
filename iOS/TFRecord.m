#import "TFRecord.h"
#import "TFAddressbook.h"
#import "TFMultiValue.h"

@implementation TFRecord

@synthesize _record;

- (id)initWithRef:(ABRecordRef)record {
	if (self = [super init]) {
		_record = record;
		CFRetain(_record);
	}
	return self;
}

- (id)init {
	if ((self = [super init])) {
	}
	return self;
}

- (id)initWithAddressbook:(TFAddressbook *)addressBook {
	[self doesNotRecognizeSelector:_cmd];
	return nil;
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

- (BOOL)removeValueForProperty:(TFPropertyID)property {
	CFErrorRef error;
	return (BOOL)ABRecordRemoveValue(_record, property, &error);
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
	return (BOOL)ABRecordSetValue(_record, property, (__bridge CFTypeRef)value, &err);
}

- (id)valueForProperty:(TFPropertyID)property {
	[self doesNotRecognizeSelector:_cmd];
	return nil;
}

- (NSString *)compositeName {
	return (__bridge_transfer NSString *)ABRecordCopyCompositeName(_record);
}

@end
