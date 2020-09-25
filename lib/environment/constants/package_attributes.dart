/*
 all globally accessible constants
 */

// type of packages
enum PACKAGE_TYPE { SMS, DATA, VOICE }
// package units
enum PACKAGE_UNIT { MB, GB, MINUTES, SMS }
// expiration of packages
enum PACKAGE_EXPIRATION { DAILY, WEEKLY, MONTHLY, NIGHTLY, WEEKEND }

const PACKAGE_FILES = {
  PACKAGE_TYPE.DATA: 'resources/package_files/data.json',
  PACKAGE_TYPE.VOICE: 'resources/package_files/voice.json',
  PACKAGE_TYPE.SMS: 'resources/package_files/sms.json',
};

const PACKAGE_TYPE_NAMES = {
  PACKAGE_TYPE.DATA: 'ኢንተርኔት',
  PACKAGE_TYPE.VOICE: 'ድምፅ',
  PACKAGE_TYPE.SMS: 'አጭር መልዕክት',
};

// ussd codes
const PACKAGE_USSD_FOR_OWN_PREFIX = '*999*1*1';
const PACKAGE_USSD_FOR_GIFT_PREFIX = '*999*1*2';
const PACKAGE_USSD_SUFFIX = '*1#';
