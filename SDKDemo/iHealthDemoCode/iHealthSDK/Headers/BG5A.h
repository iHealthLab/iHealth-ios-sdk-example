//
//  BG5A.h
//  iHealthDeviceSDK
//
//  Created by Spring on 2023/9/13.
//

#import <Foundation/Foundation.h>
#import "BGMacroFile.h"

typedef void(^BG5ASuccessBlock)(void);
typedef void(^BG5AErrorBlock)(BG5ADeviceError error);
typedef void(^BG5AHistoryBlock)(NSArray* _Nullable historyArray);

NS_ASSUME_NONNULL_BEGIN
@class BG5AInternal;
@interface BG5A : NSObject

/// Device's serial number which is same as Bluetooth MAC Address
@property (copy, nonatomic) NSString *serialNumber;

/// UUID from iOS system for Bluetooth Device
@property (copy, nonatomic) NSString *currentUUID;

/// IDPS: protocol
@property (copy, nonatomic,readonly) NSString *protocol;
/// IDPS: accessoryName
@property (copy, nonatomic,readonly) NSString *accessoryName;
/// IDPS: firmwareVersion
@property (copy, nonatomic,readonly) NSString *firmwareVersion;
/// IDPS: hardwareVersion
@property (copy, nonatomic,readonly) NSString *hardwareVersion;
/// IDPS: manufaturer
@property (copy, nonatomic,readonly) NSString *manufaturer;
/// IDPS: modelNumber
@property (copy, nonatomic,readonly) NSString *modelNumber;

/// Battery
@property (assign, nonatomic) uint8_t battery;

/// low Battery(YES:Battery low  NO: Battery normal )
@property (assign, nonatomic) BOOL lowBattery;

///device time
@property (assign, nonatomic) NSDate *deviceTS;

/// TimeZone
@property (assign, nonatomic) int deviceTimeZone;

/// history count
@property (assign, nonatomic) int historyCount;

/// unit
@property (assign, nonatomic) BGUnit bg5aUnit;

//strip State
@property (assign,nonatomic) BG5AStripState stripState;

/// An internal instance, not available for SDK users
@property (strong, nonatomic) BG5AInternal *internalDevice;

/// Get device information
/// - Parameters:
///   - success: successful callback,  battery:14（If the device is charging, the battery level will return to 0XFF）   protocol:com.jiuan.BGV45 accessoryName:BG5A11070 firmwareVersion:1.0.0 hardwareVersion:3.0.0 manufaturer:iHealth  modelNumber:BG5A 11070    deviceTS：2023-06-20 14:17:02 +0000 historyCount:1 unit:1  timezone:0  lowBattery:NO (YES:Battery low  NO: Battery normal )
///   - fail: error callback, see BG5ADeviceError
- (void)commandGetDeviceInfo:(BG5ASuccessBlock)success
                     fail:(BG5AErrorBlock)fail;

/// Change measure type. Default is BG5AMeasureType_BloodSugar.
/// - Parameters:
///   - type: Measure Type, see BG5AMeasureType
///   - success: successful callback
///   - fail: error callback. If the device collects enough blood and starts to measure, you cannot set measure type, and you will receive an error: BG5ADeviceError_RejectChangeMeasureType
- (void)commandSetMeasureType:(BG5AMeasureType)type
                      success:(BG5ASuccessBlock)success
                         fail:(BG5AErrorBlock)fail;
/**
 Set time

 @param date the date you want to set should be an UTC time. valid range:Jan. 1,2023 - Dec. 31,2099.
 @param timezone the timezone you want to set should be from -12.00 to 14.00; step length = 0.25
 @param success the block means success
 @param fail the block means fail. You can get error from this block
 @note  If date is out of range, BG5AError_InputParametersError will be returned by block.
        If date and timezone are valid , use input parameters; otherwise use [NSdate date] and system time zone;
 */
- (void)commandSetTimeWithDate:(NSDate *)date
               timezone:(float)timezone
                success:(BG5ASuccessBlock)success
                   fail:(BG5AErrorBlock)fail;

