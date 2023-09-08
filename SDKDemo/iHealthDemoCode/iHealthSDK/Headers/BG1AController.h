//
//  BG1AController.h
//  iHealthDeviceSDK
//
//  Created by Lei Bao on 2022/9/13.
//

#import <Foundation/Foundation.h>
@class BG1A;

NS_ASSUME_NONNULL_BEGIN

@interface BG1AController : NSObject
/**
 * Initialize BG1A controller class
 */
+(BG1AController *)shareIHBG1AController;

/**
 * Get all BG1A instance,use hsInstance to call BG related communication methods.
 */
-(NSArray *)getAllCurrentBG1AInstace;

/// Get BG1A Instance
/// @param mac mac or serial number
- (nullable BG1A *)getInstanceWithMac:(NSString*)mac;
@end

NS_ASSUME_NONNULL_END
