//
//  TFSearchElement.h
//  AddressbookSyncDemo
//
//  Created by Tom Fewster on 29/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TFBasicSearchElement.h"
#import "TFGlobals.h"

@interface TFSearchElement : TFBasicSearchElement

+ (TFSearchElement *)searchElementForConjunction:(TFSearchConjunction)conjunction children:(NSArray *)children;
- (id)initWithConjunction:(TFSearchConjunction)conjunction children:(NSArray *)subpredicates;

@end
