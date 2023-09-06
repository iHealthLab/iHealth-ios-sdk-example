//
//  IHSDKColorConstant.h
//  iHealthDemoCode
//
//  Created by jing on 2023/4/11.
//  Copyright © 2023 iHealth Demo Code. All rights reserved.
//

/**
 * 常用的颜色定义，可以供外部插件直接使用
 */

#ifndef IHSDKColorConstant_h
#define IHSDKColorConstant_h

#pragma mark - 颜色转换
#define IHSDK_COLOR_FROM_HEX(s) [UIColor colorWithRed:(((s & 0xFF0000) >> 16))/255.0 green:(((s &0xFF00) >>8))/255.0 blue:((s &0xFF))/255.0 alpha:1.0]//16进制设置颜色
#define IHSDK_COLOR_FROM_HEX_A(s,a) [UIColor colorWithRed:(((s & 0xFF0000) >> 16))/255.0 green:(((s &0xFF00) >>8))/255.0 blue:((s &0xFF))/255.0 alpha:a]//16进制设置颜色，与透明度
#define IHSDK_COLOR(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]//直接设置颜色
#define IHSDK_COLOR_A(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:a]//直接设置颜色
#define IHSDK_COLOR_RGBF(r, g, b, a) [UIColor colorWithRed:(r) green:(g) blue:(b) alpha:a]//直接设置颜色
#define IHSDK_RANDOM_COLOR IHSDK_COLOR(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256)) //随机色

#pragma mark - 常用颜色
#define IHSDK_COLOR_THEME IHSDK_COLOR_FROM_HEX(0x00D0B9)//main 色
#define IHSDK_COLOR_BLUE IHSDK_COLOR_FROM_HEX(0x0CC4E7)//蓝色 第二色
#define IHSDK_COLOR_BLACK IHSDK_COLOR_FROM_HEX(0x002632) //黑色

#define IHSDK_COLOR_DATA_GRAY  IHSDK_COLOR_FROM_HEX(0x7E8D92)//mate data
#define IHSDK_COLOR_DISABLE_GRAY IHSDK_COLOR_FROM_HEX(0xC9D7DB) //不可点击的灰色
#define IHSDK_COLOR_GRAY IHSDK_COLOR_FROM_HEX(0xF1F3F3) //灰色

#define IHSDK_COLOR_RED IHSDK_COLOR_FROM_HEX(0xD65035) //红色
#define IHSDK_COLOR_WHITE IHSDK_COLOR_FROM_HEX(0xffffff) //白色

#define IHSDK_COLOR_BKG IHSDK_COLOR_FROM_HEX(0xF0F4F7) //背景色灰色 IHSDK_COLOR_GREY_200

#define IHSDK_COLOR_GREEN IHSDK_COLOR_FROM_HEX(0x1C9E90)//按钮绿色   Alternate Green
#define IHSDK_COLOR_ALERT_GRAY IHSDK_COLOR_FROM_HEX(0x6A737D)//按钮灰色  IHSDK_COLOR_GREY_600
#define IHSDK_COLOR_TEXT_GRAY IHSDK_COLOR_FROM_HEX(0x515963)//文本灰色 IHSDK_COLOR_GREY_700
#define IHSDK_COLOR_ALERT_BLACK IHSDK_COLOR_FROM_HEX(0x393F47)//标题文本黑色  IHSDK_COLOR_GREY_800
#define IHSDK_COLOR_ALERT_LINE_BLACK IHSDK_COLOR_FROM_HEX(0xCED6DE)//输入框颜色 IHSDK_COLOR_GREY_400
#define IHSDK_COLOR_ALERT_BKG IHSDK_COLOR_FROM_HEX(0xE6EBF0)//输入框背景颜色 IHSDK_COLOR_GREY_300
#define IHSDK_COLOR_ALERT_RED IHSDK_COLOR_FROM_HEX(0xBE4027) //弹框红色  Alternate Red

#define IHSDK_COLOR_GREY_900 IHSDK_COLOR_FROM_HEX(0x22262B)
#define IHSDK_COLOR_GREY_800 IHSDK_COLOR_FROM_HEX(0x393F47)
#define IHSDK_COLOR_GREY_700 IHSDK_COLOR_FROM_HEX(0x515963)
#define IHSDK_COLOR_GREY_600 IHSDK_COLOR_FROM_HEX(0x6A737D)
#define IHSDK_COLOR_GREY_500 IHSDK_COLOR_FROM_HEX(0xA8B2BD)
#define IHSDK_COLOR_GREY_400 IHSDK_COLOR_FROM_HEX(0xCED6DE)
#define IHSDK_COLOR_GREY_300 IHSDK_COLOR_FROM_HEX(0xE6EBF0)
#define IHSDK_COLOR_GREY_200 IHSDK_COLOR_FROM_HEX(0xF0F4F7)
#define IHSDK_COLOR_GREY_100 IHSDK_COLOR_FROM_HEX(0xF7FAFC)


