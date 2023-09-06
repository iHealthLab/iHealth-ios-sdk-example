//
//  HS2SPROController.h
//  iHealthSDKStatic
//
//  Created by Lei Bao on 2022/8/8.
//  Copyright © 2019 ihealthSDK. All rights reserved.
//

#import <Foundation/Foundation.h>
@class HS2SPRO;

NS_ASSUME_NONNULL_BEGIN
/**
 HS2SPROController
 */
@interface HS2SPROController : NSObject
/**
 * Initialize HS2SPRO controller class
 */
+(HS2SPROController *)shareIHHS2SPROController;

/**
 * Get all scale instance,use hsInstance to call HS related communication methods.
 */
-(NSArray *)getAllCurrentHS2SPROInstace;

- (nullable HS2SPRO *)getInstanceWithMac:(NSString*)mac;
@end

NS_ASSUME_NONNULL_END
