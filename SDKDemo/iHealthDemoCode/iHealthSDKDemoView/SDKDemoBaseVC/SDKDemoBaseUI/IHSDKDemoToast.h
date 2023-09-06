//
//  IHSDKDemoToast.h
//  iHealthDemoCode
//
//  Created by jing on 2023/4/11.
//  Copyright © 2023 iHealth Demo Code. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface IHSDKDemoToast :UIView

/**
 @param title 文字内容 默认居中
 */
+ (void)showTipWithTitle:(NSString *)title;

/**
* @param title 文字内容 默认居中
* @param textAlignment 文字的样式
*/
+ (void)showTipWithTitle:(NSString *)title textAlignment:(NSTextAlignment)textAlignment;

/**
 * @param title 文字内容 默认居中
 * @param duration 持续时间
 */
+ (void)showTipWithTitle:(NSString *)title duration:(NSTimeInterval)duration;

/**
* @param title 文字内容 默认居中
* @param textAlignment 文字的样式
* @param duration 持续时间
*/
+ (void)showTipWithTitle:(NSString *)title textAlignment:(NSTextAlignment)textAlignment duration:(NSTimeInterval)duration;

/**
 * @param title 文字内容 默认居中
* @param titleFont 文字的字体
 * @param duration 持续时间
 */
+ (void)showTipWithTitle:(NSString *)title titleFont:(UIFont *)titleFont duration:(NSTimeInterval)duration;

/**
* @param title 文字内容 默认居中
* @param titleFont 文字的字体
* @param textAlignment 文字的样式
* @param duration 持续时间
*/
+ (void)showTipWithTitle:(NSString *)title titleFont:(UIFont *)titleFont textAlignment:(NSTextAlignment)textAlignment duration:(NSTimeInterval)duration;



/**
 @param title 文字内容 底部
 */
+ (void)showBottomTipWithTitle:(NSString *)title;

/**
 * @param title 文字内容 默认居中
 * @param duration 持续时间
 */
+ (void)showBottomTipWithTitle:(NSString *)title duration:(NSTimeInterval)duration;

/**
 @param title 文字内容
 @param starY 起始位置
 */
+ (void)showTipWithTitle:(NSString *)title starY:(CGFloat)starY;

/**
 * dismiss
 */
+ (void)dismiss;


@end
NS_ASSUME_NONNULL_END
