//
//  IHSDKBaseController.h
//  iHealthDemoCode
//
//  Created by jing on 2023/4/11.
//  Copyright © 2023 iHealth Demo Code. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface IHSDKBaseController : UIViewController

/**
 侧滑返回的开关 默认 YES
 */
@property (nonatomic, assign) BOOL IHSDKPopGestureRecognizerEnable;
/**
 获取顶部导航条高度(适配iPhone X)
 
 @param naviBarHidden navigationBar是否隐藏
 @return 顶部导航条高度
 */
- (CGFloat)IHSDK_safeAreaInsetTopWithNaviBarHidden:(BOOL)naviBarHidden;
/**
 获取底部tabBar高度(适配iPhone X)
 
 @param tabBarHidden tabBar是否隐藏
 @return 底部tabBar高度
 */
- (CGFloat)IHSDK_safeAreaInsetBottomWithTabBarHidden:(BOOL)tabBarHidden;
- (CGFloat)IHSDK_safeAreaInsetTop;
- (CGFloat)IHSDK_safeAreaInsetBottom;
+ (CGFloat)IHSDK_statusBarInsetTop;
+ (CGFloat)IHSDK_tabBarInsetBottom;

@end

NS_ASSUME_NONNULL_END
