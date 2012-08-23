//
//  TFSearchElement.m
//  AddressbookSyncDemo
//
//  Created by Tom Fewster on 29/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "TFSearchElement.h"
#import "TFRecord.h"
#import "TFMultiValue.h"

@interface TFSearchElement ()
@property (strong) NSArray *subpredicates;
@property (assign) TFSearchConjunction conjunctionType;
@end

@implementation TFSearchElement

@synthesize subpredicates = _subpredicates;
@synthesize conjunctionType = _conjunctionType;

+ (TFSearchElement *)searchElementForConjunction:(TFSearchConjunction)conjunction children:(NSArray *)children {
	return [[TFSearchElement alloc] initWithConjunction:conjunction children:children];
}

- (NSString *)description {
	if (super.type == kTFSearchElementTypeBasic) {
		return [super description];
	} else {
		NSMutableString *output = [NSMutableString string];

		[output appendFormat:@"%s with %d subpredicates {", object_getClassName(self), [_subpredicates count]];

		NSUInteger counter = 0;
		for (TFBasicSearchElement *element in _subpredicates) {
			[output appendString:[element description]];
			counter++;
			if (counter != [_subpredicates count]) {
				[output appendString:(_conjunctionType == kTFSearchAnd)?@" AND ":@" OR "];
			}
		}

		[output appendString:@"}"];
		return output;
	}
}

- (id)initWithConjunction:(TFSearchConjunction)conjunction children:(NSArray *)subpredicates {
	if (self = [super init]) {
		_subpredicates = subpredicates;
		_conjunctionType = conjunction;
		super.type = kTFSearchElementTypeCompound;
	}
	return self;
}

- (BOOL)matchesRecord:(TFRecord *)record {
	if (super.type == kTFSearchElementTypeBasic) {
		return [super matchesRecord:record];
	} else {
		if (_conjunctionType == kTFSearchAnd) {
			for (TFSearchElement *element in _subpredicates) {
				if ([element matchesRecord:record] == NO) {
					return NO;
				}
			}
			return YES;
		} else if (_conjunctionType == kTFSearchOr) {
			for (TFSearchElement *element in _subpredicates) {
				if ([element matchesRecord:record] == YES) {
					return YES;
				}
			}
			return NO;
		} else {
			return NO;
		}
	}
}

@end
