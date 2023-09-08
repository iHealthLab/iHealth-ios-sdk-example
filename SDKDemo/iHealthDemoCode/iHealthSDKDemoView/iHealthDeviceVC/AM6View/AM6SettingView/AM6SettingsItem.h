//
//  AM6SettingsItem.h
//  iHealthDemoCode
//
//  Created by Spring on 2023/6/13.
//  Copyright © 2023 iHealth Demo Code. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger,AM6SettingsCellType) {
    AM6SettingsCellType_None = 0, // 没有accessory view,只有left和right的文案
    AM6SettingsCellType_Switch, // 有left的文案和Switch
    AM6SettingsCellType_StartTime, // 有left文案、right文案（时间）、Indicator
    AM6SettingsCellType_EndTime, // 有left文案、right文案（时间）、Indicator
    AM6SettingsCellType_Indicator, // 有left文案、right文案、Indicator
    
};

typedef void(^AM6SettingsItemSwitchChangeBlock)(BOOL isOn);

@interface AM6SettingsItem : NSObject

@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *detail;
@property (assign, nonatomic) AM6SettingsCellType cellType;
@property (assign, nonatomic) BOOL switchStatus;
@property (copy, nonatomic) AM6SettingsItemSwitchChangeBlock onChangeSwitchBlock;

- (void)onClickSwitch:(id)sender;

@end

NS_ASSUME_NONNULL_END
