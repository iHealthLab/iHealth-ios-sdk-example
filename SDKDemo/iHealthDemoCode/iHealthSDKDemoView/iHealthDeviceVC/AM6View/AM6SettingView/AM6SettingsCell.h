//
//  AM6SettingsCell.h
//  iHealthDemoCode
//
//  Created by Spring on 2023/6/13.
//  Copyright © 2023 iHealth Demo Code. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AM6SettingsItem.h"
#import "IHSDKBaseCell.h"

typedef NS_ENUM(NSInteger,AM6SettingsType){
    AM6SettingsType_Notification,
    AM6SettingsType_Stretch,
    AM6SettingsType_ActivityGoal,
    AM6SettingsType_NotDisturb,
    AM6SettingsType_RasieToWake,
    AM6SettingsType_WearingWrist,
    AM6SettingsType_RunningInTheBackground,
    AM6SettingsType_Weather,
};

NS_ASSUME_NONNULL_BEGIN

@interface AM6SettingsCell : IHSDKBaseCell

- (instancetype)initWithType:(AM6SettingsType)type
                        item:(AM6SettingsItem*)item;

@end

NS_ASSUME_NONNULL_END
