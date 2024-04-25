//
//  KD723_V2.h
//
//  Created by dai on 24-02-27.
//  Copyright (c) 2024年 my. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIKit/UIKit.h"
#import "BPDevice.h"

@class KD723Internal;

 /**
 
  KD723_V2 device class
 
 */
@interface KD723_V2 : BPDevice

/// An internal instance, not available for SDK users
@property (strong, nonatomic) KD723Internal *internalDevice;

/**
 * synchronize time
 * @param success  A block to refer ‘set success’.
 * @param error   A block to return the error.
 */
-(void)commandSynchronizeTime:(BlockSuccess)success errorBlock:(BlockError)error;

/**
 *
 * What the function returns:
 
 upAirMeasureFlg = 1;
 haveOffline = 1;
 deviceTime = "2024-2-29 17:7:2";
 showUnit = 0;
 is24Hour = 1;
 selfUpdate = 0;
 firmwareVersion = "1.1.0";
 haveAngleSet = 0;
 modelNumber = "KD-723 11070";
 armMeasureFlg = 0;
 haveShowUnitSetting = 0;
 protocol = "com.jiuan.BPV30";
 mutableUpload = 1;
 manufacture = "iHealth";
 haveBackLightSetting = 0;
 haveClockShowSetting = 0;
 hardwareVersion = "1.1.0";
 haveAngleSensor = 0;
 memoryGroup = 1;
 lastOperatingState = 85;
 maxMemoryCapacity = 99;
 accessoryName = "Push";
 serialNumber = "5414A7E083EF";
 haveRepeatedlyMeasure = 0;
 haveHSD = 1;
 * @param function  A block to return the function and states that the device supports.
 * @param error   A block to return the error.
 */
-(void)commandFunction:(BlockDeviceFunction)function errorBlock:(BlockError)error;

/**
 * Upload offline data total Count.
 * @param  totalCount item quantity of total data count
 * @param error  A block to return the error.
 */
-(void)commandTransferMemoryCount:(BlockBachCount)totalCount errorBlock:(BlockError)error;

/**
 * Upload offline data（Please call the API for obtaining the number of historical data before calling this API, otherwise the data cannot be obtained.）
 * @param uploadDataArray item quantity of total data.
 * @param error  A block to return the error.
 */
-(void)commandTransferMemoryData:(BlockBachArray)uploadDataArray errorBlock:(BlockError)error;
 
/**
 * Delete offline data.
 * @param success   A block to refer ‘set success’.
 * @param error    A block to return the error.
 */
-(void)commandDeleteMemoryDataResult:(BlockSuccess)success errorBlock:(BlockError)error;

/**
 * Disconnect current device
 */
-(void)commandDisconnectDevice;

@end
