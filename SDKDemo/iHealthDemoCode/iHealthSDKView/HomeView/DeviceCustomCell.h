//
//  DeviceCustomCell.h
//  iHealthDemoCode
//
//  Created by jing on 2018/9/30.
//  Copyright © 2018年 iHealth Demo Code. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DeviceCustomCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *deviceTitle;

@property (weak, nonatomic) IBOutlet UILabel *deviceName1;

@property (weak, nonatomic) IBOutlet UILabel *deviceName2;

@property (weak, nonatomic) IBOutlet UILabel *deviceName3;

@property (weak, nonatomic) IBOutlet UILabel *deviceName4;
@property (weak, nonatomic) IBOutlet UIButton *deviceBtn1;
@property (weak, nonatomic) IBOutlet UIButton *deviceBtn2;
@property (weak, nonatomic) IBOutlet UIButton *deviceBtn3;
@property (weak, nonatomic) IBOutlet UIButton *deviceBtn4;

@end

NS_ASSUME_NONNULL_END
