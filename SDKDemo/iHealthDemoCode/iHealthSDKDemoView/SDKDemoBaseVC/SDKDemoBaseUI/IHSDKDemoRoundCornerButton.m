//
//  IHSDKDemoRoundCornerButton.m
//  iHealthDemoCode
//
//  Created by jing on 2023/4/11.
//  Copyright © 2023 iHealth Demo Code. All rights reserved.
//

#import "IHSDKDemoRoundCornerButton.h"
#import "IHSDKDemoUIHeader.h"
@interface IHSDKDemoRoundCornerButton()
@property (assign, nonatomic) BOOL isGreen;
@end

@implementation IHSDKDemoRoundCornerButton

+ (instancetype)buttonWithTitle:(NSString*)title{
    
    IHSDKDemoRoundCornerButton *btn = [[IHSDKDemoRoundCornerButton alloc]initWithFrame:CGRectMake(0, 200, 190, 40) isGreen:YES];
    [btn setTitle:title forState:UIControlStateNormal];
    return btn;
}

+ (instancetype)grayButtonWithTitle:(NSString*)title{
    IHSDKDemoRoundCornerButton *btn = [[IHSDKDemoRoundCornerButton alloc]initWithFrame:CGRectMake(0, 200, 190, 40) isGreen:NO];
    [btn setTitle:title forState:UIControlStateNormal];
    return btn;
}
+ (instancetype)buttonWithTitle:(NSString *)title style:(IHSDKRoundCornerButtonStyle)style{
    IHSDKDemoRoundCornerButton *btn = [IHSDKDemoRoundCornerButton buttonWithTitle:title];
    [btn.titleLabel setFont:IHSDK_FONT_Medium(18)];
    [btn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [btn setBackgroundColor:kIHSDK_Text_Wyze_Green];
    [btn setCornerRadius:4];
    [btn.layer setBorderColor:kIHSDK_Text_Wyze_Green.CGColor];
    return btn;
}

- (void)addToViewBottom:(UIView*)view{
    [view addSubview:self];
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.bottom.mas_equalTo(view.mas_safeAreaLayoutGuideBottom).offset(-20);
        } else {
            make.bottom.mas_equalTo(view).offset(-20);
        }
        make.left.mas_equalTo(view).offset(12);
        make.right.mas_equalTo(view).offset(-12);
        make.height.mas_equalTo(48);
    }];
}

- (instancetype)initWithFrame:(CGRect)frame isGreen:(BOOL)isGreen{
    self = [super initWithFrame:frame];
    if (self) {
        [self.titleLabel setFont:IHSDK_FONT_Regular(14)];
        self.isGreen = isGreen;
        if (isGreen) {
            [self setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
            
            [self setImage:[self createImageWithColor:kIHSDK_Text_Wyze_Green] forState:UIControlStateNormal];
            [self setImage:[self createImageWithColor:kIHSDK_Text_Wyze_Green] forState:UIControlStateHighlighted];
            [self setImage:[self createImageWithColor:kIHSDK_Text_Gray_Disable] forState:UIControlStateDisabled];
        } else {
            [self setTitleColor:kIHSDK_Text_Gray forState:UIControlStateNormal];
            
            [self setImage:[self createImageWithColor:kIHSDK_Text_Gray] forState:UIControlStateNormal];
            [self setImage:[self createImageWithColor:kIHSDK_Text_Gray] forState:UIControlStateHighlighted];
            [self setImage:[self createImageWithColor:kIHSDK_Text_Gray] forState:UIControlStateDisabled];
        }
        
        [self.layer setBorderWidth:1];
        [self.layer setCornerRadius:20];
        self.enabled = YES;
    }
    return self;
}

- (void)setEnabled:(BOOL)enabled{
    [super setEnabled:enabled];
    if (enabled) {
        if (self.isGreen) {
            [self setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
            [self setBackgroundColor:kIHSDK_Text_Wyze_Green];
            [self.layer setBorderColor:kIHSDK_Text_Wyze_Green.CGColor];
        } else {
            [self setTitleColor:kIHSDK_Text_Gray forState:UIControlStateNormal];
            [self setBackgroundColor:UIColor.whiteColor];
            [self.layer setBorderColor:kIHSDK_Text_Gray.CGColor];
        }
        
    } else {
        [self setTitleColor:IHSDK_COLOR_FROM_HEX(0x6A737D) forState:UIControlStateNormal];
        [self setBackgroundColor:kIHSDK_Text_Gray_Disable];
        [self.layer setBorderColor:kIHSDK_Text_Gray_Disable.CGColor];
    }
}

- (UIImage*)createImageWithColor:(UIColor*) color
{
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

- (void)setCornerRadius:(CGFloat)value{
    [self.layer setCornerRadius:value];
}
/// 更新UI变成disbale的样式，但是仍然响应点击
- (void)updateToDisableStyleButRespondTouch{
    [self setTitleColor:IHSDK_COLOR_FROM_HEX(0x6A737D) forState:UIControlStateNormal];
    [self setBackgroundColor:kIHSDK_Text_Gray_Disable];
    [self.layer setBorderColor:kIHSDK_Text_Gray_Disable.CGColor];
}

/// 回复成原来的样式，与updateToDisableStyleButRespondTouch对应
- (void)updateToDefaultStyle{
    if (self.isGreen) {
        [self setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [self setBackgroundColor:kIHSDK_Text_Wyze_Green];
        [self.layer setBorderColor:kIHSDK_Text_Wyze_Green.CGColor];
    } else {
        [self setTitleColor:kIHSDK_Text_Gray forState:UIControlStateNormal];
        [self setBackgroundColor:UIColor.whiteColor];
        [self.layer setBorderColor:kIHSDK_Text_Gray.CGColor];
    }
}

@end
