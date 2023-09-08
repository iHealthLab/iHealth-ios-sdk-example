//
//  IHSDKDemoBundle.h
//  iHealthDemoCode
//
//  Created by jing on 2023/4/11.
//  Copyright © 2023 iHealth Demo Code. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, IHSDKLanguageType) {
    /**英文*/
    IHSDKLanguageType_EN,
    /**简体中文*/
    IHSDKLanguageType_CHS,
    /**繁体中文*/
    IHSDKLanguageType_CHT,
};

/**
 使用方法：
 每个模块继承本类，并实现 currentResourceBundleName 方法,
 在该方法返回当前模块资源包的名称，
 每个模块调用时，直接使用子类调用所需的方法
 */
NS_ASSUME_NONNULL_BEGIN

extern NSString *const AppLanguageDidChangedNotification;

@interface IHSDKDemoBundle : NSObject
/**
 * 该方法需要子类实现，返回资源包名称
 */
+ (NSString *_Nullable)currentResourceBundleName;

/**
 * 设置语言。传nil表示使用系统设置
 */
+ (void)setUserSelectedLanguage:(NSString *)language;

/**
 * 返回用户设置的语言，返回nil表示用户希望使用系统设置
 */
+ (NSString *)userSelectedLanguage;

/**
 * 获取工程支持语言下的当前语言，如果遇到工程不支持的语言，默认 en
 */
+ (IHSDKLanguageType)currentLanguage;

/**
 * 获取当前模块的 Bundle
 */
+ (NSBundle *)currentBundle;

/**
 * 根据图片名称加载当前模块的图片资源
 */
+ (UIImage *)imageNamed:(NSString *)name;

/**
 根据图片名称和格式，在当前 bundle 下获取图片
 内部采用 imageWithContentsOfFile 方法获取图片资源
 
 @param resource 图片名称
 @param type 图片格式
 @return 图片实例
 */
+ (UIImage *)imageForResource:(NSString *)resource ofType:(NSString *)type;

/**
 在当前 bundle 下，根据文件名称和文件格式获取文件路径
 
 @param resource 文件名称
 @param type 文件格式
 @return 文件路径
 */
+ (NSString *)pathForResource:(NSString *)resource ofType:(NSString *)type;

/**
 * 在当前模块获取key对应的国际化字符串
 */
+ (NSString *)localizedStringForKey:(NSString *)key;

/**
 * 在当前模块获取key对应的国际化字符串
 */
+ (NSString *)localizedStringForKey:(NSString *)key value:(NSString *)value;

/**
 * 获取当前语言的字符串(私有属性)
 */
+ (NSString *)p_currentLanguage;

/**
 * 获取当前bundel的信息
 */
+ (NSDictionary *)IHSDK_infoDictionary;

/**
 * 获取当前bundel的版本
 * ⚠️⚠️ ⚠️⚠️ 不适用podspec的版本为4位的,版本号为4位请自行控制
 */
+ (NSString *)IHSDK_infoDictionaryVersion;
/**
 * 获取当前bundel的名字
 */
+ (NSString *)IHSDK_infoDictionaryName;
@end


NS_ASSUME_NONNULL_END
