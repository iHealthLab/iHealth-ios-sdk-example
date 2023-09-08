//
//  DeviceHS2SViewController.m
//  iHealthDemoCode
//
//  Created by jing on 2019/4/28.
//  Copyright © 2019 iHealth Demo Code. All rights reserved.
//

#import "DeviceHS2SProViewController.h"
#import "HSHeader.h"
#import "SDKFlowUpdateDevice.h"

#import <CommonCrypto/CommonHMAC.h>
#import <CommonCrypto/CommonCryptor.h>

@interface DeviceHS2SProViewController ()

@property (weak, nonatomic) IBOutlet UITextView *hs2sPROTextView;

@property (weak, nonatomic) IBOutlet UILabel *deviceLabel;

@property (strong, nonatomic) HS2SPRO *myHS2SPRO;

@property (strong, nonatomic) NSData *myHS2SPROUserID;

@end

@implementation DeviceHS2SProViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    
    NSString*deviceMac=[userDefault valueForKey:@"SelectDeviceMac"];
    
    self.deviceLabel.text=[NSString stringWithFormat:@"HS2S PRO %@",deviceMac];
    
    NSArray*deviceArray=[[HS2SPROController shareIHHS2SPROController] getAllCurrentHS2SPROInstace];

    for(HS2SPRO *device in deviceArray){

        if([deviceMac isEqualToString:device.serialNumber]){
            
            self.myHS2SPRO=device;

        }
    }
    
     [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(DeviceDisConnect:) name:HS2SPRODisConnectNoti object:nil];
}

