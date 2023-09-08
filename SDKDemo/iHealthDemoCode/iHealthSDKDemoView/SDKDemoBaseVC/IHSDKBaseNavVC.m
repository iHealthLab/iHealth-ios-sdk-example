//
//  IHSDKBaseNavVC.m
//  iHealthDemoCode
//
//  Created by jing on 2023/4/11.
//  Copyright © 2023 iHealth Demo Code. All rights reserved.
//

#import "IHSDKBaseNavVC.h"

#import "IHSDKColorConstant.h"

#import "IHSDKTipsView.h"

#import "IHSDKDemoUIHeader.h"

#import "IHSDKDemoLoadingHUD.h"

#import "IHSDKDemoToast.h"

#import "IHSDKUITipsView.h"

@interface IHSDKBaseNavVC ()

@property (nonatomic, strong) UIBarButtonItem *leftBarButton;
@property (nonatomic, strong) UIBarButtonItem *rightBarButton;

@end

@implementation IHSDKBaseNavVC

#pragma mark - View Lifecircle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // defaults
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.hidesBottomBarWhenPushed = YES;
    
    self.view.backgroundColor = kIHSDK_Background_Gray;
    [self.navigationController.navigationBar setTranslucent:YES];
    [self.navigationController.navigationBar setBackgroundImage:KIHSDKImageNamed(@"IHSDK_translucent") forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:KIHSDKImageNamed(@"IHSDK_translucent_shadow")];
    
    self.leftBarButtonItemStyle = IHSDKLeftBarButtonItemStyleDefault;
    self.rightBarButtonItemStyle = IHSDKRightBarButtonItemStyleNone;
    self.navigationBarStyle = IHSDKNavigationBarStyleDefault;
        
    [self setupInterface];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    [UIApplication sharedApplication].statusBarStyle = [super preferredStatusBarStyle];
    if (self.navigationBarStyle == IHSDKNavigationBarStyleLight) {
        self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:UIColor.whiteColor,NSFontAttributeName:IHSDK_FONT_Medium(20)};
        self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    } else if (self.navigationBarStyle == IHSDKNavigationBarStyleDefault){
        self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:kIHSDK_Text_Black,NSFontAttributeName:IHSDK_FONT_Medium(20)};
        self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    }
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
   
}

#pragma mark - Gesture
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer*)gestureRecognizer{
    return NO;
}

#pragma mark - Super Method
- (void)setupInterface {
}

- (void)leftBarButtonDidPressed:(nullable id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightBarButtonDidPressed:(id)sender {
}
- (void)customIconButtonDidPressed:(id)sender{
    
}
#pragma mark - NavigationBar Style
- (void)setNavigationBarStyle:(IHSDKNavigationBarStyle)navigationBarStyle{
    _navigationBarStyle = navigationBarStyle;
    if (navigationBarStyle == IHSDKNavigationBarStyleLight) {
        self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:UIColor.whiteColor,NSFontAttributeName:IHSDK_FONT_Medium(20)};
        self.navigationItem.leftBarButtonItem = [self backBarButtonItem];
    } else if (navigationBarStyle == IHSDKNavigationBarStyleDefault){
//        UIColor *black = kIHSDK_Text_Black;
//        UIFont *font = IHSDK_FONT_Medium(16);
        self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:kIHSDK_Text_Black,NSFontAttributeName:IHSDK_FONT_Medium(20)};
        self.navigationItem.leftBarButtonItem = [self blackArrowBackBarButtonItem];
    }
}
#pragma mark - Left Button
- (void)setLeftBarButtonItemStyle:(IHSDKLeftBarButtonItemStyle)leftBarButtonItemStyle{
    _leftBarButtonItemStyle = leftBarButtonItemStyle;
    if (leftBarButtonItemStyle == IHSDKLeftBarButtonItemStyleNone) {
        self.navigationItem.hidesBackButton = YES;
        self.navigationItem.leftBarButtonItem = nil;
    } else if (leftBarButtonItemStyle == IHSDKLeftBarButtonItemStyleText){
        self.navigationItem.hidesBackButton = NO;
        self.navigationItem.leftBarButtonItem = [self leftTextBarButtonItem];
    } else if (leftBarButtonItemStyle == IHSDKLeftBarButtonItemStyleBoldText){
        self.navigationItem.hidesBackButton = NO;
        self.navigationItem.leftBarButtonItem = [self leftBoldTextBarButtonItem];
    } else {
        self.navigationItem.hidesBackButton = NO;
        self.navigationItem.leftBarButtonItem = [self blackArrowBackBarButtonItem];
    }
}

- (void)setLeftBarButtonTitle:(NSString *)leftBarButtonTitle{
    _leftBarButtonTitle = leftBarButtonTitle;
    if (_leftBarButtonItemStyle == IHSDKLeftBarButtonItemStyleText || _leftBarButtonItemStyle == IHSDKLeftBarButtonItemStyleBoldText) {
        [self.leftBarButton setTitle:leftBarButtonTitle];
    }
}

