//
//  TFPerson+CompositeName.m
//  AddressbookSyncDemo
//
//  Created by Tom Fewster on 07/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "TFPerson+CompositeName.h"

@implementation TFPerson (CompositeName)

- (NSString *)compositeName {
#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR
	return (__bridge_transfer NSString *)ABRecordCopyCompositeName(_record);
#else
	NSString *compositeName;
	
	NSInteger personFlags = [[self valueForProperty:kTFPersonFlags] integerValue];
	NSString *firstName = [self valueForProperty:kTFFirstNameProperty];
	NSString *lastName = [self valueForProperty:kTFLastNameProperty];
	NSString *company = [self valueForProperty:kTFOrganizationProperty];

	
	if (personFlags & kTFShowAsCompany) {
		compositeName = company;
	} else {
		
		if (firstName && lastName) {
			if (personFlags & kTFFirstNameFirst) {
				compositeName = [NSString stringWithFormat:@"%@ %@", firstName, lastName];
			} else {
				compositeName = [NSString stringWithFormat:@"%@ %@", lastName, firstName];
			}
		} else if (firstName) {
			compositeName = firstName;
		} else if (lastName) {
			compositeName = lastName;
		} else {
			compositeName = @"";
		}
	}
	return compositeName;
#endif
}

@end
