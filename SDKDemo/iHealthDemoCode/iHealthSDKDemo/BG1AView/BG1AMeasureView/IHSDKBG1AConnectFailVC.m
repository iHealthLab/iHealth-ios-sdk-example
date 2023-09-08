//
//  IHSDKBG1AConnectFailVC.m
//  iHealthDemoCode
//
//  Created by Spring on 2023/6/4.
//  Copyright © 2023 iHealth Demo Code. All rights reserved.
//

#import "IHSDKBG1AConnectFailVC.h"

@interface IHSDKBG1AConnectFailVC ()

@property (nonatomic,strong) UIImageView *insertImageView;

@property (nonatomic,strong) UILabel *testLabel;

@property (nonatomic,strong) UILabel *testLabelline2;

@property (nonatomic,strong) UIButton *researchButton;

@end

@implementation IHSDKBG1AConnectFailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupInterface];
}

- (void)setupInterface{
    
    [self.view setBackgroundColor:[UIColor colorWithHexString:@"#FFFFFF"]];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = NSLocalizedString(@"BG1A", @"");
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:IHSDKScaleByWidth(20)];
    titleLabel.textColor = [UIColor colorWithHexString:@"#000000"];
    [self.view addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {

        make.centerX.mas_equalTo(self.view);
        make.top.offset(IHSDKStatusBarH+10);
    }];
    
    
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setImage:[UIImage imageNamed:@"bg1a_nav_cancel"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(clickleftBarButtonItem) forControlEvents:UIControlEventTouchUpInside];
    CGFloat btnW = IHSDKNavaBarItemW;
    [self.view addSubview:leftBtn];
    [leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(btnW, btnW));
        make.left.offset(IHSDKNavaBarItemMargin);
        make.top.offset(IHSDKStatusBarH);
    }];
    
    [self.view addSubview:self.insertImageView];
    [self.insertImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(IHSDKScaleByWidth(178));
        make.centerX.mas_equalTo(self.view);

//        make.centerY.mas_equalTo(self.view);
    }];
    
   
    self.testLabel.text =NSLocalizedString(@"Connected Failed", @"");
    [self.view addSubview:self.testLabel];
    [self.testLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(IHSDKScaleByWidth(-373));
        make.width.mas_equalTo(IHSDKScaleByWidth(333));
        make.centerX.mas_equalTo(self.view);
    }];
    
    self.testLabelline2.text =NSLocalizedString(@"Try to reinsert the test strip.", @"");
    [self.view addSubview:self.testLabelline2];
    [self.testLabelline2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(IHSDKScaleByWidth(-339));
        make.width.mas_equalTo(IHSDKScaleByWidth(333));
        make.centerX.mas_equalTo(self.view);
    }];
    
    [self.view addSubview:self.researchButton];
    [self.researchButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(IHSDKScaleByWidth(-54));
        make.width.mas_equalTo(IHSDKScaleByWidth(316));
        make.height.mas_equalTo(IHSDKScaleByWidth(60));
        make.centerX.mas_equalTo(self.view);
    }];
    
}

- (void)clickleftBarButtonItem{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (UIImageView *)insertImageView{
    if (_insertImageView == nil) {
        _insertImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bg1a_connectfail"]];
    }
    return _insertImageView;
}

- (UILabel *)testLabel{
    if (_testLabel == nil) {
        _testLabel = [[UILabel alloc]init];
        _testLabel.textAlignment = NSTextAlignmentCenter;
        _testLabel.numberOfLines=5;
        _testLabel.font = [UIFont systemFontOfSize:IHSDKScaleByWidth(24)];
        _testLabel.textColor = [UIColor colorWithHexString:@"#000000"];
    }
    return _testLabel;
}

- (UILabel *)testLabelline2{
    if (_testLabelline2 == nil) {
        _testLabelline2 = [[UILabel alloc]init];
        _testLabelline2.textAlignment = NSTextAlignmentCenter;
        _testLabelline2.numberOfLines=5;
        _testLabelline2.font = [UIFont systemFontOfSize:IHSDKScaleByWidth(16)];
        _testLabelline2.textColor = [UIColor colorWithHexString:@"#000000"];
    }
    return _testLabelline2;
}

- (UIButton *)researchButton{
    if (_researchButton == nil) {
        
        _researchButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        _researchButton.frame = CGRectMake(0, 0, IHSDKScreen_W - IHSDKScaleByWidth(29) * 2, 60);
        
        [_researchButton setBackgroundColor:[UIColor colorWithHexString:@"#538BF7"]];
        
        [_researchButton setTitle:NSLocalizedString(@"Reconnect", @"") forState:UIControlStateNormal];
        
        _researchButton.titleLabel.font = [UIFont systemFontOfSize:IHSDKScaleByWidth(18)];
        
        [_researchButton setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
        
        [_researchButton addTarget:self action:@selector(research) forControlEvents:UIControlEventTouchUpInside];
        
        _researchButton.layer.cornerRadius = 35;
        _researchButton.layer.masksToBounds = YES;
        

    }
    return _researchButton;
}
-(void)research{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ResearchBG1ANotification" object:nil];
    
    [self.navigationController popViewControllerAnimated:YES];
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