- (void)setLeftBarButtonTitleColor:(UIColor *)leftBarButtonTitleColor{
    _leftBarButtonTitleColor = leftBarButtonTitleColor;
    if (_leftBarButtonItemStyle == IHSDKLeftBarButtonItemStyleText || _leftBarButtonItemStyle == IHSDKLeftBarButtonItemStyleBoldText) {
        [self.leftBarButton setTintColor:leftBarButtonTitleColor];
    }
}

- (void)setLeftBarButtonEnabled:(BOOL)leftBarButtonEnabled{
    _leftBarButtonEnabled = leftBarButtonEnabled;
    if (self.leftBarButton) {
        self.leftBarButton.enabled = leftBarButtonEnabled;
    }
}
#pragma mark - Right Button
- (void)setRightBarButtonItemStyle:(IHSDKRightBarButtonItemStyle)rightBarButtonItemStyle{
    _rightBarButtonItemStyle = rightBarButtonItemStyle;
    switch (rightBarButtonItemStyle) {
        case IHSDKRightBarButtonItemStyleNone:
        {
            self.navigationItem.rightBarButtonItem = nil;
        }
            break;
        case IHSDKRightBarButtonItemStyleSettings:
        {
            self.navigationItem.rightBarButtonItems = @[[self settingBarButtonItem]];
        }
            break;
        
        case IHSDKRightBarButtonItemStyleText:
        {
            self.navigationItem.rightBarButtonItem = [self textBarButtonItem];
        }
            break;
        case IHSDKRightBarButtonItemStyleBoldText:
        {
            self.navigationItem.rightBarButtonItem = [self boldTextBarButtonItem];
        }
            break;
        case IHSDKRightBarButtonItemStyleClose:
        {
            self.navigationItem.rightBarButtonItems = @[[self closeBarButtonItem]];
        }
            break;
        case IHSDKRightBarButtonItemStyleSettingsAndCustomIcon:
        {
            self.navigationItem.rightBarButtonItems = @[[self settingBarButtonItem],[self customIconButtonItem]];
        }
            break;
        case IHSDKRightBarButtonItemStyleInfoIcon:
        {
            self.navigationItem.rightBarButtonItems = @[[self questionBarButtonItem]];
        }
            break;
        default:
            break;
    }
}

- (void)setRightBarButtonEnabled:(BOOL)rightBarButtonEnabled{
    _rightBarButtonEnabled = rightBarButtonEnabled;
    if (self.rightBarButton) {
        self.rightBarButton.enabled = rightBarButtonEnabled;
    }
}

- (void)setRightBarButtonTitle:(NSString *)rightBarButtonTitle{
    _rightBarButtonTitle = rightBarButtonTitle;
    if (_rightBarButtonItemStyle==IHSDKRightBarButtonItemStyleText || _rightBarButtonItemStyle==IHSDKRightBarButtonItemStyleBoldText) {
        [self.rightBarButton setTitle:_rightBarButtonTitle];
    }
}
- (void)setRightBarButtonTitleColor:(UIColor *)rightBarButtonTitleColor{
    _rightBarButtonTitleColor = rightBarButtonTitleColor;
    if (_rightBarButtonItemStyle == IHSDKRightBarButtonItemStyleText || _rightBarButtonItemStyle==IHSDKRightBarButtonItemStyleBoldText) {
        [self.rightBarButton setTintColor:rightBarButtonTitleColor];
    }
}
- (void)setSettingButtonImage:(UIImage*)image{
    _settingIconImage = image;
    if (self.rightBarButtonItemStyle == IHSDKRightBarButtonItemStyleSettingsAndCustomIcon) {
        self.navigationItem.rightBarButtonItems = @[[self settingBarButtonItem],[self customIconButtonItem]];
    } else if (self.rightBarButtonItemStyle == IHSDKRightBarButtonItemStyleSettings){
        self.navigationItem.rightBarButtonItems = @[[self settingBarButtonItem]];
    }
}
- (void)setCustomButtonImage:(UIImage*)image{
    _customIconImage = [image copy];
    if (self.rightBarButtonItemStyle == IHSDKRightBarButtonItemStyleSettingsAndCustomIcon) {
        self.navigationItem.rightBarButtonItems = @[[self settingBarButtonItem],[self customIconButtonItem]];
    }
}
#pragma mark - private
- (UIBarButtonItem *)leftTextBarButtonItem{

    UIBarButtonItem *saveItem = [[UIBarButtonItem alloc]initWithTitle:_leftBarButtonTitle style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonDidPressed:)];
    [saveItem setTitleTextAttributes:@{NSFontAttributeName:IHSDK_FONT_Regular(17)} forState:UIControlStateNormal];
    saveItem.tintColor = _leftBarButtonTitleColor;
    
    self.leftBarButton = saveItem;
    return saveItem;
}
- (UIBarButtonItem *)leftBoldTextBarButtonItem{

    UIBarButtonItem *saveItem = [[UIBarButtonItem alloc]initWithTitle:_leftBarButtonTitle style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonDidPressed:)];
    [saveItem setTitleTextAttributes:@{NSFontAttributeName:IHSDK_FONT_Bold(17)} forState:UIControlStateNormal];
    saveItem.tintColor = _leftBarButtonTitleColor;
    
    self.leftBarButton = saveItem;
    return saveItem;
}

