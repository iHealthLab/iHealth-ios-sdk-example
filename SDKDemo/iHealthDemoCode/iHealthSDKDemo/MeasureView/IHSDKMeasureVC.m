//
//  IHSDKMeasureVC.m
//  iHealthDemoCode
//
//  Created by Spring on 2023/5/30.
//  Copyright © 2023 iHealth Demo Code. All rights reserved.
//

#import "IHSDKMeasureVC.h"

#import "IHSDKCloudUser.h"

#import "IHSDKScanDeviceQRVC.h"

@interface IHSDKMeasureVC ()

@property (nonatomic,strong) UIButton *testButton;

@property (nonatomic,strong) UIImageView *addDeviceBackImageView;

@end

@implementation IHSDKMeasureVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setup];
    
//    [self startAuth];
    // Do any additional setup after loading the view.
}

- (void)setup{
    
    [self.view setBackgroundColor:[UIColor colorWithHexString:@"#FFFFFF"]];
    
    
    [self.view addSubview:self.addDeviceBackImageView];
    [self.addDeviceBackImageView mas_makeConstraints:^(MASConstraintMaker *make) {
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

- (UIImageView *)addDeviceBackImageView{
    if (_addDeviceBackImageView == nil) {
        _addDeviceBackImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"add_device_back"]];
    }
    return _addDeviceBackImageView;
}

- (UIButton *)testButton{
    if (_testButton == nil) {
        _testButton = [UIButton buttonWithType:UIButtonTypeSystem];
//        _testButton.frame = CGRectMake(0, 0, IHSDKScreen_W - IHSDKScaleByWidth(34) * 2, 48);
        [_testButton setTitle:NSLocalizedString(@"Add Device", @"") forState:UIControlStateNormal];
        
        _testButton.titleLabel.font=[UIFont systemFontOfSize:IHSDKScaleByWidth(32)];
        [_testButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
        [_testButton setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
        
        [_testButton addTarget:self action:@selector(gotoScanDeviceView) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _testButton;
}

- (void)startAuth{
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"com_iHealthSDK_SDKDemo_ios" ofType:@"pem"];
   
    NSData*data = [NSData dataWithContentsOfFile:filePath];

   [[IHSDKCloudUser commandGetSDKUserInstance] commandSDKUserValidationWithLicense:data UserDeviceAccess:^(NSArray *DeviceAccessArray) {
       
//        NSLog(@"DeviceAccessArray :%@",DeviceAccessArray);
       
       NSString*authMessage=NSLocalizedString(@"Authorization Sucess", @"");
       
       UIAlertController *alertController = [UIAlertController alertControllerWithTitle:authMessage
                                                                                message:[NSString stringWithFormat:@"Device List:%@",DeviceAccessArray]
                                                                         preferredStyle:UIAlertControllerStyleAlert ];
       
       //取消style:UIAlertActionStyleDefault
       UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
       [alertController addAction:cancelAction];
       
       [self presentViewController:alertController animated:YES completion:nil];
       
   } UserValidationSuccess:^(UserAuthenResult result) {
       
//        self.ResultTestView.text=[NSString stringWithFormat:NSLocalizedString(@"Sucess", @"Sucess")];

       
   } DisposeErrorBlock:^(UserAuthenResult errorID) {
       
       NSString*failMessage=[NSString string];
       
       switch (errorID) {
           case UserAuthen_InputError:
               failMessage=NSLocalizedString(@"Input error", @"Input error");
               break;
           case UserAuthen_CertificateExpired:
               failMessage=NSLocalizedString(@"Certificate expired", @"Certificate expired");
               break;
           case UserAuthen_InvalidCertificate:
               failMessage=NSLocalizedString(@"Invalid certificate", @"Invalid certificate");
               break;
           default:
               break;
       }
       
       NSString*authMessage=NSLocalizedString(@"Authorization failed", @"Authorization failed");
       
       UIAlertController *alertController = [UIAlertController alertControllerWithTitle:authMessage
                                                                                message:failMessage
                                                                         preferredStyle:UIAlertControllerStyleAlert ];
       
       //取消style:UIAlertActionStyleDefault
       UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
       [alertController addAction:cancelAction];
       
       [self presentViewController:alertController animated:YES completion:nil];
       
   }];
    
}

- (void)gotoScanDeviceView{
    
    IHSDKScanDeviceQRVC*vc=[[IHSDKScanDeviceQRVC alloc] init];
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
