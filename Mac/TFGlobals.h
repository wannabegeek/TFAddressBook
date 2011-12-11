#import <AddressBook/AddressBook.h>

#pragma mark -
#pragma mark Platform dependent object types

#define TFRecordID					NSString *
#define AddressbookRecord			ABRecord *
#define TFMultiValueIdentifier		NSString *
#define TFPropertyType				ABPropertyType
#define TFPropertyID				NSString *

typedef NSUInteger TFDefaultNameOrdering;
#define kTFShowAsMask                           kABShowAsMask
#define kTFShowAsPerson                         kABShowAsPerson
#define kTFShowAsCompany                        kABShowAsCompany
#define kTFShowAsResource                       kABShowAsResource
#define kTFShowAsRoom                           kABShowAsRoom
#define kTFNameOrderingMask                     kABNameOrderingMask
#define kTFDefaultNameOrdering                  kABDefaultNameOrdering
#define kTFFirstNameFirst                       kABFirstNameFirst
#define kTFLastNameFirst                        kABLastNameFirst

typedef enum {
	kTFPersonType = 0,
	kTFGroupType  = 1,
	kTFSourceType = 2
} TFRecordType;

#pragma mark -
#pragma mark Property Types

#define kTFInvalidPropertyType				kABErrorInProperty
#define kTFStringPropertyType				kABStringProperty
#define kTFIntegerPropertyType				kABIntegerProperty
#define kTFRealPropertyType				kABRealProperty
#define kTFDateTimePropertyType				kABDateProperty
#define kTFArrayPropertyType				kABArrayProperty
#define kTFDictionaryPropertyType			kABDictionaryProperty
#define kTFMultiStringPropertyType			kABMultiStringProperty
#define kTFMultiIntegerPropertyType			kABMultiIntegerProperty
#define kTFMultiRealPropertyType			kABMultiRealProperty
#define kTFMultiDateTimePropertyType			kABMultiDateProperty
#define kTFMultiDictionaryPropertyType			kABMultiDictionaryProperty
#define kTFMultiDataPropertyType			kABMultiDataProperty

#pragma mark -
#pragma mark Record Properties

#define kTFUIDProperty					kABUIDProperty
#define kTFCreationDateProperty				kABCreationDateProperty
#define kTFModificationDateProperty			kABModificationDateProperty

#pragma mark -
#pragma mark Person Properties

#define kTFFirstNameProperty				kABFirstNameProperty
#define kTFLastNameProperty				kABLastNameProperty
#define kTFFirstNamePhoneticProperty			kABFirstNamePhoneticProperty
#define kTFLastNamePhoneticProperty			kABLastNamePhoneticProperty
#define kTFNicknameProperty				kABNicknameProperty
#define kTFMaidenNameProperty				kABMaidenNameProperty
#define kTFBirthdayProperty				kABBirthdayProperty
#define kTFBirthdayComponentsProperty			kABBirthdayComponentsProperty
#define kTFOrganizationProperty				kABOrganizationProperty
#define kTFJobTitleProperty				kABJobTitleProperty
#define kTFHomePageProperty				kABHomePageProperty
#define kTFURLsProperty					kABURLsProperty
#define kTFCalendarURIsProperty				kABCalendarURIsProperty
#define kTFEmailProperty				kABEmailProperty
#define kTFAddressProperty				kABAddressProperty
#define kTFOtherDatesProperty				kABOtherDatesProperty
#define kTFOtherDateComponentsProperty			kABOtherDateComponentsProperty
#define kTFRelatedNamesProperty				kABRelatedNamesProperty
#define kTFDepartmentProperty				kABDepartmentProperty
#define kTFPersonFlags					kABPersonFlags
#define kTFPhoneProperty				kABPhoneProperty
#define kTFInstantMessageProperty			kABInstantMessageProperty
#define kTFAIMInstantProperty				kABAIMInstantProperty
#define kTFJabberInstantProperty			kABJabberInstantProperty
#define kTFMSNInstantProperty				kABMSNInstantProperty
#define kTFYahooInstantProperty				kABYahooInstantProperty
#define kTFICQInstantProperty				kABICQInstantProperty
#define kTFNoteProperty					kABNoteProperty
#define kTFMiddleNameProperty				kABMiddleNameProperty
#define kTFMiddleNamePhoneticProperty			kABMiddleNamePhoneticProperty
#define kTFTitleProperty				kABTitleProperty
#define kTFSuffixProperty				kABSuffixProperty
#define kTFSocialProfileProperty			kABSocialProfileProperty

#pragma mark -
#pragma mark Group Properties

#define kTFGroupNameProperty				kABGroupNameProperty

#pragma mark -
#pragma mark Search operators

typedef enum {
	kTFSearchAnd = kABSearchAnd,
	kTFSearchOr = kABSearchOr
} TFSearchConjunction;

typedef enum {
	kTFEqual = kABEqual,
	kTFNotEqual = kABNotEqual,
	kTFLessThan = kABLessThan,
	kTFLessThanOrEqual = kABLessThanOrEqual,
	kTFGreaterThan = kABGreaterThan,
	kTFGreaterThanOrEqual = kABGreaterThanOrEqual,
	kTFEqualCaseInsensitive = kABEqualCaseInsensitive,
	kTFContainsSubString = kABContainsSubString,
	kTFContainsSubStringCaseInsensitive = kABContainsSubStringCaseInsensitive
} TFSearchComparison;

#pragma mark -
#pragma mark ABAddressBook mappings

typedef ABAddressBook TFAddressBook;
typedef ABRecord TFRecord;
typedef ABPerson TFPerson;
typedef ABGroup TFGroup;
typedef ABMultiValue TFMultiValue;
typedef ABMutableMultiValue TFMutableMultiValue;
typedef ABSearchElement TFSearchElement;


#define	kTFAddressStreetKey				kABAddressStreetKey
#define	kTFAddressCityKey				kABAddressCityKey
#define	kTFAddressStateKey				kABAddressStateKey
#define	kTFAddressZIPKey				kABAddressZIPKey
#define	kTFAddressCountryKey			kABAddressCountryKey
#define	kTFAddressCountryCodeKey		kABAddressCountryCodeKey


#pragma mark -
#pragma mark Notificvation keys
#define kTFDatabaseChangedNotification			kABDatabaseChangedNotification
#define kTFDatabaseChangedExternallyNotification	kABDatabaseChangedExternallyNotification

#define kTFInsertedRecords				kABInsertedRecords
#define kTFUpdatedRecords				kABUpdatedRecords
#define kTFDeletedRecords				kABDeletedRecords

#define TFLocalizedPropertyOrLabel(propertyOrLabel) ABLocalizedPropertyOrLabel(propertyOrLabel)
