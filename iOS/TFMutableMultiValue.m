//
//  TFMutableMultiValue.m
//  TFAddressBook
//
//  Created by Tom Fewster on 01/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "TFMutableMultiValue.h"

@implementation TFMutableMultiValue

- (id)copy {
	return [self initWithRef:ABMultiValueCreateMutableCopy(_multiValue)];
}

- (void)createPrivateMultiValueRefForData:(id)data {
	if ([data isKindOfClass:[NSString class]]) {
		_multiValue = ABMultiValueCreateMutable(kABStringPropertyType);
	} else if ([data isKindOfClass:[NSNumber class]]) {
		if (strcmp([data objCType], "int") == 0) {
			_multiValue = ABMultiValueCreateMutable(kABIntegerPropertyType);
		} else {
			_multiValue = ABMultiValueCreateMutable(kABRealPropertyType);
		}
	} else if ([data isKindOfClass:[NSDate class]]) {
		_multiValue = ABMultiValueCreateMutable(kABDateTimePropertyType);
	} else if ([data isKindOfClass:[NSDictionary class]]) {
		_multiValue = ABMultiValueCreateMutable(kABDictionaryPropertyType);
		
	} else if ([data isKindOfClass:[TFMultiValue class]]) {
		if ([data propertyType] == kABStringPropertyType) {
			_multiValue = ABMultiValueCreateMutable(kABMultiStringPropertyType);
		} else if ([data propertyType] == kABIntegerPropertyType) {
			_multiValue = ABMultiValueCreateMutable(kABMultiIntegerPropertyType);
		} else if ([data propertyType] == kABRealPropertyType) {
			_multiValue = ABMultiValueCreateMutable(kABMultiRealPropertyType);
		} else if ([data propertyType] == kABDateTimePropertyType) {
			_multiValue = ABMultiValueCreateMutable(kABMultiDateTimePropertyType);
		} else if ([data propertyType] == kABDictionaryPropertyType) {
			_multiValue = ABMultiValueCreateMutable(kABMultiDictionaryPropertyType);
		}
	}
}

- (TFMultiValueIdentifier)addValue:(id)value withLabel:(NSString *)label {
	if (_multiValue == nil) {
		[self createPrivateMultiValueRefForData:value];
	}
	
	CFTypeRef rawValue = nil;
	if ([value isKindOfClass:[TFMultiValue class]]) {
		rawValue = ((TFMultiValue *)value).nativeObject;
	} else {
		rawValue = (__bridge CFTypeRef)value;
	}
	ABMultiValueIdentifier identifier;
	ABMultiValueAddValueAndLabel(_multiValue, rawValue, (__bridge CFStringRef)label, &identifier);
	return identifier;
}

- (TFMultiValueIdentifier)insertValue:(id)value withLabel:(NSString *)label atIndex:(NSUInteger)index {
	if (_multiValue == nil) {
		[self createPrivateMultiValueRefForData:value];
	}

	CFTypeRef rawValue = nil;
	if ([value isKindOfClass:[TFMultiValue class]]) {
		rawValue = ((TFMultiValue *)value).nativeObject;
	} else {
		rawValue = (__bridge CFTypeRef)value;
	}
	ABMultiValueIdentifier identifier;
	ABMultiValueInsertValueAndLabelAtIndex(_multiValue, rawValue, (__bridge CFStringRef)label, index, &identifier);
	
	return identifier;
}

- (BOOL)removeValueAndLabelAtIndex:(NSUInteger)index {
	return (BOOL)ABMultiValueRemoveValueAndLabelAtIndex(_multiValue, index);
}

- (BOOL)replaceLabelAtIndex:(NSUInteger)index withLabel:(NSString *)label {
	return (BOOL)ABMultiValueReplaceLabelAtIndex(_multiValue, (__bridge CFStringRef)label, index);
}

- (BOOL)replaceValueAtIndex:(NSUInteger)index withValue:(id)value {
	CFTypeRef rawValue = nil;
	if ([value isKindOfClass:[TFMultiValue class]]) {
		rawValue = ((TFMultiValue *)value).nativeObject;
	} else {
		rawValue = (__bridge CFTypeRef)value;
	}
	return ABMultiValueReplaceValueAtIndex(_multiValue, rawValue, index);
}

- (BOOL)setPrimaryIdentifier:(TFMultiValueIdentifier)identifier {
// setPrimaryIdentifier isn't supported on iOS
	return NO;
}

@end
