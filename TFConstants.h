#import <AddressBook/AddressBook.h>

#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR
#	define TFRecordID				ABRecordID
#	define AddressbookRecord		ABRecordRef
#	define TFMultiValueIdentifier	ABMultiValueIdentifier
#	define TFPropertyType			ABPropertyType
#	define TFPropertyID				ABPropertyID
#else
#	define TFRecordID				NSString *
#	define AddressbookRecord		ABRecord *
#	define TFMultiValueIdentifier	NSString *
#	define TFPropertyType			NSString *
#	define TFPropertyID				NSString *
#endif


typedef enum {
	kTFFirstNameFirst = 0,
	kTFLastNameFirst  = 1
} TFDefaultNameOrdering;

typedef enum {
	kTFPersonType = 0,
	kTFGroupType  = 1,
	kTFSourceType  = 2
} TFRecordType;

typedef enum {
	kTFInvalidPropertyType = kABInvalidPropertyType,
	kTFStringPropertyType = kABStringPropertyType,
	kTFIntegerPropertyType = kABIntegerPropertyType,
	kTFRealPropertyType = kABRealPropertyType,
	kTFDateTimePropertyType = kABDateTimePropertyType,
	kTFDictionaryPropertyType = kABDictionaryPropertyType,
	kTFMultiStringPropertyType = kABMultiStringPropertyType,
	kTFMultiIntegerPropertyType = kABMultiIntegerPropertyType,
	kTFMultiRealPropertyType = kABMultiRealPropertyType,
	kTFMultiDateTimePropertyType = kABMultiDateTimePropertyType,
	kTFMultiDictionaryPropertyType= kABMultiDictionaryPropertyType
} TFPropertyType;
