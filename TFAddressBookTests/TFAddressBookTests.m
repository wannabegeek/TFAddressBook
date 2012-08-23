//
//  TFAddressBookTests.m
//  TFAddressBookTests
//
//  Created by Tom Fewster on 30/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "TFAddressBookTests.h"
#import <TFAddressBook/TFABAddressBook.h>

@implementation TFAddressBookTests

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
	[[TFAddressBook sharedAddressBook] save];
	NSLog(@"Default Country code is: '%@'", [[TFAddressBook sharedAddressBook] defaultCountryCode]);
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)testAddressbookCount
{
	NSUInteger count = [[[TFAddressBook sharedAddressBook] people] count];
	NSLog(@"Addressbook contains %lu people", (unsigned long)count);
	STAssertFalse(count == 0, @"Addressbook should contain atleast 1 person");
}

- (void)testHasChanges
{
	TFAddressBook *addressbook = [TFAddressBook addressBook];
	STAssertFalse([addressbook hasUnsavedChanges], @"What addressbook changes do we have?");
	//NSUInteger beforeCount = [[addressbook people] count];
	TFPerson *person = [[TFPerson alloc] initWithAddressBook:addressbook];
	[person setValue:@"Test" forProperty:kTFFirstNameProperty];
	[person setValue:@"User" forProperty:kTFLastNameProperty];
	STAssertTrue([addressbook hasUnsavedChanges], @"We added someone where have they gone?");
/*
	[[TFAddressBook sharedAddressbook] revert];
	STAssertTrue([[TFAddressBook sharedAddressbook] hasUnsavedChanges], @"We reverted the DB, are they still there?");
*/
	
	//	NSUInteger afterCount = [[addressbook people] count];
	//	STAssertEquals(beforeCount + 1, afterCount, @"We added a record (& only 1) ([before]%d + 1 != [after]%d)", beforeCount, afterCount);
}

