//
//  AM6Constants.h
//  iHealthDeviceSDK
//
//  Created by Spring on 2023/6/12.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN



/// Device  time structure
struct AM6DateStruct {
    uint32_t second:6;
    uint32_t min:6;
    uint32_t hour:5;
    uint32_t day:5;
    uint32_t month:4;
    uint32_t year:6;
};

/// AM6DailyReportStruct
struct AM6DailyReportStruct {
    struct AM6DateStruct date;
    uint32_t functionEnable;
    uint32_t steps;
    uint16_t calorie;
    uint8_t spo2;
    uint8_t heartRate;
    uint8_t heartRateMin;
    uint8_t heartRateMax;
    uint8_t heartRateAve;
    uint8_t heartRateResting;
    struct AM6DateStruct heartRateMinTime;
    struct AM6DateStruct heartRateMaxTime;
    uint8_t effectiveStand[3];
};


static inline struct AM6DateStruct AM6DateStructFromDate(NSDate *date){
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.dateFormat = @"yy-MM-dd-HH-mm-ss";
    dateFormatter.locale = [NSLocale localeWithLocaleIdentifier:@"en_US"];
    NSString *timeString = [dateFormatter stringFromDate:date];
    NSArray *arr = [timeString componentsSeparatedByString:@"-"];
    struct AM6DateStruct dateStruct = {0};
    dateStruct.year = [arr[0] intValue];
    dateStruct.month = [arr[1] intValue];
    dateStruct.day = [arr[2] intValue];
    dateStruct.hour = [arr[3] intValue];
    dateStruct.min = [arr[4] intValue];
    dateStruct.second = [arr[5] intValue];
    return dateStruct;
}

static inline NSData* AM6DataFromUint8(uint8_t value)
{
    uint8_t buffer[1];
    buffer[0] = value;
    return [[NSData alloc] initWithBytes:(void*)buffer length:1];
}

/// Convert AM6DateStruct to a date string, yyyy-MM-dd HH:mm:ss
/// @param s Device-side time structure
static inline NSString *StringFromAM6DateStruct(struct AM6DateStruct s){
    return  [NSString stringWithFormat:@"20%02d-%02d-%02d %02d:%02d:%02d",s.year,s.month,s.day,s.hour,s.min,s.second];
}
static inline NSData *DataFromAM6DateStruct(struct AM6DateStruct s){
    return [NSData dataWithBytes:&s length:4];
}

/// AM6DeviceDailyActivityReportModel
@interface AM6DeviceDailyActivityReportModel : NSObject
/// yyyyMMddHHmmss  formate
@property (copy, nonatomic) NSString *dateString;
@property (assign, nonatomic) uint32_t functionEnable;
@property (assign, nonatomic) uint32_t steps;
@property (assign, nonatomic) uint16_t calorie;
@property (assign, nonatomic) uint8_t spo2;
@property (assign, nonatomic) uint8_t heartRate;
@property (assign, nonatomic) uint8_t heartRateMin;
@property (assign, nonatomic) uint8_t heartRateMax;
@property (assign, nonatomic) uint8_t heartRateAve;
@property (assign, nonatomic) uint8_t heartRateResting;
@property (copy, nonatomic) NSString *heartRateMinTime;
@property (copy, nonatomic) NSString *heartRateMaxTime;
@property (assign, nonatomic) uint32_t effectiveStand;
- (instancetype)initWithData:(NSData*)data;
@end

/// AM6DeviceDailyStepModel
@interface AM6DeviceDailyStepModel : NSObject
/// yyyyMMddHHmmss  formate
@property (copy, nonatomic) NSString *dateString;
@property (copy, nonatomic) NSArray<NSNumber *> *stepsArray;
@property (copy, nonatomic) NSArray<NSNumber *> *calorieArray;
@property (copy, nonatomic) NSArray<NSNumber *> *distanceArray;//unit：meter
- (instancetype)initWithData:(NSData*)data;
@end

@interface AM6DeviceActivityDataModel : NSObject
@property (copy, nonatomic) NSString *date;
@property (assign, nonatomic) NSInteger steps;
@property (assign, nonatomic) NSInteger calories;
@property (assign, nonatomic) NSInteger spo;
@property (copy, nonatomic) NSArray<NSNumber*> *stepsList;
@property (copy, nonatomic) NSArray<NSNumber*> *caloriesList;
@property (copy, nonatomic) NSArray<NSNumber*> *distanceList;
@property (assign, nonatomic) NSInteger heartRate;
@property (assign, nonatomic) NSInteger heartRateMin;
@property (assign, nonatomic) NSInteger heartRateMax;
@property (assign, nonatomic) NSInteger heartRateAve;
@property (assign, nonatomic) NSInteger heartRateRest;
@property (copy, nonatomic) NSString *heartRateMinDate;
@property (copy, nonatomic) NSString *heartRateMaxDate;
@property (assign, nonatomic) NSInteger effectiveStand;
@end


/// AM6DeviceSleepStatus
typedef NS_ENUM(int, AM6DeviceSleepStatus) {
    AM6DeviceSleepStatus_Default = 0x00,
    AM6DeviceSleepStatus_StartSleep = 0x01,
    AM6DeviceSleepStatus_LightSleep = 0x02,
    AM6DeviceSleepStatus_DeepSleep = 0x03,
    AM6DeviceSleepStatus_Awake = 0x04,
    AM6DeviceSleepStatus_StopSleep = 0x05,
    AM6DeviceSleepStatus_FastEyeMotion = 0x06,
    
};

