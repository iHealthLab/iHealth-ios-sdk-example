//
//  DevicePO3ViewController.m
//  iHealthDemoCode
//
//  Created by jing on 2018/10/12.
//  Copyright © 2018年 iHealth Demo Code. All rights reserved.
//

#import "DevicePO3ViewController.h"
#import "POHeader.h"
#import "SDKUpdateDevice.h"
@interface DevicePO3ViewController ()
@property (weak, nonatomic) IBOutlet UITextView *po3TextView;

@property (weak, nonatomic) IBOutlet UILabel *deviceLabel;

@property (weak, nonatomic) IBOutlet UIButton *getVersionBtn;

@property (weak, nonatomic) IBOutlet UIButton *startUpdateBtn;

@property (strong, nonatomic) PO3 *myPO3;

@end

@implementation DevicePO3ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.getVersionBtn setTitle:NSLocalizedString(@"GetUpdateVersion", @"") forState:UIControlStateNormal];
    
    [self.startUpdateBtn setTitle:NSLocalizedString(@"StartUpdate", @"") forState:UIControlStateNormal];
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    
    NSString*deviceMac=[userDefault valueForKey:@"SelectDeviceMac"];
    
    self.deviceLabel.text=[NSString stringWithFormat:@"PO3M %@",deviceMac];
    
    NSArray*deviceArray=[[PO3Controller shareIHPO3Controller] getAllCurrentPO3Instace];
    
    for(PO3 *device in deviceArray){
        
        if([deviceMac isEqualToString:device.serialNumber]){
            
            self.myPO3=device;
           
        }
    }
    
}

- (IBAction)Cancel:(id)sender {
    
    [self.myPO3 commandPO3Disconnect:^(BOOL resetSuc) {
        
    } withErrorBlock:^(PO3ErrorID errorID) {
        
    }];
    
     [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)syncTime:(id)sender {
    
    [self.myPO3 commandPO3SyncTime:^(BOOL resetSuc) {
        
        self.po3TextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"SetTimeSucess", @""),self.po3TextView.text];
        
    } withErrorBlock:^(PO3ErrorID errorID) {
        [self PO3Error:errorID];
    }];
}
- (IBAction)Measure:(id)sender {
    
    [self.myPO3 commandPO3StartMeasure:^(BOOL resetSuc) {
         self.po3TextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"StartMeasure", @""),self.po3TextView.text];
    } withMeasureData:^(NSDictionary *measureDataDic) {
        self.po3TextView.text=[NSString stringWithFormat:@"%@:%@\n%@",NSLocalizedString(@"measureData", @""),measureDataDic,self.po3TextView.text];
        
        NSLog(@"measureDataDic:%@",measureDataDic);
    } withFinishMeasure:^(BOOL finishData) {
        self.po3TextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"FinishMeasure", @""),self.po3TextView.text];
    } withErrorBlock:^(PO3ErrorID errorID) {
        
        [self PO3Error:errorID];
    }];
}

- (IBAction)Disconnect:(id)sender {
    
    [self.myPO3 commandPO3Disconnect:^(BOOL resetSuc) {
        
         self.po3TextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"Disconnect", @""),self.po3TextView.text];
        
    } withErrorBlock:^(PO3ErrorID errorID) {
        
        [self PO3Error:errorID];
    }];
}
- (IBAction)GetOfflineData:(id)sender {
    
    [self.myPO3 commandPO3OfflineDataCount:^(NSNumber *dataCount) {
        
         self.po3TextView.text=[NSString stringWithFormat:@"%@:%@\n%@",NSLocalizedString(@"OfflineDataCount", @""),dataCount,self.po3TextView.text];
        
    } withOfflineData:^(NSDictionary *OfflineData) {
        self.po3TextView.text=[NSString stringWithFormat:@"%@:%@\n%@",NSLocalizedString(@"OfflineData", @""),OfflineData,self.po3TextView.text];
    } withOfflineWaveData:^(NSDictionary *offlineWaveDataDic) {
         self.po3TextView.text=[NSString stringWithFormat:@"%@:%@\n%@",NSLocalizedString(@"offlineWaveDataDic", @""),offlineWaveDataDic,self.po3TextView.text];
    } withFinishMeasure:^(BOOL resetSuc) {
        self.po3TextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"FinishOfflineData", @""),self.po3TextView.text];
    } withErrorBlock:^(PO3ErrorID errorID) {
        [self PO3Error:errorID];
    }];
}
- (IBAction)GetBattery:(id)sender {
    
    [self.myPO3 commandPO3GetDeviceBattery:^(NSNumber *battery) {
        
        self.po3TextView.text=[NSString stringWithFormat:@"%@:%@\n%@",NSLocalizedString(@"Battery", @""),battery,self.po3TextView.text];
        
    } withErrorBlock:^(PO3ErrorID errorID) {
       [self PO3Error:errorID];
    }];
}

