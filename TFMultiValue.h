//
//  TFMultiValue.h
//  AddressbookSyncDemo
//
//  Created by Tom Fewster on 29/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AddressBook/ABMultiValue.h>
#import <AddressBook/ABPerson.h>
#import "TFConstants.h"

@interface TFMultiValue : NSObject {
	ABMultiValueRef _multiValue;
}

@property (readonly, getter=nativeObject) ABMultiValueRef _multiValue;

- (NSUInteger)count;
- (TFMultiValueIdentifier)identifierAtIndex:(NSUInteger)index;
- (NSUInteger)indexForIdentifier:(TFMultiValueIdentifier)identifier;
- (NSString *)labelAtIndex:(NSUInteger)index;
- (id)labelForIdentifier:(TFMultiValueIdentifier)identifier;
- (ABPropertyType)propertyType;
- (id)valueAtIndex:(NSUInteger)index;
- (id)valueForIdentifier:(TFMultiValueIdentifier)identifier;

@end
