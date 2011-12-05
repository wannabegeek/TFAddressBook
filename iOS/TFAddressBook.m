#import "TFAddressBook.h"
#import "TFPerson.h"
#import "TFGroup.h"

@interface TFAddressBook (private)
- (void)externalChangeNotification;
@end

static void _externalChangeNotification(ABAddressBookRef bookRef, CFDictionaryRef info, void * context) {
    TFAddressBook *obj = (__bridge TFAddressBook *)context;
    [obj externalChangeNotification];
}

@implementation TFAddressBook

@synthesize _addressbook;

+ (TFAddressBook *)sharedAddressBook {
	static dispatch_once_t onceToken = 0;
	__strong static TFAddressBook *_addressbook = nil;
	dispatch_once(&onceToken, ^{
		_addressbook = [TFAddressBook addressBook];
		ABAddressBookRegisterExternalChangeCallback(_addressbook.nativeObject, _externalChangeNotification, (__bridge void *)_addressbook);
	});
	return _addressbook;
}

+ (TFAddressBook *)addressBook {
	return [[TFAddressBook alloc] init];
}

- (id)init {
	if (self = [super init]) {
		_addressbook = ABAddressBookCreate();
		CFRetain(_addressbook);
	}

	return self;
}

- (void)dealloc {
//	ABAddressBookUnregisterExternalChangeCallback(_addressbook, _externalChangeNotification, self);
	CFRelease(_addressbook);
}

- (BOOL)addRecord:(TFRecord *)record {
	NSError *error;
	return [self addRecord:record error:&error];
}

- (BOOL)addRecord:(TFRecord *)record error:(NSError **)error {
	CFErrorRef err = (__bridge CFErrorRef)*error;
	BOOL success = (BOOL)ABAddressBookAddRecord(_addressbook, record.nativeObject, &err);
/*
	if (success) {
		NSDictionary *changedDict = [NSDictionary dictionaryWithObjectsAndKeys:[NSArray arrayWithObject:[record uniqueId]], kTFInsertedRecords, nil];
		[[NSNotificationCenter defaultCenter] postNotificationName:kTFDatabaseChangedNotification object:self userInfo:changedDict];
	}
 */
	return success;
}

- (BOOL)removeRecord:(TFRecord *)record {
	NSError *error;
	return (BOOL)[self removeRecord:record error:&error];
}

- (BOOL)removeRecord:(TFRecord *)record error:(NSError **)error {
	CFErrorRef err = (__bridge CFErrorRef)*error;
	BOOL success = (BOOL)ABAddressBookRemoveRecord(_addressbook, record.nativeObject, &err);
/*
	if (success) {
		NSDictionary *changedDict = [NSDictionary dictionaryWithObjectsAndKeys:[NSArray arrayWithObject:[record uniqueId]], kTFDeletedRecords, nil];
		[[NSNotificationCenter defaultCenter] postNotificationName:kTFDatabaseChangedNotification object:self userInfo:changedDict];
	}
 */
	return success;
}

- (BOOL)save {
	NSError *error;
	return [self saveAndReturnError:&error];
}

- (BOOL)saveAndReturnError:(NSError **)error {
	BOOL success = YES;
	if ([self hasUnsavedChanges]) {
		CFErrorRef err = (__bridge CFErrorRef)*error;
		success = (BOOL)ABAddressBookSave(_addressbook, &err);
	}
	return success;
}

- (BOOL)hasUnsavedChanges {
	return ABAddressBookHasUnsavedChanges(_addressbook);
}

- (TFRecord *)recordForUniqueId:(TFRecordID)uniqueId {
	ABRecordRef person = ABAddressBookGetPersonWithRecordID(_addressbook, [uniqueId integerValue]);
	if(person == NULL) {
		return nil;
	}
	return [[TFPerson alloc] initWithRef:person];
}

- (TFRecordType)recordClassFromUniqueId:(TFRecordID)uniqueId {
	if (ABRecordGetRecordType([self recordForUniqueId:uniqueId].nativeObject) == kABPersonType) {
		return kTFPersonType;
	} else {
		return kTFGroupType;
	}
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
	return [[NSLocale currentLocale] objectForKey:NSLocaleCountryCode];
}

//- (NSArray *)filterArray:(NSArray *)array withPredicate:

- (NSArray *)recordsMatchingSearchElement:(TFSearchElement *)search {
	//return [[self people] filteredArrayUsingPredicate:search.searchPredicate];
	NSArray *people = [self people];
	
	NSIndexSet *indexSet = [people indexesOfObjectsPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
		return [search matchesRecord:obj];
	}];
	
	return [people objectsAtIndexes:indexSet];
}

- (void)externalChangeNotification {
	[[NSNotificationCenter defaultCenter] postNotificationName:kTFDatabaseChangedExternallyNotification object:self userInfo:nil];
}

@end
