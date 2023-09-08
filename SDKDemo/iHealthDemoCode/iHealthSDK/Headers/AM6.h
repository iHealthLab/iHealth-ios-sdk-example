//
//  AM6.h
//  iHealthDeviceSDK
//
//  Created by Spring on 2023/4/19.
//

#import <Foundation/Foundation.h>
#import "AMMacroFile.h"
NS_ASSUME_NONNULL_BEGIN


@class WZLatteDevice;
@interface AM6 : NSObject
@property (strong, nonatomic) NSString *currentUUID;
@property (strong, nonatomic) NSString *serialNumber;
/// An internal instance, not available for SDK users
@property (weak, nonatomic) WZLatteDevice *internalDevice;

#pragma mark - Device Time

///deviceTime   20230630162155
@property (copy, nonatomic) NSString *deviceTime;
///Whether the time format is 12-hour format
@property (assign, nonatomic) BOOL is12HoursFormat;

#pragma mark - DeviceInfo
/// battery 0-100
@property (assign, nonatomic) uint8_t battery;
/// Charging Status
@property (assign, nonatomic) BOOL isCharging;
/// firmwareVersion
@property (copy, nonatomic) NSString *firmwareVersion;
/// hardwareVersion
@property (copy, nonatomic) NSString *hardwareVersion;
/// Firmware side communication SDK version
@property (copy, nonatomic) NSString *sdkFirmwareVersion;
/// 0: The watch is not bound (QR code state) 1: The watch is bound (normal state)
@property (assign, nonatomic) BOOL bindStatus;

#pragma mark - Stretch Reminder
@property (assign, nonatomic) BOOL isStretchReminderOn;
@property (assign, nonatomic) NSInteger stretchReminderStartTime;// (24-hour format, minimum 0 minutes)
@property (assign, nonatomic) NSInteger stretchReminderEndTime;//(24-hour format, max 1439 minutes)

#pragma mark - Activity Goal
@property (assign, nonatomic) BOOL isActivityGoalOn;
@property (assign, nonatomic) uint32_t stepsGoal;
@property (assign, nonatomic) uint32_t caloGoal;

#pragma mark - Do Not Disturb
@property (assign, nonatomic) BOOL isDoNotDisturbOn;
@property (assign, nonatomic) NSInteger doNotDisturbStartTime;
@property (assign, nonatomic) NSInteger doNotDisturbEndTime;

#pragma mark - Raise to Wake
@property (assign, nonatomic) BOOL isRaiseToWakeOn;
@property (assign, nonatomic) NSInteger raiseToWakeStartTime;
@property (assign, nonatomic) NSInteger raiseToWakeEndTime;

#pragma mark - Wearing Wrist
@property (assign, nonatomic) NSInteger wristHand;// 0 left 1 right

#pragma mark - Alarm
@property (copy, nonatomic, nullable) NSArray<AM6AlarmModel*> *alarmList;

#pragma mark - notification
/// notification switch
@property (assign, nonatomic) BOOL notificationEnable;

#pragma mark - Data
/// DailyActivityReport
@property (strong, nonatomic, nullable) NSArray<AM6DeviceDailyActivityReportModel*> *reportArray;
/// Step calorie array, calorie, heart rate array 6*24 bytes, one per hour
@property (copy, nonatomic, nullable) NSArray<AM6DeviceDailyStepModel*> *dailyStepsArray;
/// sleepArray
@property (copy, nonatomic, nullable) NSArray<AM6DeviceSleepModel*> *sleepArray;
/// bloodOxygenArray
@property (copy, nonatomic, nullable) NSArray<AM6DeviceOffineBloodOxygenModel*> *bloodOxygenArray;
///Heart rate array, a model with 288 points, one every 5 minutes
@property (copy, nonatomic, nullable) NSArray<AM6DeviceHeartRateModel*> *dailyHeartRateArray;
///indoorRunArray
@property (copy, nonatomic, nullable) NSArray<AM6DeviceIndoorRun*> *indoorRunArray;
/// indoorRunReportArray
@property (copy, nonatomic, nullable) NSArray<AM6DeviceIndoorRunReport*> *indoorRunReportArray;
/**
 * App sends StartBind to device
 *@param success  After calling this API, AM6 will display the pairing interface
 *@param fail  fail
 */
