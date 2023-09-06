//
//  IHSDKDemoToast.m
//  iHealthDemoCode
//
//  Created by jing on 2023/4/11.
//  Copyright © 2023 iHealth Demo Code. All rights reserved.
//

#import "IHSDKDemoToast.h"
static IHSDKDemoToast *_sdk_toastView;

#define IHSDK_TOAST_STAY_SECOND      3          //显示时间
#define IHSDK_TOAST_ANIMATION_SECOND 0.3        //动画时间
#define IHSDK_TOAST_PADING           32         //文字左边TOAST_PADING
#define IHSDK_TOAST_MAX_WIDTH        [UIScreen mainScreen].bounds.size.width-50        //最大宽度

@interface IHSDKDemoToast()
@property (nonatomic, assign) BOOL haveBorder;
@property (nonatomic, assign) BOOL isShow;
@property (nonatomic, assign) CGPoint centerTemp;
@property (nonatomic, assign) int borderHeight;
@property (nonatomic, assign) int topMargin;
@property (nonatomic, strong) UILabel *titleLbl;

@property (nonatomic, assign) NSTimeInterval IHSDK_toastStaySecond;
@property (nonatomic, strong) UIFont * IHSDK_textFont;
@end

@implementation IHSDKDemoToast

+ (void)showTipWithTitle:(NSString *)title
{
    [self showTipWithTitle:title textAlignment:NSTextAlignmentCenter];
}

/**
* @param title 文字内容 默认居中
* @param textAlignment 文字的样式
*/
+ (void)showTipWithTitle:(NSString *)title textAlignment:(NSTextAlignment)textAlignment
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [IHSDKDemoToast shareTipview].IHSDK_textFont = [UIFont systemFontOfSize:IHSDKScaleByWidth(14)];
        [IHSDKDemoToast shareTipview].IHSDK_toastStaySecond = IHSDK_TOAST_STAY_SECOND;
        [IHSDKDemoToast checkTip:title];
        [IHSDKDemoToast shareTipview].titleLbl.textAlignment = textAlignment;
        [IHSDKDemoToast showTip];
        [IHSDKDemoToast addGes];
    });
}

+ (void)showTipWithTitle:(NSString *)title starY:(CGFloat)starY
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [IHSDKDemoToast shareTipview].IHSDK_textFont = [UIFont systemFontOfSize:IHSDKScaleByWidth(14)];
        [IHSDKDemoToast shareTipview].IHSDK_toastStaySecond = IHSDK_TOAST_STAY_SECOND;
        [IHSDKDemoToast checkTip:title];
        [IHSDKDemoToast fixOrginY:starY];
        [IHSDKDemoToast showTip];
        [IHSDKDemoToast addGes];
    });
}

+ (void)showTipWithTitle:(NSString *)title duration:(NSTimeInterval)duration
{
    [self showTipWithTitle:title textAlignment:NSTextAlignmentCenter duration:duration];
}

+ (void)showTipWithTitle:(NSString *)title textAlignment:(NSTextAlignment)textAlignment duration:(NSTimeInterval)duration
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [IHSDKDemoToast shareTipview].IHSDK_textFont = [UIFont systemFontOfSize:IHSDKScaleByWidth(14)];
        [IHSDKDemoToast shareTipview].IHSDK_toastStaySecond = duration;
        [IHSDKDemoToast checkTip:title];
        [IHSDKDemoToast shareTipview].titleLbl.textAlignment = textAlignment;
        [IHSDKDemoToast showTip];
        [IHSDKDemoToast addGes];
    });
}

/**
 * @param title 文字内容 默认居中
  * @param titleFont 文字的字体
 * @param duration 持续时间
 */
+ (void)showTipWithTitle:(NSString *)title titleFont:(UIFont *)titleFont duration:(NSTimeInterval)duration
{
    [self showTipWithTitle:title titleFont:titleFont textAlignment:NSTextAlignmentCenter duration:duration];
}

+ (void)showTipWithTitle:(NSString *)title titleFont:(UIFont *)titleFont textAlignment:(NSTextAlignment)textAlignment duration:(NSTimeInterval)duration
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [IHSDKDemoToast shareTipview].IHSDK_textFont = titleFont;
        [IHSDKDemoToast shareTipview].IHSDK_toastStaySecond = duration;
        [IHSDKDemoToast checkTip:title];
        [IHSDKDemoToast shareTipview].titleLbl.textAlignment = textAlignment;
        [IHSDKDemoToast showTip];
        [IHSDKDemoToast addGes];
    });
}

