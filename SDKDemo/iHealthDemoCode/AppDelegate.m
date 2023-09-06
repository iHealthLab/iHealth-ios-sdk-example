//
//  AppDelegate.m
//  iHealthDemoCode
//
//  Created by zhiwei jing on 14-9-23.
//  Copyright (c) 2014年 zhiwei jing. All rights reserved.
//

#import "AppDelegate.h"
#import "ScanDeviceController.h"
#import "IHDeviceSDKLog.h"
#import "SDKDemoHomeVC.h"
//#import "IDOBluetoothServices.h"

@interface AppDelegate ()<IHDeviceSDKLogDelegate>

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
//    registrationServices().outputSdkLog(YES).outputProtocolLog(YES);

    // Override point for customization after application launch.
//    UIDevice *device = [UIDevice currentDevice];
//    if (![[device model]isEqualToString:@"iPad Simulator"]) {
        // 开始保存日志文件
//        [self redirectNSlogToDocumentFolder];
//    }
    
//    [ScanDeviceController commandGetInstance];
    
    
//    NSString *aPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"20160229184312.dat"];
//    NSString *bPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"20160229184312.txt"];
//    NSLog(@"aPath:%@ \nbPath:%@",aPath,bPath);
//    [[ECG3Filter sharedInstance] filterWithAFilePath:aPath bFilePath:bPath finishBlock:^(NSDictionary *resultDic) {
//        NSLog(@"滤波完成：%@",resultDic);
//
//    }];
    [[IHDeviceSDKLog sharedInstance]enableLog];
    [IHDeviceSDKLog sharedInstance].delegate = self;
    
    
    self.window = [UIWindow new];
    SDKDemoHomeVC *vc = [SDKDemoHomeVC new];
    self.window.rootViewController = [[UINavigationController alloc]initWithRootViewController:vc];
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)redirectNSlogToDocumentFolder
{
    NSArray *paths =NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    NSString *fileName = [NSString stringWithFormat:@"dr.log"];//注意不是NSData!
    NSString *logFilePath = [documentDirectory stringByAppendingPathComponent:fileName];
    //先删除已经存在的文件
    NSFileManager *defaultManager = [NSFileManager defaultManager];
    [defaultManager removeItemAtPath:logFilePath error:nil];
    
    // 将log输入到文件
    freopen([logFilePath cStringUsingEncoding:NSASCIIStringEncoding],"a+", stdout);
    freopen([logFilePath cStringUsingEncoding:NSASCIIStringEncoding],"a+", stderr);
}
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
//    UIApplication*   app = [UIApplication sharedApplication];
//    __block    UIBackgroundTaskIdentifier bgTask;
//    bgTask = [app beginBackgroundTaskWithExpirationHandler:^{
//        dispatch_async(dispatch_get_main_queue(), ^{
//            DLog(@"backgroundTime end");
//            if (bgTask != UIBackgroundTaskInvalid)
//            {
//                bgTask = UIBackgroundTaskInvalid;
//            }
//        });
//    }];

}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
- (void)iHealthSDKLogUpdate:(NSString *)log{
    NSLog(@"%@",log);
}
@end
