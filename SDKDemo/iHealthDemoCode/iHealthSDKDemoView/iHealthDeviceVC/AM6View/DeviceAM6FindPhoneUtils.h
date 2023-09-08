//
//  DeviceAM6FindPhoneUtils.h
//  iHealthDemoCode
//
//  Created by Spring on 2023/6/27.
//  Copyright © 2023 iHealth Demo Code. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DeviceAM6FindPhoneUtils : NSObject

+ (DeviceAM6FindPhoneUtils *)shareInstance;
- (void)play;
- (void)stop;

@end

NS_ASSUME_NONNULL_END
