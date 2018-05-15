//
//  Created by Ilya Kostyukevich. All rights reserved.
//

#import "UtilTest.h"
#import "DateUtil.h"
#import "TestUtil.h"
#import <SignalMessaging/NSString+OWS.h>
#import <SignalServiceKit/NSDate+OWS.h>
#import <SignalServiceKit/NSObject+OWS.h>
#import <SignalServiceKit/NSString+SSK.h>

@interface DateUtil (Test)

+ (BOOL)dateIsOlderThanToday:(NSDate *)date now:(NSDate *)now;
+ (BOOL)dateIsOlderThanOneWeek:(NSDate *)date now:(NSDate *)now;
+ (BOOL)dateIsToday:(NSDate *)date now:(NSDate *)now;
+ (BOOL)dateIsThisYear:(NSDate *)date now:(NSDate *)now;
+ (BOOL)dateIsYesterday:(NSDate *)date now:(NSDate *)now;

@end

#pragma mark -

@interface NSString (OWS_Test)

- (NSString *)removeAllCharactersIn:(NSCharacterSet *)characterSet;

- (NSString *)filterUnsafeFilenameCharacters;

@end

#pragma mark -

@implementation UtilTest

-(void) testRemoveAllCharactersIn {
    testThrows([@"" removeAllCharactersIn:nil]);

    test([[@"" removeAllCharactersIn:NSCharacterSet.letterCharacterSet] isEqual:@""]);
    test([[@"1" removeAllCharactersIn:NSCharacterSet.letterCharacterSet] isEqual:@"1"]);
    test([[@"a" removeAllCharactersIn:NSCharacterSet.letterCharacterSet] isEqual:@""]);
    test([[@"A" removeAllCharactersIn:NSCharacterSet.letterCharacterSet] isEqual:@""]);
    test([[@"abc123%^&" removeAllCharactersIn:NSCharacterSet.letterCharacterSet] isEqual:@"123%^&"]);

    test([[@"" removeAllCharactersIn:NSCharacterSet.decimalDigitCharacterSet] isEqual:@""]);
    test([[@"1" removeAllCharactersIn:NSCharacterSet.decimalDigitCharacterSet] isEqual:@""]);
    test([[@"a" removeAllCharactersIn:NSCharacterSet.decimalDigitCharacterSet] isEqual:@"a"]);
    test([[@"A" removeAllCharactersIn:NSCharacterSet.decimalDigitCharacterSet] isEqual:@"A"]);
    test([[@"abc123%^&" removeAllCharactersIn:NSCharacterSet.decimalDigitCharacterSet] isEqual:@"abc%^&"]);
}

-(void) testDigitsOnly {
    test([@"".digitsOnly isEqual:@""]);
    test([@"1".digitsOnly isEqual:@"1"]);
    test([@"a".digitsOnly isEqual:@""]);
    test([@"(555) 235-7111".digitsOnly isEqual:@"5552357111"]);
}

- (void)testfilterUnsafeFilenameCharacters
{
    XCTAssertEqualObjects(@"1".filterUnsafeFilenameCharacters, @"1");
    XCTAssertEqualObjects(@"alice\u202Dbob".filterUnsafeFilenameCharacters, @"alice\uFFFDbob");
    XCTAssertEqualObjects(@"\u202Dalicebob".filterUnsafeFilenameCharacters, @"\uFFFDalicebob");
    XCTAssertEqualObjects(@"alicebob\u202D".filterUnsafeFilenameCharacters, @"alicebob\uFFFD");
    XCTAssertEqualObjects(@"alice\u202Ebob".filterUnsafeFilenameCharacters, @"alice\uFFFDbob");
    XCTAssertEqualObjects(@"\u202Ealicebob".filterUnsafeFilenameCharacters, @"\uFFFDalicebob");
    XCTAssertEqualObjects(@"alicebob\u202E".filterUnsafeFilenameCharacters, @"alicebob\uFFFD");
    XCTAssertEqualObjects(@"alice\u202Dbobalice\u202Ebob".filterUnsafeFilenameCharacters, @"alice\uFFFDbobalice\uFFFDbob");
}