- (void)sendStartBindWithSuccess:(DisposeAM6SuccessBlock)success
                 fail:(DisposeAM6ErrorBlock)fail;


/**
 * The app sends the binding success to the device
 *@param userId   we recommend use user id's md5-16 value, 16 bytes length
 *@param success  After calling this API, AM6 will display the binding successful interface
 *@param fail  fail
 */
- (void)sendSuccessBindWithUserId:(NSData*)userId
                          success:(DisposeAM6SuccessBlock)success
                              fail:(DisposeAM6ErrorBlock)fail;


/**
 * The app sends the binding fail to the device
 *@param success  After calling this API, AM6 will display the binding fail interface
 *@param fail  fail
 */
- (void)sendFailBindWithSuccess:(DisposeAM6SuccessBlock)success
                              fail:(DisposeAM6ErrorBlock)fail;


/**
 * App sends unbind to device
 *@param userId   we recommend use user id's md5-16 value, 16 bytes length
 *@param success  success
 *@param fail  fail
 */
- (void)sendUnbindWithUserId:(NSData*)userId
                     success:(DisposeAM6SuccessBlock)success
                        fail:(DisposeAM6ErrorBlock)fail;


/**
 * Set user info
 * Setting user information to AM6 is to calculate parameters such as step length, exercise sleep and so on.
 *@param userId we recommend use user id's md5-16 value, 16 bytes length
 *@param gender 0: male 1: female
 *@param age  age
 *@param height height, in cm  1-255(Please set strictly according to this range, and the data beyond the range will be assigned according to the upper and lower limits.)
 *@param weight Weight, in kg  1-300(Please set strictly according to this range, and the data beyond the range will be assigned according to the upper and lower limits.)
 *@param success  success
 *@param fail  fail
 */
- (void)setUserInfoWithUserIdMD5:(NSData*)userId
                          gender:(uint8_t)gender
                             age:(uint8_t)age
                          height:(uint8_t)height
                          weight:(double)weight
                         success:(DisposeAM6SuccessBlock)success
                            fail:(DisposeAM6ErrorBlock)fail;


/**
 * Get the current time of the AM6
 *@param success  You can get data by reading:  deviceTime, is12HoursFormat
 *@param fail  fail
 */
- (void)queryDeviceTimeWithSuccess:(DisposeAM6SuccessBlock)success
                              fail:(DisposeAM6ErrorBlock)fail;


/**
 * Query device information and synchronize time to the device
 *
 *The device must call this API every time it is connected, so that the latest time can be synchronized to AM6.
 *
 *@param success  You can get data by reading:  battery, isCharging,firmwareVersion,sdkFirmwareVersion,hardwareVersion,bindStatus
 *{
 * battery = 100;   Power 0-100
 * isCharging = 0;  0:NO Charging  1:Charging
 * firmwareVersion = "0.1.1";  FirmwareVersion
 * hardwareVersion = "1.0.0";  HardwareVersion
 * sdkFirmwareVersion = "1.0.0";  sdkFirmwareVersion
 * bindStatus = 1;    0: The watch is not bound (QR code state) 1: The watch is bound (normal state)
}
 *@param fail  fail
 */
- (void)queryDeviceInfoAndSyncTimeWithSuccess:(DisposeAM6SuccessBlock)success
                                         fail:(DisposeAM6ErrorBlock)fail;


/**
 * Set platform to iOS
 * @param success  The platform is set so that AM6 can normally receive notifications on the phone.After calling this API, the system will pop up a pop-up window asking whether to pair uniformly. If you choose to agree, then AM6 will perform Bluetooth pairing with the mobile phone, and next time AM6 will automatically connect to the mobile phone via Bluetooth. If you choose not to agree, then the AM6 and mobile phone Bluetooth will not be automatically connected.
 * @param fail Communication error codes, see AM6 error descriptions.
 */