+ (void)dismiss
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [IHSDKDemoToast hidnTip];
    });
}

#pragma  mark - private

+ (instancetype)shareTipview
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sdk_toastView = [[IHSDKDemoToast alloc] init];
        _sdk_toastView.IHSDK_textFont = [UIFont systemFontOfSize:IHSDKScaleByWidth(14)];
    });
    return _sdk_toastView;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _isShow = NO;
        _haveBorder = NO;
        _borderHeight = 0;
        _topMargin = [UIScreen mainScreen].bounds.size.height>=812 ? 88:64;
        self.layer.cornerRadius = 5;
        self.layer.masksToBounds = YES;
        self.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
        [self addSubview:self.titleLbl];
        [self addObserver];
    }
    return self;
}


//当键盘出现
- (void)keyboardWillShow:(NSNotification *)notification
{
    _haveBorder = YES;
    //获取键盘的高度
    NSDictionary *userInfo = [notification userInfo];
    NSValue *value = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [value CGRectValue];
    int height = keyboardRect.size.height;
    IHSDKDemoToast *tip = [IHSDKDemoToast shareTipview];
    tip.borderHeight = height;
    if (_isShow) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.3 animations:^{
                tip.center = CGPointMake( [UIScreen mainScreen].bounds.size.width/2,  [UIScreen mainScreen].bounds.size.height/2-height/2+tip.topMargin);
            }];
        });
    }
}

//当键退出
- (void)keyboardWillHide:(NSNotification *)notification
{
    _haveBorder = NO;
    //获取键盘的高度
    NSDictionary *userInfo = [notification userInfo];
    NSValue *value = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [value CGRectValue];
    int height = keyboardRect.size.height;
    IHSDKDemoToast *tip = [IHSDKDemoToast shareTipview];
    tip.borderHeight = height;
    if (_isShow) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.3 animations:^{
                tip.center = tip.centerTemp;
            }];
        });
    }
}

- (void)addObserver
{
    //监听当键盘将要出现时
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    //监听当键将要退出时
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
}

+ (void)checkTip:(NSString *)title
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hidnTip) object:@"hidnTip"];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hidnAnmationTip) object:@"hidnAnmationTip"];
    CGSize size = [IHSDKDemoToast calWidthWithNSString:title];
    CGFloat width = size.width >= IHSDK_TOAST_MAX_WIDTH ? IHSDK_TOAST_MAX_WIDTH :size.width;
    IHSDKDemoToast *tip = [IHSDKDemoToast shareTipview];
    tip.layer.transform = CATransform3DMakeScale(1, 1, 1);
    tip.titleLbl.text = [NSString stringWithFormat:@"%@",title];
    tip.titleLbl.font = tip.IHSDK_textFont;
    tip.titleLbl.frame = CGRectMake(IHSDK_TOAST_PADING/2,14, width+2, size.height);
    tip.frame = CGRectMake(0, 0, width+IHSDK_TOAST_PADING, size.height+28);
    tip.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.height/2);
}


+ (void)showBottomTipWithTitle:(NSString *)title
{
    [IHSDKDemoToast checkTip:title];
    IHSDKDemoToast *tip = [IHSDKDemoToast shareTipview];
    CGFloat starY = [UIScreen mainScreen].bounds.size.height-tip.frame.size.height-IHSDK_SAFEAREA_BOTTOM_H-40;
    [IHSDKDemoToast fixOrginY:starY];
    [IHSDKDemoToast showAnmationTip];
    [IHSDKDemoToast addGes];
}


+ (void)showBottomTipWithTitle:(NSString *)title duration:(NSTimeInterval)duration
{
    [IHSDKDemoToast shareTipview].IHSDK_toastStaySecond = duration;
    [IHSDKDemoToast checkTip:title];
    IHSDKDemoToast *tip = [IHSDKDemoToast shareTipview];
    CGFloat starY = [UIScreen mainScreen].bounds.size.height-tip.frame.size.height-IHSDK_SAFEAREA_BOTTOM_H-40;
    [IHSDKDemoToast fixOrginY:starY];
    [IHSDKDemoToast showAnmationTip];
    [IHSDKDemoToast addGes];
}

+ (void)fixOrginY:(CGFloat)starY
{
    IHSDKDemoToast *tip = [IHSDKDemoToast shareTipview];
    tip.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2-tip.frame.size.width/2, starY, tip.frame.size.width, tip.frame.size.height);
}

