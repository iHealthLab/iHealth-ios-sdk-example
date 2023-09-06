//
//  IHSDKFontConstant.h
//  iHealthDemoCode
//
//  Created by jing on 2023/4/11.
//  Copyright © 2023 iHealth Demo Code. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * 常用字体定义 IHSDK 字体定义的第一层 token
 */
#ifndef IHSDKFontConstant_h
#define IHSDKFontConstant_h

#pragma mark - 系统字体
#define IHSDK_SYSTEM_FONT(f) [UIFont systemFontOfSize:f]
#define IHSDK_SYSTEM_MIDUM_FONE(f) [UIFont systemFontOfSize:f weight:UIFontWeightMedium]

//wyze 字体
/**
 * TTNormsPro-Regular
 * @param size 字体大小
 * @return UIFont
 */
UIFont * IHSDKFontDefault(double size);

/**
 * TTNormsPro-Regular
 * @param size 字体大小
 * @return UIFont
 */
UIFont * IHSDKFontRegularStyle1(double size);

/**
* TTNormsPro-Normal
* @param size 字体大小
* @return UIFont
*/
UIFont * IHSDKFontRegularStyle2(double size);

/**
* TTNormsPro-Medium
* @param size 字体大小
* @return UIFont
*/
UIFont * IHSDKFontRegularStyle3(double size);

/**
* TTNormsPro-Light
* @param size 字体大小
* @return UIFont
*/
UIFont * IHSDKFontRegularStyle4(double size);

/**
* TTNormsPro-Thin
* @param size 字体大小
* @return UIFont
*/
UIFont * IHSDKFontRegularStyle5(double size);

/**
* TTNormsPro-Black
* @param size 字体大小
* @return UIFont
*/
UIFont * IHSDKFontRegularStyle6(double size);

/**
* TTNormsPro-ExtraBlack
* @param size 字体大小
* @return UIFont
*/
UIFont * IHSDKFontRegularStyle7(double size);

/**
* TTNormsPro-ExtraLight
* @param size 字体大小
* @return UIFont
*/
UIFont * IHSDKFontRegularStyle8(double size);

#pragma mark - 粗体
/**
* TTNormsPro-Bold
* @param size 字体大小
* @return UIFont
*/
UIFont * IHSDKFontBoldStyle1(double size);

/**
* TTNormsPro-DemiBold
* @param size 字体大小
* @return UIFont
*/
UIFont * IHSDKFontBoldStyle2(double size);

/**
* TTNormsPro-ExtraBold
* @param size 字体大小
* @return UIFont
*/
UIFont * IHSDKFontBoldStyle3(double size);


#pragma mark - 插件字体
/**
* Bebas
* @param size 字体大小
* @return UIFont
*/
UIFont * IHSDKFontPluginStyle1(double size);


/**
* Facon
* @param size 字体大小
* @return UIFont
*/
UIFont * IHSDKFontPluginStyle2(double size);

/**
* Louis George Cafe Bold
* @param size 字体大小
* @return UIFont
*/
UIFont * IHSDKFontPluginStyle3(double size);

#endif /* IHSDKFontConstant_h */
