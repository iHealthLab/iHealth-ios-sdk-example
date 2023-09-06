//
//  IHSDKFontConstant.m
//  iHealthDemoCode
//
//  Created by jing on 2023/4/11.
//  Copyright © 2023 iHealth Demo Code. All rights reserved.
//

#import "IHSDKFontConstant.h"

//默认字体
UIFont * IHSDKFontDefault(double size)
{
    return  IHSDKFontRegularStyle1(size);
}

#pragma mark - 常规
UIFont * IHSDKFontRegularStyle1(double size)
{
    return [UIFont fontWithName:@"TTNormsPro-Regular" size:size];
}

/**
* TTNormsPro-Normal
* @param size 字体大小
* @return UIFont
*/
UIFont * IHSDKFontRegularStyle2(double size)
{
    return [UIFont fontWithName:@"TTNormsPro-Normal" size:size];
}

/**
* TTNormsPro-Medium
* @param size 字体大小
* @return UIFont
*/
UIFont * IHSDKFontRegularStyle3(double size)
{
    return [UIFont fontWithName:@"TTNormsPro-Medium" size:size];
}

/**
* TTNormsPro-Light
* @param size 字体大小
* @return UIFont
*/
UIFont * IHSDKFontRegularStyle4(double size)
{
    return [UIFont fontWithName:@"TTNormsPro-Light" size:size];
}

/**
* TTNormsPro-Thin
* @param size 字体大小
* @return UIFont
*/
UIFont * IHSDKFontRegularStyle5(double size)
{
    return [UIFont fontWithName:@"TTNormsPro-Thin" size:size];
}

/**
* TTNormsPro-Black
* @param size 字体大小
* @return UIFont
*/
UIFont * IHSDKFontRegularStyle6(double size)
{
    return [UIFont fontWithName:@"TTNormsPro-Black" size:size];
}

/**
* TTNormsPro-ExtraBlack
* @param size 字体大小
* @return UIFont
*/
UIFont * IHSDKFontRegularStyle7(double size)
{
    return [UIFont fontWithName:@"TTNormsPro-ExtraBlack" size:size];
}

/**
* TTNormsPro-ExtraLight
* @param size 字体大小
* @return UIFont
*/
UIFont * IHSDKFontRegularStyle8(double size)
{
    return [UIFont fontWithName:@"TTNormsPro-ExtraLight" size:size];
}


#pragma mark - 粗体
/**
* TTNormsPro-Bold
* @param size 字体大小
* @return UIFont
*/
UIFont * IHSDKFontBoldStyle1(double size)
{
    return [UIFont fontWithName:@"TTNormsPro-Bold" size:size];
}

/**
* TTNormsPro-DemiBold
* @param size 字体大小
* @return UIFont
*/
UIFont * IHSDKFontBoldStyle2(double size)
{
    return [UIFont fontWithName:@"TTNormsPro-DemiBold" size:size];
}

/**
* TTNormsPro-ExtraBold
* @param size 字体大小
* @return UIFont
 */
UIFont * IHSDKFontBoldStyle3(double size)
{
    return [UIFont fontWithName:@"TTNormsPro-ExtraBold" size:size];
}


/**
 * Bebas
 * @param size 字体大小
 * @return UIFont
 */
UIFont * IHSDKFontPluginStyle1(double size)
{
    return [UIFont fontWithName:@"Bebas" size:size];
}

/**
 * Facon
 * @param size 字体大小
 * @return UIFont
 */
UIFont * IHSDKFontPluginStyle2(double size)
{
    return [UIFont fontWithName:@"Facon" size:size];
}

/**
* Louis George Cafe Bold
* @param size 字体大小
* @return UIFont
*/
UIFont * IHSDKFontPluginStyle3(double size)
{
    return [UIFont fontWithName:@"LouisGeorgeCafe-Bold" size:size];
}