- (void)testMatchingSearching {
	STAssertFalse([[TFAddressBook sharedAddressBook] hasUnsavedChanges], @"What addressbook changes do we have - the rest of this test may fail");
	TFSearchElement *firstnameSearch = [TFPerson searchElementForProperty:kTFFirstNameProperty label:nil key:nil value:@"Test" comparison:kTFEqual];
	TFSearchElement *lastnameSearch = [TFPerson searchElementForProperty:kTFLastNameProperty label:nil key:nil value:@"User" comparison:kTFEqual];

	NSUInteger firstNameInitialCount = [[[TFAddressBook sharedAddressBook] recordsMatchingSearchElement:firstnameSearch] count];
	NSUInteger lastNameInitialCount = [[[TFAddressBook sharedAddressBook] recordsMatchingSearchElement:lastnameSearch] count];

	
	TFPerson *person = [[TFPerson alloc] initWithAddressBook:[TFAddressBook sharedAddressBook]];
	[person setValue:@"Test" forProperty:kTFFirstNameProperty];
	[person setValue:@"User" forProperty:kTFLastNameProperty];
	STAssertTrue([[TFAddressBook sharedAddressBook] save], @"For some reason saving the addressbook failed");
	
	NSArray *results1 = [[TFAddressBook sharedAddressBook] recordsMatchingSearchElement:firstnameSearch];
	STAssertEquals(firstNameInitialCount + 1, [results1 count], @"We added a new record that should match, we didn't find it ([before]%d + 1 != [after]%d)", firstNameInitialCount, [results1 count]);
	NSLog(@"%lu results found for firstName search", (unsigned long)[results1 count]);

	NSArray *results2 = [[TFAddressBook sharedAddressBook] recordsMatchingSearchElement:lastnameSearch];
	STAssertEquals(lastNameInitialCount + 1, [results2 count], @"We added a new record that should match, we didn't find it ([before]%d + 1 != [after]%d)", lastNameInitialCount, [results2 count]);
	NSLog(@"%lu results found for lastName search", (unsigned long)[results2 count]);

	NSArray *results3 = [[TFAddressBook sharedAddressBook] recordsMatchingSearchElement:[TFSearchElement searchElementForConjunction:kTFSearchAnd children:[NSArray arrayWithObjects:firstnameSearch, lastnameSearch, nil]]];
	STAssertEquals(firstNameInitialCount + 1, [results3 count], @"We added a new record that should match, we didn't find it ([before]%d + 1 != [after]%d)", firstNameInitialCount, [results3 count]);
	NSLog(@"%lu results found for firstName & lastName composite search", (unsigned long)[results3 count]);

	
	TFMutableMultiValue *multiValue = [[TFMutableMultiValue alloc] init];
	
	NSMutableDictionary *addressDictionary = [NSMutableDictionary dictionary];
	[addressDictionary setValue:@"First Line" forKey:kTFAddressStreetKey];
	[addressDictionary setValue:@"My City" forKey:kTFAddressCityKey];
	[addressDictionary setValue:@"My Country" forKey:kTFAddressCountryKey];
	[multiValue insertValue:addressDictionary withLabel:@"Home Somewhere" atIndex:0];

	[person setValue:multiValue forProperty:kTFAddressProperty];

	TFSearchElement *addressPositiveSearch = [TFPerson searchElementForProperty:kTFAddressProperty label:nil key:kTFAddressStreetKey value:@"First Line" comparison:kTFEqual];
	NSArray *results4 = [[TFAddressBook sharedAddressBook] recordsMatchingSearchElement:[TFSearchElement searchElementForConjunction:kTFSearchAnd children:[NSArray arrayWithObjects:firstnameSearch, lastnameSearch, addressPositiveSearch, nil]]];
	STAssertEquals(firstNameInitialCount + 1, [results4 count], @"We added a new record that should match, we didn't find it ([before]%d + 1 != [after]%d)", firstNameInitialCount, [results4 count]);	

	TFSearchElement *addressNegativeSearch = [TFPerson searchElementForProperty:kTFAddressProperty label:nil key:kTFAddressStreetKey value:@"NOT THERE" comparison:kTFNotEqual];
	NSArray *results5 = [[TFAddressBook sharedAddressBook] recordsMatchingSearchElement:[TFSearchElement searchElementForConjunction:kTFSearchAnd children:[NSArray arrayWithObjects:firstnameSearch, lastnameSearch, addressNegativeSearch, nil]]];
	STAssertEquals(firstNameInitialCount + 1, [results5 count], @"We added a new record that should match, we didn't find it ([before]%d + 1 != [after]%d)", firstNameInitialCount, [results5 count]);	

	addressPositiveSearch = [TFPerson searchElementForProperty:kTFAddressProperty label:@"Home Somewhere" key:kTFAddressStreetKey value:@"First Line" comparison:kTFEqual];
	results4 = [[TFAddressBook sharedAddressBook] recordsMatchingSearchElement:[TFSearchElement searchElementForConjunction:kTFSearchAnd children:[NSArray arrayWithObjects:firstnameSearch, lastnameSearch, addressPositiveSearch, nil]]];
	STAssertEquals(firstNameInitialCount + 1, [results4 count], @"We added a new record that should match, we didn't find it ([before]%d + 1 != [after]%d)", firstNameInitialCount, [results4 count]);	
	
	addressNegativeSearch = [TFPerson searchElementForProperty:kTFAddressProperty label:@"Home Somewhere" key:kTFAddressStreetKey value:@"NOT THERE" comparison:kTFNotEqual];
	results5 = [[TFAddressBook sharedAddressBook] recordsMatchingSearchElement:[TFSearchElement searchElementForConjunction:kTFSearchAnd children:[NSArray arrayWithObjects:firstnameSearch, lastnameSearch, addressNegativeSearch, nil]]];
	STAssertEquals(firstNameInitialCount + 1, [results5 count], @"We added a new record that should match, we didn't find it ([before]%d + 1 != [after]%d)", firstNameInitialCount, [results5 count]);	

	[[TFAddressBook sharedAddressBook] removeRecord:person];
	STAssertTrue([[TFAddressBook sharedAddressBook] save], @"For some reason saving the addressbook failed");
}

