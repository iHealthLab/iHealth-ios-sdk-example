//
//  DeviceNT13BViewController.m
//  iHealthDemoCode
//
//  Created by user on 2019/9/20.
//  Copyright © 2019 iHealth Demo Code. All rights reserved.
//

#import "DevicePT3SBTViewController.h"
#import "PT3SBTMacroFile.h"
#import "PT3SBT.h"
#import "PT3SBTController.h"
#import "SDKFlowUpdateDevice.h"

@interface DevicePT3SBTViewController ()

@property (weak, nonatomic) IBOutlet UITextView *pt3sbtTextView;

@property (weak, nonatomic) IBOutlet UILabel *deviceLabel;

@property (weak, nonatomic) IBOutlet UILabel *resultLabel;

@property (strong, nonatomic) PT3SBT *myPT3SBT;

@end

@implementation DevicePT3SBTViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    
    NSString*deviceMac=[userDefault valueForKey:@"SelectDeviceMac"];
    
    self.deviceLabel.text=[NSString stringWithFormat:@"PT3SBT %@",deviceMac];
    
    NSArray*deviceArray=[[PT3SBTController shareIHPT3SBTController] getAllCurrentPT3SBTInstace];
    
    for(PT3SBT *device in deviceArray){
        
        if([deviceMac isEqualToString:device.serialNumber]){
            
            self.myPT3SBT=device;
            
        }
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(devicePT3SBTResult:) name:@"PT3SBTNotificationGetResult" object:nil];
    
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(devicePT3SBTUnitChange:) name:@"PT3SBTNotificationDeviceUnitChange" object:nil];
    
    
}

-(void)devicePT3SBTResult:(NSNotification *)tempNoti{
 
    NSDictionary*deviceDic= [tempNoti userInfo];
    
    self.pt3sbtTextView.text=[NSString stringWithFormat:@"%@:%@\n%@",NSLocalizedString(@"Result", @""),deviceDic,self.pt3sbtTextView.text];
    
}


-(void)devicePT3SBTUnitChange:(NSNotification *)tempNoti{
 
    NSDictionary*deviceDic= [tempNoti userInfo];
    
    self.pt3sbtTextView.text=[NSString stringWithFormat:@"%@:%@\n%@",NSLocalizedString(@"UnitChange", @""),[deviceDic valueForKey:@"unit"],self.pt3sbtTextView.text];
    
}

- (IBAction)Cancel:(id)sender {
    
    [self.myPT3SBT commandDisconnectDevice];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)getFunction:(id)sender{
    
    [self.myPT3SBT commandFunction:^(NSDictionary *functionDict) {
        
        NSLog(@"%@",functionDict);
        
         self.pt3sbtTextView.text=[NSString stringWithFormat:@"%@:%@\n%@",NSLocalizedString(@"getFunction", @""),functionDict,self.pt3sbtTextView.text];
        
    } DisposeErrorBlock:^(PT3SBTDeviceError error) {
        
    }];
  
}
- (IBAction)getBattery:(id)sender{
    
    [self.myPT3SBT commandGetPT3SBTBattery:^(NSNumber *battary) {
        
         self.pt3sbtTextView.text=[NSString stringWithFormat:@"%@:%@\n%@",NSLocalizedString(@"battary", @""),battary,self.pt3sbtTextView.text];
        
    } DiaposeErrorBlock:^(PT3SBTDeviceError error) {
        
    }];
  
}
- (IBAction)getDeviceUnit:(id)sender{
    
    [self.myPT3SBT commandPT3SBTGetUnit:^(PT3SBTTemperatureUnit unit) {
        
        self.pt3sbtTextView.text=[NSString stringWithFormat:@"%@:%ld\n%@",NSLocalizedString(@"GetUnit", @""),(long)unit,self.pt3sbtTextView.text];
        
    } DisposeErrorBlock:^(PT3SBTDeviceError error) {
        
    }];
  
}
- (IBAction)setUnit:(id)sender{
    
    [self.myPT3SBT commandPT3SBTSetUnit:PT3SBTTemperatureUnit_C DisposeSetUnitResult:^(BOOL setResult) {
        
        self.pt3sbtTextView.text=[NSString stringWithFormat:@"%@:%d\n%@",NSLocalizedString(@"setUnit", @""),setResult,self.pt3sbtTextView.text];
        
    } DisposeErrorBlock:^(PT3SBTDeviceError error) {
        
    }];
  
}
- (IBAction)getMemoryCount:(id)sender{
    
    [self.myPT3SBT commandPT3SBTGetMemoryCount:^(NSNumber *count) {
        
         self.pt3sbtTextView.text=[NSString stringWithFormat:@"%@:%@\n%@",NSLocalizedString(@"count", @""),count,self.pt3sbtTextView.text];
        
    } DisposeErrorBlock:^(PT3SBTDeviceError error) {
        
    }];
  
}
- (IBAction)getMemoryData:(id)sender{
    
    [self.myPT3SBT commandGetMemorryData:^(NSMutableArray *memoryDataArray) {
        
        self.pt3sbtTextView.text=[NSString stringWithFormat:@"%@:%@\n%@",NSLocalizedString(@"memoryDataArray", @""),memoryDataArray,self.pt3sbtTextView.text];
        
    } DisposeErrorBlock:^(PT3SBTDeviceError error) {
        
    }];
  
}
- (IBAction)deleteData:(id)sender{
    
    [self.myPT3SBT commandDeleteMemorryData:^(BOOL deleteResult) {
        
         self.pt3sbtTextView.text=[NSString stringWithFormat:@"%@:%d\n%@",NSLocalizedString(@"deleteData", @""),deleteResult,self.pt3sbtTextView.text];
        
    } DisposeErrorBlock:^(PT3SBTDeviceError error) {
        
    }];
  
}
- (IBAction)getDeviceInfo:(id)sender{
    
    [self.myPT3SBT commandGetDeviceInfo:^(NSDictionary *deviceInfoDic) {
        
          self.pt3sbtTextView.text=[NSString stringWithFormat:@"%@:%@\n%@",NSLocalizedString(@"deviceInfoDic", @""),deviceInfoDic,self.pt3sbtTextView.text];
        
    } DisposeErrorBlock:^(PT3SBTDeviceError error) {
        
    }];
  
}


