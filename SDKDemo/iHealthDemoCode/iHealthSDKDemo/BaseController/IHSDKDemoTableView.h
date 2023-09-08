//
//  IHSDKDemoTableView.h
//  iHealthDemoCode
//
//  Created by jing on 2023/4/11.
//  Copyright © 2023 iHealth Demo Code. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IHSDKBaseCell.h"
NS_ASSUME_NONNULL_BEGIN

@interface IHSDKDemoTableView : UITableView

+ (instancetype)groupedTable;
+ (instancetype)groupedTableWithFooterButton:(NSString *)buttonTitle buttonCallback:(dispatch_block_t)buttonCallback;
+ (instancetype)plainTable;
- (void)addToView:(UIView*)containerView;
@end

NS_ASSUME_NONNULL_END
