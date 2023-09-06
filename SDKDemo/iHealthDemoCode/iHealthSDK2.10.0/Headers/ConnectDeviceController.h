//
//  ConnectDeviceController.h
//  iHealthDemoCode
//
//  Created by zhiwei jing on 1/24/16.
//  Copyright © 2016 zhiwei jing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HealthHeader.h"

/**
 ConnectDeviceController
 */
@interface ConnectDeviceController : NSObject

+ (ConnectDeviceController *)commandGetInstance;


/**
 * Connect iHealth device with bluretooth low energy
 *
 * If the API returns 0, it means that the connection was not successful, it may be that the input parameters are wrong or cannot be connected directly
 *
 * @param tempDeviceType  iHealth DeviceType
 * @param tempSerialNub   iHealth device serialNub or deviceID, you can get it from [ScanDeviceController commandScanDeviceType]. 
 */
- (int)commandContectDeviceWithDeviceType:(HealthDeviceType)tempDeviceType  andSerialNub:(NSString *)tempSerialNub;

@end
