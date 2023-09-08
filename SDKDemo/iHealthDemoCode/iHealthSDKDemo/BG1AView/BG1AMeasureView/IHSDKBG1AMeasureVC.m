//
//  BG1AMeasureVC.m
//  iHealthDemoCode
//
//  Created by Spring on 2023/5/31.
//  Copyright © 2023 iHealth Demo Code. All rights reserved.
//

#import "IHSDKBG1AMeasureVC.h"

#import "IHSDKHomeTabBarController.h"

#import "IHSDKBG1AMeasureDataVC.h"

#import "IHSDKBG1AHomeTabBarController.h"

@interface IHSDKBG1AMeasureVC ()

@property (nonatomic,strong) UIButton *testButton;

@property (nonatomic,strong) UIImageView *testBankImageView;

@end

@implementation IHSDKBG1AMeasureVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.vcTitle=NSLocalizedString(@"BG1A", @"");
    
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setImage:[UIImage imageNamed:@"nav_backBtn_black"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(clickleftBarButtonItem) forControlEvents:UIControlEventTouchUpInside];
    CGFloat btnW = IHSDKNavaBarItemW;
    [self.view addSubview:leftBtn];
    [leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(btnW, btnW));
        make.left.offset(IHSDKNavaBarItemMargin);
        make.top.offset(IHSDKStatusBarH);
    }];
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setTitle:NSLocalizedString(@"CST", @"") forState:UIControlStateNormal];
    
    [rightBtn setTitleColor:[UIColor colorWithHexString:@"#538BF7"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(clickrightBarButtonItem) forControlEvents:UIControlEventTouchUpInside];
    CGFloat btnWs = IHSDKNavaBarItemW;
    [self.view addSubview:rightBtn];
    [rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(btnWs+30, btnWs));
        make.right.offset(IHSDKNavaBarItemMargin);
        make.top.offset(IHSDKStatusBarH);
    }];
    
    
    [self.view addSubview:self.testBankImageView];
    [self.testBankImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).offset(IHSDKScaleByWidth(195));
        make.centerX.mas_equalTo(self.view);
        make.height.mas_equalTo(IHSDKScaleByWidth(210));
        make.width.mas_equalTo(IHSDKScaleByWidth(210));
    }];
    
    [self.view addSubview:self.testButton];
    [self.testButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).offset(IHSDKScaleByWidth(282));
        make.centerX.mas_equalTo(self.view);
        make.height.mas_equalTo(IHSDKScaleByWidth(38));
        make.width.mas_equalTo(IHSDKScaleByWidth(171));
    }];
}

- (void)clickrightBarButtonItem{
  
}

- (void)clickleftBarButtonItem{
   
    [self.navigationController.tabBarController.navigationController popViewControllerAnimated:YES];
  
}

- (UIImageView *)testBankImageView{
    if (_testBankImageView == nil) {
        _testBankImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bg1a_measure_start_bank"]];
    }
    return _testBankImageView;
}

- (UIButton *)testButton{
    if (_testButton == nil) {
        _testButton = [UIButton buttonWithType:UIButtonTypeSystem];
//        _testButton.frame = CGRectMake(0, 0, IHSDKScreen_W - IHSDKScaleByWidth(34) * 2, 48);
        [_testButton setTitle:NSLocalizedString(@"Measure", @"") forState:UIControlStateNormal];
        
        _testButton.titleLabel.font=[UIFont systemFontOfSize:IHSDKScaleByWidth(32)];
        [_testButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
        [_testButton setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
        
        [_testButton addTarget:self action:@selector(gotoMeasureDataView) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _testButton;
}


-(void)gotoMeasureDataView{
    
    IHSDKBG1AHomeTabBarController*homevc=(IHSDKBG1AHomeTabBarController*)self.navigationController.tabBarController;
    IHSDKBG1AMeasureDataVC*vc=[[IHSDKBG1AMeasureDataVC alloc] init];
    vc.deviceMac=homevc.deviceMac;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
