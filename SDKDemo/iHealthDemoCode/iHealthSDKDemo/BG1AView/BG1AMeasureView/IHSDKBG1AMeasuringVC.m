//
//  IHSDKBG1AMeasuringVC.m
//  iHealthDemoCode
//
//  Created by Spring on 2023/6/4.
//  Copyright © 2023 iHealth Demo Code. All rights reserved.
//

#import "IHSDKBG1AMeasuringVC.h"

#import "IHSDKBG1AResultVC.h"

#define TotleTime 5

@interface IHSDKBG1AMeasuringVC ()

@property (nonatomic,strong) UIImageView *timeBgImageView;

@property (nonatomic,strong) UIImageView *insertImageView;

@property (nonatomic,strong) UILabel *testLabel;

@property (nonatomic,strong) UILabel *testLabelline2;

@property (nonatomic,strong) NSTimer *timer;

@property (nonatomic,assign) int leftTime;

@end

@implementation IHSDKBG1AMeasuringVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupInterface];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(startTimerOver:) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    
    self.leftTime=TotleTime;
    
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(handleResultNoti:) name:kBG1ANotiNameResult object:nil];
}
//更新图片
- (void)startTimerOver:(NSTimer *)timer{
    
    self.leftTime--;
    
    if (self.leftTime==4) {
        [self.insertImageView setImage:[UIImage imageNamed:@"bg1a_measuring_time4"]];
    }else if (self.leftTime==3){
        [self.insertImageView setImage:[UIImage imageNamed:@"bg1a_measuring_time3"]];
    }else if (self.leftTime==2){
        [self.insertImageView setImage:[UIImage imageNamed:@"bg1a_measuring_time2"]];
    }else if (self.leftTime==1){
        [self.insertImageView setImage:[UIImage imageNamed:@"bg1a_measuring_time1"]];
    }else if (self.leftTime==0){
       
        
    }
    
    
}

- (void)handleResultNoti:(NSNotification*)noti{
    NSLog(@"%@",noti);
    NSNumber *num = noti.userInfo[@"result"];
    
    IHSDKBG1AResultVC*vc=[[IHSDKBG1AResultVC alloc] init];
    vc.deviceMac=self.deviceMac;
    vc.result=[num copy];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    
    
    
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
    [leftBtn setImage:[UIImage imageNamed:@"bg1a_nav_backBtn_black"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(clickleftBarButtonItem) forControlEvents:UIControlEventTouchUpInside];
    CGFloat btnW = IHSDKNavaBarItemW;
    [self.view addSubview:leftBtn];
    [leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(btnW, btnW));
        make.left.offset(IHSDKNavaBarItemMargin);
        make.top.offset(IHSDKStatusBarH);
    }];
    
    [self.view addSubview:self.timeBgImageView];
    [self.timeBgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(IHSDKStatusBarH+10+IHSDKScaleByWidth(77));
        make.centerX.mas_equalTo(self.view);

    }];
    
    [self.view addSubview:self.insertImageView];
    [self.insertImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(IHSDKStatusBarH+10+IHSDKScaleByWidth(207));
        make.centerX.mas_equalTo(self.view);

    }];
    
    self.testLabel.text =NSLocalizedString(@"Measuring", @"");
    [self.view addSubview:self.testLabel];
    [self.testLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(IHSDKStatusBarH+10+IHSDKScaleByWidth(462));
        make.height.mas_equalTo(IHSDKScaleByWidth(40));
        make.centerX.mas_equalTo(self.view);
    }];
    
    self.testLabelline2.text =NSLocalizedString(@"Do not pull out the test paper", @"");
    [self.view addSubview:self.testLabelline2];
    [self.testLabelline2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(IHSDKStatusBarH+10+IHSDKScaleByWidth(520));
        make.height.mas_equalTo(IHSDKScaleByWidth(22));
        make.centerX.mas_equalTo(self.view);
    }];
    
}

- (void)clickleftBarButtonItem{
    [self.navigationController popViewControllerAnimated:YES];
}

- (UIImageView *)insertImageView{
    if (_insertImageView == nil) {
        _insertImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bg1a_measuring_time5"]];
    }
    return _insertImageView;
}


- (UIImageView *)timeBgImageView{
    if (_timeBgImageView == nil) {
        _timeBgImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bg1a_measuring_time_image"]];
    }
    return _timeBgImageView;
}

- (UILabel *)testLabel{
    if (_testLabel == nil) {
        _testLabel = [[UILabel alloc]init];
        _testLabel.textAlignment = NSTextAlignmentCenter;
        _testLabel.numberOfLines=5;
        _testLabel.font = [UIFont systemFontOfSize:IHSDKScaleByWidth(28)];
        _testLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    }
    return _testLabel;
}

- (UILabel *)testLabelline2{
    if (_testLabelline2 == nil) {
        _testLabelline2 = [[UILabel alloc]init];
        _testLabelline2.textAlignment = NSTextAlignmentCenter;
        _testLabelline2.numberOfLines=5;
        _testLabelline2.font = [UIFont systemFontOfSize:IHSDKScaleByWidth(18)];
        _testLabelline2.textColor = [UIColor colorWithHexString:@"#666666"];
    }
    return _testLabelline2;
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
