//
//  UIButton+WPKButton.m
//  WZPlatformKit
//
//  Created by abc on 2019/4/30.
//  Copyright © 2019 Wyze. All rights reserved.
//

#import "UIButton+WPKButton.h"
#import <objc/runtime.h>

@interface UIButton ()
@property (nonatomic, copy) WPKButtonBlock wpkblock;
@end
static NSString *kWPK_BUTTON_CLOKC_KEY = @"com.wpk.BUTTONS";
@implementation UIButton (WZButton)
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-designated-initializers"
- (instancetype _Nullable)initWithFrame:(CGRect)frame titile:(NSString * _Nullable)title font:(UIFont * _Nullable)font  textColor:(UIColor *_Nullable)textColor
{
    self = [UIButton buttonWithType:UIButtonTypeCustom];//适配iOS13
    if (self) {
        self.frame = frame;
        if (title) {
            [self setTitle:title forState:UIControlStateNormal];
        }
        if (font) {
            self.titleLabel.font = font;
        }
        if (textColor) {
            [self setTitleColor:textColor forState:UIControlStateNormal];
        } else {
            [self setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];//defalut color
        }
    }
    return self;
}

- (instancetype _Nullable)initWithFrame:(CGRect)frame titile:(NSString * _Nullable)title font:(UIFont * _Nullable)font  textColor:(UIColor *_Nullable)textColor action:(WPKButtonBlock _Nullable)action
{
    self = [UIButton buttonWithType:UIButtonTypeCustom];//适配iOS13 frame为CGRectZero self.titleLabel 返回值为nil
    if (self) {
        self.frame = frame;
        if (title) {
            [self setTitle:title forState:UIControlStateNormal];
        }
        if (font) {
            self.titleLabel.font = font;
        }
        if (textColor) {
            [self setTitleColor:textColor forState:UIControlStateNormal];
        } else {
            [self setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];//defalut color
        }
        if (action != nil) {
            objc_setAssociatedObject(self, (__bridge const void *)kWPK_BUTTON_CLOKC_KEY, action, OBJC_ASSOCIATION_COPY);
            [self addTarget:self action:@selector(callActionBlock:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    return self;
}
#pragma clang diagnostic pop


- (void)callActionBlock:(id)sender
{
     WPKButtonBlock block = (WPKButtonBlock)objc_getAssociatedObject(self, (__bridge const void *)kWPK_BUTTON_CLOKC_KEY);
     if (block) {
         block(sender);
    }
}

#pragma mark - Setter and Getter
- (void)setWpkblock:(WPKButtonBlock)wpkblock
{
    objc_setAssociatedObject(self,  (__bridge const void *)kWPK_BUTTON_CLOKC_KEY, wpkblock, OBJC_ASSOCIATION_COPY);
    self.wpkblock = wpkblock;
}

- (WPKButtonBlock)wpkblock
{
    return objc_getAssociatedObject(self,  (__bridge const void *)kWPK_BUTTON_CLOKC_KEY);
}
@end
