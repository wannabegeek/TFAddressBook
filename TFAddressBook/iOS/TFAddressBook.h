#import "TFGlobals.h"

@class TFSearchElement, TFRecord;

@interface TFAddressBook : NSObject {
@private
	ABAddressBookRef _addressbook;
	NSMutableDictionary *_updatableObjects;
}

@property (readonly, getter=nativeObject) ABAddressBookRef _addressbook;

+ (TFAddressBook *)sharedAddressBook;
+ (TFAddressBook *)addressBook;

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
