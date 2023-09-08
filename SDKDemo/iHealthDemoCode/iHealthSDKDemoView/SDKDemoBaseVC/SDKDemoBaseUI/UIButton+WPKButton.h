//
//  UIButton+WPKButton.h
//  WZPlatformKit
//
//  Created by abc on 2019/4/30.
//  Copyright © 2019 Wyze. All rights reserved.
//

 /*
  * 对基本组件的系统按钮的分类扩展，可以快速创建按钮的模板类
  */
#import <UIKit/UIKit.h>

typedef void(^WPKButtonBlock)(UIButton * _Nullable button);
@interface UIButton (WPKButton)

/**
 快速初始化按钮
 @param frame  button's frame
 @param title  button's titile
 @param font  titile font
 @param textColor  button's textColor
 @return UIButton
 */
- (instancetype _Nullable)initWithFrame:(CGRect)frame titile:(NSString * _Nullable)title font:(UIFont * _Nullable)font  textColor:(UIColor *_Nullable)textColor;

/**
 快速初始化按钮
 @param frame  button's frame
 @param title  button's titile
 @param font  titile font
 @param textColor  button's textColor
 @param action  button's action
 @return UIButton
 */
- (instancetype _Nullable)initWithFrame:(CGRect)frame titile:(NSString * _Nullable)title font:(UIFont * _Nullable)font  textColor:(UIColor *_Nullable)textColor action:(WPKButtonBlock _Nullable)action;
@end

