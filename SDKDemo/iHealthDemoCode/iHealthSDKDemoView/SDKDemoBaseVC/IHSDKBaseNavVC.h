//
//  IHSDKBaseNavVC.h
//  iHealthDemoCode
//
//  Created by jing on 2023/4/11.
//  Copyright © 2023 iHealth Demo Code. All rights reserved.
//

#import "IHSDKBaseController.h"

#import "IHSDKCustomLabel.h"

NS_ASSUME_NONNULL_BEGIN


typedef NS_ENUM(NSUInteger, IHSDKNavigationBarStyle) {
    IHSDKNavigationBarStyleDefault, // black arrow and title
    IHSDKNavigationBarStyleLight,// white arrow and title
};

typedef NS_ENUM(NSUInteger, IHSDKLeftBarButtonItemStyle) {
    IHSDKLeftBarButtonItemStyleNone, // hidden left bar button
    IHSDKLeftBarButtonItemStyleDefault, // back arrow style
    IHSDKLeftBarButtonItemStyleText, // text, default font
    IHSDKLeftBarButtonItemStyleBoldText,// text, bold font
};

typedef NS_ENUM(NSUInteger, IHSDKRightBarButtonItemStyle) {
    IHSDKRightBarButtonItemStyleNone = (1UL << 0), // hidden left bar button
    IHSDKRightBarButtonItemStyleSettings  = (1UL << 1), // setting image style
    IHSDKRightBarButtonItemStyleText = (1UL << 2), // custom text, regular font
    IHSDKRightBarButtonItemStyleBoldText = (1UL << 3), // custom text, bold font
    IHSDKRightBarButtonItemStyleClose = (1UL << 4), // close image style
    IHSDKRightBarButtonItemStyleSettingsAndCustomIcon = (1UL << 5), // custom icon
    IHSDKRightBarButtonItemStyleInfoIcon = (1UL << 6), // info icon
};

@interface IHSDKBaseNavVC : IHSDKBaseController

@property (assign, nonatomic) IHSDKNavigationBarStyle navigationBarStyle;

@property (assign, nonatomic) IHSDKLeftBarButtonItemStyle leftBarButtonItemStyle;// default is IHSDKLeftBarButtonItemStyleDefault

@property (copy, nonatomic) NSString *leftBarButtonTitle;
@property (copy, nonatomic) UIColor *leftBarButtonTitleColor;

@property (assign, nonatomic) BOOL leftBarButtonEnabled;

@property (assign, nonatomic) IHSDKRightBarButtonItemStyle rightBarButtonItemStyle;// default is IHSDKRightBarButtonItemStyleNone

@property (assign, nonatomic) BOOL rightBarButtonEnabled; // available when rightBarButtonItemStyle is not IHSDKRightBarButtonItemStyleNone

@property (copy, nonatomic)  NSString *rightBarButtonTitle; // available when rightBarButtonItemStyle is IHSDKRightBarButtonItemStyleText
@property (copy, nonatomic) UIColor *rightBarButtonTitleColor;
@property (copy, nonatomic) UIImage *settingIconImage;
@property (copy, nonatomic) UIImage *customIconImage;

- (void)setSettingButtonImage:(UIImage*)image;
- (void)setCustomButtonImage:(UIImage*)image;

// subclass can override this method to initialize view, no need to [super setupInterface]
- (void)setupInterface;

// subclass can override this method to handle press, default is popViewController
- (void)leftBarButtonDidPressed:(nullable id)sender;

// subclass can override this method to handle press, no need to [super rightBarButtonDidPressed:]
- (void)rightBarButtonDidPressed:(id)sender;

// subclass can override this method to handle press, no need to [super customIconButtonDidPressed:]
- (void)customIconButtonDidPressed:(id)sender;

/// 不屏蔽点击的loading
- (void)showLoading;
/// 屏蔽点击的loading
- (void)showLoadingDisableTap;
/// 隐藏loading
- (void)hideLoading;

// 显示3s，不屏蔽屏幕点击
- (void)showTopToast:(NSString*)text;

// 马上隐藏Toast
- (void)hideTopToast;

// 显示loading，带文字，屏蔽屏幕点击
- (void)showLoadingTipsWithText:(NSString*)text;

- (void)hideLoadingTips;
/**
 失败的Toast，内部使用的是WPK的[[WPKTipsView shareInstance] showFailedTips:text duration:3.0 useInteraction:YES];

 @param text 文字
 */
- (void)showFailToastWithText:(NSString*)text;

/**
 成功的Toast，内部使用的是WPK的[[WPKTipsView shareInstance] showFailedTips:text duration:3.0 useInteraction:YES];
 
 @param text 文字
 */
- (void)showSuccessToastWithText:(NSString*)text;

@end

NS_ASSUME_NONNULL_END
