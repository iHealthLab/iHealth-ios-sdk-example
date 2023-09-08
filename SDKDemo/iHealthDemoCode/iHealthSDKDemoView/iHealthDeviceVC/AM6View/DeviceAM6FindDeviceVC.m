//
//  DeviceAm6FindDeviceVC.m
//  iHealthDemoCode
//
//  Created by Spring on 2023/5/10.
//  Copyright © 2023 iHealth Demo Code. All rights reserved.
//

#import "DeviceAM6FindDeviceVC.h"
#import "IHSDKDemoRoundCornerButton.h"
#import "AMMacroFile.h"
#import "AMHeader.h"
@interface DeviceAM6FindDeviceVC ()

@property (strong, nonatomic) UIImageView *placeholderImageView;
@property (strong, nonatomic) UILabel *myLabel;
@property (strong, nonatomic) IHSDKDemoRoundCornerButton *btn;
@property (strong, nonatomic) NSTimer *myTimer;
@property (weak, nonatomic) AM6 *device;
@end

@implementation DeviceAM6FindDeviceVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (AM6 *)device{
    if (!_device) {
        NSArray*deviceArray=[[AM6Controller shareAM6Controller] getAllCurrentAM6Instace];
        
        for(AM6 *am6 in deviceArray){
            
            if([self.deviceId isEqualToString:am6.serialNumber]){
                
                _device=am6;
                
            }
        }
    }
    __weak typeof(self) weakSelf = self;
    if (_device==nil) {
        
        [IHSDKDemoToast showTipWithTitle:@"Device Not Connected"];
            
        [weakSelf hideLoading];
            
        [weakSelf.navigationController popViewControllerAnimated:YES];
    }
    return _device;
}

- (void)setupInterface{
    self.title = @"Find Watch";
    self.placeholderImageView = [[UIImageView alloc]initWithImage:KIHSDKImageNamed(@"latte_findwatch_start_icon")];
    [self.view addSubview:self.placeholderImageView];
    [self.placeholderImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_safeAreaLayoutGuideTop);
        make.width.mas_equalTo(375);
        make.height.mas_equalTo(250);
        make.centerX.mas_equalTo(self.view);
    }];
    
    self.myLabel.text =@"When connected, you can tap the \"Start\" to find your watch. Your watch will vibrate and its screen will be turned on.";
//    self.myLabel = [[UILabel alloc]initWithFrame:CGRectZero text:@"When connected, you can tap the \"Start\" to find your watch. Your watch will vibrate and its screen will be turned on." font:IHSDK_FONT_Regular(17) textColor:IHSDK_COLOR_FROM_HEX(0x22262B) numberOfLines:0];
    self.myLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.myLabel];
    [self.myLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(self.placeholderImageView.mas_bottom);
        make.left.mas_equalTo(self.view).offset(48);
        make.right.mas_equalTo(self.view).offset(-48);
        make.height.mas_greaterThanOrEqualTo(54);
    }];
    
    IHSDKDemoRoundCornerButton *btn = [IHSDKDemoRoundCornerButton buttonWithTitle:@"Start" style:IHSDKRoundCornerButtonStyle_Default];
    [btn addTarget:self action:@selector(onClickBtn:) forControlEvents:UIControlEventTouchUpInside];
    [btn addToViewBottom:self.view];
    self.btn = btn;
    
}
- (void)leftBarButtonDidPressed:(id)sender{
    [super leftBarButtonDidPressed:sender];
    if (self.myTimer) {
        [self.myTimer invalidate];
        self.myTimer = nil;
    }
}

- (void)onClickBtn:(id)sender{
    if ([self.btn.titleLabel.text isEqualToString:@"Start"]) {
        
        if (self.device) {
            __weak typeof(self) weakSelf = self;
            [self.device findDevice:0 success:^{
                [weakSelf.btn setTitle:@"Stop" forState:UIControlStateNormal];
                [weakSelf.btn setBackgroundColor:IHSDK_COLOR_FROM_HEX(0xFF4C4C)];
                [weakSelf.btn.layer setBorderColor:IHSDK_COLOR_FROM_HEX(0xFF4C4C).CGColor];
                weakSelf.myLabel.text = @"Once your watch is found, tap Stop.";
                if (weakSelf.myTimer) {
                    [weakSelf.myTimer invalidate];
                }
                weakSelf.myTimer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(findWatch) userInfo:nil repeats:YES];
                
            } fail:^(int error) {
                [self showTopToast:@"Connection failed. Please keep the watch connect before setting."];
            }];
            
        } else {
//            JAKBluetoothState state = [[WZLatteDeviceManager manager]getBluetoothState];
//            if (state == JAKBluetoothState_PoweredOn) {
//                [self showNotConnectToast];
//            } else {
//                [self showBluetoothIsOffToast];
//            }
        }
    } else {
        if (self.myTimer) {
            [self.myTimer invalidate];
            self.myTimer = nil;
        }
        [self.btn setTitle:@"Start" forState:UIControlStateNormal];
        self.myLabel.text = @"When connected, you can tap the \"Start\" to find your watch. Your watch will vibrate and its screen will be turned on.";
        [self.btn setBackgroundColor:kIHSDK_Text_Wyze_Green];
        [self.btn.layer setBorderColor:kIHSDK_Text_Wyze_Green.CGColor];
        
        if (self.device) {
            [self.device findDevice:1 success:^{
                
            } fail:^(int error) {
                
            }];
        }
    }
}

- (void)findWatch{
    __weak typeof(self) weakSelf = self;
    [self.device findDevice:0 success:^{
        
        
    } fail:^(int error) {
        [self showTopToast:@"Connection failed. Please keep the watch connect before setting."];
        [weakSelf.btn setTitle:@"Start" forState:UIControlStateNormal];
        weakSelf.myLabel.text = @"When connected, you can tap the \"Start\" to find your watch. Your watch will vibrate and its screen will be turned on.";
        [weakSelf.btn setBackgroundColor:kIHSDK_Text_Wyze_Green];
        [weakSelf.btn.layer setBorderColor:kIHSDK_Text_Wyze_Green.CGColor];
    }];
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