- (void)testDateComparison
{
    NSDate *firstDate = [NSDate new];

    NSDate *sameDate = [NSDate dateWithTimeIntervalSinceReferenceDate:firstDate.timeIntervalSinceReferenceDate];
    NSDate *laterDate = [NSDate dateWithTimeIntervalSinceReferenceDate:firstDate.timeIntervalSinceReferenceDate + 1.f];

    XCTAssertEqual(firstDate.timeIntervalSinceReferenceDate, sameDate.timeIntervalSinceReferenceDate);
    XCTAssertNotEqual(firstDate.timeIntervalSinceReferenceDate, laterDate.timeIntervalSinceReferenceDate);
    XCTAssertEqualObjects(firstDate, sameDate);
    XCTAssertNotEqualObjects(firstDate, laterDate);
    XCTAssertTrue(firstDate.timeIntervalSinceReferenceDate < laterDate.timeIntervalSinceReferenceDate);
    XCTAssertFalse([firstDate isBeforeDate:sameDate]);
    XCTAssertTrue([firstDate isBeforeDate:laterDate]);
    XCTAssertFalse([laterDate isBeforeDate:firstDate]);
    XCTAssertFalse([firstDate isAfterDate:sameDate]);
    XCTAssertFalse([firstDate isAfterDate:laterDate]);
    XCTAssertTrue([laterDate isAfterDate:firstDate]);
}

