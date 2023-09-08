//
//  AM6TimePicker.h
//  iHealthDemoCode
//
//  Created by Spring on 2023/6/13.
//  Copyright © 2023 iHealth Demo Code. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WPKDateIntervalView.h"
NS_ASSUME_NONNULL_BEGIN

@interface AM6TimePicker :  WPKDateIntervalView
@property (copy, nonatomic) void(^onSelctionCallback)(NSInteger hours,NSInteger minutes);
- (instancetype)initWithTitle:(NSString*)title is12hoursFormat:(BOOL)is12hoursFormat currentValues:(nullable NSArray *)currentValues;

@end

NS_ASSUME_NONNULL_END
