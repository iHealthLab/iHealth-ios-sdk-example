//
//  IHSDKDemoUIUtils.h
//  iHealthDemoCode
//
//  Created by jing on 2023/4/11.
//  Copyright © 2023 iHealth Demo Code. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface IHSDKDemoUIUtils : NSObject

/**
 * 获取App顶层视图控制器 或者 获取当前视图控制器
 */
+ (UIViewController *)topViewController;

#pragma mark 隐藏系统键盘与弹框
+ (void)hideKeyBoard;

@end

NS_ASSUME_NONNULL_END