- (void)testDateComparators
{
    // Use a specific reference date to make this test deterministic,
    // and to avoid failing around midnight, new year's, etc.
    NSDateComponents *nowDateComponents = [NSDateComponents new];
    nowDateComponents.year = 2015;
    nowDateComponents.month = 8;
    nowDateComponents.day = 31;
    nowDateComponents.hour = 8;
    NSDate *now = [[NSCalendar currentCalendar] dateFromComponents:nowDateComponents];

    NSDateFormatter *formatter = [NSDateFormatter new];
    formatter.dateStyle = NSDateFormatterLongStyle;
    formatter.timeStyle = NSDateFormatterLongStyle;
    NSLog(@"now: %@", [formatter stringFromDate:now]);

    NSDate *oneSecondAgo =
        [NSDate dateWithTimeIntervalSinceReferenceDate:[now timeIntervalSinceReferenceDate] - kSecondInterval];
    NSDate *oneMinuteAgo =
        [NSDate dateWithTimeIntervalSinceReferenceDate:[now timeIntervalSinceReferenceDate] - kMinuteInterval];
    NSDate *oneDayAgo =
        [NSDate dateWithTimeIntervalSinceReferenceDate:[now timeIntervalSinceReferenceDate] - kDayInterval];
    NSDate *threeDaysAgo =
        [NSDate dateWithTimeIntervalSinceReferenceDate:[now timeIntervalSinceReferenceDate] - kDayInterval * 3];
    NSDate *tenDaysAgo =
        [NSDate dateWithTimeIntervalSinceReferenceDate:[now timeIntervalSinceReferenceDate] - kDayInterval * 10];
    NSDate *oneYearAgo =
        [NSDate dateWithTimeIntervalSinceReferenceDate:[now timeIntervalSinceReferenceDate] - kYearInterval];
    NSDate *twoYearsAgo =
        [NSDate dateWithTimeIntervalSinceReferenceDate:[now timeIntervalSinceReferenceDate] - kYearInterval * 2];

    NSDate *oneSecondAhead =
        [NSDate dateWithTimeIntervalSinceReferenceDate:[now timeIntervalSinceReferenceDate] + kSecondInterval];
    NSDate *oneMinuteAhead =
        [NSDate dateWithTimeIntervalSinceReferenceDate:[now timeIntervalSinceReferenceDate] + kMinuteInterval];
    NSDate *oneDayAhead =
        [NSDate dateWithTimeIntervalSinceReferenceDate:[now timeIntervalSinceReferenceDate] + kDayInterval];
    NSDate *threeDaysAhead =
        [NSDate dateWithTimeIntervalSinceReferenceDate:[now timeIntervalSinceReferenceDate] + kDayInterval * 3];
    NSDate *tenDaysAhead =
        [NSDate dateWithTimeIntervalSinceReferenceDate:[now timeIntervalSinceReferenceDate] + kDayInterval * 10];
    NSDate *oneYearAhead =
        [NSDate dateWithTimeIntervalSinceReferenceDate:[now timeIntervalSinceReferenceDate] + kYearInterval];
    NSDate *twoYearsAhead =
        [NSDate dateWithTimeIntervalSinceReferenceDate:[now timeIntervalSinceReferenceDate] + kYearInterval * 2];

    NSLog(@"oneSecondAgo: %@", [formatter stringFromDate:oneSecondAgo]);

    XCTAssertTrue([DateUtil dateIsToday:oneSecondAgo now:now]);
    XCTAssertTrue([DateUtil dateIsToday:oneMinuteAgo now:now]);
    XCTAssertFalse([DateUtil dateIsToday:oneDayAgo now:now]);
    XCTAssertFalse([DateUtil dateIsToday:threeDaysAgo now:now]);
    XCTAssertFalse([DateUtil dateIsToday:tenDaysAgo now:now]);
    XCTAssertFalse([DateUtil dateIsToday:oneYearAgo now:now]);
    XCTAssertFalse([DateUtil dateIsToday:twoYearsAgo now:now]);

    XCTAssertTrue([DateUtil dateIsToday:oneSecondAhead now:now]);
    XCTAssertTrue([DateUtil dateIsToday:oneMinuteAhead now:now]);
    XCTAssertFalse([DateUtil dateIsToday:oneDayAhead now:now]);
    XCTAssertFalse([DateUtil dateIsToday:threeDaysAhead now:now]);
    XCTAssertFalse([DateUtil dateIsToday:tenDaysAhead now:now]);
    XCTAssertFalse([DateUtil dateIsToday:oneYearAhead now:now]);
    XCTAssertFalse([DateUtil dateIsToday:twoYearsAhead now:now]);

    XCTAssertFalse([DateUtil dateIsYesterday:oneSecondAgo now:now]);
    XCTAssertFalse([DateUtil dateIsYesterday:oneMinuteAgo now:now]);
    XCTAssertTrue([DateUtil dateIsYesterday:oneDayAgo now:now]);
    XCTAssertFalse([DateUtil dateIsYesterday:threeDaysAgo now:now]);
    XCTAssertFalse([DateUtil dateIsYesterday:tenDaysAgo now:now]);
    XCTAssertFalse([DateUtil dateIsYesterday:oneYearAgo now:now]);
    XCTAssertFalse([DateUtil dateIsYesterday:twoYearsAgo now:now]);

    XCTAssertFalse([DateUtil dateIsYesterday:oneSecondAhead now:now]);
    XCTAssertFalse([DateUtil dateIsYesterday:oneMinuteAhead now:now]);
    XCTAssertFalse([DateUtil dateIsYesterday:oneDayAhead now:now]);
    XCTAssertFalse([DateUtil dateIsYesterday:threeDaysAhead now:now]);
    XCTAssertFalse([DateUtil dateIsYesterday:tenDaysAhead now:now]);
    XCTAssertFalse([DateUtil dateIsYesterday:oneYearAhead now:now]);
    XCTAssertFalse([DateUtil dateIsYesterday:twoYearsAhead now:now]);

    XCTAssertFalse([DateUtil dateIsOlderThanToday:oneSecondAgo now:now]);
    XCTAssertFalse([DateUtil dateIsOlderThanToday:oneMinuteAgo now:now]);
    XCTAssertTrue([DateUtil dateIsOlderThanToday:oneDayAgo now:now]);
    XCTAssertTrue([DateUtil dateIsOlderThanToday:threeDaysAgo now:now]);
    XCTAssertTrue([DateUtil dateIsOlderThanToday:tenDaysAgo now:now]);
    XCTAssertTrue([DateUtil dateIsOlderThanToday:oneYearAgo now:now]);
    XCTAssertTrue([DateUtil dateIsOlderThanToday:twoYearsAgo now:now]);

    XCTAssertFalse([DateUtil dateIsOlderThanToday:oneSecondAhead now:now]);
    XCTAssertFalse([DateUtil dateIsOlderThanToday:oneMinuteAhead now:now]);
    XCTAssertFalse([DateUtil dateIsOlderThanToday:oneDayAhead now:now]);
    XCTAssertFalse([DateUtil dateIsOlderThanToday:threeDaysAhead now:now]);
    XCTAssertFalse([DateUtil dateIsOlderThanToday:tenDaysAhead now:now]);
    XCTAssertFalse([DateUtil dateIsOlderThanToday:oneYearAhead now:now]);
    XCTAssertFalse([DateUtil dateIsOlderThanToday:twoYearsAhead now:now]);

    XCTAssertFalse([DateUtil dateIsOlderThanOneWeek:oneSecondAgo now:now]);
    XCTAssertFalse([DateUtil dateIsOlderThanOneWeek:oneMinuteAgo now:now]);
    XCTAssertFalse([DateUtil dateIsOlderThanOneWeek:oneDayAgo now:now]);
    XCTAssertFalse([DateUtil dateIsOlderThanOneWeek:threeDaysAgo now:now]);
    XCTAssertTrue([DateUtil dateIsOlderThanOneWeek:tenDaysAgo now:now]);
    XCTAssertTrue([DateUtil dateIsOlderThanOneWeek:oneYearAgo now:now]);
    XCTAssertTrue([DateUtil dateIsOlderThanOneWeek:twoYearsAgo now:now]);

    XCTAssertFalse([DateUtil dateIsOlderThanOneWeek:oneSecondAhead now:now]);
    XCTAssertFalse([DateUtil dateIsOlderThanOneWeek:oneMinuteAhead now:now]);
    XCTAssertFalse([DateUtil dateIsOlderThanOneWeek:oneDayAhead now:now]);
    XCTAssertFalse([DateUtil dateIsOlderThanOneWeek:threeDaysAhead now:now]);
    XCTAssertFalse([DateUtil dateIsOlderThanOneWeek:tenDaysAhead now:now]);
    XCTAssertFalse([DateUtil dateIsOlderThanOneWeek:oneYearAhead now:now]);
    XCTAssertFalse([DateUtil dateIsOlderThanOneWeek:twoYearsAhead now:now]);

    XCTAssertTrue([DateUtil dateIsThisYear:oneSecondAgo now:now]);
    XCTAssertTrue([DateUtil dateIsThisYear:oneMinuteAgo now:now]);
    XCTAssertTrue([DateUtil dateIsThisYear:oneDayAgo now:now]);
    XCTAssertFalse([DateUtil dateIsThisYear:oneYearAgo now:now]);
    XCTAssertFalse([DateUtil dateIsThisYear:twoYearsAgo now:now]);

    XCTAssertTrue([DateUtil dateIsThisYear:oneSecondAhead now:now]);
    XCTAssertTrue([DateUtil dateIsThisYear:oneMinuteAhead now:now]);
    XCTAssertTrue([DateUtil dateIsThisYear:oneDayAhead now:now]);
    XCTAssertFalse([DateUtil dateIsThisYear:oneYearAhead now:now]);
    XCTAssertFalse([DateUtil dateIsThisYear:twoYearsAhead now:now]);
}

