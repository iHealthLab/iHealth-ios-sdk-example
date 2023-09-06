//
//  IHSDKDemoTableView.m
//  iHealthDemoCode
//
//  Created by jing on 2023/4/11.
//  Copyright © 2023 iHealth Demo Code. All rights reserved.
//

#import "IHSDKDemoTableView.h"
@interface IHSDKDemoTableView ()
@property (copy, nonatomic) dispatch_block_t footerButtonCallback;
@end

@implementation IHSDKDemoTableView

+ (instancetype)groupedTable{
    IHSDKDemoTableView *_myTable = [[IHSDKDemoTableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _myTable.backgroundColor = [UIColor colorWithHexString:@"#F1F3F3"];
    _myTable.separatorColor = [UIColor colorWithHexString:@"#C9D7DB"];
    _myTable.rowHeight = 64;
    _myTable.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 1, 0.01)];// 解决留白
    _myTable.sectionHeaderHeight = 0.01;
    if (IHSDKiPad && IHSDKiOSVersion>=11.0 && IHSDKiOSVersion<12.0 ) {
        _myTable.separatorInset = UIEdgeInsetsMake(0, 20, 0, -80);
    }
    return _myTable;
}
+ (instancetype)groupedTableWithFooterButton:(NSString *)buttonTitle buttonCallback:(dispatch_block_t)buttonCallback{
    IHSDKDemoTableView *_myTable = [IHSDKDemoTableView groupedTable];
    _myTable.footerButtonCallback = buttonCallback;
    UIView *footer = [[UIView alloc]initWithFrame:CGRectMake(0, 0, IHSDKScreen_W, 80)];
    UIButton *btn =[UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btn setTitle:buttonTitle forState: UIControlStateNormal];
//    [btn.titleLabel setFont:IHSDK_FONT_Bold(17)];
//    [btn setTitleColor:IHSDK_COLOR_FROM_HEX(0xBE4027) forState:UIControlStateNormal];
    [btn setBackgroundColor:UIColor.whiteColor];
    [btn.layer setBorderColor:UIColor.whiteColor.CGColor];
    [btn addTarget:_myTable action:@selector(onClickFooterBtn:) forControlEvents:UIControlEventTouchUpInside];
    [footer addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(footer);
        make.width.mas_equalTo(IHSDKScreen_W-26);
        make.height.mas_equalTo(48);
    }];
    _myTable.tableFooterView = footer;
    return _myTable;
}

+ (instancetype)plainTable{
    IHSDKDemoTableView *myTable = [[IHSDKDemoTableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    myTable.backgroundColor = [UIColor colorWithHexString:@"#F1F3F3"];
    return myTable;
}

- (void)addToView:(UIView*)containerView{
    [containerView addSubview:self];
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(containerView).offset(IHSDKStatusBarH+ (IHSDKiPad?50:44));
        make.bottom.left.right.mas_equalTo(containerView);
    }];
}

- (void)onClickFooterBtn:(id)sender{
    if (self.footerButtonCallback) {
        self.footerButtonCallback();
    }
}
@end
