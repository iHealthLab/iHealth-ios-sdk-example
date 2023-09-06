//
//  BG1A.h
//  iHealthDeviceSDK
//
//  Created by Lei Bao on 2022/9/13.
//

#import <Foundation/Foundation.h>
#import "BGMacroFile.h"

typedef void(^BG1ASuccessBlock)(void);
typedef void(^BG1AErrorBlock)(BG1ADeviceError error);
typedef void(^BG1AHistoryBlock)(NSArray* _Nullable historyArray);

NS_ASSUME_NONNULL_BEGIN
@class BG1AInternal;
@interface BG1A : NSObject

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

///device time
@property (assign, nonatomic) NSDate *deviceTS;

/// Is there any unuploaded data from the last measurement
@property (assign, nonatomic) BOOL hasHistoryResult;

//strip State
@property (assign,nonatomic) BG1AStripState stripState;

/// An internal instance, not available for SDK users
@property (strong, nonatomic) BG1AInternal *internalDevice;

/// Get device information
/// - Parameters:
///   - success: successful callback,  battery:14   protocol:com.jiuan.BGV44 accessoryName:BG1A firmwareVersion:1.0.0 hardwareVersion:3.0.0 manufaturer:iHealth  modelNumber:BG1A 11070   hasHistoryResult：1（0：no history 1：has history） deviceTS：2023-06-20 14:17:02 +0000
///   - fail: error callback, see BG1ADeviceError
- (void)commandGetDeviceInfo:(BG1ASuccessBlock)success
                     fail:(BG1AErrorBlock)fail;

/// Change measure type. Default is BG1AMeasureType_BloodSugar.
/// - Parameters:
///   - type: Measure Type, see BG1AMeasureType
///   - success: successful callback
///   - fail: error callback. If the device collects enough blood and starts to measure, you cannot set measure type, and you will receive an error: BG1ADeviceError_RejectChangeMeasureType
- (void)commandSetMeasureType:(BG1AMeasureType)type
                      success:(BG1ASuccessBlock)success
                         fail:(BG1AErrorBlock)fail;
/// synchronised time
/// - Parameters:
///   - success: successful callback
///   - fail: error callback, see BG1ADeviceError
- (void)commandSyncTime:(BG1ASuccessBlock)success
                     fail:(BG1AErrorBlock)fail;

/// Sync History
/// - Parameters:
///   - historyArray: successful callback    (
///{
///mac = "004D3201D6CD";
///isResultNeedCalibrate = 0;
///measureTs = 2023-05-19 14:28:51 +0000;
///mode = 0;//
///result= 200;
///metaData = <BG1AMeasureMetaData: 0x281a89f20>;
///errorCode=0;    If it is not 0, it means that it is a wrong result, and the subsequent blood sugar value is invalid
///}
///)
///   - fail: error callback, see BG1ADeviceError
- (void)commandSyncHistory:(BG1AHistoryBlock)historyArray
                     fail:(BG1AErrorBlock)fail;

/// Delete History
/// - Parameters:
///   - success: successful callback
///   - fail: error callback, see BG1ADeviceError
- (void)commandDeleteHistory:(BG1ASuccessBlock)success
                     fail:(BG1AErrorBlock)fail;

/**
 
 During the measurement process, please listen to the following notifications to obtain the measurement status and results of the BG1A device

1) kBG1ANotiNameStripStatus
  
 The device collects enough blood to measure, and the result will be post in a few seconds. The notification's userInfo:
  {
    mac = "004D3201D6CD";
    status = 0;
    Test strip status value: 0: The test strip is inserted, and blood can be dripped 1: The test strip is removed 2: Blood sucking starts 3: The blood sucking volume is insufficient for 1 4: The blood sucking volume is insufficient for 1 state for more than 5 seconds 5: The blood sucking volume is insufficient for 2 6: The blood sucking is completed
    type = 1;  1: Blood glucose 2: Uric acid 3: Quality control strip
  }
  Tips:
  It will be posted immediately after the bluetooth is connected. Because only after strip in, the device is ready to connect bluetooth.
 
 2)  kBG1ANotiNameResult
 The device sends the measurement result (the value is in the unit mg/dL). The notification's userInfo:
 {
    mac = "385B44DDC723";
    result = 80;
    mode = 0;  Measure Type, see BG1AMeasureType
 }
**/


/// Active disconnect a device from app
- (void)commandDisconnectDevice;
@end

NS_ASSUME_NONNULL_END
