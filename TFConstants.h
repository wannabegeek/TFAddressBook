#import <AddressBook/AddressBook.h>

#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR
#	define TFRecordID ABRecordID
#	define AddressbookRecord ABRecordRef
#else
#	define TFRecordID NSString *
#	define AddressbookRecord ABRecord *
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