- (IBAction)commandGetDeviceVersion:(id)sender {

    [[SDKFlowUpdateDevice shareSDKUpdateDeviceInstance] commandGetUpdateVersionWithDeviceUUID:self.myPT3SBT.currentUUID DeviceType:UpdateFlowDeviceType_PT3SBT DisposeUpdateVersionResult:^(NSDictionary *updateVersionDic) {
        
        NSLog(@"updateVersionDic:%@",updateVersionDic);
        
         self.pt3sbtTextView.text=[NSString stringWithFormat:@"%@:%@\n%@",NSLocalizedString(@"PT3SBT updateVersionDic", @""),updateVersionDic,self.pt3sbtTextView.text];
        
    } DisposeErrorBlock:^(UpdateFlowDeviceError errorID) {
        
        [self PT3SBTUpdataError:errorID];
    }];
  
    
   
}

- (IBAction)commandGetUpdateModuleState:(id)sender {
    
    [[SDKFlowUpdateDevice shareSDKUpdateDeviceInstance] commandGetUpdateModuleState:^(NSNumber *updateModuleState) {
        
        
        NSLog(@"updateModuleState:%@",updateModuleState);
        
        self.pt3sbtTextView.text=[NSString stringWithFormat:@"%@:%@\n%@",NSLocalizedString(@"PT3SBT updateModuleState", @""),updateModuleState,self.pt3sbtTextView.text];
        
    }];
    
    
    
}



- (IBAction)commandUpdataDevice:(id)sender {
    
   
    [[SDKFlowUpdateDevice shareSDKUpdateDeviceInstance] commandStartUpdateWithDeviceUUID:self.myPT3SBT.currentUUID DeviceType:UpdateFlowDeviceType_PT3SBT DownloadFirmwareStart:^{
        
        NSLog(@"DownloadFirmwareStart");
        
        self.pt3sbtTextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"PT3SBT DownloadFirmwareStart", @""),self.pt3sbtTextView.text];
        
    } DisposeDownloadFirmwareFinish:^{
        
         NSLog(@"DisposeDownloadFirmwareFinish");
        
        self.pt3sbtTextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"PT3SBT DisposeDownloadFirmwareFinish", @""),self.pt3sbtTextView.text];
        
    } DisposeDownloadProgress:^(NSNumber *progress) {
        
        NSLog(@"DisposeDownloadProgress:%@",progress);
        
        self.pt3sbtTextView.text=[NSString stringWithFormat:@"%@:%@\n%@",NSLocalizedString(@"PT3SBT DisposeDownloadProgress", @""),progress,self.pt3sbtTextView.text];
        
    } DisposeUpdateProgress:^(NSNumber *progress) {
        
        NSLog(@"DisposeUpdateProgress:%@",progress);
        
        self.pt3sbtTextView.text=[NSString stringWithFormat:@"%@:%@\n%@",NSLocalizedString(@"PT3SBT DisposeUpdateProgress", @""),progress,self.pt3sbtTextView.text];
        
    } DisposeUpdateResult:^(NSNumber *updateResult) {
        
        NSLog(@"updateResult:%@",updateResult);
        
        self.pt3sbtTextView.text=[NSString stringWithFormat:@"%@:%@\n%@",NSLocalizedString(@"PT3SBT updateResult", @""),updateResult,self.pt3sbtTextView.text];
        
    } TransferSuccess:^(NSNumber *transferSuccess) {
        
         NSLog(@"transferSuccess:%@",transferSuccess);
        
        self.pt3sbtTextView.text=[NSString stringWithFormat:@"%@:%@\n%@",NSLocalizedString(@"PT3SBT transferSuccess", @""),transferSuccess,self.pt3sbtTextView.text];
        
    } DisposeErrorBlock:^(UpdateFlowDeviceError errorID) {
        
        [self PT3SBTUpdataError:errorID];
        
    }];

}