+ (void)showAnmationTip
{
    IHSDKDemoToast *tip = [IHSDKDemoToast shareTipview];
    CGFloat starY = [UIScreen mainScreen].bounds.size.height-tip.frame.size.height-IHSDK_SAFEAREA_BOTTOM_H-40;
    
    tip.layer.transform = CATransform3DTranslate(tip.layer.transform, 0, starY, 0);
    tip.alpha = 0;
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:tip];
    [UIView animateWithDuration:IHSDK_TOAST_ANIMATION_SECOND animations:^{
        tip.layer.transform = CATransform3DIdentity;
        tip.alpha = 1;
    }completion:^(BOOL finished) {
        [IHSDKDemoToast performSelector:@selector(hidnAnmationTip) withObject:@"hidnAnmationTip" afterDelay:[IHSDKDemoToast shareTipview].IHSDK_toastStaySecond];
    }];
    
    tip.centerTemp =  tip.center;
    if (tip.haveBorder) {
        tip.center = CGPointMake( [UIScreen mainScreen].bounds.size.width/2,  [UIScreen mainScreen].bounds.size.height/2-tip.borderHeight/2+tip.topMargin);
    }
    tip.isShow = YES;
}

+ (void)showTip
{
    IHSDKDemoToast *tip = [IHSDKDemoToast shareTipview];
    tip.layer.transform = CATransform3DScale(tip.layer.transform, 0, 0, 0);
    tip.alpha = 0;
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:tip];
    [UIView animateWithDuration:IHSDK_TOAST_ANIMATION_SECOND animations:^{
        tip.layer.transform = CATransform3DIdentity;
        tip.alpha = 1;
    }completion:^(BOOL finished) {
        [IHSDKDemoToast performSelector:@selector(hidnTip) withObject:@"hidnTip" afterDelay:[IHSDKDemoToast shareTipview].IHSDK_toastStaySecond];
    }];
    
    tip.centerTemp =  tip.center;
    if (tip.haveBorder) {
        tip.center = CGPointMake( [UIScreen mainScreen].bounds.size.width/2,  [UIScreen mainScreen].bounds.size.height/2-tip.borderHeight/2+tip.topMargin);
    }
    tip.isShow = YES;
}

//添加手势
+ (void)addGes
{
    IHSDKDemoToast *tip = [IHSDKDemoToast shareTipview];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hidnTip)];
    [tip addGestureRecognizer:tap];
}

+ (void)hidnAnmationTip
{
    IHSDKDemoToast *tip = [IHSDKDemoToast shareTipview];
    if (tip.alpha != 1) {return;}
    [UIView animateWithDuration:IHSDK_TOAST_ANIMATION_SECOND animations:^{
        tip.layer.transform = CATransform3DTranslate(tip.layer.transform, 0, [UIScreen mainScreen].bounds.size.height, 0);
        tip.alpha = 0;
    }completion:^(BOOL finished) {
        [tip removeFromSuperview];
    }];
    tip.isShow = NO;
}


//取消
+ (void)hidnTip
{
    IHSDKDemoToast *tip = [IHSDKDemoToast shareTipview];
    if (tip.alpha != 1) {return;}
    [UIView animateWithDuration:IHSDK_TOAST_ANIMATION_SECOND animations:^{
        tip.layer.transform = CATransform3DScale(tip.layer.transform, 0, 0, 0);
        tip.alpha = 0;
    }completion:^(BOOL finished) {
        [tip removeFromSuperview];
    }];
    tip.isShow = NO;
}

//计算文本宽
+ (CGSize)calWidthWithNSString:(NSString *)str
{
    CGSize infoSize = CGSizeMake(IHSDK_TOAST_MAX_WIDTH, 1000);
    NSDictionary *dic = @{NSFontAttributeName: [IHSDKDemoToast shareTipview].IHSDK_textFont};
    CGRect rect =   [str boundingRectWithSize:infoSize options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dic context:nil];
    return rect.size;
}

- (UILabel *)titleLbl
{
    if (!_titleLbl) {
        _titleLbl = [[UILabel alloc]init];
        _titleLbl.textColor = [UIColor blackColor];
        _titleLbl.font = self.IHSDK_textFont;
        _titleLbl.center = self.center;
        _titleLbl.textAlignment = NSTextAlignmentCenter;
        _titleLbl.numberOfLines = 0;
    }
    return _titleLbl;
}


@end
