//
//  TFAddressBookTests.m
//  TFAddressBookTests
//
//  Created by Tom Fewster on 30/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "TFAddressBookTests.h"
#import "TFABAddressBook.h"

@implementation TFAddressBookTests

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
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

	[[TFAddressBook sharedAddressBook] removeRecord:person];
	STAssertTrue([[TFAddressBook sharedAddressBook] save], @"For some reason saving the addressbook failed");
}

- (void)testMultiValue {
	TFPerson *person = [[TFPerson alloc] initWithAddressBook:[TFAddressBook sharedAddressBook]];
	[person setValue:@"Test" forProperty:kTFFirstNameProperty];
	[person setValue:@"User 2" forProperty:kTFLastNameProperty];

//	TFMultiValue *multiValue = [[TFMultiValue alloc] init];

	
	[[TFAddressBook sharedAddressBook] removeRecord:person];
	STAssertTrue([[TFAddressBook sharedAddressBook] save], @"For some reason saving the addressbook failed");
}

@end
