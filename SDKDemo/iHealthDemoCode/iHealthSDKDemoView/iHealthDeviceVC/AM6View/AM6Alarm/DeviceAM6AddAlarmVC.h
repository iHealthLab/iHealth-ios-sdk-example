//
//  DeviceAM6AddAlarmVC.h
//  iHealthDemoCode
//
//  Created by Spring on 2023/6/13.
//  Copyright © 2023 iHealth Demo Code. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AM6Constants.h"
NS_ASSUME_NONNULL_BEGIN

typedef void(^WZLatteAddAlarmCallback)(AM6AlarmModel *model);

@interface DeviceAM6AddAlarmVC : IHSDKBaseNavVC

@property (assign, nonatomic) BOOL isFromAdd;
@property (assign, nonatomic) struct AM6DateStruct date;
@property (assign, nonatomic) BOOL isOn;
@property (assign, nonatomic) uint8_t repeatMode;
@property (copy, nonatomic) WZLatteAddAlarmCallback callback;

@end

NS_ASSUME_NONNULL_END
