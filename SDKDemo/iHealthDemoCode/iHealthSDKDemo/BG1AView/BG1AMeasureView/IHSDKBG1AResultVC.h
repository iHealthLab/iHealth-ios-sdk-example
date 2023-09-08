//
//  IHSDKBG1AResultVC.h
//  iHealthDemoCode
//
//  Created by Spring on 2023/6/5.
//  Copyright © 2023 iHealth Demo Code. All rights reserved.
//

#import "IHSDKBG1ABaseController.h"

NS_ASSUME_NONNULL_BEGIN

@interface IHSDKBG1AResultVC : IHSDKBG1ABaseController

@property (strong, nonatomic) NSString *deviceMac;

@property (strong, nonatomic) NSNumber *result;

@end

NS_ASSUME_NONNULL_END
