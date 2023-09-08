//
//  AM6Controller.h
//  iHealthDeviceSDK
//
//  Created by Spring on 2023/4/19.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AM6Controller : NSObject

/**
 * Initialize AM6 controller class
 */
+(AM6Controller *)shareAM6Controller;

/// Get Information from QR Code Scan Result: {s:AM6,mac:1234ABCD5678}. Return nil if QR code is invalid.
/// - Parameter result: QR Code Scan Result
+ (nullable NSDictionary*)dictionaryWithQRCodeScanResult:(NSString*)result;
/**
 * Please call this method before scanning and connecting Am6 devices, otherwise Am6 devices will not be able to connect.
 */
-(void)configAM6DeviceBleParameters;

/**
 * Access control class instance after receiving AM6ConnectNoti, then use instance to call AM6related communication methods
 */
-(NSArray *)getAllCurrentAM6Instace;

/**
 * Get the Bluetooth connected device, if you can't scan the device, you can try to use this API to see if it is connected.
 */
-(NSArray *)getAllCurrentConnectedAM6Mac;



@end

NS_ASSUME_NONNULL_END
