//
//  UIColor+IHSDKColor.h
//  iHealthDemoCode
//
//  Created by Spring on 2023/5/30.
//  Copyright © 2023 iHealth Demo Code. All rights reserved.
//

#import <Foundation/Foundation.h>

#define IHRGBA_COLOR(R, G, B, A) [UIColor colorWithRed:((R) / 255.0f) green:((G) / 255.0f) blue:((B) / 255.0f) alpha:A]
#define IHRGB_COLOR(R, G, B) [UIColor colorWithRed:((R) / 255.0f) green:((G) / 255.0f) blue:((B) / 255.0f) alpha:1.0f]


NS_ASSUME_NONNULL_BEGIN

@interface UIColor(IHSDKColor)

+ (UIColor *)colorWithHexString:(NSString *)color;

+ (UIColor *)colorWithHexString:(NSString *)color alpha:(CGFloat)alpha;

@end

NS_ASSUME_NONNULL_END
