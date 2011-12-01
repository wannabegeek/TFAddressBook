//
//  TFMutableMultiValue.h
//  TFAddressBook
//
//  Created by Tom Fewster on 01/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "TFMultiValue.h"

@interface TFMutableMultiValue : TFMultiValue

- (NSString *)addValue:(id)value withLabel:(NSString *)label;
- (NSString *)insertValue:(id)value withLabel:(NSString *)label atIndex:(NSUInteger)index;
- (BOOL)removeValueAndLabelAtIndex:(NSUInteger)index;
- (BOOL)replaceLabelAtIndex:(NSUInteger)index withLabel:(NSString *)label;
- (BOOL)replaceValueAtIndex:(NSUInteger)index withValue:(id)value;
- (BOOL)setPrimaryIdentifier:(NSString *)identifier;

@end
