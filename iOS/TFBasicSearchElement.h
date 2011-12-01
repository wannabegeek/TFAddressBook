//
//  TFBasicSearchElement.h
//  TFAddressbook
//
//  Created by Tom Fewster on 30/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
	kTFSearchElementTypeBasic,
	kTFSearchElementTypeCompound
} TFSearchElementType;

@class TFRecord;
@class TFSearchElement;

@interface TFBasicSearchElement : NSObject {
	NSUInteger _searchComparison;
	TFPropertyID _property;
	NSString *_label;
	NSString *_key;
	id _value;
	TFSearchComparison _comparison;
	
	NSPredicate *_predicate;
	
	TFSearchElementType _type;
}

- (TFSearchElement *)initWithProperty:(TFPropertyID)property label:(NSString *)label key:(NSString *)key value:(id)value comparison:(TFSearchComparison)comparison;
- (BOOL)matchesRecord:(TFRecord *)record;

@end
