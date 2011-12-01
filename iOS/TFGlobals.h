#import <AddressBook/AddressBook.h>

#pragma mark -
#pragma mark Platform dependent object types

#define TFRecordID					ABRecordID
#define AddressbookRecord				ABRecordRef
#define TFMultiValueIdentifier				ABMultiValueIdentifier
#define TFPropertyType					ABPropertyType
#define TFPropertyID					ABPropertyID


typedef enum {
	kTFFirstNameFirst = kABPersonSortByFirstName,
	kTFLastNameFirst = kABPersonSortByLastName
} TFDefaultNameOrdering;

typedef enum {
	kTFPersonType = 0,
	kTFGroupType  = 1,
	kTFSourceType  = 2
} TFRecordType;

#pragma mark -
#pragma mark Property Types

#define kTFInvalidPropertyType				kABInvalidPropertyType
#define kTFStringPropertyType				kABStringPropertyType
#define kTFIntegerPropertyType				kABIntegerPropertyType
#define kTFRealPropertyType				kABRealPropertyType
#define kTFDateTimePropertyType				kABDateTimePropertyType
#define kTFArrayPropertyType				kTFInvalidPropertyType
#define kTFDictionaryPropertyType			kABDictionaryPropertyType
#define kTFMultiStringPropertyType			kABMultiStringPropertyType
#define kTFMultiIntegerPropertyType			kABMultiIntegerPropertyType
#define kTFMultiRealPropertyType			kABMultiRealPropertyType
#define kTFMultiDateTimePropertyType			kABMultiDateTimePropertyType
#define kTFMultiDictionaryPropertyType			kABMultiDictionaryPropertyType
#define kTFMultiDataPropertyType			kTFInvalidPropertyType

#pragma mark -
#pragma mark Record Properties

#define kTFUIDProperty					kABPropertyInvalidID			// Not Supported on iOS
#define kTFCreationDateProperty				kABPersonCreationDateProperty
#define kTFModificationDateProperty			kABPersonModificationDateProperty

#pragma mark -
#pragma mark Person Properties

#define kTFFirstNameProperty				kABPersonFirstNameProperty
#define kTFLastNameProperty				kABPersonLastNameProperty
#define kTFFirstNamePhoneticProperty			kABPersonFirstNamePhoneticProperty
#define kTFLastNamePhoneticProperty			kABPersonLastNamePhoneticProperty
#define kTFNicknameProperty				kABPersonNicknameProperty
#define kTFMaidenNameProperty				kABPropertyInvalidID			// Not Supported on iOS
#define kTFBirthdayProperty				kABPersonBirthdayProperty
#define kTFBirthdayComponentsProperty
#define kTFOrganizationProperty				kABPersonOrganizationProperty
#define kTFJobTitleProperty				kABPersonJobTitleProperty
#define kTFHomePageProperty				kABPropertyInvalidID			// Not Supported on iOS
#define kTFURLsProperty					kABPersonURLProperty
#define kTFCalendarURIsProperty
#define kTFEmailProperty				kABPersonEmailProperty
#define kTFAddressProperty				kABPersonAddressProperty
#define kTFOtherDatesProperty				kABPropertyInvalidID			// Not Supported on iOS
#define kTFOtherDateComponentsProperty			kABPropertyInvalidID			// Not Supported on iOS
#define kTFRelatedNamesProperty				kABPersonRelatedNamesProperty
#define kTFDepartmentProperty				kABPersonDepartmentProperty
#define kTFPersonFlags
#define kTFPhoneProperty				kABPersonPhoneProperty
#define kTFInstantMessageProperty			kABPersonInstantMessageProperty
#define kTFAIMInstantProperty				kABPropertyInvalidID			// Not Supported on iOS
#define kTFJabberInstantProperty			kABPropertyInvalidID			// Not Supported on iOS
#define kTFMSNInstantProperty				kABPropertyInvalidID			// Not Supported on iOS
#define kTFYahooInstantProperty				kABPropertyInvalidID			// Not Supported on iOS
#define kTFICQInstantProperty				kABPropertyInvalidID			// Not Supported on iOS
#define kTFNoteProperty					kABPersonNoteProperty
#define kTFMiddleNameProperty				kABPersonMiddleNameProperty
#define kTFMiddleNamePhoneticProperty			kABPersonMiddleNamePhoneticProperty
#define kTFTitleProperty				kABPersonPrefixProperty
#define kTFSuffixProperty				kABPersonSuffixProperty
#define kTFSocialProfileProperty			kABPersonSocialProfileProperty

#pragma mark -
#pragma mark Group Properties

#define kTFGroupNameProperty				kABGroupNameProperty
#pragma mark -
#pragma mark Search operators

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