-(void)DeviceDisConnect:(NSNotification *)tempNoti{
    
     self.hs2sPROTextView.text=[NSString stringWithFormat:@"%@:%@\n%@",NSLocalizedString(@"HS2SPRODisconnect", @""),[tempNoti userInfo],self.hs2sPROTextView.text];
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
- (IBAction)Cancel:(id)sender {
    
    [self.myHS2SPRO commandDisconnectDevice];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)setUnit:(id)sender {
    [self.myHS2SPRO commandSetHS2SPROUnit:HSUnit_LB successBlock:^{
        NSLog(@"set unit success");
    } disposeErrorBlock:^(HS2SPRODeviceError errorID) {
        [self HS2SPROError:errorID];
    }];

}

- (IBAction)commandGetHS2SPRODeviceInfo:(id)sender {
    
    
    [self.myHS2SPRO commandGetHS2SPRODeviceInfo:^(NSDictionary *deviceInfo) {
        
        NSLog(@"HS2S PRO deviceInfo:%@",deviceInfo);
        
         self.hs2sPROTextView.text=[NSString stringWithFormat:@"%@:%@\n%@",NSLocalizedString(@"HS2S PRO deviceInfo", @""),deviceInfo,self.hs2sPROTextView.text];
        
    } disposeErrorBlock:^(HS2SPRODeviceError errorID) {
        [self HS2SPROError:errorID];
    }];
}

- (IBAction)commandGetHS2SPROBattery:(id)sender {
    
    
    [self.myHS2SPRO commandGetHS2SPROBattery:^(NSNumber *battary) {
        
         NSLog(@"HS2S PRO battary:%@",battary);
        
         self.hs2sPROTextView.text=[NSString stringWithFormat:@"%@:%@\n%@",NSLocalizedString(@"HS2S PRO battary", @""),battary,self.hs2sPROTextView.text];
        
    } disposeErrorBlock:^(HS2SPRODeviceError errorID) {
        [self HS2SPROError:errorID];
    }];
}

- (IBAction)commandSetHS2SPROBLE:(id)sender {
    
    
//    [self.myHS2S commandSetBLEConnectInterval:@0 result:^{
//        
//        self.hs2sPROTextView.text=[NSString stringWithFormat:@"%@:%hhd\n%@",NSLocalizedString(@"HS2S SetBLE", @""),result,self.hs2sPROTextView.text];
//        
//    } disposeErrorBlock:^(HS2SDeviceError errorID) {
//        [self HS2SError:errorID];
//    }];
}

- (IBAction)commandGetHS2SPROUserInfo:(id)sender {
    
    [self.myHS2SPRO commandGetHS2SPROUserInfo:^(NSArray<HS2SProUser *> * _Nonnull array) {
        for (HS2SProUser *obj in array) {
            NSLog(@"%@",[obj debugDescription]);
        }
    } disposeErrorBlock:^(HS2SPRODeviceError errorID) {
        [self HS2SPROError:errorID];
    }];
}
- (IBAction)commandUpdateHS2SPROUserInfoWithUser:(id)sender {
    
    HS2SProUser *user = [HS2SProUser new];
    user.userId = [self md5:@"your_user_id"];
    user.createTS = [[NSDate date] timeIntervalSince1970];
    user.gender = HS2SProGender_Male;
    user.age = 25;
    user.height = 180;
    user.weight = 75.0f;
    user.enableMeasureImpedance = YES;
    user.enableFitness = NO;
    
    [self.myHS2SPRO commandUpdateHS2SPROUserInfoWithUser:user successBlock:^{
        
        NSLog(@"HS2S PRO UpdateHS2SPROUserInfo:success");
        
        self.hs2sPROTextView.text=[NSString stringWithFormat:@"%@:success\n%@",NSLocalizedString(@"HS2S UpdateHS2SUserInfo", @""),self.hs2sPROTextView.text];
        
    } disposeErrorBlock:^(HS2SPRODeviceError errorID) {
        [self HS2SPROError:errorID];
    }];
}
- (IBAction)commandDeleteHS2SPROUserWithUserID:(id)sender {
    
    [self.myHS2SPRO commandDeleteHS2SPROUserWithUserId:[self md5:@"your_user_id"] successBlock:^{
        
        NSLog(@"HS2S PRO DeleteHS2SPROUser:success");
        
         self.hs2sPROTextView.text=[NSString stringWithFormat:@"%@:success\n%@",NSLocalizedString(@"HS2S DeleteHS2SUser", @""),self.hs2sPROTextView.text];
        
    } disposeErrorBlock:^(HS2SPRODeviceError errorID) {
        [self HS2SPROError:errorID];
    }];
}
- (IBAction)commandGetHS2SPROMemoryDataCountWithUserID:(id)sender {
    
    
    [self.myHS2SPRO commandGetHS2SPROMemoryDataCountWithUserId:[self md5:@"your_user_id"] successBlock:^(NSNumber *count) {
        
        NSLog(@"HS2S PRO GetHS2SPROMemoryDataCount:%@",count);
        
        self.hs2sPROTextView.text=[NSString stringWithFormat:@"%@:%@\n%@",NSLocalizedString(@"HS2S GetHS2SMemoryDataCount", @""),count,self.hs2sPROTextView.text];
        
    } disposeErrorBlock:^(HS2SPRODeviceError errorID) {
        [self HS2SPROError:errorID];
    }];
}

- (IBAction)commandGetHS2SPROMemoryDataWithUserID:(id)sender {
    
    
    [self.myHS2SPRO commandGetHS2SPROMemoryDataWithUserId:[self md5:@"your_user_id"] successBlock:^(NSArray *data) {
        
         NSLog(@"HS2S PRO GetHS2SPROMemoryData:%@",data);
        
         self.hs2sPROTextView.text=[NSString stringWithFormat:@"%@:%@\n%@",NSLocalizedString(@"HS2S GetHS2SMemoryData", @""),data,self.hs2sPROTextView.text];
        
    } disposeErrorBlock:^(HS2SPRODeviceError errorID) {
        [self HS2SPROError:errorID];
    }];
}

- (IBAction)commandDeleteHS2SPROMemoryDataWithUserID:(id)sender {
    
    HealthUser*user=[HealthUser new];
    
    if (self.myHS2SPROUserID==nil) {
        
        NSData *data =[@"iHealth123456787" dataUsingEncoding:NSUTF8StringEncoding];
        
        user.hs2SPROUserID=data;
        
    }else{
        
        user.hs2SPROUserID=self.myHS2SPROUserID;
    }
    
    
    [self.myHS2SPRO commandDeleteHS2SPROMemoryDataWithUserId:user.hs2SPROUserID successBlock:^{
        
        NSLog(@"DeleteHS2SPROMemoryData:success");
        
         self.hs2sPROTextView.text=[NSString stringWithFormat:@"%@:success\n%@",NSLocalizedString(@"HS2S DeleteHS2SMemoryData", @""),self.hs2sPROTextView.text];
        
    } disposeErrorBlock:^(HS2SPRODeviceError errorID) {
        [self HS2SPROError:errorID];
    }];
}

- (IBAction)commandGetHS2SAnonymousMemoryDataCount:(id)sender {
    
    
    [self.myHS2SPRO commandGetHS2SPROAnonymousMemoryDataCount:^(NSNumber *count) {
        
        NSLog(@"GetHS2SPROAnonymousMemoryDataCount:%@",count);
        
        self.hs2sPROTextView.text=[NSString stringWithFormat:@"%@:%@\n%@",NSLocalizedString(@"HS2S GetHS2SAnonymousMemoryDataCount", @""),count,self.hs2sPROTextView.text];
        
    } disposeErrorBlock:^(HS2SPRODeviceError errorID) {
        [self HS2SPROError:errorID];
    }];
}

- (IBAction)commandGetHS2SPROAnonymousMemoryData:(id)sender {
    
    
    [self.myHS2SPRO commandGetHS2SPROAnonymousMemoryData:^(NSArray *data) {
        
        NSLog(@"GetHS2SPROAnonymousMemoryData:%@",data);
        
        self.hs2sPROTextView.text=[NSString stringWithFormat:@"%@:%@\n%@",NSLocalizedString(@"HS2S GetHS2SAnonymousMemoryData", @""),data,self.hs2sPROTextView.text];
        
    } disposeErrorBlock:^(HS2SPRODeviceError errorID) {
        [self HS2SPROError:errorID];
    }];
}

- (IBAction)commandDeleteHS2SPROAnonymousMemoryData:(id)sender {
    
    
    [self.myHS2SPRO commandDeleteHS2SPROAnonymousMemoryData:^{
        
         NSLog(@"DeleteHS2SPROAnonymousMemoryData:success");
        
         self.hs2sPROTextView.text=[NSString stringWithFormat:@"%@:success\n%@",NSLocalizedString(@"HS2S DeleteHS2SAnonymousMemoryData", @""),self.hs2sPROTextView.text];
        
    } disposeErrorBlock:^(HS2SPRODeviceError errorID) {
        [self HS2SPROError:errorID];
    }];
}

- (IBAction)commandEnterHS2SPROHeartRateMeasurementMode:(id)sender {
    
    [self.myHS2SPRO commandEnterHS2SPROHeartRateMeasurementMode:^(NSDictionary *heartResultDic) {
        
        NSLog(@"heartResultDic:%@",heartResultDic);
       
        self.hs2sPROTextView.text=[NSString stringWithFormat:@"%@:%@\n%@",NSLocalizedString(@"HS2S heartResultDic", @""),heartResultDic,self.hs2sPROTextView.text];
        
    } measurementStatus:^(NSNumber *measurementStatus) {
        
        NSLog(@"measurementStatus:%@",measurementStatus);
        
        self.hs2sPROTextView.text=[NSString stringWithFormat:@"%@:%@\n%@",NSLocalizedString(@"HS2S measurementStatus", @""),measurementStatus,self.hs2sPROTextView.text];
        
    } disposeErrorBlock:^(HS2SPRODeviceError errorID) {
        
        [self HS2SPROError:errorID];
    }];
    
}

- (IBAction)commandEndHS2SPROHeartRateMeasurementMode:(id)sender {
    
    [self.myHS2SPRO commandExitHS2SPROHeartRateMeasurementMode:^ {
        
        self.hs2sPROTextView.text=[NSString stringWithFormat:@"%@:success\n%@",NSLocalizedString(@"ExitHS2SPROHeartRateMeasurementMode", @""),self.hs2sPROTextView.text];
        
    } disposeErrorBlock:^(HS2SPRODeviceError errorID) {
        [self HS2SPROError:errorID];
    }];
    
}

- (IBAction)commandSetHS2SPRODeviceLightUp:(id)sender {
    
    [self.myHS2SPRO commandShowBluetoothLightWithSuccessBlock:^{
        
        self.hs2sPROTextView.text=[NSString stringWithFormat:@"%@:success\n%@",NSLocalizedString(@"SetHS2SDeviceLightUp", @""),self.hs2sPROTextView.text];
        
    } disposeErrorBlock:^(HS2SPRODeviceError errorID) {
        [self HS2SPROError:errorID];
    }];
    
}

- (IBAction)commandStartHS2SPROMeasureWithUser:(id)sender {
    
    HS2SProUser *user = [HS2SProUser new];
    user.userId = [self md5:@"your_user_id"];
    user.createTS = [[NSDate date] timeIntervalSince1970];
    user.gender = HS2SProGender_Male;
    user.age = 25;
    user.height = 180;
    user.weight = 75.0f;
    user.enableMeasureImpedance = YES;
    user.enableFitness = NO;
    
    [self.myHS2SPRO commandStartHS2SPROMeasureWithUser:user realtimeWeightBlock:^(NSNumber *unStableWeight) {
        NSLog(@"unStableWeight:%@",unStableWeight);
    } stableWeightBlock:^(NSNumber *stableWeight) {
        NSLog(@"stableWeight:%@",stableWeight);
    } weightAndBodyInfoBlock:^(NSDictionary *weightAndBodyInfoDic) {
        NSLog(@"weightAndBodyInfoDic:%@",weightAndBodyInfoDic);
    } disposeErrorBlock:^(HS2SPRODeviceError errorID) {
        [self HS2SPROError:errorID];
    }];
    
}


- (IBAction)commandStartHS2SPROGuestMeasureWithUser:(id)sender {
    
    [self.myHS2SPRO commandStartHS2SPROGuestMeasureWithRealtimeWeightBlock:^(NSNumber *unStableWeight) {
        NSLog(@"unStableWeight:%@",unStableWeight);
    } stableWeightBlock:^(NSNumber *stableWeight) {
        NSLog(@"stableWeight:%@",stableWeight);
    } disposeErrorBlock:^(HS2SPRODeviceError errorID) {
        [self HS2SPROError:errorID];
    }];
}

- (IBAction)commandResetHS2SPRODevice:(id)sender {
    
    
    [self.myHS2SPRO commandResetHS2SPRODevice:^{
        
        NSLog(@"ResetHS2SPRODevice:success");
        
        self.hs2sPROTextView.text=[NSString stringWithFormat:@"%@:success\n%@",NSLocalizedString(@"HS2S ResetHS2SDevice", @""),self.hs2sPROTextView.text];
        
    } disposeErrorBlock:^(HS2SPRODeviceError errorID) {
        
        [self HS2SPROError:errorID];
        
    }];
}

- (IBAction)commandDisconnectDevice:(id)sender {
    
    
    [self.myHS2SPRO commandDisconnectDevice];
    
}

- (IBAction)commandCloseDevice:(id)sender {
    
    
//    [self.myHS2SPRO commandBroadCastTypeHS2SPRODevice:^{
//
//        
//        NSLog(@"BroadCastTypeHS2SPRODevice:success");
//
//        self.hs2sPROTextView.text=[NSString stringWithFormat:@"%@:success\n%@",NSLocalizedString(@"HS2S BroadCastTypeHS2SDevice", @""),self.hs2sPROTextView.text];
//
//    } disposeErrorBlock:^(HS2SPRODeviceError errorID) {
//
//         [self HS2SPROError:errorID];
//
//    }];
    
}

- (IBAction)commandGetDeviceVersions:(id)sender {

    [[SDKFlowUpdateDevice shareSDKUpdateDeviceInstance] commandGetUpdateVersionWithDeviceUUID:self.myHS2SPRO.currentUUID DeviceType:UpdateFlowDeviceType_HS2SPRO DisposeUpdateVersionResult:^(NSDictionary *updateVersionDic) {
        
        NSLog(@"updateVersionDic:%@",updateVersionDic);
        
         self.hs2sPROTextView.text=[NSString stringWithFormat:@"%@:%@\n%@",NSLocalizedString(@"HS2S updateVersionDic", @""),updateVersionDic,self.hs2sPROTextView.text];
        
    } DisposeErrorBlock:^(UpdateFlowDeviceError errorID) {
        
        [self HS2SPROUpdataError:errorID];
    }];
  
    
   
}

- (IBAction)commandGetUpdateModuleState:(id)sender {
    
    [[SDKFlowUpdateDevice shareSDKUpdateDeviceInstance] commandGetUpdateModuleState:^(NSNumber *updateModuleState) {
        
        
        NSLog(@"updateModuleState:%@",updateModuleState);
        
        self.hs2sPROTextView.text=[NSString stringWithFormat:@"%@:%@\n%@",NSLocalizedString(@"HS2S updateModuleState", @""),updateModuleState,self.hs2sPROTextView.text];
        
    }];
    
    
    
}



- (IBAction)commandUpdataDevice:(id)sender {
    
   
    [[SDKFlowUpdateDevice shareSDKUpdateDeviceInstance] commandStartUpdateWithDeviceUUID:self.myHS2SPRO.currentUUID DeviceType:UpdateFlowDeviceType_HS2SPRO DownloadFirmwareStart:^{
        
        NSLog(@"DownloadFirmwareStart");
        
        self.hs2sPROTextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"HS2S DownloadFirmwareStart", @""),self.hs2sPROTextView.text];
        
    } DisposeDownloadFirmwareFinish:^{
        
         NSLog(@"DisposeDownloadFirmwareFinish");
        
        self.hs2sPROTextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"HS2S DisposeDownloadFirmwareFinish", @""),self.hs2sPROTextView.text];
        
    } DisposeDownloadProgress:^(NSNumber *progress) {
        
        NSLog(@"DisposeDownloadProgress:%@",progress);
        
        self.hs2sPROTextView.text=[NSString stringWithFormat:@"%@:%@\n%@",NSLocalizedString(@"HS2S DisposeDownloadProgress", @""),progress,self.hs2sPROTextView.text];
        
    } DisposeUpdateProgress:^(NSNumber *progress) {
        
        NSLog(@"DisposeUpdateProgress:%@",progress);
        
        self.hs2sPROTextView.text=[NSString stringWithFormat:@"%@:%@\n%@",NSLocalizedString(@"HS2S DisposeUpdateProgress", @""),progress,self.hs2sPROTextView.text];
        
    } DisposeUpdateResult:^(NSNumber *updateResult) {
        
        NSLog(@"updateResult:%@",updateResult);
        
        self.hs2sPROTextView.text=[NSString stringWithFormat:@"%@:%@\n%@",NSLocalizedString(@"HS2S updateResult", @""),updateResult,self.hs2sPROTextView.text];
        
    } TransferSuccess:^(NSNumber *transferSuccess) {
        
         NSLog(@"transferSuccess:%@",transferSuccess);
        
        self.hs2sPROTextView.text=[NSString stringWithFormat:@"%@:%@\n%@",NSLocalizedString(@"HS2S transferSuccess", @""),transferSuccess,self.hs2sPROTextView.text];
        
    } DisposeErrorBlock:^(UpdateFlowDeviceError errorID) {
        
        [self HS2SPROUpdataError:errorID];
        
    }];

}

