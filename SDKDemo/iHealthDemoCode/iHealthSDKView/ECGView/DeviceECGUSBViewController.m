//
//  DeviceECGUSBViewController.m
//  iHealthDemoCode
//
//  Created by jing on 2018/10/30.
//  Copyright © 2018年 iHealth Demo Code. All rights reserved.
//

#import "DeviceECGUSBViewController.h"
#import "ECGHeader.h"
@interface DeviceECGUSBViewController ()
@property (weak, nonatomic) IBOutlet UITextView *ecg3USBTextView;

@property (weak, nonatomic) IBOutlet UILabel *deviceLabel;

@property (strong, nonatomic) ECG3USB *myECG3USB;
@end

@implementation DeviceECGUSBViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    
    NSString*deviceMac=[userDefault valueForKey:@"SelectDeviceMac"];
    
    self.deviceLabel.text=[NSString stringWithFormat:@"ECG3USB %@",deviceMac];
    
    self.myECG3USB=[[ECG3USBController shareECG3USBController] getCurrentECG3USBInstace];
    
    
}
- (IBAction)Cancel:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)syncBtnPressed:(id)sender {
    self.ecg3USBTextView.text = @"Call sync";
    __weak typeof(self) weakSelf = self;
    [self.myECG3USB syncDataWithStartBlock:^{
        weakSelf.ecg3USBTextView.text = @"Start sync";
    } progressBlock:^(NSUInteger progress) {
        //        NSLog(@"Sync progress:%@",@(progress));
        weakSelf.ecg3USBTextView.text = [NSString stringWithFormat:@"Sync progress:%@",@(progress)];
    } resultBlock:^(NSArray *resultArray, BOOL finish) {
        weakSelf.ecg3USBTextView.text = [NSString stringWithFormat:@"finish Flag: %@\n data quantity:%@\n content: %@",finish?@"YES":@"NO",@(resultArray.count),resultArray];
    } errorBlock:^(ECG3USBError errorID) {
        weakSelf.ecg3USBTextView.text = [NSString stringWithFormat:@"Sync error:%@",@(errorID)];
    }];
}
- (IBAction)formatBtnPressed:(id)sender {
    
    [[ECG3USB new]getFilterDataWithDic:@{@"DataFileName":@"ECG_Data_20150228184312.dat",@"MarkFileName":@"ECG_Mark_20150228184312.txt"} success:^(NSArray *resultArray, BOOL finish) {
        NSLog(@"%@",resultArray);
        
        self.ecg3USBTextView.text = [NSString stringWithFormat:@"FilterData result:%@",resultArray];
    } error:^(NSString *message) {
        NSLog(@"%@",message);
    }];
    
   
}

- (IBAction)systhsize:(id)sender {
    [ECG3USB spliceWithFileNames:@[@"ECGSDK_20180808010203",@"ECGSDK_20180808030203"] successBlock:^(NSDictionary *dic) {
        NSLog(@"result:%@",dic);
         self.ecg3USBTextView.text = [NSString stringWithFormat:@"systhsize result:%@",dic];
    } errorBlock:^(ECG3USBError error, NSString *message) {
        NSLog(@"result:%@",message);
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
