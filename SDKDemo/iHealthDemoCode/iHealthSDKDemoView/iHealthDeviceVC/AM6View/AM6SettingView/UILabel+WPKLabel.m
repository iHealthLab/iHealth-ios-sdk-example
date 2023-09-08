//
//  UILabel+WPKLabel.m
//  WZPlatformKit
//
//  Created by abc on 2019/4/29.
//  Copyright © 2019 Wyze. All rights reserved.
//

#import "UILabel+WPKLabel.h"

@implementation UILabel (WPKLabel)
/**
    快速初始化标签
    @param frame  Label's frame
    @param text  Label's text
    @param font  Label's font
    @param textColor  Label's textColor
    @return UILabel
 */
- (instancetype _Nonnull)initWithFrame:(CGRect)frame text:(NSString * _Nullable)text font:(UIFont * _Nullable)font textColor:(UIColor * _Nullable)textColor
{
    if (self = [self initWithFrame:frame])
    {
        if (text != nil) {
            self.text = text;
        }
        if (font != nil) {
            self.font = font;
        }
        if (textColor != nil ) {
            self.textColor = textColor;
        }
    }
    return self;
}

/**
 快速初始化标签
 @param frame  Label's frame
 @param text  Label's text
 @param font  Label's font
 @param textColor  Label's textColor
 @param numberOfLines  Label's numberOfLines
 @return UILabel
 */
- (instancetype _Nonnull )initWithFrame:(CGRect)frame text:(NSString * _Nullable)text font:(UIFont * _Nullable)font textColor:(UIColor * _Nullable)textColor numberOfLines:(NSInteger)numberOfLines
{
    if (self = [self initWithFrame:frame]) {
        if (text != nil) {
            self.text = text;
        }
        if (font != nil) {
            self.font = font;
        }
        if (textColor != nil ) {
            self.textColor = textColor;
        }
        self.numberOfLines = numberOfLines;
    }
    return self;
}
@end
