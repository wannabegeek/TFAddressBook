#import "TFAddressbook.h"

@implementation TFAddressBook

+ (TFAddressbook *)sharedAddressbook {
	static dispatch_once_t onceToken = 0;
	__strong static TFAddressBook *_addressbook = nil;
	dispatch_once(&onceToken, ^{
		_addressbook = [TFAddressBook addressBook];
	});
	return _addressbook;
}

+ (TFAddressbook *)addressbook {
	return [[TFAddressbook alloc] init];
}

- (id)init {
	if (self = [super init]) {
		_addressbook = ABAddressBookCreate();
		CFRetain(_addressbook);
	}

	return self;
}

- (void)dealloc {
	CFRelease(_addressbook);
}

- (BOOL)addRecord:(TFRecord *)record {
	NSError *error;
	[self addRecord:record error:&error];
}

- (BOOL)addRecord:(TFRecord *)record error:(NSError **)error {
	return (BOOL)ABAddressBookAddRecord(_addressbook, record.nativeObject, (__bridge CFErrorRef *)error);
}

- (BOOL)removeRecord:(TFRecord *)record {
	NSError *error;
	[self removeRecord:record error:&error];
}

- (BOOL)removeRecord:(TFRecord *)record error:(NSError **)error {
	return (BOOL)ABAddressBookRemoveRecord(_addressbook, record.nativeObject, (__bridge CFErrorRef *)error);
}

- (BOOL)save {
	NSError *error;
	return [self saveAndReturnError:&error];
}

- (BOOL)saveAndReturnError:(NSError **)error {
	return (BOOL)ABAddressBookSave(_addressbook, (__bridge CFErrorRef *)error);
}

- (BOOL)hasUnsavedChanges {
	return ABAddressBookHasUnsavedChanges(_addressbook);
}

- (TFRecord *)recordForUniqueId:(TFRecordID)uniqueId {
	ABRecordRef person = ABAddressBookGetPersonWithRecordID(_addressbook, uniqueId);
	if(person == NULL) {
		return nil;
	}
	return [[TFPerson alloc] initWithRef:person];
}

- (TFRecordType)recordClassFromUniqueId:(TFRecordID)uniqueId 
	return ABRecordGetRecordID([self recordForUniqueId:uniqueId]);
}


- (NSArray *)people {
	NSMutableArray *people = [NSMutableArray array];
	NSArray *allPeople = (__bridge_transfer NSArray *)ABAddressBookCopyArrayOfAllPeople(_addressbook);
	for (NSUInteger i=0; i<[allPeople count]; i++) {
		ABRecordRef person = (__bridge ABRecordRef)[allPeople objectAtIndex:i];
		[people addObject:[[TFPerson alloc] initWithRef:person]];
	}
	return people;
}

- (NSArray *)groups {
	NSMutableArray *groups = [NSMutableArray array];
	NSArray *allGroups = (__bridge_transfer NSArray *)ABAddressBookCopyArrayOfAllGroups(_addressbook);
	for (NSUInteger i=0; i<[allGroups count]; i++) {
		ABRecordRef group = (__bridge ABRecordRef)[allGroups objectAtIndex:i];
		[groups addObject:[[TFGroup alloc] initWithRef:group]];
	}
	return groups;
}

- (TFDefaultNameOrdering)defaultNameOrdering {
	if (ABPersonGetCompositeNameFormat() == kABPersonCompositeNameFormatFirstNameFirst) {
		return kTFFirstNameFirst;
	}
	return kTFLastNameFirst;
}

- (NSString *)defaultCountryCode {
#warning Not implemented yet
}

- (NSArray *)recordsMatchingSearchElement:(TFSearchElement *)search {
#warning Not implemented yet
}

@end
