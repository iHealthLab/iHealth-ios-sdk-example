//
//  IHSDKDemoLoadingHUD.h
//  iHealthDemoCode
//
//  Created by jing on 2023/4/11.
//  Copyright © 2023 iHealth Demo Code. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface IHSDKDemoLoadingHUD : UIView

/**
 * show loading without supview
 */
+ (void)show;

/**
 * hide loading
 */
+ (void)hide;

/**
 * show loading on window
 */
+ (void)showWindow;

/**
 * show loading on superview
   @param view show loading's superview
 */
+ (void)showLoadingOn:(UIView *)view;


/**
 * show loading on window isUserInteractionEnabled = false
 */
+ (void)showWindowUserInteractionDisabled;

@end

NS_ASSUME_NONNULL_END
