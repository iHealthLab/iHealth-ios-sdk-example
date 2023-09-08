//
//  AM6SettingsItem.m
//  iHealthDemoCode
//
//  Created by Spring on 2023/6/13.
//  Copyright © 2023 iHealth Demo Code. All rights reserved.
//

#import "AM6SettingsItem.h"

@implementation AM6SettingsItem

- (void)onClickSwitch:(id)sender{
    if (self.onChangeSwitchBlock) {
        UISwitch *sw = (UISwitch*)sender;
        self.onChangeSwitchBlock(sw.isOn);
    }
}

@end
