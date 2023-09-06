//
//  IHDeviceSDKLog.h
//  iHealthDeviceSDK
//  Use this class to control and receive log.
//  Created by Lei Bao on 2022/10/12.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol IHDeviceSDKLogDelegate <NSObject>

@required
- (void)iHealthSDKLogUpdate:(NSString*)log;

@end

@interface IHDeviceSDKLog : NSObject

@property (assign, nonatomic, readonly) BOOL isEnableLog;
@property (weak, nonatomic) id<IHDeviceSDKLogDelegate> delegate;

@property(nonatomic, strong) NSFileHandle *fileHandle;

/// Return a singleton
+ (instancetype)sharedInstance;

/// Enable log print
- (void)enableLog;

/// Disable log print
- (void)disableLog;
@end

NS_ASSUME_NONNULL_END