- (IBAction)commandUpdataDeviceWithLocalFile:(id)sender {
    
    
    NSString *fileinfoPath = [[NSBundle mainBundle] pathForResource:@"HS2S 110705.0.00.6.1info" ofType:@"bin"];

    NSString *fileFirPath = [[NSBundle mainBundle] pathForResource:@"HS2S 110705.0.00.6.1firmware" ofType:@"bin"];
    

    [[SDKFlowUpdateDevice shareSDKUpdateDeviceInstance] commandStartUpdateWithDeviceUUID:self.myHS2SPRO.currentUUID DeviceType:UpdateFlowDeviceType_HS2SPRO InfoFilePath:fileinfoPath UpadteFilePath:fileFirPath DisposeUpdateProgress:^(NSNumber *progress) {

        NSLog(@"DisposeUpdateProgress:%@",progress);
        
        self.hs2sPROTextView.text=[NSString stringWithFormat:@"%@:%@\n%@",NSLocalizedString(@"HS2S DisposeUpdateProgress", @""),progress,self.hs2sPROTextView.text];
        

    } DisposeUpdateResult:^(NSNumber *updateResult) {

         NSLog(@"updateResult:%@",updateResult);
        
         self.hs2sPROTextView.text=[NSString stringWithFormat:@"%@:%@\n%@",NSLocalizedString(@"HS2S updateResult", @""),updateResult,self.hs2sPROTextView.text];

    } TransferSuccess:^(NSNumber *transferSuccess) {

         NSLog(@"transferSuccess:%@",transferSuccess);
        
        self.hs2sPROTextView.text=[NSString stringWithFormat:@"%@:%@\n%@",NSLocalizedString(@"HS2S transferSuccess", @""),transferSuccess,self.hs2sPROTextView.text];

    } DisposeErrorBlock:^(UpdateFlowDeviceError errorID) {

        [self HS2SPROUpdataError:errorID];
    }];

    
}



