//
//  PO3.h
//  testShareCommunication
//
//  Created by daiqingquan on 13-11-29.
//  Copyright (c) 2013年 my. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "POMacroFile.h"


/**
 PO3
 */
@interface PO3 : NSObject

@property (strong, nonatomic) NSString *currentUUID;
@property (strong, nonatomic) NSString *serialNumber;
@property (strong, nonatomic) NSString *firmwareVersion;

///device time
@property (strong, nonatomic) NSDate *deviceTS;

//（Firmware version must more than or equal to 3.1.1 support this）
@property (assign,nonatomic) PO3ChargeState state;



/**
 * Restore Sync time
 * @param syncTimeBlock Sync completed. Yes = Success, No = Fail.
 * @param errorBlock Communication error codes
 */
-(void)commandPO3SyncTime:(DisposePO3SyncTimeBlock)syncTimeBlock withErrorBlock:(DisposePO3ErrorBlock)errorBlock;




/**
 * Restore Real-time measurements
 * @param startMeasure  Start measurement, Return no for fail, return yes for success.
 * @param measureData  SpO2 values, including SpO2, pulse rate, pulse intensity. Corresponding keys are spo2, bpm, wave, and pi.
 * @param finishMeasure  Finish measurement. No for fail, yes for success.
 * @param errorBlock Communication error codes
 */

-(void)commandPO3StartMeasure:(DisposePO3StartMeasure)startMeasure withMeasureData:(DisposePO3MeasureData)measureData  withFinishMeasure:(DisposePO3FinishMeasure)finishMeasure  withErrorBlock:(DisposePO3ErrorBlock)errorBlock;




/**
 * Restore Historical data （The firmware version is 3.2.0 and the isRightTime field is added. This field marks whether the historical data needs time correction (0: no need 1: need correction)）
 * @param offlineDataCount Number of historical offline data measurements.
 * @param offlineData date, spo2, bpm, and wave.
 * @param offlineWaveData Pulse intensity, corresponding key: wave
 * @param finishUpload End transmission of data, yes for success, no for fail.
 * @param errorBlock Communication error codes
 */
-(void)commandPO3OfflineDataCount:(DisposePO3OfflineDataCount)offlineDataCount withOfflineData:(DisposePO3OfflineData)offlineData withOfflineWaveData:(DisposePO3OfflineWaveData)offlineWaveData withFinishMeasure:(DisposePO3FinishUpload)finishUpload  withErrorBlock:(DisposePO3ErrorBlock)errorBlock;




/**
 * Query power status
 * @param batteryBlock Battery，from 0～100
 * @param errorBlock Communication error codes
 */
-(void)commandPO3GetDeviceBattery:(DisposePO3BatteryBlock)batteryBlock withErrorBlock:(DisposePO3ErrorBlock)errorBlock;



/**
 * Disconnect connection
 * @param disconnectBlock  yes = success, no = fail.
 * @param errorBlock Communication error codes
 */
-(void)commandPO3Disconnect:(DisposePO3DisconnectBlock)disconnectBlock withErrorBlock:(DisposePO3ErrorBlock)errorBlock;


/**
 * GetChargeState    （Firmware version must more than or equal to 3.1.1 support this API）
 * @param state  PO3ChargeState
 * @param errorBlock Communication error codes
 */
-(void)commandPO3GetChargeState:(DisposePO3ChargeState)state withErrorBlock:(DisposePO3ErrorBlock)errorBlock;

/**
 
 Charge State  change Notification（Firmware version must more than or equal to 3.1.1 support this API）

 PO3NotificationChargeState

You need to listen to this message to get ChargeState
 
 {
     state = 1;   0:PO3ChargeState_ExitCharge,   1: PO3ChargeState_Charging,
 }

 
 */


/**
 * GetDeviceTime    （Firmware version must more than or equal to 3.2.0 support this API）
 * @param time  DeviceTime  
 * @param errorBlock Communication error codes
 */
-(void)commandPO3GetDeviceTime:(DisposePO3TimeBlock)time withErrorBlock:(DisposePO3ErrorBlock)errorBlock;

//Determine whether API for obtaining device time of new PO3 devices is supported
-(BOOL)supportNewPO3GetDeviceTSCommand;

@end