- (void)setPlatformWithSuccess:(DisposeAM6SuccessBlock)success
                          fail:(DisposeAM6ErrorBlock)fail;

/**
 * Query notification switch
 * @param success   notificationEnable    0:close 1:open
 * @param fail Communication error codes, see AM6 error descriptions.
 */
- (void)queryNotificationStateWithSuccess:(DisposeAM6SuccessBlock)success
                                     fail:(DisposeAM6ErrorBlock)fail;
/**
 * Set notification switch
 * @param enable YES：open  NO：close
 * @param success  success
 * @param fail Communication error codes, see AM6 error descriptions.
 */
- (void)setNotificationStatus:(BOOL)enable
                      success:(DisposeAM6SuccessBlock)success
                         fail:(DisposeAM6ErrorBlock)fail;
/**
 * Query whether ANCS has been authorized
 *
 *The purpose of Apple Notification Center Service (ANCS) is to provide a simple and convenient way for Bluetooth peripherals to obtain notification information of ios devices.
 *
 *If the query authorization is turned off, it will affect your normal  receiving notifications.
 */
- (BOOL)queryAncsAuthorizedStatus NS_AVAILABLE_IOS(13);

/**
 * findDevice
 * @param flag 0: start 1: end
 * @param success  If you call the search device interface, AM6 will keep vibrating
 * @param fail Communication error codes, see AM6 error descriptions.
 */
- (void)findDevice:(uint8_t)flag
           success:(DisposeAM6SuccessBlock)success
              fail:(DisposeAM6ErrorBlock)fail;


/**
 *Start FindPhone
 *
 *If you want to use this feature, please listen to this notification:
 *
 *AM6StartFindPhoneNoti
 *
 */

/**
 * Stop FindPhone
 *
 *If you want to use this feature, please listen to this notification:
 *
 *AM6StopFindPhoneNoti
 *
 */


/**
 * rebootDevice
 * @param success    Call this API, AM6 will disconnect from the phone and restart
 * @param fail Communication error codes, see AM6 error descriptions.
 */
- (void)rebootDeviceWithSuccess:(DisposeAM6SuccessBlock)success
                           fail:(DisposeAM6ErrorBlock)fail;
/**
 * queryGoalReminder
 * @param success  :  isActivityGoalOn(YES or NO),caloGoal,stepsGoal
 * @param fail Communication error codes, see AM6 error descriptions.
 */
- (void)queryGoalReminderWithSuccess:(DisposeAM6SuccessBlock)success
                                fail:(DisposeAM6ErrorBlock)fail;

/**
 * setGoalReminder
 * @param enable YES：open，NO：close
 * @param calorie  Calorie Goal (0-65535 Cal)
 * @param steps  step goal(0-65534)
 * @param success  success
 * @param fail Communication error codes, see AM6 error descriptions.
 */
- (void)setGoalReminderEnable:(BOOL)enable
                      calorie:(uint32_t)calorie
                        steps:(uint32_t)steps
                      success:(DisposeAM6SuccessBlock)success
                         fail:(DisposeAM6ErrorBlock)fail;
/**
 * queryStretchReminder
 * @param success  : isStretchReminderOn(YES or NO) ,stretchReminderStartTime(24-hour format, minimum 0 minutes),stretchReminderEndTime((24-hour format, max 1439 minutes)
 * @param fail Communication error codes, see AM6 error descriptions.
 */
- (void)queryStretchReminderWithSuccess:(DisposeAM6SuccessBlock)success
                                   fail:(DisposeAM6ErrorBlock)fail;
/**
 * setStretchReminder
 * @param enable YES：open，NO：close
 * @param start  Minute to start (24-hour format, minimum 0 minutes)
 * @param end  Ending minute (24-hour format, max 1439 minutes)
 * @param success  success
 * @param fail Communication error codes, see AM6 error descriptions.
 */
- (void)setStretchReminderEnable:(BOOL)enable
                           start:(NSInteger)start
                             end:(NSInteger)end
                         success:(DisposeAM6SuccessBlock)success
                            fail:(DisposeAM6ErrorBlock)fail;
