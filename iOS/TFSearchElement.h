//
//  TFSearchElement.h
//  AddressbookSyncDemo
//
//  Created by Tom Fewster on 29/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TFBasicSearchElement.h"

@interface TFSearchElement : TFBasicSearchElement {
	NSArray *_subpredicates;
	TFSearchConjunction _conjunctionType;
}

+ (TFSearchElement *)searchElementForConjunction:(TFSearchConjunction)conjunction children:(NSArray *)children;
- (id)initWithConjunction:(TFSearchConjunction)conjunction children:(NSArray *)subpredicates;

@end