/**
 Set unit

 @param unit the unit you want to set (BGUnit_mmolPL stands for mmol/L,BGUnit_mgPmL stands for mg/dL)
 @param success the block means success
 @param fail the block means fail. You can get error from this block
 */
- (void)setUnit:(BGUnit)unit
        success:(BG5ASuccessBlock)success
           fail:(BG5AErrorBlock)fail;

/// Sync History
/// - Parameters:
///   - historyArray: successful callback    (
///{
///mac = "004D3201D6CD";
///isResultNeedCalibrate = 0;
///measureTs = 2023-05-19 14:28:51 +0000;
///mode = 0;//
///result= 200;
///metaData = <BG5AMeasureMetaData: 0x281a89f20>;
///errorCode=0;    If it is not 0, it means that it is a wrong result, and the subsequent blood sugar value is invalid
///timezone =0;
///}
///)
///   - fail: error callback, see BG5ADeviceError
- (void)commandSyncHistory:(BG5AHistoryBlock)historyArray
                     fail:(BG5AErrorBlock)fail;

/// Delete History
/// - Parameters:
///   - success: successful callback
///   - fail: error callback, see BG5ADeviceError
- (void)commandDeleteHistory:(BG5ASuccessBlock)success
                     fail:(BG5AErrorBlock)fail;


/**
 
 Is offline measurement allowed
 
 @param allowed  Is offline measurement allowed     0:Offline measurement is not allowed   1:allowed
 @param success the block means success
 @param fail the block means fail. You can get error from this block
 */
- (void)setOfflineMeasurementAllowed:(BOOL)allowed
                               success:(BG5ASuccessBlock)success
                                  fail:(BG5AErrorBlock)fail;


/**
 
 setCloseDeviceBLE
 ///After calling this method, the device will disconnect and will not perform Bluetooth broadcast. If you want to restore the device broadcast, please pass in the test strip to activate the device Bluetooth broadcast.
 @param success the block means success
 @param fail the block means fail. You can get error from this block
 */
- (void)setCloseDeviceBLE:(BG5ASuccessBlock)success
                     fail:(BG5AErrorBlock)fail;

/**
 
  setDeviceDisplay
 
 @param display  Is display allowed    0:Display is not allowed  1:allowed
 @param success the block means success
 @param fail the block means fail. You can get error from this block
 */
- (void)setDeviceDisplay:(BOOL)display
                 success:(BG5ASuccessBlock)success
                    fail:(BG5AErrorBlock)fail;

/** kBG5ANotiNameChargeState
 The device sends the measurement result (the value is in the unit mg/dL). The notification's userInfo:
 {
    mac = "385B44DDC723";
    state = 1; 1 enters the charging state, 2 exits the charging state, 3 is fully charged
 }
 **/

/**
 
 During the measurement process, please listen to the following notifications to obtain the measurement status and results of the BG5A device

1) kBG5ANotiNameStripStatus
  
 The device collects enough blood to measure, and the result will be post in a few seconds. The notification's userInfo:
  {
    mac = "004D3201D6CD";
    status = 0;
    Test strip status value: 0: The test strip is inserted, and blood can be dripped 1: The test strip is removed 2: Blood sucking starts 3: The blood sucking volume is insufficient for 1 4: The blood sucking volume is insufficient for 1 state for more than 5 seconds 5: The blood sucking volume is insufficient for 2 6: The blood sucking is completed
    type = 1;  1: Blood glucose 2: Uric acid 3: Quality control strip
  }
 
 2)  kBG5ANotiNameResult
 The device sends the measurement result (the value is in the unit mg/dL). The notification's userInfo:
 {
    mac = "385B44DDC723";
    result = 80;
    mode = 0;  Measure Type, see BG5AMeasureType
 }
**/


/// Active disconnect a device from app
- (void)commandDisconnectDevice;
@end

NS_ASSUME_NONNULL_END
