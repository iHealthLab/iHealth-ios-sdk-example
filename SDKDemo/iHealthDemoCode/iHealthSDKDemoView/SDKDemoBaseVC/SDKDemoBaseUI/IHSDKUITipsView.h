//
//  IHSDKUITipsView.h
//  iHealthDemoCode
//
//  Created by jing on 2023/4/11.
//  Copyright © 2023 iHealth Demo Code. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface IHSDKUITipsView : UIView

@property (assign, nonatomic) CGFloat radius;// 转圈的外径
@property (assign, nonatomic) CGFloat lineWidth;// 转圈的线宽
@property (copy, nonatomic) UIColor *lineColor; // 转圈的颜色，默认白色
@property (copy, nonatomic) UIFont *font;
@property (copy, nonatomic) UIColor *textColor;
@property (assign, nonatomic) NSTimeInterval duration;// tips显示的时长，默认2秒
@property (copy, nonatomic) UIImage *successImage;
@property (copy, nonatomic) UIImage *failImage;

+ (instancetype)sharedInstance;

/// 显示toast，默认2秒后消失
/// @param text 文字
- (void)showToast:(NSString*)text;

/// 显示Loading，可带文字，不消失
/// @param text 文字
- (void)showLoadingTips:(NSString*)text;

/// 显示成功的Tips，可带文字，默认2秒后消失
/// @param text 文字
- (void)showSuccessTips:(NSString*)text;

/// 显示失败的Tips，可带文字，默认2秒后消失
/// @param text 文字
- (void)showFailTips:(NSString*)text;

/// 隐藏Tips
- (void)hide;

@end

NS_ASSUME_NONNULL_END
