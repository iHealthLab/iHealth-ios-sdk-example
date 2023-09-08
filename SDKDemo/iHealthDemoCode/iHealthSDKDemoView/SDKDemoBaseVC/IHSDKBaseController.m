//
//  IHSDKBaseController.m
//  iHealthDemoCode
//
//  Created by jing on 2023/4/11.
//  Copyright © 2023 iHealth Demo Code. All rights reserved.
//

#import "IHSDKBaseController.h"
#import "IHSDKColorConstant.h"
@interface IHSDKBaseController ()

@end

@implementation IHSDKBaseController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.modalPresentationStyle = UIModalPresentationFullScreen;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = IHSDK_COLOR_FROM_HEX(0xF0F4F7);
    self.tabBarController.tabBar.hidden = YES;
    self.IHSDKPopGestureRecognizerEnable = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = [self preferredStatusBarStyle];
   // 适配 iOS 11 以下
    if (@available(iOS 11.0, *)) {
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (self.navigationController) {
        self.navigationController.interactivePopGestureRecognizer.enabled = self.IHSDKPopGestureRecognizerEnable;
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
   
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (CGFloat)IHSDK_safeAreaInsetTopWithNaviBarHidden:(BOOL)naviBarHidden
{
    // statusbar高度=24+20（包含顶部Inset）
    CGFloat safeAreaInsetTop = CGRectGetHeight([UIApplication sharedApplication].statusBarFrame);
    if (!naviBarHidden) {
        safeAreaInsetTop += CGRectGetHeight(self.navigationController.navigationBar.frame);
    }
    return safeAreaInsetTop;
}

- (CGFloat)IHSDK_safeAreaInsetBottomWithTabBarHidden:(BOOL)tabBarHidden
{
    CGFloat safeAreaInsetBottom = IHSDK_isIPhoneX()?34.f:0.0 ;
    if (!tabBarHidden) {
        // tabbar高度=49+34（包含底部Inset）
        if (self.tabBarController.tabBar) {
            safeAreaInsetBottom += CGRectGetHeight(self.tabBarController.tabBar.frame);
        } else {
            safeAreaInsetBottom += 49.f;
        }
    }
    return safeAreaInsetBottom;
}

- (CGFloat)IHSDK_safeAreaInsetTop
{
    if (@available(iOS 11.0, *)) {
        return self.view.safeAreaInsets.top;
    } else {
        return self.topLayoutGuide.length;
    }
}

- (CGFloat)IHSDK_safeAreaInsetBottom
{
    if (@available(iOS 11.0, *)) {
        return self.view.safeAreaInsets.bottom;
    } else {
        return self.bottomLayoutGuide.length;
    }
}

+ (CGFloat)IHSDK_statusBarInsetTop
{
    if (IHSDK_isIPhoneX()) {
        return 24.0;
    } else {
        return 0.0;
    }
}

+ (CGFloat)IHSDK_tabBarInsetBottom
{
    if (IHSDK_isIPhoneX()) {
        return 34.0;
    } else {
        return 0.0;
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    if (@available(iOS 13, *)) {
        return UIStatusBarStyleDarkContent;
    }
    return UIStatusBarStyleDefault;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
