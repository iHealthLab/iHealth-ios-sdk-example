//
//  AM6SettingsCell.m
//  iHealthDemoCode
//
//  Created by Spring on 2023/6/13.
//  Copyright © 2023 iHealth Demo Code. All rights reserved.
//

#import "AM6SettingsCell.h"

@implementation AM6SettingsCell

+ (instancetype)customCellWithTextFont:(UIFont *)textFont textColor:(UIColor *)textColor detailTextFont:(UIFont *)detailTextFont detailTextColor:(UIColor *)detailTextColor isShowAccessoryView:(BOOL)isShowAccessoryView{
    return (AM6SettingsCell*)[super customCellWithTextFont:textFont textColor:textColor detailTextFont:detailTextFont detailTextColor:detailTextColor isShowAccessoryView:isShowAccessoryView];
}

- (instancetype)initWithType:(AM6SettingsType)type item:(AM6SettingsItem*)item{
    self = [AM6SettingsCell customCellWithTextFont:IHSDK_FONT_Regular(17) textColor:IHSDK_COLOR_FROM_HEX(0x22262B) detailTextFont:IHSDK_FONT_Regular(15) detailTextColor:IHSDK_COLOR_FROM_HEX(0x515963) isShowAccessoryView:YES];
    if (self) {
        self.textLabel.text = item.title;
        self.detailTextLabel.text = item.detail;
        if (item.cellType == AM6SettingsCellType_Switch) {
            UISwitch *sw = [UISwitch new];
            sw.onTintColor = kIHSDK_Text_Wyze_Green;
            self.accessoryView = sw;
            [sw setOn:item.switchStatus];
            [sw addTarget:item action:@selector(onClickSwitch:) forControlEvents:UIControlEventValueChanged];
            
        } else if (item.cellType == AM6SettingsCellType_StartTime || item.cellType == AM6SettingsCellType_EndTime){
        } else if (item.cellType == AM6SettingsCellType_Indicator){
            self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        } else if (item.cellType == AM6SettingsCellType_None){
            self.accessoryView = nil;
        }
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
