//
//  IHSDKDemoLoadingView.h
//  iHealthDemoCode
//
//  Created by jing on 2023/4/11.
//  Copyright © 2023 iHealth Demo Code. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface IHSDKDemoLoadingView : UIView

/** 一次动画所持续时长 默认2秒*/
@property(nonatomic,assign)NSTimeInterval duration;
/** 线条颜色*/
@property (nonatomic, strong) UIColor *strokeColor;
@property (nonatomic, assign) CGFloat lineW;
/**
 开始动画
 */
- (void)starAnimation;

/**
 停止动画
 */
- (void)stopAnimation;

- (void)createUI;

@end

NS_ASSUME_NONNULL_END
