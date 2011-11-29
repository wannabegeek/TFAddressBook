#import "TFConstants.h"

@class TFSearchElement, TFRecord;

@interface TFAddressBook : NSObject {
	ABAddressBookRef _addressbook;
	id<TFABAddressbookDelegate> *_delegate;
}

+ (TFAddressbook *)sharedAddressbook;
+ (TFAddressbook *)addressbook;

@property (weak) id<TFAddressBookDelegate> delegate;

- (BOOL)addRecord:(TFRecord *)record;
- (BOOL)addRecord:(TFRecord *)record error:(NSError **)error;
- (BOOL)removeRecord:(TFRecord *)record;
- (BOOL)removeRecord:(TFRecord *)record error:(NSError **)error;

- (BOOL)save;
- (BOOL)saveAndReturnError:(NSError **)error;
- (BOOL)hasUnsavedChanges;

- (TFRecord *)recordForUniqueId:(TFRecordID)uniqueId;
- (TFRecordType)recordClassFromUniqueId:(TFRecordID)uniqueId;

- (NSArray *)people;
- (NSArray *)groups;

- (TFDefaultNameOrdering)defaultNameOrdering;
- (NSString *)defaultCountryCode;

- (NSArray *)recordsMatchingSearchElement:(TFSearchElement *)search;

@end