/// each stage of sleep
@interface AM6DeviceSleepItem : NSObject
/// HHmm formate
@property (copy, nonatomic) NSString *timeString;
@property (assign, nonatomic) AM6DeviceSleepStatus status;
@end

/// Single sleep data
@interface AM6DeviceSleepModel : NSObject
/// yyyyMMddHHmmss formate
@property (copy, nonatomic) NSString *dateString;
@property (copy, nonatomic) NSArray<AM6DeviceSleepItem*> *dataArray;
- (instancetype)initWithData:(NSData*)data;
@end


@interface AM6DeviceOffineBloodOxygenModel : NSObject
/// yyyyMMddHHmmss formate
@property (copy, nonatomic) NSString *dateString;
@property (assign, nonatomic) uint8_t value;
@end

/// AM6DeviceHeartRateModel
@interface AM6DeviceHeartRateModel : NSObject
/// yyyyMMddHHmmss formate
@property (copy, nonatomic) NSString *dateString;
@property (copy, nonatomic) NSArray<NSNumber *> *dataArray;
- (instancetype)initWithData:(NSData*)data;
@end


/// AM6DeviceSportType
typedef NS_ENUM(NSInteger,AM6DeviceSportType) {
    AM6DeviceSportType_No = 0,
    AM6DeviceSportType_IndoorRun = 3,
};
/// AM6DeviceSportDataType
typedef NS_ENUM(NSInteger,AM6DeviceSportDataType) {
    AM6DeviceSportDataType_Stastics = 0,
    AM6DeviceSportDataType_Report = 1,
    AM6DeviceSportDataType_GPS = 2,
};

/// Base class for motion data
@interface AM6DeviceBaseSport : NSObject
/// time
@property (copy, nonatomic) NSString *mainDateString;
///
@property (assign, nonatomic) int8_t timeZone;
/// The default version is 1
@property (assign, nonatomic) uint8_t version;
/// Type description 0=reserved (invalid), 1=motion data, default 1
@property (assign, nonatomic) uint8_t typeDescription;
/// sportType
@property (assign, nonatomic) AM6DeviceSportType type;
/// dataType
@property (assign, nonatomic) AM6DeviceSportDataType dataType;

@end

///
@interface AM6DeviceIndoorRunPart : NSObject
@property (copy, nonatomic) NSString *dateString;
@property (copy, nonatomic) NSArray *calorieArray;
@property (copy, nonatomic) NSArray *stepArray;
@property (copy, nonatomic) NSArray *heartArray;
@property (copy, nonatomic) NSArray *distanceArray;
@end


/// Indoor running data class
@interface AM6DeviceIndoorRun : AM6DeviceBaseSport
@property (copy, nonatomic) NSArray<AM6DeviceIndoorRunPart *> *dataArray;
- (instancetype)initWithData:(NSData*)data;
@end

/// Report data class for indoor running
@interface AM6DeviceIndoorRunReport : AM6DeviceBaseSport
@property (copy, nonatomic) NSString *startDateString;
@property (copy, nonatomic) NSString *endDateString;
@property (assign, nonatomic) NSInteger totalTime;
@property (assign, nonatomic) NSInteger totalDistance;
@property (assign, nonatomic) NSInteger totalCalorie;
@property (assign, nonatomic) NSInteger maxPace;
@property (assign, nonatomic) NSInteger minPace;
@property (assign, nonatomic) NSInteger totalStep;
@property (assign, nonatomic) NSInteger maxStepFrequency;
@property (assign, nonatomic) NSInteger aveHeartRate;
@property (assign, nonatomic) NSInteger maxHeartRate;
@property (assign, nonatomic) NSInteger minHeartRate;
@property (assign, nonatomic) float trainingEffect;
@property (assign, nonatomic) NSInteger maxOxygenUptake;
@property (assign, nonatomic) NSInteger bodyEnergyCost;
@property (assign, nonatomic) NSInteger estimatedRecoveryTime;
@property (assign, nonatomic) NSInteger peakTime;
@property (assign, nonatomic) NSInteger anaerobicTime;
@property (assign, nonatomic) NSInteger cardioTime;
@property (assign, nonatomic) NSInteger fatReductionTime;
@property (assign, nonatomic) NSInteger warmUpTime;
- (instancetype)initWithData:(NSData*)data;
@end



@interface AM6AlarmModel : NSObject
// Switch Status
@property (assign, nonatomic) BOOL isOn;

/// Alarm Repeat Mode, randge: 0x00~0x7F, bit0-bit6 refer to Sunday to Staturday, 1: repeat 0: not repeat. For example, 0x41(0100 0001) means repeat at weekends, 0x3E(0011 1110) means repeat on weekdays and 0x00(0000 00000) means no repeat.
@property (assign, nonatomic) uint8_t repeatMode;

/// Only hour and minute Available
@property (assign, nonatomic) struct AM6DateStruct date;
- (nullable NSData*)commandData;
- (instancetype)initWithData:(NSData*)data;

@end



@interface AM6Constants : NSObject

@end

NS_ASSUME_NONNULL_END
