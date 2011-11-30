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

@implementation TFSearchElement

+ (TFSearchElement *)searchElementForConjunction:(TFSearchConjunction)conjunction children:(NSArray *)children {
	return [[TFSearchElement alloc] initWithConjunction:conjunction children:children];
}

- (id)initWithConjunction:(TFSearchConjunction)conjunction children:(NSArray *)subpredicates {
	if (self = [super init]) {
		_subpredicates = subpredicates;
		_conjunctionType = conjunction;
		_type = kTFSearchElementTypeCompound;
	}
	return self;
}

- (BOOL)matchesRecord:(TFRecord *)record {
	if (_type == kTFSearchElementTypeBasic) {
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
