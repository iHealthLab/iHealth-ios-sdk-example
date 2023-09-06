//
//  IHSDKBaseController.h
//  iHealthDemoCode
//
//  Created by Spring on 2023/5/28.
//  Copyright © 2023 iHealth Demo Code. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "IHSDKNavigationBar.h"

NS_ASSUME_NONNULL_BEGIN

@interface IHSDKBaseController : UIViewController

@property (nonatomic, strong) IHSDKNavigationBar *navigationBar;
@property (nonatomic, copy) NSString *vcTitle;
- (void)leftItemAction;
- (void)rightItemAction;

@end

NS_ASSUME_NONNULL_END
