//
//  IHSDKDemoUIHeader.h
//  iHealthDemoCode
//
//  Created by jing on 2023/4/11.
//  Copyright © 2023 iHealth Demo Code. All rights reserved.
//

#ifndef IHSDKDemoUIHeader_h
#define IHSDKDemoUIHeader_h

#import "IHSDKDemoBundle.h"
#import "IHSDKFontConstant.h"
#import "IHSDKColorConstant.h"
#import "Masonry.h"
// UI通用颜色
#define kIHSDK_Background_Gray        IHSDK_COLOR_FROM_HEX(0xF1F3F3)//灰色
#define kIHSDK_Text_Black             IHSDK_COLOR_FROM_HEX(0x002632)//黑色
#define kIHSDK_Text_Black_2           IHSDK_COLOR_FROM_HEX(0x22262B)//黑色
#define kIHSDK_Text_Gray              IHSDK_COLOR_FROM_HEX(0x7E8D92)// 灰色
#define kIHSDK_Text_Gray_2            IHSDK_COLOR_FROM_HEX(0x515963)// 灰色 cell detaiLabel
#define kIHSDK_Text_Gray_Light        IHSDK_COLOR_FROM_HEX(0xAEBDC2)// 灰色
#define kIHSDK_Text_Gray_Disable      IHSDK_COLOR_FROM_HEX(0xC9D7DB)// 不可点的灰色
#define kIHSDK_Text_Gray_Disable_2    IHSDK_COLOR_FROM_HEX(0xA8B2BD)// 不可点的灰色
#define kIHSDK_Text_Wyze_Green        IHSDK_COLOR_FROM_HEX(0x00D0B9)
#define kIHSDK_Text_Wyze_Blue         IHSDK_COLOR_FROM_HEX(0x0CC4E7)

#define KIHSDKImageNamed(_name) [IHSDKDemoBundle imageNamed:_name]


#define IHSDK_FONT_Normal(x)  IHSDKFontRegularStyle2(x)
#define IHSDK_FONT_Regular(x) IHSDKFontRegularStyle1(x)
#define IHSDK_FONT_Light(x)   IHSDKFontRegularStyle4(x)
#define IHSDK_FONT_Medium(x)  IHSDKFontRegularStyle3(x)
#define IHSDK_FONT_Bold(x)    IHSDKFontBoldStyle1(x)
#define IHSDK_FONT_DemiBold(x) IHSDKFontBoldStyle2(x)

#pragma mark - 屏幕尺寸获取
#define IHSDK_SCREEN_W [[UIScreen mainScreen] bounds].size.width
#define IHSDK_SCREEN_H [[UIScreen mainScreen] bounds].size.height
#define IHSDK_STATUS_BAR_H  [[UIApplication sharedApplication] statusBarFrame].size.height //状态栏的高度
#define IHSDK_NAV_TITLE_BAR_H (IHSDK_STATUS_BAR_H+44)//状态栏+导航栏高度的
#define IHSDK_SAFEAREA_BOTTOM_H (IHSDK_isIPhoneX() ? 34 : 0)//安全安全区底部高度
#define IHSDK_TABBAR_H (IHSDK_SAFEAREA_BOTTOM_H+49)//底部安全区+tabbar高度

#define IHSDKSCREEN_MAX_LENGTH (MAX(IHSDK_SCREEN_W, IHSDK_SCREEN_H))
#define IHSDKSCREEN_MIN_LENGTH (MIN(IHSDK_SCREEN_W, IHSDK_SCREEN_H))

/** 机型 **/
#define IHSDKIS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IHSDKIS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)

#define IHSDKIS_IPHONE_5 (IHSDKIS_IPHONE && IHSDKSCREEN_MAX_LENGTH == 568.0)
#define IHSDKIS_IPHONE_6 (IHSDKIS_IPHONE && IHSDKSCREEN_MAX_LENGTH == 667.0)
#define IHSDKIS_IPHONE_6P (IHSDKIS_IPHONE && IHSDKSCREEN_MAX_LENGTH == 736.0)
#define IHSDKIS_IPHONE_X_XS_11Pro_ (IHSDKIS_IPHONE && IHSDKSCREEN_MAX_LENGTH == 812.0)
#define IHSDKIS_IPHONE_XR_XRMAX_11_11ProMax (IHSDKIS_IPHONE && IHSDKSCREEN_MAX_LENGTH == 896.0)
#define IHSDKIS_IPHONE_12_12Pro (IHSDKIS_IPHONE && IHSDKSCREEN_MAX_LENGTH == 844.0)
#define IHSDKIS_IPHONE_12mini (IHSDKIS_IPHONE && IHSDKSCREEN_MAX_LENGTH == 780.0)
#define IHSDKIS_IPHONE_12ProMax (IHSDKIS_IPHONE && IHSDKSCREEN_MAX_LENGTH == 926.0)

/* iOS version*/

#define IHSDKiOSVersion [[UIDevice currentDevice].systemVersion floatValue]


#define IHSDK_StatusBarHeight  [[UIApplication sharedApplication] statusBarFrame].size.height


#endif /* IHSDKDemoUIHeader_h */
