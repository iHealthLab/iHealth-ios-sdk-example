//
//  IHSDKDemoBundle.m
//  iHealthDemoCode
//
//  Created by jing on 2023/4/11.
//  Copyright © 2023 iHealth Demo Code. All rights reserved.
//

#import "IHSDKDemoBundle.h"

#define User_Selected_Language @"language"
#define IHSDKBundleLock(lock) dispatch_semaphore_wait(lock, DISPATCH_TIME_FOREVER);
#define IHSDKBundleUnlock(lock) dispatch_semaphore_signal(lock);

static NSMapTable *bdMap;
static dispatch_semaphore_t bdLock;

NSString *const AppLanguageDidChangedNotification = @"AppLanguageDidChangedNotification";

@implementation IHSDKDemoBundle

+ (void)load
{
    bdLock = dispatch_semaphore_create(1);
    bdMap = [NSMapTable new];
}

+ (NSBundle *)currentBundle
{
    NSString *currentBundleName = [self currentResourceBundleName];
    if (!currentBundleName) return [NSBundle mainBundle];
    
    NSBundle *bd = [bdMap objectForKey:currentBundleName];
    if (bd) {
        return bd;
    } else {
        NSURL *currentBundleURL = [[NSBundle mainBundle] URLForResource:currentBundleName withExtension:@"bundle"];
        NSBundle *currentBundle;
        if (!currentBundleURL) {//组件 Demo 工程使用
            currentBundle = [NSBundle bundleForClass:[self class]];
            NSURL *bundleUrl = [currentBundle URLForResource:currentBundle.infoDictionary[@"CFBundleName"] withExtension:@"bundle"];
            if (bundleUrl != nil) {
                currentBundle = [NSBundle bundleWithURL:bundleUrl];
            }
        } else {//壳工程使用
            currentBundle = [NSBundle bundleWithURL:currentBundleURL];
        }
        if (bdLock == nil) {
            bdLock = dispatch_semaphore_create(1);
            bdMap = [NSMapTable new];
        }
        IHSDKBundleLock(bdLock);
        NSMapTable *mapTabel = bdMap.copy;
        [mapTabel setObject:currentBundle forKey:currentBundleName];
        bdMap = mapTabel;
        IHSDKBundleUnlock(bdLock);
        return currentBundle;
    }
}

+ (void)setUserSelectedLanguage:(NSString *)language
{
    if (!language) {
        // 传nil表示要使用系统设置
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:User_Selected_Language];
    } else {
        [[NSUserDefaults standardUserDefaults] setObject:language forKey:User_Selected_Language];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:AppLanguageDidChangedNotification object:self];
}

+ (NSString *)userSelectedLanguage
{
    return [NSUserDefaults.standardUserDefaults objectForKey:User_Selected_Language];
}

+ (IHSDKLanguageType)currentLanguage
{
    NSString *language = [self p_currentLanguage];
    if ([language isEqualToString:@"en"]) {
        return IHSDKLanguageType_EN;
    } else if ([language isEqualToString:@"zh-Hans"]) {
        return IHSDKLanguageType_CHS;
    } else if ([language isEqualToString:@"zh-Hant"]) {
        return IHSDKLanguageType_CHT;
    } else {
        return IHSDKLanguageType_EN;
    }
}

+ (UIImage *)imageNamed:(NSString *)name
{
    if (@available(iOS 8.0, *)) {
        return [UIImage imageNamed:name inBundle:[self currentBundle] compatibleWithTraitCollection:nil];
    } else {
        // Fallback on earlier versions
       return  [UIImage imageNamed:name];
    }
}

+ (UIImage *)imageForResource:(NSString *)resource ofType:(NSString *)type
{
    return [UIImage imageWithContentsOfFile:[self pathForResource:resource ofType:type]];
}

+ (NSString *)pathForResource:(NSString *)resource ofType:(NSString *)type
{
    return [[self currentBundle] pathForResource:resource ofType:type];
}


+ (NSString *)localizedStringForKey:(NSString *)key
{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wnonnull"
    return [self localizedStringForKey:key value:nil];
#pragma clang diagnostic pop
}

+ (NSString *)localizedStringForKey:(NSString *)key value:(NSString *)value
{
    NSString *currentResourceLanguage = [self p_currentResourceLanguage:[self p_currentLanguage]];
    
    NSBundle *pluginBundle = [self currentBundle];
    NSString *coveredStr = nil;
    if (pluginBundle) {//优先读取插件
        NSBundle *currentLocalizableBundle = [NSBundle bundleWithPath:[[self currentBundle] pathForResource:currentResourceLanguage ofType:@"lproj"]];
        coveredStr = NSLocalizedStringFromTableInBundle(key, @"Localizable", currentLocalizableBundle, value);
    }
    if (coveredStr) {
        return coveredStr;
    }
    
    NSBundle *mainLocalizableBundle = [NSBundle bundleWithPath:[NSBundle.mainBundle pathForResource:currentResourceLanguage ofType:@"lproj"]];
    coveredStr = NSLocalizedStringFromTableInBundle(key, @"Localizable", mainLocalizableBundle, nil);//读取壳工程国际化文件
    if (coveredStr) {
        return coveredStr;
    }
    return nil;
}

#pragma mark -
+ (NSString *)p_currentResourceLanguage:(NSString *)language
{
    return language;
}

+ (NSString *)p_currentLanguage
{
    NSString *language = [self userSelectedLanguage];
    if (!language) {
        language = [NSLocale preferredLanguages].firstObject;
    }
    //中文特殊处理
    if ([language hasPrefix:@"zh"]) {
        language = ([language rangeOfString:@"Hans"].location != NSNotFound) ? @"zh-Hans" : @"zh-Hant";
    }
    //是否包含语言包
    BOOL supportLanguage = [[[self currentBundle] localizations] containsObject:[self p_currentResourceLanguage:language]];
    //工程不支持该语言包则默认英文
    if (!supportLanguage) {
        language = @"en";
    }
    return language;
}

#pragma mark -

+ (NSString * _Nullable)currentResourceBundleName
{
    //For subclass
    return nil;
}

/**
 * 获取当前bundel的信息
 */
+ (NSDictionary *)IHSDK_infoDictionary
{
    NSDictionary *infoDictionary = [[self currentBundle] infoDictionary];//读取插件版本
    return infoDictionary;
}


/**
 * 获取当前bundel的版本
 * ⚠️⚠️ ⚠️⚠️不适用podspec的版本为4位的,版本号为4位请自行控制
 */
+ (NSString *)IHSDK_infoDictionaryVersion
{
    NSDictionary *infoDictionary = [[self currentBundle] infoDictionary];//读取插件版本
    NSString *version = @"";
    if (infoDictionary) {
        version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    }
    return version;
}

/**
 * 获取当前bundle的名字
 */
+ (NSString *)IHSDK_infoDictionaryName
{
    NSDictionary *infoDictionary = [[self currentBundle] infoDictionary];//读取插件版本
    NSString *name = @"";
    if (infoDictionary) {
         name = [infoDictionary objectForKey:@"CFBundleDisplayName"];
        if (name == nil || name == Nil || ([name isEqualToString:@""] == true)) {
            name = [infoDictionary objectForKey:@"CFBundleName"];
        }
    }
    return name;
}

@end
