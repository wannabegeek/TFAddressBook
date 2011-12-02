//
//  TFPerson.m
//  AddressbookSyncDemo
//
//  Created by Tom Fewster on 29/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "TFPerson.h"
#import "TFAddressBook.h"
#import "TFMultiValue.h"

@implementation TFPerson

+ (TFSearchElement *)searchElementForProperty:(TFPropertyID)property label:(NSString *)label key:(NSString *)key value:(id)value comparison:(TFSearchComparison)comparison {
	return [[TFSearchElement alloc] initWithProperty:property label:label key:key value:value comparison:comparison];
}

+ (TFPropertyType)typeOfProperty:(TFPropertyID)property {
	if (property == kTFPersonFlags) {
		return kABIntegerPropertyType;
	}
	return ABPersonGetTypeOfProperty(property);
}

- (id)init {
	return [self initWithAddressBook:[TFAddressBook sharedAddressBook]];
}

- (id)initWithAddressBook:(TFAddressBook *)addressbook {
	if (self = [super init]) {
		ABRecordRef person = ABPersonCreate();
		CFErrorRef error;
		BOOL success = ABAddressBookAddRecord(addressbook.nativeObject, person, &error);
		if (success) {
			_record = person;
		} else {
			CFRelease(person);
			return nil;
		}
	}
	
	return self;
}

- (id)valueForProperty:(TFPropertyID)property {
	TFPropertyType propertyType = [[self class] typeOfProperty:property];
	if (propertyType == kABInvalidPropertyType) {
		[NSException raise:@"TFSearchElementExcpetion" format:@"Invalid property for object"];
	}

	id result = nil;

	if (property == kTFPersonFlags) {
		NSUInteger flags;
		if (ABPersonGetCompositeNameFormat() == kABPersonCompositeNameFormatFirstNameFirst) {
			flags |= (kTFNameOrderingMask & kTFFirstNameFirst);
		} else {
			flags |= (kTFNameOrderingMask & kTFLastNameFirst);
		}
		
		CFNumberRef type = ABRecordCopyValue(_record, kABPersonKindProperty);
		if (type == kABPersonKindPerson) {
			flags |= (kTFShowAsMask & kTFShowAsPerson);
		} else {
			flags |= (kTFShowAsMask & kTFShowAsCompany);
		}

		CFRelease(type);
		
		return [NSNumber numberWithInteger:flags];
		
	} else {
		CFTypeRef value = ABRecordCopyValue(_record, property);
		if (value == NULL) {
			result = nil;
		} else {
			// check the property type & convert as appropriate
			if (propertyType & kABMultiValueMask) {
				result = [[TFMultiValue alloc] initWithRef:value];
			} else {
				switch (propertyType) {
					case kABStringPropertyType:
						result = (__bridge NSString *)value;
						break;
					case kABIntegerPropertyType:
						result = (__bridge NSNumber *)value;
						break;
					case kABRealPropertyType:
						result = (__bridge NSNumber *)value;
						break;
					case kABDateTimePropertyType:
						result = (__bridge NSDate *)value;
						break;
					case kABDictionaryPropertyType:
						result = (__bridge NSDictionary *)value;
						break;
					default:
						break;
				}
			}
			CFRelease(value);
		}
	}	
	return result;
}

@end
