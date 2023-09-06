//
//  IHSDKColorConstant.m
//  iHealthDemoCode
//
//  Created by jing on 2023/4/11.
//  Copyright © 2023 iHealth Demo Code. All rights reserved.
//

#import "IHSDKColorConstant.h"

#import <UIKit/UIKit.h>

/**
 * 16进制颜色
 */
UIColor *IHSDKColorWithHex(long s)
{
    return [UIColor colorWithRed:(((s & 0xFF0000) >> 16))/255.0 green:(((s &0xFF00) >>8))/255.0 blue:((s &0xFF))/255.0 alpha:1.0];
}

UIColor *wyzeColorWithHex(long s)
{
    return [UIColor colorWithRed:(((s & 0xFF0000) >> 16))/255.0 green:(((s &0xFF00) >>8))/255.0 blue:((s &0xFF))/255.0 alpha:1.0];
}


/**
 * 0x00D0B9
 */
UIColor *IHSDK_green_core(void)
{
    return IHSDKColorWithHex(0x00D0B9);
}

/**
 * 0x1C9E90
 */
UIColor *IHSDK_green_alt(void)
{
    return IHSDKColorWithHex(0x1C9E90);
}

UIColor *wyze_green_alt(void)
{
    return IHSDKColorWithHex(0x1C9E90);
}

/**
 * 0xD65035
 */
UIColor *IHSDK_red_core(void)
{
    return IHSDKColorWithHex(0xD65035);
}

/**
 * 0xBE4027
 */
UIColor *IHSDK_red_alt(void)
{
    return IHSDKColorWithHex(0xBE4027);
}

/**
 * 0x22262B
 */
UIColor *IHSDK_gray_900(void)
{
    return IHSDKColorWithHex(0x22262B);
}

/**
 * 0x393F47
 */
UIColor *IHSDK_gray_800(void)
{
    return IHSDKColorWithHex(0x393F47);
}

UIColor *wyze_gray_800(void)
{
    return IHSDKColorWithHex(0x393F47);
}

/**
 * 0x515963
 */
UIColor *IHSDK_gray_700(void)//0x515963
{
    return IHSDKColorWithHex(0x515963);
}

UIColor *wyze_gray_700(void)//0x515963
{
    return IHSDKColorWithHex(0x515963);
}

/**
 * 0x6A737D
 */
UIColor *IHSDK_gray_600(void)
{
    return IHSDKColorWithHex(0x6A737D);
}

UIColor *wyze_gray_600(void)
{
    return IHSDKColorWithHex(0x6A737D);
}

/**
 * 0xA8B2BD
 */
UIColor *IHSDK_gray_500(void)
{
    return IHSDKColorWithHex(0xA8B2BD);
}

/**
 * 0xCED6DE
 */
UIColor *IHSDK_gray_400(void)
{
    return IHSDKColorWithHex(0xCED6DE);
}

/**
 * 0xE6EBF0
 */
UIColor *IHSDK_gray_300(void)
{
    return IHSDKColorWithHex(0xE6EBF0);
}

/**
 * 0xF0F4F7
 */
UIColor *IHSDK_gray_200(void)
{
    return IHSDKColorWithHex(0xF0F4F7);
}

UIColor *wyze_gray_200(void)
{
    return IHSDKColorWithHex(0xF0F4F7);
}

/**
 * 0xF7FAFC
 */
UIColor *IHSDK_gray_100(void)
{
    return IHSDKColorWithHex(0xF7FAFC);
}

/**
 * 0xFFFFFF
 */
UIColor *IHSDK_white(void)
{
    return IHSDKColorWithHex(0xFFFFFF);
}

#pragma mark - 获取当前 手机显示模式
IHSDKUIUserInterfaceStyle IHSDKStatusBarStyle(void)
{
    if (@available(iOS 13.0, *)) {
        switch (UITraitCollection.currentTraitCollection.userInterfaceStyle) {
            case UIUserInterfaceStyleUnspecified:
                return IHSDKUIUserInterfaceStyleUnspecified;
                break;
            case UIUserInterfaceStyleLight:
                return IHSDKUIUserInterfaceStyleLight;
                break;
            case UIUserInterfaceStyleDark:
                return IHSDKUIUserInterfaceStyleDark;
                break;
            default:
                break;
        }
        return IHSDKUIUserInterfaceStyleUnspecified;
    } else {
        return IHSDKUIUserInterfaceStyleLight;
    }
}


UIColor *IHSDKThemeColor(UIColor *lightColor, UIColor *darkColor, ...)
{
    IHSDKUIUserInterfaceStyle style = IHSDKStatusBarStyle();
    if (style == IHSDKUIUserInterfaceStyleDark && darkColor) {
        return darkColor;
    }
    return lightColor;
}


#pragma mark - 获取适配的
BOOL IHSDK_isIPhoneX()//PhoneX系列的屏幕
{
    static BOOL _wpk_isiPhoneX;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (@available(iOS 11.0, *)) {
            _wpk_isiPhoneX = [[UIApplication sharedApplication] delegate].window.safeAreaInsets.bottom > 0.0;
        }
    });
    return _wpk_isiPhoneX;
}

BOOL IHSDK_isIPad(void)
{
    static BOOL _wpk_isIPad;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _wpk_isIPad = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);
    });
    return _wpk_isIPad;
}

CGFloat IHSDK_getScaleWithWidth(void)
{
    static CGFloat _wpk_scaleWidth;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _wpk_scaleWidth =[UIScreen mainScreen].bounds.size.width / 375.f;
        if ([UIScreen mainScreen].bounds.size.width > 414) {
            _wpk_scaleWidth = 1.5f;
        }
        if ([UIScreen mainScreen].bounds.size.width < 375) {
            _wpk_scaleWidth = 0.8f;
        }
    });
    return _wpk_scaleWidth;
}

CGFloat IHSDK_getScaleWithHeight(void)
{
    static CGFloat _wpk_scaleHeight;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _wpk_scaleHeight = [UIScreen mainScreen].bounds.size.height / 667.f;
    });
    return _wpk_scaleHeight;
}

#pragma mark - 线程
void ihsdk_dispatchMain(void (^block)(void))
{
    if ([NSThread isMainThread]) {
        if (block) {
            block();
        }
    } else {
        dispatch_async(dispatch_get_main_queue(), block);
    }
}

void ihsdk_after(double time, void (^block)(void))
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (block) {
            block();
        }
    });
}

