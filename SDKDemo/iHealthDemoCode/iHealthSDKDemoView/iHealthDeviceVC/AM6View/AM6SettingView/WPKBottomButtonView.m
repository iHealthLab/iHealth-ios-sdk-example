//
//  WPKBottomButtonView.m
//  WZPlatformKit
//
//  Created by abc on 2019/6/11.
//  Copyright © 2019 Wyze. All rights reserved.
//

#import "WPKBottomButtonView.h"

@interface WPKBottomButtonView()
@property (nonatomic, strong) UIButton *leftButton;
@property (nonatomic, strong) UIButton *rightButton;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UIButton *bottomButton;

@end
@implementation WPKBottomButtonView
/**
 * init bottom button style Multiple button
 * @param frame view's frame
 * @param leftStr left button title
 * @param leftAction left button action
 * @param rightStr right button title
 * @param rightAction right button action
 */
- (instancetype)initWithFrame:(CGRect)frame leftStr:(NSString *)leftStr leftAction:(WPKButtonBlock)leftAction rightStr:(NSString *)rightStr rightAction:(WPKButtonBlock)rightAction
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = IHSDK_COLOR_FROM_HEX(0xffffff);
        self.leftButton = [[UIButton  alloc] initWithFrame:CGRectMake(0, 0, frame.size.width/2-0.5, frame.size.height) titile:leftStr font:IHSDKFontBoldStyle2(16) textColor:IHSDK_COLOR_ALERT_GRAY action:^(UIButton * _Nullable button) {
            if (leftAction) {
                leftAction(button);
            }
        }];
        self.rightButton = [[UIButton alloc] initWithFrame:CGRectMake(frame.size.width/2+0.5, 0, frame.size.width/2-0.5, frame.size.height) titile:rightStr font:IHSDKFontBoldStyle2(16) textColor:IHSDK_COLOR_GREEN action:^(UIButton * _Nullable button) {
            if (rightAction) {
                rightAction(button);
            }
        }];
        self.lineView = [[UIView alloc] initWithFrame:CGRectMake(frame.size.width/2-0.5, 0, 1, frame.size.height)];
        self.lineView.backgroundColor = IHSDK_COLOR_FROM_HEX_A(0x2C2D30, 0.05);
        [self addSubview:self.leftButton];
        [self addSubview:self.rightButton];
        [self addSubview:self.lineView];
        
    }
    return self;
}

/**
 * init bottom button style Multiple button
 * @param frame view's frame
 * @param leftStr left button title
 * @param leftAction left button action
 * @param rightStr right button title
 * @param rightAction right button action
 */
- (instancetype)initWithCMCBottomFrame:(CGRect)frame leftStr:(NSString *)leftStr leftAction:(WPKButtonBlock)leftAction rightStr:(NSString *)rightStr rightAction:(WPKButtonBlock)rightAction
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = IHSDK_COLOR_FROM_HEX(0xffffff);
        self.leftButton = [[UIButton  alloc] initWithFrame:CGRectMake(0, 0, frame.size.width/2-0.5, frame.size.height) titile:leftStr font:IHSDKFontRegularStyle2(17) textColor:IHSDK_COLOR_FROM_HEX(0x788A8F) action:^(UIButton * _Nullable button) {
            if (leftAction) {
                leftAction(button);
            }
        }];
        self.rightButton = [[UIButton alloc] initWithFrame:CGRectMake(frame.size.width/2+0.5, 0, frame.size.width/2-0.5, frame.size.height) titile:rightStr font:IHSDKFontRegularStyle2(17) textColor:IHSDK_COLOR_FROM_HEX(0x788A8F) action:^(UIButton * _Nullable button) {
            if (rightAction) {
                rightAction(button);
            }
        }];
        self.lineView = [[UIView alloc] initWithFrame:CGRectMake(frame.size.width/2-0.5, 0, 1, frame.size.height)];
        self.lineView.backgroundColor = IHSDK_COLOR_FROM_HEX_A(0x2C2D30, 0.05);
        [self addSubview:self.leftButton];
        [self addSubview:self.rightButton];
        [self addSubview:self.lineView];
        
    }
    return self;
}