- (IBAction)commandDownUpdataDeviceWithLocalFile600:(id)sender {
    
    
    NSString *fileinfoPath = [[NSBundle mainBundle] pathForResource:@"HS2S 110706.0.02.0.2info" ofType:@"bin"];
    
    NSString *fileFirPath = [[NSBundle mainBundle] pathForResource:@"HS2S 110706.0.02.0.2firmware" ofType:@"bin"];
    
    [[SDKFlowUpdateDevice shareSDKUpdateDeviceInstance] commandStartUpdateWithDeviceUUID:self.myHS2SPRO.currentUUID DeviceType:UpdateFlowDeviceType_HS2SPRO InfoFilePath:fileinfoPath UpadteFilePath:fileFirPath DisposeUpdateProgress:^(NSNumber *progress) {
        
        NSLog(@"DisposeUpdateProgress:%@",progress);
        
        self.hs2sPROTextView.text=[NSString stringWithFormat:@"%@:%@\n%@",NSLocalizedString(@"HS2S DisposeUpdateProgress", @""),progress,self.hs2sPROTextView.text];
        
    } DisposeUpdateResult:^(NSNumber *updateResult) {
        
        NSLog(@"updateResult:%@",updateResult);
        
        self.hs2sPROTextView.text=[NSString stringWithFormat:@"%@:%@\n%@",NSLocalizedString(@"HS2S updateResult", @""),updateResult,self.hs2sPROTextView.text];
        
    } TransferSuccess:^(NSNumber *transferSuccess) {
        
        NSLog(@"transferSuccess:%@",transferSuccess);
        
        self.hs2sPROTextView.text=[NSString stringWithFormat:@"%@:%@\n%@",NSLocalizedString(@"HS2S transferSuccess", @""),transferSuccess,self.hs2sPROTextView.text];
        
    } DisposeErrorBlock:^(UpdateFlowDeviceError errorID) {
        
        [self HS2SPROUpdataError:errorID];
        
    }];
    
    
}



