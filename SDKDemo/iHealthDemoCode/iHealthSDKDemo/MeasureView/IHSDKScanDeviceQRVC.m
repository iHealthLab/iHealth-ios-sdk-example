//
//  IHSDKScanDeviceQRVC.m
//  iHealthDemoCode
//
//  Created by Spring on 2023/6/2.
//  Copyright © 2023 iHealth Demo Code. All rights reserved.
//

#import "IHSDKScanDeviceQRVC.h"

#import "IHSDKQRScanView.h"

#import "IHSDKDeviceListVC.h"

@interface IHSDKScanDeviceQRVC ()<IHSDKQRScanDelegate>
@property (nonatomic ,strong) IHSDKQRScanView *scanView;

@end

@implementation IHSDKScanDeviceQRVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.scanView.frame = self.view.frame;
    [self.view addSubview:self.scanView];
    self.scanView.noteStr = NSLocalizedString(@"Please scan the QR code on your device to add device.", @"");
   
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = YES;
    [self.scanView stopScanning];
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.scanView startScanning];
    
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setImage:[UIImage imageNamed:@"nav_backBtn"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(clickleftBarButtonItem) forControlEvents:UIControlEventTouchUpInside];
    CGFloat btnW = IHSDKNavaBarItemW;
    [self.view addSubview:leftBtn];
    [leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(btnW, btnW));
        make.left.offset(IHSDKNavaBarItemMargin);
        make.top.offset(IHSDKStatusBarH);
    }];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = NSLocalizedString(@"Scan QR Code", @"");
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:IHSDKScaleByWidth(20)];
    titleLabel.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
    [self.view addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {

        make.centerX.mas_equalTo(self.view);
        make.top.offset(IHSDKStatusBarH+10);
    }];
    
    UIButton *scanDeviceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [scanDeviceBtn setTitle:NSLocalizedString(@"Manual Add", @"") forState:UIControlStateNormal];
    [scanDeviceBtn setTitleColor:[UIColor colorWithHexString:@"#00D0B9"] forState:UIControlStateNormal];
    [scanDeviceBtn addTarget:self action:@selector(clickScanDeviceBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:scanDeviceBtn];
    [scanDeviceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.height.mas_equalTo(IHSDKScaleByWidth(19));
//        make.width.mas_equalTo(IHSDKScaleByWidth(87));
        make.centerX.mas_equalTo(self.view);
        make.bottom.offset(IHSDKScaleByWidth(-43));
    }];
    
#if TARGET_IPHONE_SIMULATOR
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setTitle:NSLocalizedString(@"NEXT", @"") forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(clickrightBarButtonItem) forControlEvents:UIControlEventTouchUpInside];
    CGFloat btnWs = IHSDKNavaBarItemW;
    [self.view addSubview:rightBtn];
    [rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(btnWs+30, btnWs));
        make.right.offset(IHSDKNavaBarItemMargin);
        make.top.offset(IHSDKStatusBarH);
    }];

    
#elif TARGET_OS_IPHONE//真机
    
#endif
}

- (void)clickrightBarButtonItem{
  
}

- (void)clickleftBarButtonItem{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)clickScanDeviceBtn{
    
    IHSDKDeviceListVC*vc=[[IHSDKDeviceListVC alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
  
}

#pragma mark - scanViewDelegate
- (void)scanView:(IHSDKQRScanView *)scanView pickUpMessage:(NSString *)message{
    
    NSLog(@"check device QR:%@",message);
    [scanView stopScanning];
    
    NSRange range = [message rangeOfString:@"mac="];
    
//    NSRange ranges = [message rangeOfString:@"s="];
    
    if (range.location != NSNotFound && message.length-range.location>12) {
        
        NSString*mac=[message substringWithRange:NSMakeRange(range.location,12)];
        
        IHSDKDeviceListVC*vc=[[IHSDKDeviceListVC alloc] init];
        vc.deviceMac=[mac copy];
        [self.navigationController pushViewController:vc animated:YES];
        
    }else{
        
        
        NSString*authMessage=NSLocalizedString(@"Invalid QR Code", @"");
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:authMessage
                                                                                 message:NSLocalizedString(@"This QR code cannot be recognized. Please scan the correct QR code.", @"")
                                                                          preferredStyle:UIAlertControllerStyleAlert ];
        
        //取消style:UIAlertActionStyleDefault
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:cancelAction];
        
        [self presentViewController:alertController animated:YES completion:nil];
        
    }
    
    
}

- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil){
        return nil;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
        
    } return dic;
}

- (IHSDKQRScanView *)scanView{
    if (_scanView == nil) {
        _scanView = [[IHSDKQRScanView alloc]initWithFrame:self.view.bounds];
        _scanView.delegate = self;
        _scanView.showBorderLine = YES;
    }
    return _scanView;
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
