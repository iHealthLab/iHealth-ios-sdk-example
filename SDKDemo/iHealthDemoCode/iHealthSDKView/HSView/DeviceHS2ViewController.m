//
//  DeviceHS2ViewController.m
//  iHealthDemoCode
//
//  Created by jing on 2018/10/22.
//  Copyright © 2018年 iHealth Demo Code. All rights reserved.
//

#import "DeviceHS2ViewController.h"
#import "HSHeader.h"
#import "SDKUpdateDevice.h"
@interface DeviceHS2ViewController ()
@property (weak, nonatomic) IBOutlet UITextView *hs2TextView;

@property (weak, nonatomic) IBOutlet UILabel *deviceLabel;

@property (strong, nonatomic) HS2 *myHS2;
@end

@implementation DeviceHS2ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    
    NSString*deviceMac=[userDefault valueForKey:@"SelectDeviceMac"];
    
    self.deviceLabel.text=[NSString stringWithFormat:@"HS2 %@",deviceMac];
    
    NSArray*deviceArray=[[HS2Controller shareIHHs2Controller] getAllCurrentHS2Instace];
    
    for(HS2 *device in deviceArray){
        
        if([deviceMac isEqualToString:device.deviceID]){
            
            self.myHS2=device;
            
        }
    }
}
- (IBAction)Cancel:(id)sender {
    
    [self.myHS2 commandDisconnectDevice];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)commandHS2GetMemoryPressed:(id)sender{
    
    [self.myHS2 commandHS2TransferMemorryData:^(NSDictionary *numberDic) {
        
        NSLog(@"HS2_StartTransferMemorryData:%@",numberDic);
        
        self.hs2TextView.text=[NSString stringWithFormat:@"%@:%@\n%@",NSLocalizedString(@"MemoryData", @""),numberDic,self.hs2TextView.text];
        
       
        
    } DisposeProgress:^(NSNumber *progress) {
        
        NSLog(@"HS2_progress:%@",progress);
        self.hs2TextView.text=[NSString stringWithFormat:@"%@:%@\n%@",NSLocalizedString(@"progress", @""),progress,self.hs2TextView.text];

    } MemorryData:^(NSArray *historyDataArray) {
        
        NSLog(@"HS2_historyDataArray:%@",historyDataArray);
        self.hs2TextView.text=[NSString stringWithFormat:@"%@:%@\n%@",NSLocalizedString(@"AllMemoryData", @""),historyDataArray,self.hs2TextView.text];

    } FinishTransmission:^{
        
        self.hs2TextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"FinishOfflineData", @""),self.hs2TextView.text];

    } DisposeErrorBlock:^(HS2DeviceError errorID) {
        
        
         [self HS2Error:errorID];
    }];
}
- (IBAction)commandHS2MeasurePressed:(id)sender{
    
    [self.myHS2 commandHS2MeasureWithUint:HSUnit_Kg Weight:^(NSNumber *unStableWeight) {
        
        NSLog(@"HS2_unStableWeight:%@",unStableWeight);
        
        self.hs2TextView.text=[NSString stringWithFormat:@"%@:%@\n%@",NSLocalizedString(@"unStableWeight", @""),unStableWeight,self.hs2TextView.text];

        
    } StableWeight:^(NSDictionary *StableWeightDic) {
        
        NSLog(@"HS2_StableWeightDic:%@",StableWeightDic);
        
        self.hs2TextView.text=[NSString stringWithFormat:@"%@:%@\n%@",NSLocalizedString(@"StableWeight", @""),StableWeightDic,self.hs2TextView.text];

    } DisposeErrorBlock:^(HS2DeviceError errorID) {
        
         [self HS2Error:errorID];
        
    }];
    
}
- (IBAction)commandHS2Battery:(id)sender {
   
    [self.myHS2 commandGetHS2Battery:^(NSNumber *battary) {
        NSLog(@"Energy:%@",battary);
        
        self.hs2TextView.text=[NSString stringWithFormat:@"%@:%@\n%@",NSLocalizedString(@"Energy", @""),battary,self.hs2TextView.text];

    } DiaposeErrorBlock:^(HS2DeviceError errorID) {
        [self HS2Error:errorID];
    }];
}

