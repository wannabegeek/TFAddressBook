
#import "TFConstants.h"

@interface TFRecord {
	ABRecordRef _record;
}

- (id)initWithRef:(ABRecordRef)record;

- (id)initWithAddressBook:(TFAddressBook *)addressBook;
- (TFRecordID)uniqueId;
- (BOOL)isReadOnly;
- (BOOL)removeValueForProperty:(NSString *)property;
- (BOOL)setValue:(id)value forProperty:(NSString *)property;
- (BOOL)setValue:(id)value forProperty:(NSString *)property error:(NSError **)error;
- (id)valueForProperty:(NSString *)property;

- (NSString *)compositeName;