/**
 * queryRaiseWake
 * @param success : isRaiseToWakeOn(YES or NO) ,raiseToWakeStartTime (24-hour format, minimum 0 minutes),raiseToWakeEndTime(24-hour format, max 1439 minutes)
 * @param fail Communication error codes, see AM6 error descriptions.
 */
- (void)queryRaiseWakeWithSuccess:(DisposeAM6SuccessBlock)success
                             fail:(DisposeAM6ErrorBlock)fail;

/**
 * setRaiseWake
 * @param enable YES：open，NO：close
 * @param start  Minute to start (24-hour format, minimum 0 minutes)
 * @param end  Ending minute (24-hour format, max 1439 minutes)
 * @param success  success
 * @param fail Communication error codes, see AM6 error descriptions.
 */
- (void)setRaiseWakeEnable:(BOOL)enable
                     start:(NSInteger)start
                       end:(NSInteger)end
                   success:(DisposeAM6SuccessBlock)success
                      fail:(DisposeAM6ErrorBlock)fail;

/**
 * queryNotDisturb
 * @param success  : isDoNotDisturbOn(YES or NO) ,doNotDisturbStartTime (24-hour format, minimum 0 minutes), doNotDisturbEndTime(24-hour format, max 1439 minutes)
 * @param fail Communication error codes, see AM6 error descriptions.
 */
- (void)queryNotDisturbWithSuccess:(DisposeAM6SuccessBlock)success
                              fail:(DisposeAM6ErrorBlock)fail;

/**
 * setNotDisturb
 * @param enable YES：open，NO：close
 * @param start  Minute to start (24-hour format, minimum 0 minutes)
 * @param end  Ending minute (24-hour format, max 1439 minutes)
 * @param success  success
 * @param fail Communication error codes, see AM6 error descriptions.
 */
- (void)setNotDisturbEnable:(BOOL)enable
                      start:(NSInteger)start
                        end:(NSInteger)end
                    success:(DisposeAM6SuccessBlock)success
                       fail:(DisposeAM6ErrorBlock)fail;
/**
 * queryWearHand
 * @param success wristHand:   0 left 1 right
 * @param fail Communication error codes, see AM6 error descriptions.
 */
- (void)queryWearHandWithSuccess:(DisposeAM6SuccessBlock)success
                            fail:(DisposeAM6ErrorBlock)fail;

/**
 * setWearHand
 * @param hand 0x00: left 0x01: right
 * @param success  success
 * @param fail Communication error codes, see AM6 error descriptions.
 */
- (void)setWearHand:(uint8_t)hand
            success:(DisposeAM6SuccessBlock)success
               fail:(DisposeAM6ErrorBlock)fail;


/**
 * setAlartList
 * @param alarmArray AM6AlarmModel Array
 *
 *AM6AlarmModel
 *
// Switch Status
@property (assign, nonatomic) BOOL isOn;

/// Alarm Repeat Mode, randge: 0x00~0x7F, bit0-bit6 refer to Sunday to Staturday, 1: repeat 0: not repeat. For example, 0x41(0100 0001) means repeat at weekends, 0x3E(0011 1110) means repeat on weekdays and 0x00(0000 00000) means no repeat.
@property (assign, nonatomic) uint8_t repeatMode;

/// Only hour and minute Available
@property (assign, nonatomic) struct AM6DateStruct date;
- (nullable NSData*)commandData;
- (instancetype)initWithData:(NSData*)data;

 * @param success  success
 * @param fail Communication error codes, see AM6 error descriptions.
 */
- (void)setAlartList:(NSArray<AM6AlarmModel*> *)alarmArray
             success:(DisposeAM6SuccessBlock)success
                fail:(DisposeAM6ErrorBlock)fail;

/**
 * queryAlarmList
 * @param success  alarmList(AM6AlarmModel)
 * @param fail Communication error codes, see AM6 error descriptions.
 */
- (void)queryAlarmListWithSuccess:(DisposeAM6SuccessBlock)success
                             fail:(DisposeAM6ErrorBlock)fail;

