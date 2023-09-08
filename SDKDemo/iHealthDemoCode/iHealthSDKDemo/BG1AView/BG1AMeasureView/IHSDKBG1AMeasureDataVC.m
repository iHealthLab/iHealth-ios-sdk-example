//
//  IHSDKBG1AMeasureDataVC.m
//  iHealthDemoCode
//
//  Created by Spring on 2023/6/3.
//  Copyright © 2023 iHealth Demo Code. All rights reserved.
//

#import "IHSDKBG1AMeasureDataVC.h"

#import "IHSDKBG1AConnectFailVC.h"

#import "IHSDKBG1AMeasuringVC.h"

@interface IHSDKBG1AMeasureDataVC ()

@property (nonatomic,strong) UIImageView *insertImageView;

@property (nonatomic,strong) UILabel *testLabel;

@property (nonatomic,strong) NSTimer *timer;

@end

@implementation IHSDKBG1AMeasureDataVC

-(void)viewWillAppear:(BOOL)animated{
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupInterface];
    
    [BG1AController shareIHBG1AController];
    
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(onDiscoverNewDevice:) name:BG1ADiscover object:nil];
    
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(onConnectNewDevice:) name:BG1AConnectNoti object:nil];
    
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(onFailConnectNewDevice:) name:BG1AConnectFailed object:nil];
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(onDeviceDisconnect:) name:BG1ADisConnectNoti object:nil];
    
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(researchBG1ADevice:) name:@"ResearchBG1ANotification" object:nil];
    
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(handleErrorNoti:) name:kBG1ANotiNameError object:nil];
    
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(handleBloodInNoti:) name:kBG1ANotiNameStripStatus object:nil];
    
    [[ScanDeviceController commandGetInstance]commandScanDeviceType:HealthDeviceType_BG1A];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:60.0 target:self selector:@selector(startTimerOver:) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

//超时一分钟后弹窗继续搜索
- (void)startTimerOver:(NSTimer *)timer{
    
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil
                                                                             message:NSLocalizedString(@"Check the test paper is fully inserted.", @"")
                                                                      preferredStyle:UIAlertControllerStyleAlert ];
    
    [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Research", @"") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [[ScanDeviceController commandGetInstance]commandScanDeviceType:HealthDeviceType_BG1A];
         
    }]];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)onDiscoverNewDevice:(NSNotification*)noti{
    
    if ([self.deviceMac isEqualToString:noti.userInfo[IDPS_SerialNumber]]) {
        
        [[ConnectDeviceController commandGetInstance]commandContectDeviceWithDeviceType:HealthDeviceType_BG1A andSerialNub:self.deviceMac];
        
        self.testLabel.text =NSLocalizedString(@"Connecting...", @"");
    }
}

- (void)onConnectNewDevice:(NSNotification*)noti{
    
    [self.timer invalidate];
    
    self.testLabel.text =NSLocalizedString(@"Aim your fingers for blood sucking", @"");
    
    NSLog(@"connect notification:%@",noti.userInfo);
    
}

- (void)onFailConnectNewDevice:(NSNotification*)noti{
    
    [self.timer invalidate];
    NSLog(@"connect fail %@",noti.userInfo);
    
    IHSDKBG1AConnectFailVC*vc=[[IHSDKBG1AConnectFailVC alloc] init];
    vc.deviceMac=self.deviceMac;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)researchBG1ADevice:(NSNotification*)noti{
    
    [[ScanDeviceController commandGetInstance]commandScanDeviceType:HealthDeviceType_BG1A];
}

- (void)handleErrorNoti:(NSNotification*)noti{
    NSLog(@"%@",noti);
    NSNumber *num = noti.userInfo[@"Error"];
   
}

- (void)handleBloodInNoti:(NSNotification*)noti{
    NSLog(@"%@",noti);
    
    NSLog(@"%@",noti);
    NSNumber *num = noti.userInfo[@"status"];
    
    if ([num intValue]==2) {
        
        IHSDKBG1AMeasuringVC*vc=[[IHSDKBG1AMeasuringVC alloc] init];
        vc.deviceMac=self.deviceMac;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
   
   
}

- (void)onDeviceDisconnect:(NSNotification*)noti{
    NSLog(@"Device disconnect %@",noti);
  
}
- (void)setupInterface{
    
    [self.view addSubview:self.insertImageView];
    [self.insertImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view);
        make.centerX.mas_equalTo(self.view);
//        make.height.mas_equalTo(IHSDKScaleByWidth(545));
        make.right.mas_equalTo(self.view.mas_right);
        make.left.mas_equalTo(self.view.mas_left);
//        make.centerY.mas_equalTo(self.view);
    }];
    
    [self.view setBackgroundColor:[UIColor colorWithHexString:@"#538BF7"]];
    
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
    
    
   
    self.testLabel.text =NSLocalizedString(@"Insert the test strip into the blood glucose meter", @"");
    [self.view addSubview:self.testLabel];
    [self.testLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).offset(IHSDKScaleByWidth(509));
        make.width.mas_equalTo(IHSDKScaleByWidth(333));
        make.centerX.mas_equalTo(self.view);
    }];
    
}

- (void)clickleftBarButtonItem{
    [self.navigationController popViewControllerAnimated:YES];
}

- (UIImageView *)insertImageView{
    if (_insertImageView == nil) {
        _insertImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bg1a_measure_insertImage"]];
    }
    return _insertImageView;
}

- (UILabel *)testLabel{
    if (_testLabel == nil) {
        _testLabel = [[UILabel alloc]init];
        _testLabel.textAlignment = NSTextAlignmentCenter;
        _testLabel.numberOfLines=5;
        _testLabel.font = [UIFont systemFontOfSize:IHSDKScaleByWidth(28)];
        _testLabel.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
    }
    return _testLabel;
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
