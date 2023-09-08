//
//  DeviceTS28BViewController.m
//  iHealthDemoCode
//
//  Created by jing on 2018/10/22.
//  Copyright © 2018年 iHealth Demo Code. All rights reserved.
//

#import "DeviceTS28BViewController.h"
#import "TS28BHeader.h"
@interface DeviceTS28BViewController ()<TS28BControllerDelegate>
@property (weak, nonatomic) IBOutlet UITextView *ts28bTextView;

@property (weak, nonatomic) IBOutlet UILabel *deviceLabel;

@property (strong, nonatomic) TS28BController *controller;

@property (strong, nonatomic) TS28B *connectedDevice;

@end

@implementation DeviceTS28BViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.deviceLabel.text=[NSString stringWithFormat:@"TS28B"];
    
    self.controller = [TS28BController sharedController];
}
- (IBAction)Cancel:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)scan:(id)sender {
    self.controller.delegate=self;
    [self.controller startScan];
}

- (IBAction)connect:(id)sender {
    
   
}
- (IBAction)disconnect:(id)sender {
    
    [self.controller disconnectDevice:self.connectedDevice];
}

#pragma mark - delegate

- (void)controller:(TS28BController *)controller didDiscoverDevice:(TS28B *)device{
    NSLog(@"搜索到设备的代理");
    self.connectedDevice=device;
    
     [self.controller connectDevice:self.connectedDevice];
    
    self.ts28bTextView.text = [NSString stringWithFormat:@"DiscoverDevice: %@",device];
}
- (void)controller:(TS28BController *)controller didConnectSuccessDevice:(TS28B *)device{
    NSLog(@"连接成功的代理");
    self.connectedDevice = device;
   self.ts28bTextView.text = [NSString stringWithFormat:@"ConnectDevice: %@",device];
}
- (void)controller:(TS28BController *)controller didConnectFailDevice:(TS28B *)device{
    NSLog(@"连接失败的代理");
    //    self.recordTextView.text = @"连接失败";
}
- (void)controller:(TS28BController *)controller didDisconnectDevice:(TS28B *)device{
    NSLog(@"断开连接的代理");
    //    self.recordTextView.text = @"连接断开";
    
    self.ts28bTextView.text = [NSString stringWithFormat:@"DisConnectDevice: %@ \n %@",device,self.ts28bTextView.text ];
}
- (void)controller:(TS28BController *)controller device:(TS28B *)device didUpdateTemperature:(float)value temperatureUnit:(TemperatureUnit)unit measureDate:(NSDate *)date measureLocation:(TemperatureType)type{
    
    self.ts28bTextView.text = [NSString stringWithFormat:@"Temperature:%.1f %@ \n %@",value,(unit == TemperatureUnit_C)?@"C":@"F",self.ts28bTextView.text];
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
