//
//  BG1ANavigationBar.h
//  iHealthDemoCode
//
//  Created by Spring on 2023/6/1.
//  Copyright © 2023 iHealth Demo Code. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface IHSDKBG1ANavigationBar : UIView

@property (nonatomic, strong) UIButton *leftItem;
@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UIButton *rightItem;
@property (nonatomic, strong) CAGradientLayer *gradientLayer;

@property (nonatomic, copy) void (^leftItemBlock)(void);
@property (nonatomic, copy) void (^rightItemBlock)(void);
@end

NS_ASSUME_NONNULL_END
