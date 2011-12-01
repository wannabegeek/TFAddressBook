//
//  TFGroup.m
//  AddressbookSyncDemo
//
//  Created by Tom Fewster on 29/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "TFGroup.h"
#import "TFAddressBook.h"

@implementation TFGroup

+ (TFSearchElement *)searchElementForProperty:(TFPropertyID)property label:(NSString *)label key:(NSString *)key value:(id)value comparison:(TFSearchComparison)comparison {
	return [[TFSearchElement alloc] initWithProperty:property label:label key:key value:value comparison:comparison];
}

+ (TFPropertyType)typeOfProperty:(TFPropertyID)property {
	return kABStringPropertyType;
}

- (id)init {
	return [self initWithAddressBook:[TFAddressBook sharedAddressBook]];
}

- (id)initWithAddressBook:(TFAddressBook *)addressbook {
	if ((self = [super init])) {
		ABRecordRef group = ABGroupCreate();
		CFErrorRef error;
		BOOL success = ABAddressBookAddRecord(addressbook.nativeObject, group, &error);
		if (success) {
			_record = group;
		} else {
			CFRelease(group);
			return nil;
		}
	}
	
	return self;
}

@end