- (UIBarButtonItem *)textBarButtonItem{

    UIBarButtonItem *saveItem = [[UIBarButtonItem alloc]initWithTitle:_rightBarButtonTitle style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonDidPressed:)];
    [saveItem setTitleTextAttributes:@{NSFontAttributeName:IHSDK_FONT_Regular(17)} forState:UIControlStateNormal];
    saveItem.tintColor = _rightBarButtonTitleColor;
    
    self.rightBarButton = saveItem;
    return saveItem;
}
- (UIBarButtonItem*)boldTextBarButtonItem{
    UIBarButtonItem *saveItem = [[UIBarButtonItem alloc]initWithTitle:_rightBarButtonTitle style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonDidPressed:)];
    [saveItem setTitleTextAttributes:@{NSFontAttributeName:IHSDK_FONT_Bold(17)} forState:UIControlStateNormal];
    saveItem.tintColor = _rightBarButtonTitleColor;
    
    self.rightBarButton = saveItem;
    return saveItem;
}
- (UIBarButtonItem *)settingBarButtonItem{
    UIImage *image = _settingIconImage?_settingIconImage:KIHSDKImageNamed(@"IHSDK_settings");
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonDidPressed:)];
    backItem.tintColor = kIHSDK_Text_Black;
    return backItem;
}
- (UIBarButtonItem *)questionBarButtonItem{
    UIImage *image = KIHSDKImageNamed(@"IHSDK_Info");
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonDidPressed:)];
    backItem.tintColor = kIHSDK_Text_Wyze_Green;
    return backItem;
}
- (UIBarButtonItem *)customIconButtonItem{

    
    UIView *containerV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 26, 26)];
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 26, 26)];
    
    
//    btn.layer.borderColor = UIColor.whiteColor.CGColor;
//    btn.layer.borderWidth = 1;
//    btn.layer.cornerRadius = 11.5;
//    btn.clipsToBounds = YES;
    btn.imageView.contentMode = UIViewContentModeScaleAspectFill;
    [btn setImage:self.customIconImage forState:UIControlStateNormal];
    
    [btn addTarget:self action:@selector(customIconButtonDidPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    [containerV addSubview:btn];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:containerV];
    return backItem;
}
- (UIBarButtonItem *)closeBarButtonItem{
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithImage:KIHSDKImageNamed(@"IHSDK_close") style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonDidPressed:)];
    backItem.tintColor = kIHSDK_Text_Black;
    return backItem;
}

//IHSDK_back_white 11x12
- (UIBarButtonItem *)backBarButtonItem{
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithImage:KIHSDKImageNamed(@"IHSDK_back_white") style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonDidPressed:)];
    backItem.tintColor = UIColor.whiteColor;
    self.leftBarButton = backItem;
    return backItem;
}

- (UIBarButtonItem *)blackArrowBackBarButtonItem{
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithImage:KIHSDKImageNamed(@"IHSDK_back_white") style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonDidPressed:)];
    backItem.tintColor = kIHSDK_Text_Black;
    self.leftBarButton = backItem;
    return backItem;
}

#pragma mark -
- (void)showLoading{
    [IHSDKDemoLoadingHUD showLoadingOn:self.view];
}
- (void)showLoadingDisableTap{
    [IHSDKDemoLoadingHUD showWindowUserInteractionDisabled];
}
- (void)hideLoading{
    [IHSDKDemoLoadingHUD hide];
}
- (void)showTopToast:(NSString*)text{
    if (text && text.length>0) {
        [IHSDKDemoToast showTipWithTitle:text];
    }
}

- (void)hideTopToast{
    [IHSDKDemoToast dismiss];
}

// 显示loading，带文字，屏蔽屏幕点击
- (void)showLoadingTipsWithText:(NSString*)text{
    [[IHSDKUITipsView sharedInstance]showLoadingTips:text];
}
- (void)hideLoadingTips{
    [[IHSDKUITipsView sharedInstance]hide];
}
- (void)showFailToastWithText:(NSString*)text{
    [IHSDKUITipsView sharedInstance].failImage = KIHSDKImageNamed(@"IHSDK_fail_icon");
    [[IHSDKUITipsView sharedInstance]showFailTips:text];
}

- (void)showSuccessToastWithText:(NSString*)text{
    [IHSDKUITipsView sharedInstance].successImage = KIHSDKImageNamed(@"IHSDK_success_icon");
    [[IHSDKUITipsView sharedInstance]showSuccessTips:text];
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
