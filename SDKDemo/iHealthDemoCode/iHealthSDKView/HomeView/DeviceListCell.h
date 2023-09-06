//
//  DeviceListCell.h
//  iHealthDemoCode
//
//  Created by jing on 2018/10/10.
//  Copyright © 2018年 iHealth Demo Code. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DeviceListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *deviceMac;
@property (weak, nonatomic) IBOutlet UIButton *deviceConnects;
@end

NS_ASSUME_NONNULL_END