- (IBAction)commandStopUpdataDevice:(id)sender {
    
    [[SDKFlowUpdateDevice shareSDKUpdateDeviceInstance] commandEndUpdateWithDeviceUUID:self.myHS2SPRO.currentUUID DeviceType:UpdateFlowDeviceType_HS2SPRO DisposeEndUpdateResult:^(NSNumber *endUpdate) {
        
        NSLog(@"HS2S endUpdate:%@",endUpdate);
        
         self.hs2sPROTextView.text=[NSString stringWithFormat:@"%@:%@\n%@",NSLocalizedString(@"HS2S endUpdate", @""),endUpdate,self.hs2sPROTextView.text];
        
    } DisposeErrorBlock:^(UpdateFlowDeviceError errorID) {
        
        [self HS2SPROUpdataError:errorID];
        
    }];
}

-(void)HS2SPROUpdataError:(UpdateFlowDeviceError)errorID{
    
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
    
    self.hs2sPROTextView.text=[NSString stringWithFormat:@"%@:%lu detial:%@\n%@",NSLocalizedString(@"HS2SUpdataError", @""),(unsigned long)errorID,errorDetail,self.hs2sPROTextView.text];
    
    NSLog(@"Error Detail:%@",errorDetail);
}

-(void)HS2SPROError:(HS2SPRODeviceError)errorID{
    
    NSString*errorDetail=[NSString string];
    
    switch (errorID) {
        case HS2SPRODeviceError_Unknown:
            errorDetail=@"HS2SDeviceError_Unknown";
            break;
        case HS2SPRODeviceError_CommunicationTimeout:
            errorDetail=@"HS2SDeviceError_CommunicationTimeout";
            break;
        case HS2SPRODeviceError_ReceivedCommandError:
            errorDetail=@"HS2SDeviceError_ReceivedCommandError";
            break;
        case HS2SPRODeviceError_InputParameterError:
            errorDetail=@"HS2SDeviceError_InputParameterError";
            break;
        case HS2SPRODeviceError_MoreThanMaxNumbersOfUser:
            errorDetail=@"HS2SDeviceError_MoreThanMaxNumbersOfUser";
            break;
        case HS2SPRODeviceError_WriteFlashError:
            errorDetail=@"HS2SDeviceError_WriteFlashError";
            break;
        case HS2SPRODeviceError_UserNotExist:
            errorDetail=@"HS2SDeviceError_UserNotExist";
            break;
        case HS2SPRODeviceError_StartMeasureError:
            errorDetail=@"HS2SDeviceError_StartMeasureError";
            break;
        case HS2SPRODeviceError_MeasureTimeout:
            errorDetail=@"HS2SDeviceError_MeasureTimeout";
            break;
        case HS2SPRODeviceError_MeasureOverweight:
            errorDetail=@"HS2SDeviceError_MeasureOverweight";
            break;
        case HS2SPRODeviceError_MeasureNotGetStalbeWeight:
            errorDetail=@"HS2SPRODeviceError_MeasureNotGetStalbeWeight";
            break;
        case HS2SPRODeviceError_Disconnect:
            errorDetail=@"HS2SDeviceError_Disconnect";
            break;
        case HS2SPRODeviceError_Unsupported:
            errorDetail=@"HS2SPRODeviceError_Unsupported";
            break;
    }
    
    self.hs2sPROTextView.text=[NSString stringWithFormat:@"%@:%d detial:%@\n%@",NSLocalizedString(@"HS2S PRO Error:", @""),errorID,errorDetail,self.hs2sPROTextView.text];
    
    NSLog(@"Error Detail:%@",errorDetail);
}

- (NSData *)md5:(NSString *)hashString{
    
    NSData *data = [hashString dataUsingEncoding:NSUTF8StringEncoding];
    // 计算md5
    unsigned char *digest;
    digest = (unsigned char *)malloc(CC_MD5_DIGEST_LENGTH);
    
    CC_MD5([data bytes], (CC_LONG)[data length], digest);
    NSData *md5Data = [NSData dataWithBytes:digest length:CC_MD5_DIGEST_LENGTH];
    free(digest);
    
    return md5Data;
}
@end
