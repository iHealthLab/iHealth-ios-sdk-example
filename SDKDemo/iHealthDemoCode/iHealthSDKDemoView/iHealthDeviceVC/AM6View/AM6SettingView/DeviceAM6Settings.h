//
//  DeviceAM6Settings.h
//  iHealthDemoCode
//
//  Created by Spring on 2023/6/13.
//  Copyright © 2023 iHealth Demo Code. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AM6SettingsCell.h"
NS_ASSUME_NONNULL_BEGIN

@interface DeviceAM6Settings : IHSDKBaseNavVC

@property (assign, nonatomic) AM6SettingsType settingsType;
@property (strong, nonatomic) UITableView *myTable;
@property (copy, nonatomic) NSString *deviceId;

- (instancetype)initWithSettingsType:(AM6SettingsType)type deviceId:(NSString*)deviceId;

@end

NS_ASSUME_NONNULL_END
