#import "TFAddressBook.h"
#import "TFPerson.h"
#import "TFGroup.h"

@interface TFAddressBook (private)
- (void)_externalChangeNotification;
- (void)_prepareForExternalNotifications;
@end

static void _externalChangeNotification(ABAddressBookRef bookRef, CFDictionaryRef info, void * context) {
    TFAddressBook *obj = (__bridge TFAddressBook *)context;
    [obj _externalChangeNotification];
}

@implementation TFAddressBook

@synthesize _addressbook;

+ (TFAddressBook *)sharedAddressBook {
	static dispatch_once_t onceToken = 0;
	__strong static TFAddressBook *_addressbook = nil;
	dispatch_once(&onceToken, ^{
		_addressbook = [TFAddressBook addressBook];
		[_addressbook _prepareForExternalNotifications];
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
	if (success && [record uniqueId] != nil) {
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
	if (success && [record uniqueId] != nil) {
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
	return [[TFPerson alloc] initWithRef:person addressbook:self];
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
		[people addObject:[[TFPerson alloc] initWithRef:person addressbook:self]];
	}
	return people;
}

- (NSArray *)groups {
	NSMutableArray *groups = [NSMutableArray array];
	NSArray *allGroups = (__bridge_transfer NSArray *)ABAddressBookCopyArrayOfAllGroups(_addressbook);
	for (NSUInteger i=0; i<[allGroups count]; i++) {
		ABRecordRef group = (__bridge ABRecordRef)[allGroups objectAtIndex:i];
		[groups addObject:[[TFGroup alloc] initWithRef:group addressbook:self]];
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

- (NSArray *)recordsMatchingSearchElement:(TFSearchElement *)search {
	NSArray *people = [self people];
	
	NSIndexSet *indexSet = [people indexesOfObjectsPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
		return [search matchesRecord:obj];
	}];
	
	return [people objectsAtIndexes:indexSet];
}

- (void)_prepareForExternalNotifications {
	_updatableObjects = [NSMutableDictionary dictionary];
	NSArray *allPeople = (__bridge_transfer NSArray *)ABAddressBookCopyArrayOfAllPeople(_addressbook);
	for (NSUInteger i=0; i<[allPeople count]; i++) {
		ABRecordRef person = (__bridge ABRecordRef)[allPeople objectAtIndex:i];
		ABRecordID recordId = ABRecordGetRecordID(person);
		NSDate *lastModified = (__bridge_transfer NSDate *)ABRecordCopyValue(person, kABPersonModificationDateProperty);
		[_updatableObjects setObject:lastModified forKey:[NSString stringWithFormat:@"%d", recordId]];
	}
	
	ABAddressBookRegisterExternalChangeCallback(_addressbook, _externalChangeNotification, (__bridge void *)self);
}

- (void)_externalChangeNotification {
	TFAddressBook *tempAb = [TFAddressBook addressBook];
	NSArray *allPeople = (__bridge_transfer NSArray *)ABAddressBookCopyArrayOfAllPeople(tempAb.nativeObject);

	NSMutableSet *inserted = [NSMutableSet set];
	NSMutableSet *updated = [NSMutableSet set];
	NSMutableSet *deleted = [NSMutableSet setWithArray:[_updatableObjects allKeys]];
	
	for (NSUInteger i=0; i<[allPeople count]; i++) {
		ABRecordRef person = (__bridge ABRecordRef)[allPeople objectAtIndex:i];
		NSString *recordId = [NSString stringWithFormat:@"%d", ABRecordGetRecordID(person)];
		NSDate *lastModified = (__bridge_transfer NSDate *)ABRecordCopyValue(person, kABPersonModificationDateProperty);
		
		NSDate *lastKnownUpdate = [_updatableObjects objectForKey:recordId];
		if (lastKnownUpdate == nil) {
			[_updatableObjects setObject:lastModified forKey:recordId];
			[inserted addObject:recordId];
		} else if (![lastKnownUpdate isEqualToDate:lastModified]) {
			[_updatableObjects setObject:lastModified forKey:recordId];
			[updated addObject:recordId];
		}
		
		// We still have it, not been removed
		[deleted removeObject:recordId];
	}
	
	if ([inserted count] != 0 || [updated count] != 0 || [deleted count] != 0) {
		NSDictionary *changed = [NSDictionary dictionaryWithObjectsAndKeys:inserted, kTFInsertedRecords, updated, kTFUpdatedRecords, deleted, kTFDeletedRecords, nil];
		[[NSNotificationCenter defaultCenter] postNotificationName:kTFDatabaseChangedExternallyNotification object:self userInfo:changed];
	}
}

@end
