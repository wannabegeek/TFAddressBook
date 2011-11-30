//
//  TFABAddressbook.h
//  TFAddressbook
//
//  Created by Tom Fewster on 30/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "TFConstants.h"

#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR
	#import "iOS/TFAddressbook.h"
	#import "iOS/TFGroup.h"
	#import "iOS/TFMultiValue.h"
	#import "iOS/TFPerson.h"
	#import "iOS/TFRecord.h"
	#import "iOS/TFSearchElement.h"
#else
	#import "Mac/TFAddressbook.h"
	#import "Mac/TFGroup.h"
	#import "Mac/TFMultiValue.h"
	#import "Mac/TFPerson.h"
	#import "Mac/TFRecord.h"
	#import "Mac/TFSearchElement.h"
#endif