/**
 * Delete specified historical data
 * @param type in order bit0: steps and calories bit1: sleep bit2: heart rate bit3: blood oxygen bit4: daily bit5: multi-sports, the highest bit is 1 all delete all the corresponding data on the above bits If you need to delete, it is 1 If you don’t need to delete is 0
 *
 * type example
 * 0x0010     deleteDailyActivityReport
 * 0x0001     deleteDailyStepsCalorieDistance
 * 0x0002     deleteSleepData
 * 0x0004     deleteDailyHeartRate
 * 0x0008     deleteOfflineBloodOxygen
 * 0x0020     deleteSport
 * 0x8000    deleteAllData
 * @param success  success
 * @param fail Communication error codes, see AM6 error descriptions.
 */
- (void)deleteDataWithType:(uint16_t)type
                   success:(DisposeAM6SuccessBlock)success
                          fail:(DisposeAM6ErrorBlock)fail;


/**
 * Prepare the synchronization command. Before synchronizing data, you need to call this command once!!!!
 * @param success  success
 * @param fail Communication error codes, see AM6 error descriptions.
 */
- (void)prepareSyncWithSuccess:(DisposeAM6SuccessBlock)success
                          fail:(DisposeAM6ErrorBlock)fail;

/**
 * Sync daily, up to 15 days
 * @param success  :NSArray<AM6DeviceDailyActivityReportModel*> *reportArray
 {
 calorie = 0;  // The calorie of daily report
 dateString = 2020-02-29 00:00:00;   // The date of daily report
 effectiveStand = 0; //Effective standing mark 24bits to mark whether there is effective standing from 0~1 point, 1~2 point, ... to 23~24 point
 functionEnable = 2047;
 heartRate = 0;   // The heart rate of daily report
 heartRateAve = 0; ;// The ave heart rate of daily report
 heartRateMax = 0;// The max heart rate of daily report
 heartRateMaxTime = 2020-02-29 00:00:00; // The time of day when your maximum heart rate occurs
 heartRateMin = 0;   // The min heart rate of daily report
 heartRateMinTime = 2020-02-29 00:00:00;   // The time of day when the minimum heart rate occurs
 heartRateResting = 0;  // The rest heart rate of daily report
 spo2 = 0;   // The blood oxygen of daily report
 steps = 0;  // The step of daily report
}
 * @param fail Communication error codes, see AM6 error descriptions.
 */
- (void)syncDailyActivityReportWithSuccess:(DisposeAM6SuccessBlock)success
                                      fail:(DisposeAM6ErrorBlock)fail;

/**
 * Synchronize daily records of steps, calories, distance details, up to 15 days, 1 set of values per hour
 * @param success  :NSArray<AM6DeviceDailyStepModel*> *dailyStepsArray;
 (   {
 calorieArray =         (
     2850............
 );
 dateString = 2020-02-29 00:00:00;// time of this day
 distanceArray =         (
     2850.............
 );
 stepsArray =         (
     2850.................
 );
},
)
 * @param fail Communication error codes, see AM6 error descriptions.
 */
- (void)syncDailyStepsCalorieDistanceWithSuccess:(DisposeAM6SuccessBlock)success
                                            fail:(DisposeAM6ErrorBlock)fail;

/**
 * Synchronized sleep, up to 15 days
 *
 *One sleep data per day. When the sleep state changes, add an item data point.
 *
 * @param success  :NSArray<AM6DeviceSleepModel*> *sleepArray;
 (  {
         dataArray =         (
                         {
                 status = 1;//0x01 enter sleep 0x02 light sleep 0x03 deep sleep 0x04 wake up 0x05 exit sleep 0x06 rapid eye movement (REM)
                 timeString = 22:01;  //Sleep time   22:hour 01:minute
             },
         );
         dateString = 2020-02-29 00:00:00;//Sleep date
     },
)
 * @param fail Communication error codes, see AM6 error descriptions.
 */

- (void)syncSleepWithSuccess:(DisposeAM6SuccessBlock)success
                        fail:(DisposeAM6ErrorBlock)fail;

