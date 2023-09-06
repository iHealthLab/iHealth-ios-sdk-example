//
//  BG1ABaseController.h
//  iHealthDemoCode
//
//  Created by Spring on 2023/6/1.
//  Copyright © 2023 iHealth Demo Code. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "IHSDKBG1ANavigationBar.h"

NS_ASSUME_NONNULL_BEGIN

@interface IHSDKBG1ABaseController : UIViewController
@property (nonatomic, strong) IHSDKBG1ANavigationBar *navigationBar;
@property (nonatomic, copy) NSString *vcTitle;
- (void)leftItemAction;
- (void)rightItemAction;
@end

NS_ASSUME_NONNULL_END
