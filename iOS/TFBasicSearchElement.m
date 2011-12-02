//
//  TFBasicSearchElement.m
//  TFAddressbook
//
//  Created by Tom Fewster on 30/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "TFBasicSearchElement.h"
#import "TFRecord.h"
#import "TFMultiValue.h"


NSString *kTFSearchBindingPropertyKey = @"PROPERTY";
NSString *kTFSearchBindingLabelKey = @"LABEL";
NSString *kTFSearchBindingKeyKey = @"KEY";
NSString *kTFSearchBindingValueKey = @"VALUE";
NSString *kTFSearchBindingComparisonKey = @"COMPARISON";

@implementation TFBasicSearchElement

- (NSDictionary *)bindings {
	NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithCapacity:5];
	
	[dictionary setObject:[NSValue value:&_property withObjCType:@encode(TFPropertyType)] forKey:kTFSearchBindingPropertyKey];
	if (_label) {
		[dictionary setObject:_label forKey:kTFSearchBindingLabelKey];
	}
	if (_key) {
		[dictionary setObject:_key forKey:kTFSearchBindingKeyKey];
	}
	if (_value) {
		[dictionary setObject:_value forKey:kTFSearchBindingValueKey];
	}
	[dictionary setObject:[NSValue value:&_comparison withObjCType:@encode(TFSearchComparison)] forKey:kTFSearchBindingComparisonKey];
	
	return dictionary;
}

- (id)initWithProperty:(TFPropertyID)property label:(NSString *)label key:(NSString *)key value:(id)value comparison:(TFSearchComparison)comparison {
	
	if (self = [super init]) {
		_property = property;
		_label = label;
		_key = key;
		_value = value;
		_comparison = comparison;
		_type = kTFSearchElementTypeBasic;
		
		_predicate = [NSPredicate predicateWithBlock:^BOOL(TFRecord *evaluatedObject, NSDictionary *bindings) {
			TFPropertyID property;
			[[bindings valueForKey:kTFSearchBindingPropertyKey] getValue:&property];
			NSString *label = [bindings valueForKey:kTFSearchBindingLabelKey];
			NSString *key = [bindings valueForKey:kTFSearchBindingKeyKey];
			NSString *value = [bindings valueForKey:kTFSearchBindingValueKey];
			TFSearchComparison comparison;
			[[bindings valueForKey:kTFSearchBindingComparisonKey] getValue:&comparison];
			
			id result = [evaluatedObject valueForProperty:property];
			if ([result isKindOfClass:[TFMultiValue class]]) {
				TFMultiValue *mv = (TFMultiValue *)result;
				for (NSUInteger i = 0; i<[mv count]; i++) {
					if (label && key) {
						NSDictionary *dictionary = [mv valueAtIndex:i];
						if ([[mv labelAtIndex:i] isEqualToString:label] && [dictionary isKindOfClass:[NSDictionary class]]  && [dictionary valueForKey:key] != nil) {
							switch (comparison) {
								case kTFEqual:
									if ([[dictionary valueForKey:key] isEqual:value]) { 
										return YES;
									}
									break;
								case kTFNotEqual:
									if (![[dictionary valueForKey:key] isEqual:value]) {
										return YES;
									}
									break;
									
								default:
									break;
							}
						}
					} else if (label) {
						if ([[mv labelAtIndex:i] isEqualToString:label]) {
							switch (comparison) {
								case kTFEqual:
									if ([[mv valueAtIndex:i] isEqual:value]) {
										return YES;
									}
									break;
								case kTFNotEqual:
									if (![[mv valueAtIndex:i] isEqual:value]) {
										return YES;
									}
									break;
									
								default:
									break;
							}
						}
					} else if (key) {
						NSDictionary *dictionary = [mv valueAtIndex:i];
						if ([dictionary isKindOfClass:[NSDictionary class]] && [dictionary valueForKey:key] != nil) {
							switch (comparison) {
								case kTFEqual:
									if ([[dictionary valueForKey:key] isEqual:value]) { 
										return YES;
									}
									break;
								case kTFNotEqual:
									if (![[dictionary valueForKey:key] isEqual:value]) {
										return YES;
									}
									break;
									
								default:
									break;
							}
						}
					} else {
						switch (comparison) {
							case kTFEqual:
								if ([[mv valueAtIndex:i] isEqual:value]) {
									return YES;
								}
								break;
							case kTFNotEqual:
								if (![[mv valueAtIndex:i] isEqual:value]) {
									return YES;
								}
								break;
							default:
								[NSException raise:@"TFSearchElementExcpetion" format:@"Unsupported comparison"];
								break;
						}
					}
				}
			} else {
				switch (comparison) {
					case kTFEqual:
						if (result != nil) {
							return [result isEqual:value];
						} else if (value == nil) {
							return YES;
						}
						break;
					case kTFNotEqual:
						if (result != nil) {
							return ![result isEqual:value];
						} else if (value == nil) {
							return NO;
						}
						break;
					case kTFLessThan:
						return [result isEqual:value];
						NSAssert(false, @"not implemented yet");
						break;
					case kTFLessThanOrEqual:
						NSAssert(false, @"not implemented yet");
						break;
					case kTFGreaterThan:
						NSAssert(false, @"not implemented yet");
						break;
					case kTFGreaterThanOrEqual:
						NSAssert(false, @"not implemented yet");
						break;
					case kTFEqualCaseInsensitive:
						if (result != nil) {
							if (![result isKindOfClass:[NSString class]]) {
								[NSException raise:@"TFSearchElementExcpetion" format:@"Property must be a string for search type"];
							}
							return [(NSString *)result caseInsensitiveCompare:value] == NSOrderedSame;
						} else if (value == nil) {
							return YES;
						}
						break;
					case kTFContainsSubString:
						if (result != nil) {
							if (![result isKindOfClass:[NSString class]]) {
								[NSException raise:@"TFSearchElementExcpetion" format:@"Property must be a string for search type"];
							}
							return [(NSString *)result rangeOfString:value].location != NSNotFound;
						}
						break;
					case kTFContainsSubStringCaseInsensitive:
						if (result != nil) {
							if (![result isKindOfClass:[NSString class]]) {
								[NSException raise:@"TFSearchElementExcpetion" format:@"Property must be a string for search type"];
							}
							return [[(NSString *)result lowercaseString] rangeOfString:[value lowercaseString]].location != NSNotFound;
						}
						break;
					default:
						[NSException raise:@"TFSearchElementExcpetion" format:@"Unsupported comparison"];
						break;
				}
			}
			
			return NO;
		}];
	}
	return self;
}

- (BOOL)matchesRecord:(TFRecord *)record {
	return [_predicate evaluateWithObject:record substitutionVariables:self.bindings];
}

@end