- (IBAction)commandUpdataDeviceWithLocalFile:(id)sender {
    
    
    NSString *fileinfoPath = [[NSBundle mainBundle] pathForResource:@"PT3SBT 110701.1.01.1.1info" ofType:@"bin"];
    
    NSString *fileFirPath = [[NSBundle mainBundle] pathForResource:@"PT3SBT 110701.1.01.1.1Firmware" ofType:@"bin"];
    
    [[SDKFlowUpdateDevice shareSDKUpdateDeviceInstance] commandStartUpdateWithDeviceUUID:self.myPT3SBT.currentUUID DeviceType:UpdateFlowDeviceType_PT3SBT InfoFilePath:fileinfoPath UpadteFilePath:fileFirPath DisposeUpdateProgress:^(NSNumber *progress) {
        
        NSLog(@"DisposeUpdateProgress:%@",progress);
        
        self.pt3sbtTextView.text=[NSString stringWithFormat:@"%@:%@\n%@",NSLocalizedString(@"PT3SBT DisposeUpdateProgress", @""),progress,self.pt3sbtTextView.text];
        
    } DisposeUpdateResult:^(NSNumber *updateResult) {
        
        NSLog(@"updateResult:%@",updateResult);
        
        self.pt3sbtTextView.text=[NSString stringWithFormat:@"%@:%@\n%@",NSLocalizedString(@"PT3SBT updateResult", @""),updateResult,self.pt3sbtTextView.text];
        
    } TransferSuccess:^(NSNumber *transferSuccess) {
        
        NSLog(@"transferSuccess:%@",transferSuccess);
        
        self.pt3sbtTextView.text=[NSString stringWithFormat:@"%@:%@\n%@",NSLocalizedString(@"PT3SBT transferSuccess", @""),transferSuccess,self.pt3sbtTextView.text];
        
    } DisposeErrorBlock:^(UpdateFlowDeviceError errorID) {
        
     [self PT3SBTUpdataError:errorID];
        
    }];
    
    
}

- (IBAction)commandStopUpdataDevice:(id)sender {
    
    [[SDKFlowUpdateDevice shareSDKUpdateDeviceInstance] commandEndUpdateWithDeviceUUID:self.myPT3SBT.currentUUID DeviceType:UpdateFlowDeviceType_PT3SBT DisposeEndUpdateResult:^(NSNumber *endUpdate) {
        
        NSLog(@"HS2S endUpdate:%@",endUpdate);
        
         self.pt3sbtTextView.text=[NSString stringWithFormat:@"%@:%@\n%@",NSLocalizedString(@"PT3SBT endUpdate", @""),endUpdate,self.pt3sbtTextView.text];
        
    } DisposeErrorBlock:^(UpdateFlowDeviceError errorID) {
        
        [self PT3SBTUpdataError:errorID];
        
    }];
}


-(void)PT3SBTUpdataError:(UpdateFlowDeviceError)errorID{
    
    NSString*errorDetail=[NSString string];
    
    switch (errorID) {
        case UpdateFlowNetworkError:
            errorDetail=@"UpdateNetworkError";
            break;
        case UpdateFlowOrderError:
            errorDetail=@"UpdateOrderError";
            break;
        case UpdateFlowDeviceDisconnect:
            errorDetail=@"UpdateDeviceDisconnect";
            break;
        case UpdateFlowDeviceEnd:
            errorDetail=@"UpdateDeviceEnd";
            break;
        case UpdateFlowInputError:
            errorDetail=@"UpdateInputError";
            break;
        case UpdateFlowNOUpdateUpgrade:
            errorDetail=@"NOUpdateUpgrade";
            break;
        case UpdateFlowErrorLowPower:
            errorDetail=@"UpdateErrorLowPower";
            break;
        case UpdateFlowErrorMeasuring:
            errorDetail=@"UpdateErrorMeasuring";
            break;
        case UpdateFlowErrorUnKnow:
            errorDetail=@"UpdateErrorUnKnow";
            break;
       
    }
    
    self.pt3sbtTextView.text=[NSString stringWithFormat:@"%@:%lu detial:%@\n%@",NSLocalizedString(@"PT3SBTUpdataError", @""),(unsigned long)errorID,errorDetail,self.pt3sbtTextView.text];
    
    NSLog(@"Error Detail:%@",errorDetail);
}


- (IBAction)disconnect:(id)sender{
    
   
    [self.myPT3SBT commandDisconnectDevice];
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
