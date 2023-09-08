//
//  KN550BT.h
//  testShareCommunication
//
//  Created by my on 8/10/13.
//  Copyright (c) 2013年 my. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BPAV10Device.h"
#import <UIKit/UIKit.h>

@class KN550BTInternal;
/**
 KN550BT device class
 */
@interface KN550BT : BPAV10Device <BPBasicBTLEProtocol,BPOfflineDataTransferProtocol>

/// An internal instance, not available for SDK users
@property (strong, nonatomic) KN550BTInternal *internalDevice;

#pragma mark - Hypogenous query

/**
 * Synchronize time and judge if the device supports the function of up Air Measurement, arm Measurement, Angle Sensor, Angle Setting, HSD, Offline Memory, mutable Groups Upload, Self Upgrade. ‘True’ means yes or on, ‘False’ means no or off.
 * @param function  A block to return the function and states that the device supports.
 * @param error  A block to refer ‘error’ in ‘Establish measurement connection’ in KN550BT.
 */
-(void)commandFunction:(BlockDeviceFunction)function errorBlock:(BlockError)error;

/**
 * Query battery remaining energy.
 * @param energyValue  A block to return the device battery remaining energy percentage, ‘80’ stands for 80%.
 * @param error  A block to return the error in ‘Establish measurement connection’
 */
-(void)commandEnergy:(BlockEnergyValue)energyValue errorBlock:(BlockError)error;


/**
 * Upload offline data total Count.
 * @param  totalCount item quantity of total data.
 * @param error  A block to return the error.
 */
-(void)commandTransferMemoryTotalCount:(BlockBachCount)totalCount errorBlock:(BlockError)error;

/**
 * Upload offline data.
 * @param  totalCount item quantity of total data
 * @param  progress upload completion ratio , from 0.0 to 1.0 or 0%~100％, 100% means upload completed.
 * @param  uploadDataArray	offline data set, including measurement time, systolic pressure, diastolic pressure, pulse rate, irregular judgment. corresponding KEYs are time, sys, dia, heartRate, irregular. If there is a lot of measurements, this block will be called more than once.（The firmware version is 2.0.1 and the isRightTime field is added. This field marks whether the historical data needs time correction (0: no need 1: need correction)）
 * @param error   error codes.
 * Specification:
 *   1.  BPError0 = 0: Unable to take measurements due to arm/wrist movements.
 *   2.  BPError1:  Failed to detect systolic pressure.
 *   3.  BPError2:  Failed to detect diastolic pressure.
 *   4.  BPError3:  Pneumatic system blocked or cuff is too tight during inflation.
 *   5.  BPError4:  Pneumatic system leakage or cuff is too loose during inflation.
 *   6.  BPError5:  Cuff pressure reached over 300mmHg.
 *   7.  BPError6:  Cuff pressure reached over 15 mmHg for more than 160 seconds.
 *   8.  BPError7:  Data retrieving error.
 *   9.  BPError8:  Data retrieving error.
 *   10.  BPError9:  Data retrieving error.
 *   11.  BPError10:  Data retrieving error.
 *   12.  BPError11:  Communication Error.
 *   13.  BPError12:  Communication Error.
 *   14.  BPError13:  Low battery.
 *   15.  BPError14:  Device bluetooth set failed.
 *   16.  BPError15:  Systolic exceeds 260mmHg or diastolic exceeds 199mmHg.
 *   17.  BPError16:  Systolic below 60mmHg or diastolic below 40mmHg.
 *   18.  BPError17:  Arm/wrist movement beyond range.
 *   19.  BPNormalError=30:  device error, error message displayed automatically.
 *   20.  BPOverTimeError:  Abnormal communication.
 *   21.  BPNoRespondError:  Abnormal communication.
 *   22.  BPBeyondRangeError:  device is out of communication range.
 *   23.  BPDidDisconnect:  device is disconnected.
 *   24.  BPAskToStopMeasure:  measurement has been stopped.
 *   25.  BPInputParameterError=400:  Parameter input error.
 *   26.  BPInvalidOperation = 402:  Invalid Operation
 *   27.  BPDeviceErrorUnsupported = 403:  Unsupported
 */
-(void)commandTransferMemoryDataWithTotalCount:(BlockBachCount)totalCount progress:(BlockBachProgress)progress dataArray:(BlockBachArray)uploadDataArray errorBlock:(BlockError)error;



/**
 * Delete offline data.（Firmware version must more than or equal to 2.0.1 support this API）
 * @param  result The block return ‘YES’ means delete sucess, return ‘NO’ means delete fail.
 * @param error   error codes.
 */
-(void)commandDeleteMemoryDataResult:(BlockResult)result errorBlock:(BlockError)error;


/**
 * Get Device Date.（Firmware version must more than or equal to 2.0.1 support this API）
 * @param  date The block return Date      "2020-01-01 08:56:38"
 * @param error   error codes.
 */
-(void)commandGetDeviceDate:(BlockDeviceDate)date errorBlock:(BlockError)error;


/**
 * Disconnect current device
 */
-(void)commandDisconnectDevice;


/**
 get status of device display

 @param displayStatusBlock feedback status
 @param errorBlock A block to return the error
 */
-(void)commandGetStatusOfDisplay:(BlockDisplayStatus)displayStatusBlock error:(BlockError)errorBlock;


/**
 set status of device display

 @param backLightOn turn on back light or not
 @param clockOn show clock or not
 @param successBlock This block return means set success
 @param errorBlock A block to return the error
 */
-(void)commandSetStatusOfDisplayForBackLight:(BOOL)backLightOn andClock:(BOOL)clockOn resultSuccess:(BlockSuccess)successBlock error:(BlockError)errorBlock;

@end
