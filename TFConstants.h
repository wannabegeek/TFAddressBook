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
#	define TFPropertyType			ABPropertyType
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

#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR
#	define kTFInvalidPropertyType kABInvalidPropertyType
#	define kTFStringPropertyType kABStringPropertyType
#	define kTFIntegerPropertyType kABIntegerPropertyType
#	define kTFRealPropertyType kABRealPropertyType
#	define kTFDateTimePropertyType kABDateTimePropertyType
#	define kTFArrayPropertyType kTFInvalidPropertyType
#	define kTFDictionaryPropertyType kABDictionaryPropertyType
#	define kTFMultiStringPropertyType kABMultiStringPropertyType
#	define kTFMultiIntegerPropertyType kABMultiIntegerPropertyType
#	define kTFMultiRealPropertyType kABMultiRealPropertyType
#	define kTFMultiDateTimePropertyType kABMultiDateTimePropertyType
#	define kTFMultiDictionaryPropertyType kABMultiDictionaryPropertyType
#	define kTFMultiDataPropertyType kTFInvalidPropertyType
#else
#	define kTFInvalidPropertyType kABErrorInProperty
#	define kTFStringPropertyType kABStringProperty
#	define kTFIntegerPropertyType kABIntegerProperty
#	define kTFRealPropertyType kABRealProperty
#	define kTFDateTimePropertyType kABDateProperty
#	define kTFArrayPropertyType kABArrayProperty
#	define kTFDictionaryPropertyType kABDictionaryProperty
#	define kTFMultiStringPropertyType kABMultiStringProperty
#	define kTFMultiIntegerPropertyType kABMultiIntegerProperty
#	define kTFMultiRealPropertyType kABMultiRealProperty
#	define kTFMultiDateTimePropertyType kABMultiDateProperty
#	define kTFMultiDictionaryPropertyType kABMultiDictionaryProperty
#	define kTFMultiDataPropertyType kABMultiDataProperty
#endif

#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR
	#define kTFUIDProperty					kABPropertyInvalidID			// Not Supported on iOS
	#define kTFCreationDateProperty			kABPersonCreationDateProperty
	#define kTFModificationDateProperty		kABPersonModificationDateProperty

	#define kTFFirstNameProperty			kABPersonFirstNameProperty
	#define kTFLastNameProperty				kABPersonLastNameProperty
	#define kTFFirstNamePhoneticProperty	kABPersonFirstNamePhoneticProperty
	#define kTFLastNamePhoneticProperty		kABPersonLastNamePhoneticProperty
	#define kTFNicknameProperty				kABPersonNicknameProperty
	#define kTFMaidenNameProperty			kABPropertyInvalidID			// Not Supported on iOS
	#define kTFBirthdayProperty				kABPersonBirthdayProperty
	#define kTFBirthdayComponentsProperty
	#define kTFOrganizationProperty			kABPersonOrganizationProperty
	#define kTFJobTitleProperty				kABPersonJobTitleProperty
	#define kTFHomePageProperty				kABPropertyInvalidID			// Not Supported on iOS
	#define kTFURLsProperty					kABPersonURLProperty
	#define kTFCalendarURIsProperty
	#define kTFEmailProperty				kABPersonEmailProperty
	#define kTFAddressProperty				kABPersonAddressProperty
	#define kTFOtherDatesProperty			kABPropertyInvalidID			// Not Supported on iOS
	#define kTFOtherDateComponentsProperty	kABPropertyInvalidID			// Not Supported on iOS
	#define kTFRelatedNamesProperty			kABPersonRelatedNamesProperty
	#define kTFDepartmentProperty			kABPersonDepartmentProperty
	#define kTFPersonFlags
	#define kTFPhoneProperty				kABPersonPhoneProperty
	#define kTFInstantMessageProperty		kABPersonInstantMessageProperty
	#define kTFAIMInstantProperty			kABPropertyInvalidID			// Not Supported on iOS
	#define kTFJabberInstantProperty		kABPropertyInvalidID			// Not Supported on iOS
	#define kTFMSNInstantProperty			kABPropertyInvalidID			// Not Supported on iOS
	#define kTFYahooInstantProperty			kABPropertyInvalidID			// Not Supported on iOS
	#define kTFICQInstantProperty			kABPropertyInvalidID			// Not Supported on iOS
	#define kTFNoteProperty					kABPersonNoteProperty
	#define kTFMiddleNameProperty			kABPersonMiddleNameProperty
	#define kTFMiddleNamePhoneticProperty	kABPersonMiddleNamePhoneticProperty
	#define kTFTitleProperty				kABPersonPrefixProperty
	#define kTFSuffixProperty				kABPersonSuffixProperty
	#define kTFSocialProfileProperty		kABPersonSocialProfileProperty
