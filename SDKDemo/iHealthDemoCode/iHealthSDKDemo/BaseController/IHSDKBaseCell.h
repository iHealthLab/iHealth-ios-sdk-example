//
//  IHSDKBaseCell.h
//  iHealthDemoCode
//
//  Created by jing on 2023/4/12.
//  Copyright © 2023 iHealth Demo Code. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface IHSDKBaseCell : UITableViewCell

- (void)setEnable:(BOOL)enable;

+ (instancetype)settingCell;// 设置页的cell

/// 返回自定义字体和颜色的cell
/// @param textFont 字体
/// @param textColor 颜色
/// @param detailTextFont 字体
/// @param detailTextColor 颜色
/// @param isShowAccessoryView 是否显示Accessory View
+ (instancetype)customCellWithTextFont:(nullable UIFont*)textFont
                             textColor:(nullable UIColor*)textColor
                        detailTextFont:(nullable UIFont*)detailTextFont
                       detailTextColor:(nullable UIColor*)detailTextColor
                   isShowAccessoryView:(BOOL)isShowAccessoryView;

- (void)addBottomLineView;
/// accessory view的地方，显示New和箭头，适用于固件升级有新版本时的Cell样式
- (void)addNewIconToAccessoryView;

/// accessory view的地方，显示传入的Image和箭头
/// @param image 图片
- (void)addIconToAccessoryViewWithImage:(UIImage*)image;

- (void)isShowAccessoryView:(BOOL)isShowAccessoryView;

@end

NS_ASSUME_NONNULL_END
