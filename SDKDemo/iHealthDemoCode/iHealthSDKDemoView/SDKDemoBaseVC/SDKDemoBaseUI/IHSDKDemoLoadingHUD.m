//
//  IHSDKDemoLoadingHUD.m
//  iHealthDemoCode
//
//  Created by jing on 2023/4/11.
//  Copyright © 2023 iHealth Demo Code. All rights reserved.
//

#import "IHSDKDemoLoadingHUD.h"
#import "IHSDKDemoLoadingView.h"
#import "IHSDKDemoUIUtils.h"
#import "IHSDKColorConstant.h"
#import "IHSDKDemoUIHeader.h"

@interface IHSDKDemoLoadingHUD () <UIGestureRecognizerDelegate>
@property (nonatomic, strong) IHSDKDemoLoadingView *loadingView;
@property (nonatomic, strong) UILabel *loadingText;
@end

@implementation IHSDKDemoLoadingHUD

static IHSDKDemoLoadingHUD *sdk_loadingHUD = nil;
static UIView *sdk_loadingBackgroundView = nil;

/**
* show loading without supview
*/
+ (void)show
{
    ihsdk_dispatchMain(^{
        UIView *superView =  [IHSDKDemoUIUtils topViewController].view;
        
        if (![superView.subviews containsObject:[IHSDKDemoLoadingHUD shareView]]) {
            [superView addSubview:[IHSDKDemoLoadingHUD shareView]];
        }
        [[IHSDKDemoLoadingHUD shareView].loadingView starAnimation];
        [IHSDKDemoLoadingHUD shareView].center = CGPointMake(superView.frame.size.width/2.0, superView.frame.size.height/2.0);
    });
    
}

/**
* hide loading
*/
+ (void)hide
{
    ihsdk_dispatchMain(^{
        [[IHSDKDemoLoadingHUD shareView].loadingView stopAnimation];
        [[IHSDKDemoLoadingHUD shareView] removeFromSuperview];
        [[IHSDKDemoLoadingHUD shareBackgroundView] removeFromSuperview];
        sdk_loadingHUD = nil;
        sdk_loadingBackgroundView = nil;
    });
}

/**
* show loading on window
*/
+ (void)showWindow
{
    ihsdk_dispatchMain(^{
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        if (![window.subviews containsObject:[IHSDKDemoLoadingHUD shareView]]) {
            [window addSubview:[IHSDKDemoLoadingHUD shareView]];
        }
        [[IHSDKDemoLoadingHUD shareView].loadingView starAnimation];
        [IHSDKDemoLoadingHUD shareView].center = CGPointMake(window.frame.size.width/2.0, window.frame.size.height/2.0);
    });
}

/**
* show loading on superview
  @param view show loading's superview
*/
+ (void)showLoadingOn:(UIView *)view
{
    ihsdk_dispatchMain(^{
        if (![view.subviews containsObject:[IHSDKDemoLoadingHUD shareView]]) {
            [view addSubview:[IHSDKDemoLoadingHUD shareView]];
        }
        [[IHSDKDemoLoadingHUD shareView].loadingView starAnimation];
        [IHSDKDemoLoadingHUD shareView].center = CGPointMake(view.frame.size.width/2.0, view.frame.size.height/2.0);
    });
}

/**
* show loading on window isUserInteractionEnabled = false
*/
+ (void)showWindowUserInteractionDisabled
{
    ihsdk_dispatchMain(^{
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        
        if (![window.subviews containsObject:[IHSDKDemoLoadingHUD shareBackgroundView]]) {
            [window addSubview:[IHSDKDemoLoadingHUD shareBackgroundView]];
        }
        if (![window.subviews containsObject:[IHSDKDemoLoadingHUD shareView]]) {
            [[IHSDKDemoLoadingHUD shareBackgroundView] addSubview:[IHSDKDemoLoadingHUD shareView]];
        }
        
        if (sdk_loadingHUD) {
            UITapGestureRecognizer *hideTap = [[UITapGestureRecognizer alloc]initWithTarget:sdk_loadingHUD action:@selector(disablebackgroundOeration)];
            hideTap.delegate = sdk_loadingHUD;
            [sdk_loadingBackgroundView addGestureRecognizer:hideTap];
        }
        [[IHSDKDemoLoadingHUD shareView].loadingView starAnimation];
        [IHSDKDemoLoadingHUD shareView].center = CGPointMake(window.frame.size.width/2.0, window.frame.size.height/2.0);
    });
}

#pragma mark - private Method
+ (UIView *)shareBackgroundView
{
    if (!sdk_loadingBackgroundView) {
        sdk_loadingBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, IHSDK_SCREEN_W, IHSDK_SCREEN_H)];
        sdk_loadingBackgroundView.backgroundColor = [UIColor clearColor];
    }
    return sdk_loadingBackgroundView;
}

+ (instancetype)shareView
{
    if (!sdk_loadingHUD) {
        sdk_loadingHUD = [[IHSDKDemoLoadingHUD alloc] initWithFrame:CGRectMake(0, 0, 110, 40)];
        sdk_loadingHUD.backgroundColor = [[UIColor darkGrayColor] colorWithAlphaComponent:0.7];
        sdk_loadingHUD.layer.cornerRadius = 8;
        sdk_loadingHUD.layer.masksToBounds = YES;
        [sdk_loadingHUD buildSubiews];
    }
    return sdk_loadingHUD;
}

- (void)buildSubiews
{
    IHSDKDemoLoadingView *loadingView = [[IHSDKDemoLoadingView alloc] init];
    loadingView.lineW = 2.f;
    loadingView.strokeColor = [UIColor whiteColor];
    
    [loadingView createUI];
    self.loadingView = loadingView;
    [self addSubview:loadingView];
    
    [loadingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.left.mas_equalTo(self).offset(13);
        make.width.equalTo(@16);
        make.height.equalTo(@16);
    }];
    
    _loadingText = ({
        UILabel *label = [[UILabel alloc] init];
        label.text = @"Loading...";
        label.font = IHSDKFontDefault(12);
        label.textColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        label;
    });
    [self addSubview:_loadingText];
    
    [_loadingText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.right.top.equalTo(self);
        make.left.equalTo(loadingView.mas_right);
    }];
}

#pragma mark - 屏蔽视图点击效果
- (void)disablebackgroundOeration
{
    return;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    CGPoint touchPoint = [touch locationInView:self];
    if (CGRectContainsPoint(sdk_loadingBackgroundView.frame, touchPoint)) {
        return NO;
    }
    return  YES;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