/**
 * Synchronous offline blood oxygen, 8
 * @param success  :NSArray<AM6DeviceOffineBloodOxygenModel*> *bloodOxygenArray;
 (
 {
 dateString = 2020-02-29 00:00:00; //date
 value = 15; //For each measurement, increment the value by 1.
},
)
 * @param fail Communication error codes, see AM6 error descriptions.
 */
- (void)syncOfflineBloodOxygenWithSuccess:(DisposeAM6SuccessBlock)success
                                     fail:(DisposeAM6ErrorBlock)fail;

/**
 * Synchronize daily heart rate, up to 15 days
 * One value every 5 minutes, a total of 288 values per day.
 * @param success  :NSArray<AM6DeviceHeartRateModel*> *dailyHeartRateArray;
 (
  {
         dataArray =         (      // The value of heart rate
             0..........
         );
         dateString = 2020-02-29 00:00:00;//date
  },
)
 * @param fail Communication error codes, see AM6 error descriptions.
 */

- (void)syncDailyHeartRateWithSuccess:(DisposeAM6SuccessBlock)success
                                 fail:(DisposeAM6ErrorBlock)fail;
/**
 * Synchronize sports data (dotted data and report data)
 *
 *The device uploads the daily data management results to the mobile phone, and counts the data every hour, including the number of steps, calories, and distance.
 * @param success  :
 NSArray<AM6DeviceIndoorRun*> *indoorRunArray
 (
         {
         dataArray =         (
                         {
                 calorieArray =   (                                //calorieArray
                     61,
                     61,..............
                      )
                 dateString = 2020-02-29 00:00:00;        //date
                 distanceArray =  (                             //distanceArray
                     28,
                     28,.................
                   )
                 stepArray=  (                                    //stepArray
                     28,
                     28,.................
                   )
                        }
                    )
         }
 )
 NSArray<AM6DeviceIndoorRunReport*> *indoorRunReportArray;
 (
         {
         anaerobicTime = 20;     // The anaerobic endurance duration, the unit is second
         aveHeartRate = 178;     // The average heart rate
         bodyEnergyCost = 0;    // The body energy expenditure, the range is 0 ~ 100
         cardioTime = 20;          // The aerobic endurance duration, the unit is second
         dataType = 0;              //dataType
         endDateString = 2020-02-29 00:00:00;  // The end time of activity
         estimatedRecoveryTime = 0;            // The estimated recovery time
         fatReductionTime = 20;      // The fat burning duration, the unit is second
         maxHeartRate = 255;      // The max heart rate
         maxOxygenUptake = 0;  // The max oxygen uptake, the unit is milliliter/minute
         maxPace = 320;             // The max running pace, the unit is second / 100 meter
         maxStepFrequency = 336;    // The max freguency of step
         minHeartRate = 0;        // The min heart rate
         minPace = 400;            // The min running pace, the unit is second / 100 meter
         peakTime = 20;           // The ultimate heart rate duration, the unit is second
         startDateString = 2020-02-29 00:00:00;   // The start time of activity
         timeZone = 0;                     //timeZone
         totalCalorie = 65535;         //Current total active calories
         totalDistance = 30000;      //Current total Distance
         totalStep = 60000;            //Current total steps
         totalTime = 10800;           //Current total Time
         trainingEffect = 0;            // The training effect
         type = 0;                          //type
         typeDescription = 0;        //typeDescription
         version = 0;                      //version
         warmUpTime = 20;         // The warm up time, the unit is secode
     },
)
 * @param fail Communication error codes, see AM6 error descriptions.
 */
- (void)syncSportWithSuccess:(DisposeAM6SuccessBlock)success
                        fail:(DisposeAM6ErrorBlock)fail;

/**
 * Disconnect AM6 connection.
 * @param success  success
 * @param fail Communication error codes, see AM6 error descriptions.
 */
-(void)commandAM6Disconnect:(DisposeAM6SuccessBlock)success
                       fail:(DisposeAM6ErrorBlock)fail;
@end

NS_ASSUME_NONNULL_END
