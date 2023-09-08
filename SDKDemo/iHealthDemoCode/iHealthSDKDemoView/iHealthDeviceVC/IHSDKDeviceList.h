//
//  IHSDKDeviceList.h
//  iHealthDemoCode
//
//  Created by jing on 2023/4/12.
//  Copyright © 2023 iHealth Demo Code. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IHSDKBaseNavVC.h"
#import "HealthHeader.h"
NS_ASSUME_NONNULL_BEGIN

@interface IHSDKDeviceList : IHSDKBaseNavVC

@property (nonatomic) HealthDeviceType SDKDeviceType;

@end

NS_ASSUME_NONNULL_END
