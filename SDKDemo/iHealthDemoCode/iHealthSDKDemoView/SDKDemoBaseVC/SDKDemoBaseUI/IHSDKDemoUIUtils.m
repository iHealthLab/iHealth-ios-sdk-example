//
//  IHSDKDemoUIUtils.m
//  iHealthDemoCode
//
//  Created by jing on 2023/4/11.
//  Copyright © 2023 iHealth Demo Code. All rights reserved.
//

#import "IHSDKDemoUIUtils.h"

#import <AVFoundation/AVAsset.h>
#import <AVFoundation/AVAssetImageGenerator.h>
#import <AVFoundation/AVTime.h>

@implementation IHSDKDemoUIUtils

+ (UIViewController *)topViewController
{
    return [self findBestViewController:[[UIApplication sharedApplication].keyWindow rootViewController]];
}

+ (UIViewController*)findBestViewController:(UIViewController*)vc
{
    if (vc.presentedViewController) {
        // Return presented view controller
        return [self findBestViewController:vc.presentedViewController];
    } else if ([vc isKindOfClass:[UISplitViewController class]]) {
        // Return right hand side
        UISplitViewController* svc = (UISplitViewController*) vc;
        if (svc.viewControllers.count > 0) {
            return [self findBestViewController:svc.viewControllers.lastObject];
        } else {
            return vc;
        }
    } else if ([vc isKindOfClass:[UINavigationController class]]) {
        UINavigationController* svc = (UINavigationController*) vc;
        if (svc.viewControllers.count > 0) {
            return [self findBestViewController:svc.topViewController];
        } else {
            return vc;
        }
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        UITabBarController* svc = (UITabBarController*) vc;
        if (svc.viewControllers.count > 0) {
            return [self findBestViewController:svc.selectedViewController];
        } else {
            return vc;
        }
    } else {
        return vc;
    }
}

#pragma mark 隐藏系统键盘与弹框
+ (void)hideKeyBoard
{
    for (UIWindow* window in [UIApplication sharedApplication].windows) {
        for (UIView* view in window.subviews) {
            [self dismissAllKeyBoardInView:view];
        }
    }
}

+ (BOOL)dismissAllKeyBoardInView:(UIView *)view
{
    if ([view isFirstResponder]) {
        [view resignFirstResponder];
        return YES;
    }
    for (UIView *subView in view.subviews) {
        if ([self dismissAllKeyBoardInView:subView]) {
            return YES;
        }
    }
    return NO;
}

@end
