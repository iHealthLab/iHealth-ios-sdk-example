//
//  DeviceECG3ViewController.m
//  iHealthDemoCode
//
//  Created by jing on 2018/10/22.
//  Copyright © 2018年 iHealth Demo Code. All rights reserved.
//

#import "DeviceECG3ViewController.h"
#import "ECGHeader.h"
@interface DeviceECG3ViewController ()
@property (weak, nonatomic) IBOutlet UITextView *ecg3TextView;

@property (weak, nonatomic) IBOutlet UILabel *deviceLabel;

@property (strong, nonatomic) ECG3 *myECG3;
@end

@implementation DeviceECG3ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    
    NSString*deviceMac=[userDefault valueForKey:@"SelectDeviceMac"];
    
    self.deviceLabel.text=[NSString stringWithFormat:@"ECG3 %@",deviceMac];
    
    NSArray*deviceArray=[[ECG3Controller shareECG3Controller] getAllCurrentECG3Instace];
    
    for(ECG3 *device in deviceArray){
        
        if([deviceMac isEqualToString:device.serialNumber]){
            
            self.myECG3=device;
            
        }
    }
}
- (IBAction)Cancel:(id)sender {
    
    [self.myECG3 disconnectDevice];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)syncTime:(id)sender {
    [self.myECG3 commandECG3SyncTime:^{
         self.ecg3TextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"SetTimeSucess", @""),self.ecg3TextView.text];
    } withErrorBlock:^(ECG3ErrorID errorId) {
        [self ECGDeviceError:errorId];
    }];
}
- (IBAction)getBattery:(id)sender {
    [self.myECG3 commandECG3GetBatteryInfo:^(NSNumber *battery) {
        NSLog(@"battery: %@",battery);
         self.ecg3TextView.text=[NSString stringWithFormat:@"%@:%@\n%@",NSLocalizedString(@"Battery", @""),battery,self.ecg3TextView.text];
    } withErrorBlock:^(ECG3ErrorID errorId) {
        [self ECGDeviceError:errorId];
    }];
}
- (IBAction)commandECG3StartMeasure:(id)sender {
    [self.myECG3 commandECG3StartMeasure:^{
        self.ecg3TextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"StartMeasure", @""),self.ecg3TextView.text];

    } withWaveData:^(NSArray *waveDataArray) {
        self.ecg3TextView.text=[NSString stringWithFormat:@"%@:%@\n%@",NSLocalizedString(@"waveDataArray", @""),waveDataArray,self.ecg3TextView.text];
    } withPulseResult:^(BOOL hasHR, NSUInteger HR) {
        
        if (HR!=0) {
             self.ecg3TextView.text=[NSString stringWithFormat:@"%@:%lu %@:%d\n%@",NSLocalizedString(@"HR", @""),(unsigned long)HR,NSLocalizedString(@"hasHR", @""),hasHR,self.ecg3TextView.text];
        }
       
        
    } withErrorBlock:^(ECG3ErrorID errorId) {
        
        [self ECGDeviceError:errorId];
    }];
}
- (IBAction)commandECG3FinishMeasure:(id)sender {
    [self.myECG3 commandECG3FinishMeasure:^{
         self.ecg3TextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"FinishMeasure", @""),self.ecg3TextView.text];
    } withErrorBlock:^(ECG3ErrorID errorId) {
        [self ECGDeviceError:errorId];
    }];
}
- (IBAction)disconnectDevice:(id)sender {
    
    [self.myECG3 disconnectDevice];
     self.ecg3TextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"Device disconnect", @""),self.ecg3TextView.text];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


-(void)ECGDeviceError:(ECG3ErrorID)errorID{
    
    switch (errorID) {
        case ECG3Error_ElectrodeLoss:
            self.ecg3TextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"Electrode Loss", @""),self.ecg3TextView.text];
            break;
        case ECG3Error_ElectrodeLossRecovery:
            self.ecg3TextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"Electrode Loss Recovery", @""),self.ecg3TextView.text];
            break;
        case ECG3Error_ElectrodeLossTimeout:
            self.ecg3TextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"Electrode Loss Timeout", @""),self.ecg3TextView.text];
            break;
        case ECG3Error_SDCardCommunicationError:
            self.ecg3TextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"SDCard Communication Error", @""),self.ecg3TextView.text];
            break;
        case ECG3Error_SampleModuleError:
            self.ecg3TextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"Sample Module Error", @""),self.ecg3TextView.text];
            break;
        case ECG3Error_LowPower:
            self.ecg3TextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"Low Power", @""),self.ecg3TextView.text];
            break;
        case ECG3Error_DeviceMemoryFull:
            self.ecg3TextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"Device Memory Full", @""),self.ecg3TextView.text];
            break;
        case ECG3Error_Disconnect:
            self.ecg3TextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"Disconnect", @""),self.ecg3TextView.text];
            break;
        case ECG3Error_ParameterError:
            self.ecg3TextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"Parameter Error", @""),self.ecg3TextView.text];
            break;
        case ECG3Error_CommandTimeout:
            self.ecg3TextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"Command timeout", @""),self.ecg3TextView.text];
            break;
        default:
            break;
    }
    
}

@end