- (NSDate *)dateWithYear:(NSInteger)year
                   month:(NSInteger)month
                     day:(NSInteger)day
                    hour:(NSInteger)hour
                  minute:(NSInteger)minute
{
    NSDateComponents *components = [NSDateComponents new];
    components.year = year;
    components.month = month;
    components.day = day;
    components.hour = hour;
    components.minute = minute;
    return [[NSCalendar currentCalendar] dateFromComponents:components];
}

- (void)testDateComparators_timezoneVMidnight
{
    NSDateFormatter *formatter = [NSDateFormatter new];
    formatter.dateStyle = NSDateFormatterLongStyle;
    formatter.timeStyle = NSDateFormatterLongStyle;

    NSDate *yesterdayBeforeMidnight = [self dateWithYear:2015 month:8 day:10 hour:23 minute:55];
    NSLog(@"yesterdayBeforeMidnight: %@", [formatter stringFromDate:yesterdayBeforeMidnight]);

    NSDate *todayAfterMidnight = [self dateWithYear:2015 month:8 day:11 hour:0 minute:5];
    NSLog(@"todayAfterMidnight: %@", [formatter stringFromDate:todayAfterMidnight]);

    NSDate *todayNoon = [self dateWithYear:2015 month:8 day:11 hour:12 minute:0];
    NSLog(@"todayNoon: %@", [formatter stringFromDate:todayNoon]);

    // Before Midnight, after Midnight.
    XCTAssertFalse([DateUtil dateIsToday:yesterdayBeforeMidnight now:todayAfterMidnight]);
    XCTAssertTrue([DateUtil dateIsYesterday:yesterdayBeforeMidnight now:todayAfterMidnight]);
    XCTAssertTrue([DateUtil dateIsOlderThanToday:yesterdayBeforeMidnight now:todayAfterMidnight]);
    XCTAssertFalse([DateUtil dateIsOlderThanOneWeek:yesterdayBeforeMidnight now:todayAfterMidnight]);
    XCTAssertTrue([DateUtil dateIsThisYear:yesterdayBeforeMidnight now:todayAfterMidnight]);

    // Before Midnight, noon.
    XCTAssertFalse([DateUtil dateIsToday:yesterdayBeforeMidnight now:todayNoon]);
    XCTAssertTrue([DateUtil dateIsYesterday:yesterdayBeforeMidnight now:todayNoon]);
    XCTAssertTrue([DateUtil dateIsOlderThanToday:yesterdayBeforeMidnight now:todayNoon]);
    XCTAssertFalse([DateUtil dateIsOlderThanOneWeek:yesterdayBeforeMidnight now:todayNoon]);
    XCTAssertTrue([DateUtil dateIsThisYear:yesterdayBeforeMidnight now:todayNoon]);

    // After Midnight, noon.
    XCTAssertTrue([DateUtil dateIsToday:todayAfterMidnight now:todayNoon]);
    XCTAssertFalse([DateUtil dateIsYesterday:todayAfterMidnight now:todayNoon]);
    XCTAssertFalse([DateUtil dateIsOlderThanToday:todayAfterMidnight now:todayNoon]);
    XCTAssertFalse([DateUtil dateIsOlderThanOneWeek:todayAfterMidnight now:todayNoon]);
    XCTAssertTrue([DateUtil dateIsThisYear:todayAfterMidnight now:todayNoon]);
}

- (void)testObjectComparison
{
    XCTAssertTrue([NSObject isNullableObject:nil equalTo:nil]);
    XCTAssertFalse([NSObject isNullableObject:@(YES) equalTo:nil]);
    XCTAssertFalse([NSObject isNullableObject:nil equalTo:@(YES)]);
    XCTAssertFalse([NSObject isNullableObject:@(YES) equalTo:@(NO)]);
    XCTAssertTrue([NSObject isNullableObject:@(YES) equalTo:@(YES)]);
}

@end
