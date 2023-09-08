//
//  IHSDKTipsView.h
//  iHealthDemoCode
//
//  Created by jing on 2023/4/11.
//  Copyright © 2023 iHealth Demo Code. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface IHSDKTipsView : UIView

+ (IHSDKTipsView *)shareInstance;

/**
 * show tips only text
 * @param info show text
 * @param useInteraction view's useInteraction
 */
- (void)showTips:(NSString *)info useInteraction:(BOOL)useInteraction;

/**
 * show error tips
 * @param info show text
 * @param duration view auto dismiss duration
 * @param useInteraction view's useInteraction
 */
- (void)showFailedTips:(NSString *)info duration:(NSTimeInterval)duration useInteraction:(BOOL)useInteraction;

/**
 * show sucess tips
 * @param info show text
 * @param duration view auto dismiss duration
 * @param useInteraction view's useInteraction
 */
- (void)showFinishTips:(NSString *)info duration:(NSTimeInterval)duration useInteraction:(BOOL)useInteraction;

/**
 * show tips
 * @param info show text
 * @param duration view auto dismiss duration
 * @param useInteraction view's useInteraction
 */
- (void)showTipsInfo:(NSString *)info duration:(NSTimeInterval)duration useInteraction:(BOOL)useInteraction;

/**
 * show custom image
 * @param image show image icon
 * @param info show text
 * @param duration view auto dismiss duration
 * @param useInteraction view's useInteraction
 */
- (void)showTipsWithImage:(UIImage*)image info:(NSString *)info duration:(NSTimeInterval)duration useInteraction:(BOOL)useInteraction;

/**
 * show custom without image
 * @param centerPoint show view loaction
 * @param info show text
 * @param duration view auto dismiss duration
 * @param useInteraction view's useInteraction
 */
- (void)showTipsNoneImage:(CGPoint)centerPoint info:(NSString *)info duration:(NSTimeInterval)duration useInteraction:(BOOL)useInteraction;

/**
 * hide tips
 */
- (void)hide;

@end

NS_ASSUME_NONNULL_END
