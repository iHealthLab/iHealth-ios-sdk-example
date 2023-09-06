//
//  WPKBottomButtonView.h
//  WZPlatformKit
//
//  Created by abc on 2019/6/11.
//  Copyright © 2019 Wyze. All rights reserved.
//
/**
 * 顶部操作按钮的视图
*/
#import <UIKit/UIKit.h>
#import "UIButton+WPKButton.h"

NS_ASSUME_NONNULL_BEGIN

@interface WPKBottomButtonView : UIView
/**
 * init bottom button style Multiple button
 * @param frame view's frame
 * @param leftStr left button title
 * @param leftAction left button action
 * @param rightStr right button title
 * @param rightAction right button action
 */
- (instancetype)initWithFrame:(CGRect)frame leftStr:(NSString *)leftStr leftAction:(WPKButtonBlock)leftAction rightStr:(NSString *)rightStr rightAction:(WPKButtonBlock)rightAction;

/**
 * init bottom button style Single button
 * @param frame view's frame
 * @param tileStr  button title
 * @param titleAction  button action
 */
- (instancetype)initWithFrame:(CGRect)frame tileStr:(NSString *)tileStr titleAction:(WPKButtonBlock)titleAction;

/**
* init bottom button CMC style Multiple button
* @param frame view's frame
* @param leftStr left button title
* @param leftAction left button action
* @param rightStr right button title
* @param rightAction right button action
*/
- (instancetype)initWithCMCBottomFrame:(CGRect)frame leftStr:(NSString *)leftStr leftAction:(WPKButtonBlock)leftAction rightStr:(NSString *)rightStr rightAction:(WPKButtonBlock)rightAction;

/**
 * 重置分割线的宽度
 */
- (void)resetLineWidth:(CGFloat)lineWidth;

/**
 * 重置按钮的字体
 */
- (void)resButtonFont:(UIFont *)font;

/**
 * 修改按钮的文案
 */
- (void)changeLeftStr:(NSString *)leftStr rightStr:(NSString *)rightStr;


/**
 * 设置右侧按钮不可点击
 */
- (void)setRightUserEnable:(BOOL)enable;

/**
 * 设置底部按钮不可点击
 */
- (void)setBottomButtonUserEnable:(BOOL)enable;

/**
 * 设置左侧按钮的颜色
 */
- (void)setLeftButtonTextColor:(UIColor * _Nullable)textColor font:(UIFont *_Nullable)font;

/**
 * 设置右侧按钮的颜色
 */
- (void)setRightButtonTextColor:(UIColor * _Nullable)textColor font:(UIFont *_Nullable)font;

/**
 * 设置右侧底部按钮
 */
- (void)setBottomButtonTextColor:(UIColor * _Nullable)textColor font:(UIFont *_Nullable)font;
@end

NS_ASSUME_NONNULL_END
