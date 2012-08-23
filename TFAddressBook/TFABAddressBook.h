//
//  TFAddressBook.h
//  TFAddressBook
//
//  Created by Tom Fewster on 20/08/2012.
//  Copyright (c) 2012 Tom Fewster. All rights reserved.
//

#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR
#import "iOS/TFGlobals.h"
#import "iOS/TFAddressbook.h"
#import "iOS/TFGroup.h"
#import "iOS/TFMultiValue.h"
#import "iOS/TFMutableMultiValue.h"
#import "iOS/TFPerson.h"
#import "iOS/TFRecord.h"
#import "iOS/TFSearchElement.h"
#import "TFPerson+CompositeName.h"
#else
#import "OSX/TFGlobals.h"
#import "TFPerson+CompositeName.h"
#endif