- (IBAction)commandDisHS2Pressed:(id)sender{
    
    
    [self.myHS2 commandDisconnectDevice];

}
-(void)HS2Error:(HS2DeviceError)errorID{
    
    switch (errorID) {
        case HS2DataZeor:
            self.hs2TextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"No memory", @""),self.hs2TextView.text];
            break;
        case HS2DeviceEr0:
            self.hs2TextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"The Scale failed to initialize", @""),self.hs2TextView.text];
            break;
        case HS2DeviceEr1:
            self.hs2TextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"Maximum weight has been exceeded", @""),self.hs2TextView.text];
            break;
        case HS2DeviceEr2:
            self.hs2TextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"The Scale can't capture a steady reading", @""),self.hs2TextView.text];
            break;
        case HS2DeviceEr4:
            self.hs2TextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"Bluetooth connection error", @""),self.hs2TextView.text];
            break;
        case HS2DeviceEr7:
            self.hs2TextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"Movement while measuring", @""),self.hs2TextView.text];
            break;
        case HS2DeviceEr8:
            self.hs2TextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"Invalidate", @""),self.hs2TextView.text];
            break;
        case HS2DeviceEr9:
        
            self.hs2TextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"Scale memory access error", @""),self.hs2TextView.text];
            break;
        
        case HS2DeviceLowPower:
            self.hs2TextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"Battery level is low", @""),self.hs2TextView.text];
            break;
        case HS2DeviceDisconnect:
            self.hs2TextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"Device disconnect", @""),self.hs2TextView.text];
            break;
        case HS2DeviceSendTimeout:
            self.hs2TextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"Communication error", @""),self.hs2TextView.text];
            break;
        case HS2DeviceRecWeightError:
            self.hs2TextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@" DeviceRecWeightError", @""),self.hs2TextView.text];
            break;
        
        default:
            break;
    }
    
    
}



- (IBAction)GetUpdateVersion:(id)sender {
    
    

    
    [[SDKUpdateDevice shareSDKUpdateDeviceInstance] commandGetUpdateVersionWithDeviceUUID:self.myHS2.currentUUID DisposeUpdateVersionResult:^(NSDictionary *updateVersionDic) {
         self.hs2TextView.text=[NSString stringWithFormat:@"%@:%@\n%@",NSLocalizedString(@"updateVersionDic", @""),updateVersionDic,self.hs2TextView.text];
    } DisposeErrorBlock:^(UpdateDeviceError errorID) {
        
    }];
}

- (IBAction)DownLoadUpdateVersion:(id)sender {
    
    [[SDKUpdateDevice shareSDKUpdateDeviceInstance] commandStartDownloadWithDeviceUUID:self.myHS2.currentUUID DownloadFirmwareStart:^{
        
         self.hs2TextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"DownloadFirmwareStart", @""),self.hs2TextView.text];
        
    } DisposeDownloadFirmwareFinish:^{
        
         self.hs2TextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"DownloadFirmwareFinish", @""),self.hs2TextView.text];
        
    } DisposeDownloadProgress:^(NSNumber *progress) {
        
         self.hs2TextView.text=[NSString stringWithFormat:@"%@:%@\n%@",NSLocalizedString(@"progress", @""),progress,self.hs2TextView.text];
        
    } DisposeErrorBlock:^(UpdateDeviceError errorID) {
        
       
        
    }];
    
}


- (IBAction)commandUpdate:(id)sender {
    
    [[SDKUpdateDevice shareSDKUpdateDeviceInstance] commandStartUpdateWithDeviceUUID:self.myHS2.currentUUID DisposeUpdateProgress:^(NSNumber *progress) {
        
         self.hs2TextView.text=[NSString stringWithFormat:@"%@:%@\n%@",NSLocalizedString(@"progress", @""),progress,self.hs2TextView.text];
        
    } DisposeUpdateResult:^(NSNumber *updateResult) {
        
         self.hs2TextView.text=[NSString stringWithFormat:@"%@:%@\n%@",NSLocalizedString(@"updateResult", @""),updateResult,self.hs2TextView.text];
        
    } TransferSuccess:^(NSNumber *transferSuccess) {
        
         self.hs2TextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"TransferSuccess", @""),self.hs2TextView.text];
        
    } DisposeErrorBlock:^(UpdateDeviceError errorID) {
        
     
        
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