#define IHSDK_COLOR_SAFETY_BLUE_GRADIENT @[IHSDK_COLOR_FROM_HEX(0x72A4F1), IHSDK_COLOR_FROM_HEX(0x4580F7)]
#define IHSDK_COLOR_ALARM_RED_GRADIENT @[IHSDK_COLOR_FROM_HEX(0xDD847E), IHSDK_COLOR_FROM_HEX(0xD65270)]
#define IHSDK_COLOR_GREEN_BLUE_GRADIENT @[IHSDK_COLOR_FROM_HEX(0x00D0B9), IHSDK_COLOR_FROM_HEX(0x0CC4E7)]

#pragma mark ------------------------------------------------- UI 2.0 新版颜色定义 ---------------------------
typedef NS_ENUM(NSInteger, IHSDKUIUserInterfaceStyle) {
    IHSDKUIUserInterfaceStyleUnspecified,//
    IHSDKUIUserInterfaceStyleLight,//浅色模式
    IHSDKUIUserInterfaceStyleDark,//暗黑模式
};

/**
 * 16进制转换颜色
 */
UIColor *IHSDKColorWithHex(long s);

//2.25版本会删掉
UIColor *wyzeColorWithHex(long s) DEPRECATED_MSG_ATTRIBUTE("Use IHSDKColorWithHex instead.");

#pragma mark - 常用颜色
/**
 * 0x00D0B9
 */
UIColor *IHSDK_green_core(void);

/**
 * 0x1C9E90
 */
UIColor *IHSDK_green_alt(void);

//2.25版本会删掉
UIColor *wyze_green_alt(void) DEPRECATED_MSG_ATTRIBUTE("Use IHSDK_green_alt instead.");

/**
 * 0xD65035
 */
UIColor *IHSDK_red_core(void);

/**
 * 0xBE4027
 */
UIColor *IHSDK_red_alt(void);

/**
 * 0x22262B
 */
UIColor *IHSDK_gray_900(void);

/**
 * 0x393F47
 */
UIColor *IHSDK_gray_800(void);

//2.25版本会删掉
UIColor *wyze_gray_800(void) DEPRECATED_MSG_ATTRIBUTE("Use IHSDK_green_alt instead.");

/**
 * 0x515963
 */
UIColor *IHSDK_gray_700(void);

//2.25版本会删掉
UIColor *wyze_gray_700(void) DEPRECATED_MSG_ATTRIBUTE("Use IHSDK_green_alt instead.");

/**
 * 0x6A737D
 */
UIColor *IHSDK_gray_600(void);

//2.25版本会删掉
UIColor *wyze_gray_600(void) DEPRECATED_MSG_ATTRIBUTE("use IHSDK_gray_600 instead");

/**
 * 0xA8B2BD
 */
UIColor *IHSDK_gray_500(void);

/**
 * 0xCED6DE
 */
UIColor *IHSDK_gray_400(void);

/**
 * 0xE6EBF0
 */
UIColor *IHSDK_gray_300(void);

/**
 * 0xF0F4F7
 */
UIColor *IHSDK_gray_200(void);

//2.25版本会删掉
UIColor *wyze_gray_200(void) DEPRECATED_MSG_ATTRIBUTE("use IHSDK_gray_200 instead");

/**
 * 0xF7FAFC
 */
UIColor *IHSDK_gray_100(void);

/**
 * 0xFFFFFF
 */
UIColor *IHSDK_white(void);

#pragma mark - 获取当前 手机显示模式

/**
 * 获取当前 手机显示模式
 */
IHSDKUIUserInterfaceStyle IHSDKStatusBarStyle(void);

#pragma mark - 获取模式下的颜色

/**
 * 获取模式下的颜色
 * @param lightColor 正常模式颜色
 * @param darkColor 暗黑模式颜色
 */
UIColor *IHSDKThemeColor(UIColor *lightColor, UIColor *darkColor, ...);
#endif /* IHSDKColorConstant_h */


#pragma mark - 获取适配的
BOOL IHSDK_isIPhoneX(void);
BOOL IHSDK_isIPad(void);

CGFloat IHSDK_getScaleWithWidth(void);
CGFloat IHSDK_getScaleWithHeight(void);

#pragma mark - 线程
void ihsdk_dispatchMain(void (^block)(void));
void ihsdk_after(double time, void (^block)(void));