- (void)testUnmatchingSearching {
	STAssertFalse([[TFAddressBook sharedAddressBook] hasUnsavedChanges], @"What addressbook changes do we have - the rest of this test may fail");
	TFSearchElement *firstnameSearch = [TFPerson searchElementForProperty:kTFFirstNameProperty label:nil key:nil value:@"fdhgfjhfsdkjd" comparison:kTFEqual];
	TFSearchElement *lastnameSearch = [TFPerson searchElementForProperty:kTFLastNameProperty label:nil key:nil value:@"XXXXXXXXXXXXXXXXX" comparison:kTFEqual];
	
	NSUInteger firstNameInitialCount = [[[TFAddressBook sharedAddressBook] recordsMatchingSearchElement:firstnameSearch] count];
	NSUInteger lastNameInitialCount = [[[TFAddressBook sharedAddressBook] recordsMatchingSearchElement:lastnameSearch] count];
	
	
	TFPerson *person = [[TFPerson alloc] initWithAddressBook:[TFAddressBook sharedAddressBook]];
	[person setValue:@"Test" forProperty:kTFFirstNameProperty];
	[person setValue:@"XXXXXXXXXXXXXXXXX" forProperty:kTFLastNameProperty];
	STAssertTrue([[TFAddressBook sharedAddressBook] save], @"For some reason saving the addressbook failed");
	
	NSArray *results1 = [[TFAddressBook sharedAddressBook] recordsMatchingSearchElement:firstnameSearch];
	STAssertEquals(firstNameInitialCount, [results1 count], @"We added a new record but search shouldn't match, where did it come from ([before]%d != [after]%d)", firstNameInitialCount, [results1 count]);
	NSLog(@"%lu results found for firstName search", (unsigned long)[results1 count]);
	
	NSArray *results2 = [[TFAddressBook sharedAddressBook] recordsMatchingSearchElement:lastnameSearch];
	STAssertEquals(lastNameInitialCount + 1, [results2 count], @"We added a new record that should match, we didn't find it ([before]%d + 1 != [after]%d)", lastNameInitialCount, [results2 count]);
	NSLog(@"%lu results found for lastName search", (unsigned long)[results2 count]);

	NSArray *results3 = [[TFAddressBook sharedAddressBook] recordsMatchingSearchElement:[TFSearchElement searchElementForConjunction:kTFSearchAnd children:[NSArray arrayWithObjects:firstnameSearch, lastnameSearch, nil]]];
	STAssertEquals(firstNameInitialCount, [results3 count], @"We added a new record that shouldn't match, we found something ([before]%d + 1 != [after]%d)", firstNameInitialCount, [results3 count]);
	NSLog(@"%lu results found for firstName & lastName composite search", (unsigned long)[results3 count]);

	NSArray *results4 = [[TFAddressBook sharedAddressBook] recordsMatchingSearchElement:[TFSearchElement searchElementForConjunction:kTFSearchOr children:[NSArray arrayWithObjects:firstnameSearch, lastnameSearch, nil]]];
	STAssertEquals(firstNameInitialCount + 1, [results4 count], @"We added a new record that should match, we didn't find it ([before]%d + 1 != [after]%d)", [results4 count]);
	NSLog(@"%lu results found for firstName & lastName composite search", (unsigned long)[results4 count]);

	TFMutableMultiValue *multiValue = [[TFMutableMultiValue alloc] init];
	NSMutableDictionary *addressDictionary = [NSMutableDictionary dictionary];
	[addressDictionary setValue:@"First Line" forKey:kTFAddressStreetKey];
	[addressDictionary setValue:@"My City" forKey:kTFAddressCityKey];
	[addressDictionary setValue:@"My Country" forKey:kTFAddressCountryKey];
	[multiValue insertValue:addressDictionary withLabel:@"Home Somewhere" atIndex:0];
	[person setValue:multiValue forProperty:kTFAddressProperty];
	
	TFSearchElement *addressPositiveSearch = [TFPerson searchElementForProperty:kTFAddressProperty label:nil key:kTFAddressStreetKey value:@"First Line" comparison:kTFEqual];
	NSArray *results5 = [[TFAddressBook sharedAddressBook] recordsMatchingSearchElement:[TFSearchElement searchElementForConjunction:kTFSearchAnd children:[NSArray arrayWithObjects:firstnameSearch, lastnameSearch, addressPositiveSearch, nil]]];
	STAssertEquals(firstNameInitialCount, [results5 count], @"We added a new record that should match, we didn't find it ([before]%d + 1 != [after]%d)", firstNameInitialCount, [results5 count]);	
	
	TFSearchElement *addressNegativeSearch = [TFPerson searchElementForProperty:kTFAddressProperty label:nil key:kTFAddressStreetKey value:@"NOT THERE" comparison:kTFNotEqual];
	results5 = [[TFAddressBook sharedAddressBook] recordsMatchingSearchElement:[TFSearchElement searchElementForConjunction:kTFSearchAnd children:[NSArray arrayWithObjects:firstnameSearch, lastnameSearch, addressNegativeSearch, nil]]];
	STAssertEquals(firstNameInitialCount, [results5 count], @"We added a new record that should match, we didn't find it ([before]%d + 1 != [after]%d)", firstNameInitialCount, [results5 count]);	
	
	addressPositiveSearch = [TFPerson searchElementForProperty:kTFAddressProperty label:@"Home Somewhere" key:kTFAddressStreetKey value:@"First Line" comparison:kTFNotEqual];
	results5 = [[TFAddressBook sharedAddressBook] recordsMatchingSearchElement:[TFSearchElement searchElementForConjunction:kTFSearchAnd children:[NSArray arrayWithObjects:firstnameSearch, lastnameSearch, addressPositiveSearch, nil]]];
	STAssertEquals(firstNameInitialCount, [results5 count], @"We added a new record that should match, we didn't find it ([before]%d + 1 != [after]%d)", firstNameInitialCount, [results5 count]);	
	
	addressNegativeSearch = [TFPerson searchElementForProperty:kTFAddressProperty label:@"Home Somewhere" key:kTFAddressStreetKey value:@"NOT THERE" comparison:kTFEqual];
	results5 = [[TFAddressBook sharedAddressBook] recordsMatchingSearchElement:[TFSearchElement searchElementForConjunction:kTFSearchAnd children:[NSArray arrayWithObjects:firstnameSearch, lastnameSearch, addressNegativeSearch, nil]]];
	STAssertEquals(firstNameInitialCount, [results5 count], @"We added a new record that should match, we didn't find it ([before]%d + 1 != [after]%d)", firstNameInitialCount, [results5 count]);	

	
	[[TFAddressBook sharedAddressBook] removeRecord:person];
	STAssertTrue([[TFAddressBook sharedAddressBook] save], @"For some reason saving the addressbook failed");
}

