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

- (id)initWithAddressBook:(TFAddressBook *)addressbook {
	if ((self = [super initWithAddressBook:addressbook])) {
		ABRecordRef group = ABGroupCreate();
		_record = group;

		NSError *error;
		BOOL success = [addressbook addRecord:self error:&error];
		if (!success) {
			CFRelease(group);
			return nil;
		}
	}
	
	return self;
}

@end
