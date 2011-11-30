//
//  TFGroup.h
//  AddressbookSyncDemo
//
//  Created by Tom Fewster on 29/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "TFRecord.h"
#import "TFSearchElement.h"

@interface TFGroup : TFRecord

+ (TFSearchElement *)searchElementForProperty:(TFPropertyID)property label:(NSString *)label key:(NSString *)key value:(id)value comparison:(TFSearchComparison)comparison;

@end