- (void)testPropertyTypes {
	TFPerson *person = [[TFPerson alloc] initWithAddressBook:[TFAddressBook sharedAddressBook]];
	[person setValue:@"Test" forProperty:kTFFirstNameProperty];
	[person setValue:[NSDate date] forProperty:kTFBirthdayProperty];
	TFMutableMultiValue *multiValue = [[TFMutableMultiValue alloc] init];
	NSMutableDictionary *addressDictionary = [NSMutableDictionary dictionary];
	[multiValue insertValue:addressDictionary withLabel:@"Test" atIndex:0];
	[person setValue:multiValue forProperty:kTFAddressProperty];

	STAssertTrue([[person valueForProperty:kTFFirstNameProperty] isKindOfClass:[NSString class]], @"Incorrect type returned expecting NSString");
	STAssertTrue([[person valueForProperty:kTFBirthdayProperty] isKindOfClass:[NSDate class]], @"Incorrect type returned expecting NSDate");
	STAssertTrue([[person valueForProperty:kTFAddressProperty] isKindOfClass:[TFMultiValue class]], @"Incorrect type returned expecting TFMultiValue");

	[[TFAddressBook sharedAddressBook] removeRecord:person];
}

- (void)testMultiValue {
	TFPerson *person = [[TFPerson alloc] initWithAddressBook:[TFAddressBook sharedAddressBook]];
	[person setValue:@"Test" forProperty:kTFFirstNameProperty];
	[person setValue:@"User 2" forProperty:kTFLastNameProperty];

	TFMutableMultiValue *multiValue = [[TFMutableMultiValue alloc] init];

	NSUInteger index = 0;
	for (index = 0; index < 4; index++) {
		NSMutableDictionary *addressDictionary = [NSMutableDictionary dictionary];
		[addressDictionary setValue:@"First Line" forKey:kTFAddressStreetKey];
		[addressDictionary setValue:@"My City" forKey:kTFAddressCityKey];
		[addressDictionary setValue:@"My Country" forKey:kTFAddressCountryKey];
		[multiValue insertValue:addressDictionary withLabel:[NSString stringWithFormat:@"Home %ld", index] atIndex:index];
	}
	
	[person setValue:multiValue forProperty:kTFAddressProperty];

	STAssertEquals((NSUInteger)[multiValue count], (NSUInteger)4, @"MultiValue should contain 4 keys, found %d", [multiValue count]);
	
	TFMultiValue *multiValue2 = [person valueForProperty:kTFAddressProperty];
	STAssertTrue([multiValue2 isKindOfClass:[TFMultiValue class]], @"Incorrect type returned expecting TFMultiValue");

	NSString *label = [multiValue2 labelAtIndex:0];
	STAssertEqualObjects(label, @"Home 0", @"Unexpected label");
	
	NSDictionary *addressDictionary = [multiValue2 valueAtIndex:0];
	STAssertEqualObjects([addressDictionary valueForKey:kTFAddressStreetKey], @"First Line", @"Unexpected dictionary entry");
	

	[[TFAddressBook sharedAddressBook] removeRecord:person];
	STAssertTrue([[TFAddressBook sharedAddressBook] save], @"For some reason saving the addressbook failed");
}

- (void)testChangeNotifications {
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changedCallback:) name:kTFDatabaseChangedNotification object:nil];
	
	TFPerson *person = [[TFPerson alloc] initWithAddressBook:[TFAddressBook sharedAddressBook]];
	[person setValue:@"Test" forProperty:kTFFirstNameProperty];
	[person setValue:@"User 2" forProperty:kTFLastNameProperty];
	
	[[NSRunLoop currentRunLoop] runUntilDate:[[NSDate date] dateByAddingTimeInterval:0.5]];
	
	[[TFAddressBook sharedAddressBook] removeRecord:person];
	
	[[NSRunLoop currentRunLoop] runUntilDate:[[NSDate date] dateByAddingTimeInterval:0.5]];
	
	[[TFAddressBook sharedAddressBook] save];
	
	[[NSRunLoop currentRunLoop] runUntilDate:[[NSDate date] dateByAddingTimeInterval:0.5]];
}

- (void)changedCallback:(NSNotification *)notification {
	_callbackCount++;
}
@end
