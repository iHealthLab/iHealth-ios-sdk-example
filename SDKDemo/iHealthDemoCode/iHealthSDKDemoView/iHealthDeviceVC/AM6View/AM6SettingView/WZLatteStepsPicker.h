//
//  WZLatteStepsPicker.h
//  WyzeLatte
//
//  Created by Lei Bao on 2021/3/26.
//

#import "WPKDateIntervalView.h"

NS_ASSUME_NONNULL_BEGIN

@interface WZLatteStepsPicker : WPKDateIntervalView
@property (copy, nonatomic) void(^onSelctionCallback)(NSInteger value);
- (instancetype)initWithTitle:(NSString*)title currentValue:(NSInteger)currentValue;
@end

NS_ASSUME_NONNULL_END
