//
//  IHSDKDemoRoundCornerButton.h
//  iHealthDemoCode
//
//  Created by jing on 2023/4/11.
//  Copyright © 2023 iHealth Demo Code. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger,IHSDKRoundCornerButtonStyle) {
    IHSDKRoundCornerButtonStyle_Default, // enable：绿背景白字 disbale：浅灰背景深灰字
    IHSDKRoundCornerButtonStyle_Delete, // enable：绿背景白字 disbale：浅灰背景深灰字
};

@interface IHSDKDemoRoundCornerButton : UIButton

/**
 绿底白字

 @param title <#title description#>
 @return <#return value description#>
 */
+ (instancetype)buttonWithTitle:(NSString*)title;

/**
 白底灰字

 @param title <#title description#>
 @return <#return value description#>
 */
+ (instancetype)grayButtonWithTitle:(NSString*)title;

- (void)setCornerRadius:(CGFloat)value;

+ (instancetype)buttonWithTitle:(NSString *)title style:(IHSDKRoundCornerButtonStyle)style;

- (void)addToViewBottom:(UIView*)view;

/// 更新UI变成disbale的样式，但是仍然响应点击
- (void)updateToDisableStyleButRespondTouch;

/// 回复成原来的样式，与updateToDisableStyleButRespondTouch对应
- (void)updateToDefaultStyle;

@end

NS_ASSUME_NONNULL_END
