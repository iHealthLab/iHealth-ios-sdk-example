//
//  NSString+WPKStringDrawing.h
//  WZPlatformKit
//
//  Created by abc on 2019/4/30.
//  Copyright © 2019 Wyze. All rights reserved.
//

/**
 * 字符串宽高计算
 */
#import <Foundation/Foundation.h>

@interface NSString (WPKStringDrawing)

/**
 *  @brief  使用指定的条件render字符串，返回展示字符串需要的尺寸
 *
 *  @param  font            字体
 *  @param  constrainedWidth           限制宽度（高度不限）
 *  @param  lineBreakMode   换行模式
 *
 *  @return 展示字符串需要的宽和高，这些值已经向上取整
 *
 *  @discussion 通过调用系统的sizeWithFont:constrainedToSize:lineBreakMode:（iOS7以前）
 *              或boundingRectWithSize:options:attributes:context:（iOS7或之后）接口
 *              来获得展示字符串需要的宽度和高度。
 *              调用时使用参数指定的限定宽度，和高度MAXFLOAT生成的限定尺寸，即限宽不限高
 */
- (CGSize)wpk_sizeWithFont:(UIFont *)font constrainedToWidth:(CGFloat)constrainedWidth lineBreakMode:(NSLineBreakMode)lineBreakMode;

/**
 *  @brief  使用指定的条件render字符串（默认使用NSLineBreakModeWordWrap），返回展示字符串需要的尺寸
 *
 *  @param  font            字体
 *  @param  constrainedWidth           限制宽度（高度不限）
 *
 *  @return 展示字符串需要的宽和高，这些值已经向上取整
 */
- (CGSize)wpk_sizeWithFont:(UIFont *)font constrainedToWidth:(CGFloat)constrainedWidth; //use NSLineBreakModeWordWrap


/**
 *  @brief  使用指定的条件render字符串（在一行中），返回展示字符串需要的尺寸
 *
 *  @param  font            字体
 *
 *  @return 展示字符串需要的宽和高，这些值已经向上取整
 */
- (CGSize)wpk_singleLineSizeWithFont:(UIFont *)font;


/**
 *  动态返回字符串size大小
 *  @param aString 字符串
 *  @param width   指定宽度
 *  @param height  指定宽度
 *  @param font  文本的字体
 *  @return CGSize
 */
+ (CGSize)getStringRect:(NSAttributedString *)aString width:(CGFloat)width height:(CGFloat)height font:(UIFont *)font;
@end