#else
	#define kTFUIDProperty					kABUIDProperty
	#define kTFCreationDateProperty			kABCreationDateProperty
	#define kTFModificationDateProperty		kABModificationDateProperty

	#define kTFFirstNameProperty			kABFirstNameProperty
	#define kTFLastNameProperty				kABLastNameProperty
	#define kTFFirstNamePhoneticProperty	kABFirstNamePhoneticProperty
	#define kTFLastNamePhoneticProperty		kABLastNamePhoneticProperty
	#define kTFNicknameProperty				kABNicknameProperty
	#define kTFMaidenNameProperty			kABMaidenNameProperty
	#define kTFBirthdayProperty				kABBirthdayProperty
	#define kTFBirthdayComponentsProperty	kABBirthdayComponentsProperty
	#define kTFOrganizationProperty			kABOrganizationProperty
	#define kTFJobTitleProperty				kABJobTitleProperty
	#define kTFHomePageProperty				kABHomePageProperty
	#define kTFURLsProperty					kABURLsProperty
	#define kTFCalendarURIsProperty			kABCalendarURIsProperty
	#define kTFEmailProperty				kABEmailProperty
	#define kTFAddressProperty				kABAddressProperty
	#define kTFOtherDatesProperty			kABOtherDatesProperty
	#define kTFOtherDateComponentsProperty	kABOtherDateComponentsProperty
	#define kTFRelatedNamesProperty			kABRelatedNamesProperty
	#define kTFDepartmentProperty			kABDepartmentProperty
	#define kTFPersonFlags					kABPersonFlags
	#define kTFPhoneProperty				kABPhoneProperty
	#define kTFInstantMessageProperty		kABInstantMessageProperty
	#define kTFAIMInstantProperty			kABAIMInstantProperty
	#define kTFJabberInstantProperty		kABJabberInstantProperty
	#define kTFMSNInstantProperty			kABMSNInstantProperty
	#define kTFYahooInstantProperty			kABYahooInstantProperty
	#define kTFICQInstantProperty			kABICQInstantProperty
	#define kTFNoteProperty					kABNoteProperty
	#define kTFMiddleNameProperty			kABMiddleNameProperty
	#define kTFMiddleNamePhoneticProperty	kABMiddleNamePhoneticProperty
	#define kTFTitleProperty				kABTitleProperty
	#define kTFSuffixProperty				kABSuffixProperty
	#define kTFSocialProfileProperty		kABSocialProfileProperty
#endif

typedef enum {
	kTFSearchAnd,
	kTFSearchOr
} TFSearchConjunction;

typedef enum {
	kTFEqual,
	kTFNotEqual,
	kTFLessThan,
	kTFLessThanOrEqual,
	kTFGreaterThan,
	kTFGreaterThanOrEqual,
	kTFEqualCaseInsensitive,
	kTFContainsSubString,
	kTFContainsSubStringCaseInsensitive
} TFSearchComparison;


typedef enum {
	kTFSearchElementTypeBasic,	
	kTFSearchElementTypeCompound	
} TFSearchElementType;