/**
 * init bottom button style Single button
 * @param frame view's frame
 * @param tileStr  button title
 * @param titleAction  button action
 */
- (instancetype)initWithFrame:(CGRect)frame tileStr:(NSString *)tileStr titleAction:(WPKButtonBlock)titleAction
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = IHSDK_COLOR_FROM_HEX(0xffffff);
        self.bottomButton = [[UIButton  alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height) titile:tileStr font:IHSDKFontBoldStyle2(16) textColor:IHSDK_COLOR_ALERT_GRAY action:^(UIButton * _Nullable button) {
            if (titleAction) {
                titleAction(button);
            }
        }];
        [self addSubview:self.bottomButton];
    }
    return self;
}

/**
 * 重置分割线的宽度
 */
- (void)resetLineWidth:(CGFloat)lineWidth
{
    if (lineWidth <= 0) {
        self.lineView.hidden = YES;
    } else {
        self.lineView.hidden = NO;
    }
    self.lineView.frame = CGRectMake(self.frame.size.width/2-lineWidth/2.0, 0, lineWidth, self.frame.size.height);
}

/**
 * 重置按钮的字体
 */
- (void)resButtonFont:(UIFont *)font
{
    if (font) {
        self.leftButton.titleLabel.font = font;
        self.rightButton.titleLabel.font = font;
    }
}

/**
 * 重置按钮的文案
 */
- (void)changeLeftStr:(NSString *)leftStr rightStr:(NSString *)rightStr
{
    if (leftStr) {
        [self.leftButton setTitle:leftStr forState:UIControlStateNormal];
    }
    if (rightStr) {
        [self.rightButton setTitle:rightStr forState:UIControlStateNormal];
    }
}

/**
 * 设置右侧按钮不可点击
 */
- (void)setRightUserEnable:(BOOL)enable
{
    if (enable) {
        [self.rightButton setTitleColor:IHSDK_COLOR_GREEN forState:UIControlStateNormal];
    } else {
        [self.rightButton setTitleColor:IHSDK_COLOR_DISABLE_GRAY forState:UIControlStateNormal];
    }
    self.rightButton.userInteractionEnabled = enable;
}

/**
 * 设置底部按钮不可点击
 */
- (void)setBottomButtonUserEnable:(BOOL)enable
{
    if (enable) {
        [self.bottomButton setTitleColor:IHSDK_COLOR_GREEN forState:UIControlStateNormal];
    } else {
        [self.bottomButton setTitleColor:IHSDK_COLOR_DISABLE_GRAY forState:UIControlStateNormal];
    }
    self.bottomButton.userInteractionEnabled = enable;
}


/**
 * 设置左侧按钮的颜色
 */
- (void)setLeftButtonTextColor:(UIColor * _Nullable)textColor font:(UIFont *_Nullable)font
{
    if (textColor) {
        [self.leftButton setTitleColor:textColor forState:UIControlStateNormal];
    }
    
    if (font) {
        self.leftButton.titleLabel.font = font;
    }
}

/**
 * 设置右侧按钮的颜色
 */
- (void)setRightButtonTextColor:(UIColor * _Nullable)textColor font:(UIFont *_Nullable)font
{
    if (textColor) {
        [self.rightButton setTitleColor:textColor forState:UIControlStateNormal];
    }
    if (font) {
        self.rightButton.titleLabel.font = font;
    }
}

/**
 * 设置右侧底部按钮
 */
- (void)setBottomButtonTextColor:(UIColor * _Nullable)textColor font:(UIFont *_Nullable)font
{
    if (textColor) {
        [self.bottomButton setTitleColor:textColor forState:UIControlStateNormal];
    }
    
    if (font) {
        self.bottomButton.titleLabel.font = font;
    }
}
@end