- (IBAction)GetUpdateVersion:(id)sender {
    
    
    
    if ([self.myPO3.firmwareVersion isEqualToString:@"1.0.1"]||[self.myPO3.firmwareVersion isEqualToString:@"1.0.2"]||[self.myPO3.firmwareVersion isEqualToString:@"1.0.3"]||[self.myPO3.firmwareVersion isEqualToString:@"1.0.4"]||[self.myPO3.firmwareVersion isEqualToString:@"1.0.5"])
    {
       self.po3TextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"This version device can not update", @""),self.po3TextView.text];
        
        return;
    }
    
    [[SDKUpdateDevice shareSDKUpdateDeviceInstance] commandGetUpdateVersionWithDeviceUUID:self.myPO3.currentUUID DisposeUpdateVersionResult:^(NSDictionary *updateVersionDic) {
         self.po3TextView.text=[NSString stringWithFormat:@"%@:%@\n%@",NSLocalizedString(@"updateVersionDic", @""),updateVersionDic,self.po3TextView.text];
    } DisposeErrorBlock:^(UpdateDeviceError errorID) {
         [self UpdateDeviceError:errorID];
    }];
}

- (IBAction)StartUpdate:(id)sender {
    
    if ([self.myPO3.firmwareVersion isEqualToString:@"1.0.1"]||[self.myPO3.firmwareVersion isEqualToString:@"1.0.2"]||[self.myPO3.firmwareVersion isEqualToString:@"1.0.3"]||[self.myPO3.firmwareVersion isEqualToString:@"1.0.4"]||[self.myPO3.firmwareVersion isEqualToString:@"1.0.5"])
    {
        self.po3TextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"This version device can not update", @""),self.po3TextView.text];
        
        return;
    }
    
    [[SDKUpdateDevice shareSDKUpdateDeviceInstance]commandStartUpdateWithDeviceUUID:self.myPO3.currentUUID DownloadFirmwareStart:^{
        
        self.po3TextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"DownloadFirmwareStart", @""),self.po3TextView.text];
        
    } DisposeDownloadFirmwareFinish:^{
        self.po3TextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"DownloadFirmwareFinish", @""),self.po3TextView.text];
    } DisposeUpdateProgress:^(NSNumber *progress) {
         self.po3TextView.text=[NSString stringWithFormat:@"%@:%@\n%@",NSLocalizedString(@"progress", @""),progress,self.po3TextView.text];
    } DisposeUpdateResult:^(NSNumber *updateResult) {
         self.po3TextView.text=[NSString stringWithFormat:@"%@:%@\n%@",NSLocalizedString(@"updateResult", @""),updateResult,self.po3TextView.text];
    } TransferSuccess:^(NSNumber *transferSuccess) {
        self.po3TextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"TransferSuccess", @""),self.po3TextView.text];
    } DisposeErrorBlock:^(UpdateDeviceError errorID) {
        [self UpdateDeviceError:errorID ];
    }];
}
-(void)UpdateDeviceError:(UpdateDeviceError)errorID{
    
    switch (errorID) {
        case UpdateNetworkError:
            self.po3TextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"UpdateNetworkError", @""),self.po3TextView.text];
            break;
        case UpdateOrderError:
            self.po3TextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"Before starting the upgrade must go to query version first", @""),self.po3TextView.text];
            break;
        case UpdateDeviceDisconnect:
            self.po3TextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"UpdateDeviceDisconnect", @""),self.po3TextView.text];
            break;
        case UpdateDeviceEnd:
            self.po3TextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"UpdateDeviceEnd", @""),self.po3TextView.text];
            break;
        case UpdateInputError:
            self.po3TextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"UpdateInputError", @""),self.po3TextView.text];
            break;
        case NOUpdateUpgrade:
            self.po3TextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"cannot update", @""),self.po3TextView.text];
            break;
       
        default:
            break;
    }
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void)PO3Error:(PO3ErrorID)errorID{
    
    switch (errorID) {
        case PO3Error_OverTime:
             self.po3TextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"PO3Error_OverTime", @""),self.po3TextView.text];
            break;
        case PO3Error_ResetDeviceFaild:
            self.po3TextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"PO3Error_ResetDeviceFaild", @""),self.po3TextView.text];
            break;
        case PO3Error_Disconnect:
            self.po3TextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"PO3Error_Disconnect", @""),self.po3TextView.text];
            break;
        case PO3Error_ParameterError:
            self.po3TextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"PO3Error_ParameterError", @""),self.po3TextView.text];
            break;
        case PO3Error_FirmwareVersionIsNotSupported:
            self.po3TextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"PO3Error_FirmwareVersionIsNotSupported", @""),self.po3TextView.text];
            break;
            
        default:
            break;
    }
    
    
}
@end
