//
//  DeviceHS2SViewController.m
//  iHealthDemoCode
//
//  Created by jing on 2019/4/28.
//  Copyright © 2019 iHealth Demo Code. All rights reserved.
//

#import "DeviceHS2SViewController.h"
#import "HSHeader.h"
#import "SDKFlowUpdateDevice.h"

@interface DeviceHS2SViewController ()

@property (weak, nonatomic) IBOutlet UITextView *hs2sTextView;

@property (weak, nonatomic) IBOutlet UILabel *deviceLabel;

@property (strong, nonatomic) HS2S *myHS2S;

@property (strong, nonatomic) NSData *myHS2SUserID;

@end

@implementation DeviceHS2SViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    
    NSString*deviceMac=[userDefault valueForKey:@"SelectDeviceMac"];
    
    self.deviceLabel.text=[NSString stringWithFormat:@"HS2S %@",deviceMac];
    
    NSArray*deviceArray=[[HS2SController shareIHHS2SController] getAllCurrentHS2SInstace];

    for(HS2S *device in deviceArray){

        if([deviceMac isEqualToString:device.serialNumber]){
            
            self.myHS2S=device;

        }
    }
    
     [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(DeviceDisConnect:) name:HS2SDisConnectNoti object:nil];
}

-(void)DeviceDisConnect:(NSNotification *)tempNoti{
    
     self.hs2sTextView.text=[NSString stringWithFormat:@"%@:%@\n%@",NSLocalizedString(@"HS2SDisconnect", @""),[tempNoti userInfo],self.hs2sTextView.text];
    
}
- (IBAction)Cancel:(id)sender {
    
    [self.myHS2S commandDisconnectDevice];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)setUnit:(id)sender {
    
    [self.myHS2S commandSetHS2SUnit:HSUnit_Kg result:^(BOOL result) {
        
        self.hs2sTextView.text=[NSString stringWithFormat:@"%@:%d\n%@",NSLocalizedString(@"HS2S SetHS2SUint", @""),result,self.hs2sTextView.text];
        
    } DisposeErrorBlock:^(HS2SDeviceError errorID) {
        [self HS2SError:errorID];
    }];

}

- (IBAction)commandGetHS2SDeviceInfo:(id)sender {
    
    
    [self.myHS2S commandGetHS2SDeviceInfo:^(NSDictionary *deviceInfo) {
        
        NSLog(@"HS2S deviceInfo:%@",deviceInfo);
        
         self.hs2sTextView.text=[NSString stringWithFormat:@"%@:%@\n%@",NSLocalizedString(@"HS2S deviceInfo", @""),deviceInfo,self.hs2sTextView.text];
        
    } DiaposeErrorBlock:^(HS2SDeviceError errorID) {
        [self HS2SError:errorID];
    }];
}

- (IBAction)commandGetHS2SBattery:(id)sender {
    
    
    [self.myHS2S commandGetHS2SBattery:^(NSNumber *battary) {
        
         NSLog(@"HS2S battary:%@",battary);
        
         self.hs2sTextView.text=[NSString stringWithFormat:@"%@:%@\n%@",NSLocalizedString(@"HS2S battary", @""),battary,self.hs2sTextView.text];
        
    } DiaposeErrorBlock:^(HS2SDeviceError errorID) {
        [self HS2SError:errorID];
    }];
}

- (IBAction)commandSetHS2SBLE:(id)sender {
    
    
//    [self.myHS2S commandSetBLEConnectInterval:@0 result:^(BOOL result) {
//        
//        self.hs2sTextView.text=[NSString stringWithFormat:@"%@:%hhd\n%@",NSLocalizedString(@"HS2S SetBLE", @""),result,self.hs2sTextView.text];
//        
//    } DiaposeErrorBlock:^(HS2SDeviceError errorID) {
//        [self HS2SError:errorID];
//    }];
}

- (IBAction)commandGetHS2SUserInfo:(id)sender {
    
    [self.myHS2S commandGetHS2SUserInfo:^(NSDictionary *userInfo) {
        
        NSArray*userInfoArray=[userInfo valueForKey:@"UserInfo"];
        
        NSLog(@"HS2S userInfoArray:%@",userInfoArray);
        
        self.hs2sTextView.text=[NSString stringWithFormat:@"%@:%@\n%@",NSLocalizedString(@"HS2S userInfo", @""),userInfo,self.hs2sTextView.text];
        
        if (userInfoArray.count==0) {
            
            return ;
        }
        for (int i=0; i<userInfoArray.count; i++) {
            
            self.myHS2SUserID=[[userInfoArray objectAtIndex:i] valueForKey:@"UserInfo_ID"];
            
            NSString * str  =[[NSString alloc] initWithData:self.myHS2SUserID encoding:NSUTF8StringEncoding];
            
            NSLog(@"HS2S USerID:%@",str);
            
            NSLog(@"HS2S userInfo:%@",[userInfoArray objectAtIndex:i]);
        }
        
       
        
    } DiaposeErrorBlock:^(HS2SDeviceError errorID) {
        [self HS2SError:errorID];
    }];
}
- (IBAction)commandUpdateHS2SUserInfoWithUser:(id)sender {
    
//     userID:String type,createTS:seconds , weight:20-150kg, age:18-99 years ,height:90-220cm sex:0 female 1 male,HS2SImpedanceMark: 0 Don't measure 1 Measure
    
    HealthUser*user=[HealthUser new];
    
    if (self.myHS2SUserID==nil) {
        
        NSData *data =[@"iHealth123456786" dataUsingEncoding:NSUTF8StringEncoding];
        
        user.hs2SUserID=data;
        
    }else{
        
       user.hs2SUserID=self.myHS2SUserID;
    }
    
    
    user.createTS=[[NSDate date] timeIntervalSince1970];
    
    user.weight=@85;
    
    user.age=@18;
    
    user.height=@180;
    
    user.sex=UserSex_Male;
    
    user.impedanceMark=HS2SImpedanceMark_YES;
    
    user.fitnessMark=HS2SFitnessMark_YES;
    
    [self.myHS2S commandUpdateHS2SUserInfoWithUser:user result:^(BOOL result) {
        
        NSLog(@"HS2S UpdateHS2SUserInfo:%d",result);
        
         self.hs2sTextView.text=[NSString stringWithFormat:@"%@:%d\n%@",NSLocalizedString(@"HS2S UpdateHS2SUserInfo", @""),result,self.hs2sTextView.text];
        
    } DiaposeErrorBlock:^(HS2SDeviceError errorID) {
        [self HS2SError:errorID];
    }];
}
- (IBAction)commandDeleteHS2SUserWithUserID:(id)sender {
    
    HealthUser*user=[HealthUser new];
    
    if (self.myHS2SUserID==nil) {
        
        NSData *data =[@"iHealth123456783" dataUsingEncoding:NSUTF8StringEncoding];
        
        user.hs2SUserID=data;
        
    }else{
        
        user.hs2SUserID=self.myHS2SUserID;
    }
    
    
    [self.myHS2S commandDeleteHS2SUserWithUserID:user.hs2SUserID result:^(BOOL result) {
        
        NSLog(@"HS2S DeleteHS2SUser:%d",result);
        
         self.hs2sTextView.text=[NSString stringWithFormat:@"%@:%d\n%@",NSLocalizedString(@"HS2S DeleteHS2SUser", @""),result,self.hs2sTextView.text];
        
    } DiaposeErrorBlock:^(HS2SDeviceError errorID) {
        [self HS2SError:errorID];
    }];
}
- (IBAction)commandGetHS2SMemoryDataCountWithUserID:(id)sender {
    
    
    [self.myHS2S commandGetHS2SMemoryDataCountWithUserID:self.myHS2SUserID memoryCount:^(NSNumber *count) {
        
        NSLog(@"HS2S GetHS2SMemoryDataCount:%@",count);
        
        self.hs2sTextView.text=[NSString stringWithFormat:@"%@:%@\n%@",NSLocalizedString(@"HS2S GetHS2SMemoryDataCount", @""),count,self.hs2sTextView.text];
        
    } DiaposeErrorBlock:^(HS2SDeviceError errorID) {
        [self HS2SError:errorID];
    }];
}

- (IBAction)commandGetHS2SMemoryDataWithUserID:(id)sender {
    
    
    [self.myHS2S commandGetHS2SMemoryDataWithUserID:self.myHS2SUserID memoryData:^(NSArray *data) {
        
         NSLog(@"HS2S GetHS2SMemoryData:%@",data);
        
         self.hs2sTextView.text=[NSString stringWithFormat:@"%@:%@\n%@",NSLocalizedString(@"HS2S GetHS2SMemoryData", @""),data,self.hs2sTextView.text];
        
    } DiaposeErrorBlock:^(HS2SDeviceError errorID) {
        [self HS2SError:errorID];
    }];
}

- (IBAction)commandDeleteHS2SMemoryDataWithUserID:(id)sender {
    
    HealthUser*user=[HealthUser new];
    
    if (self.myHS2SUserID==nil) {
        
        NSData *data =[@"iHealth123456787" dataUsingEncoding:NSUTF8StringEncoding];
        
        user.hs2SUserID=data;
        
    }else{
        
        user.hs2SUserID=self.myHS2SUserID;
    }
    
    
    [self.myHS2S commandDeleteHS2SMemoryDataWithUserID:user.hs2SUserID result:^(BOOL result) {
        
        NSLog(@"DeleteHS2SMemoryData:%d",result);
        
         self.hs2sTextView.text=[NSString stringWithFormat:@"%@:%d\n%@",NSLocalizedString(@"HS2S DeleteHS2SMemoryData", @""),result,self.hs2sTextView.text];
        
    } DiaposeErrorBlock:^(HS2SDeviceError errorID) {
        [self HS2SError:errorID];
    }];
}

- (IBAction)commandGetHS2SAnonymousMemoryDataCount:(id)sender {
    
    
    [self.myHS2S commandGetHS2SAnonymousMemoryDataCount:^(NSNumber *count) {
        
        NSLog(@"GetHS2SAnonymousMemoryDataCount:%@",count);
        
        self.hs2sTextView.text=[NSString stringWithFormat:@"%@:%@\n%@",NSLocalizedString(@"HS2S GetHS2SAnonymousMemoryDataCount", @""),count,self.hs2sTextView.text];
        
    } DiaposeErrorBlock:^(HS2SDeviceError errorID) {
        [self HS2SError:errorID];
    }];
}

- (IBAction)commandGetHS2SAnonymousMemoryData:(id)sender {
    
    
    [self.myHS2S commandGetHS2SAnonymousMemoryData:^(NSArray *data) {
        
        NSLog(@"GetHS2SAnonymousMemoryData:%@",data);
        
        self.hs2sTextView.text=[NSString stringWithFormat:@"%@:%@\n%@",NSLocalizedString(@"HS2S GetHS2SAnonymousMemoryData", @""),data,self.hs2sTextView.text];
        
    } DiaposeErrorBlock:^(HS2SDeviceError errorID) {
        [self HS2SError:errorID];
    }];
}

- (IBAction)commandDeleteHS2SAnonymousMemoryData:(id)sender {
    
    
    [self.myHS2S commandDeleteHS2SAnonymousMemoryData:^(BOOL result) {
        
         NSLog(@"DeleteHS2SAnonymousMemoryData:%d",result);
        
         self.hs2sTextView.text=[NSString stringWithFormat:@"%@:%d\n%@",NSLocalizedString(@"HS2S DeleteHS2SAnonymousMemoryData", @""),result,self.hs2sTextView.text];
        
    } DiaposeErrorBlock:^(HS2SDeviceError errorID) {
        [self HS2SError:errorID];
    }];
}

- (IBAction)commandEnterHS2SHeartRateMeasurementMode:(id)sender {
    
    [self.myHS2S commandEnterHS2SHeartRateMeasurementMode:^(NSDictionary *heartResultDic) {
        
        NSLog(@"heartResultDic:%@",heartResultDic);
       
        self.hs2sTextView.text=[NSString stringWithFormat:@"%@:%@\n%@",NSLocalizedString(@"HS2S heartResultDic", @""),heartResultDic,self.hs2sTextView.text];
        
    } measurementStatus:^(NSNumber *measurementStatus) {
        
        NSLog(@"measurementStatus:%@",measurementStatus);
        
        self.hs2sTextView.text=[NSString stringWithFormat:@"%@:%@\n%@",NSLocalizedString(@"HS2S measurementStatus", @""),measurementStatus,self.hs2sTextView.text];
        
    } DiaposeErrorBlock:^(HS2SDeviceError errorID) {
        
        [self HS2SError:errorID];
    }];
    
}

- (IBAction)commandEndHS2SHeartRateMeasurementMode:(id)sender {
    
    [self.myHS2S commandExitHS2SHeartRateMeasurementMode:^(BOOL result) {
        
        self.hs2sTextView.text=[NSString stringWithFormat:@"%@:%d\n%@",NSLocalizedString(@"ExitHS2SHeartRateMeasurementMode", @""),result,self.hs2sTextView.text];
        
    } DiaposeErrorBlock:^(HS2SDeviceError errorID) {
        [self HS2SError:errorID];
    }];
    
}

- (IBAction)commandSetHS2SDeviceLightUp:(id)sender {
    
    [self.myHS2S commandSetHS2SDeviceLightUp:^(BOOL result) {
        
        self.hs2sTextView.text=[NSString stringWithFormat:@"%@:%d\n%@",NSLocalizedString(@"SetHS2SDeviceLightUp", @""),result,self.hs2sTextView.text];
        
    } DiaposeErrorBlock:^(HS2SDeviceError errorID) {
        [self HS2SError:errorID];
    }];
    
}

- (IBAction)commandStartHS2SMeasureWithUser:(id)sender {
    
    
    HealthUser*user=[HealthUser new];
    
    user.hs2SUserID=self.myHS2SUserID;
    
    user.createTS=[[NSDate date] timeIntervalSince1970];
    
    user.weight=@85;
    
    user.age=@18;
    
    user.height=@180;
    
    user.sex=UserSex_Male;
    
    user.impedanceMark=HS2SImpedanceMark_YES;
    
    user.userType=UserType_Normal;
    
    user.fitnessMark=HS2SFitnessMark_YES;
    
    [self.myHS2S commandStartHS2SMeasureWithUser:user weight:^(NSNumber *unStableWeight) {
        NSLog(@"unStableWeight:%@",unStableWeight);
        
        self.hs2sTextView.text=[NSString stringWithFormat:@"%@:%@\n%@",NSLocalizedString(@"HS2S unStableWeight", @""),unStableWeight,self.hs2sTextView.text];
    } stableWeight:^(NSNumber *stableWeight) {
        NSLog(@"stableWeight:%@",stableWeight);
        
        self.hs2sTextView.text=[NSString stringWithFormat:@"%@:%@\n%@",NSLocalizedString(@"HS2S stableWeight", @""),stableWeight,self.hs2sTextView.text];
    } weightAndBodyInfo:^(NSDictionary *weightAndBodyInfoDic) {
        NSLog(@"weightAndBodyInfoDic:%@",weightAndBodyInfoDic);
        
        self.hs2sTextView.text=[NSString stringWithFormat:@"%@:%@\n%@",NSLocalizedString(@"HS2S weightAndBodyInfoDic", @""),weightAndBodyInfoDic,self.hs2sTextView.text];
    } disposeHS2SMeasureFinish:^{
        NSLog(@"HS2SMeasureFinish");
        self.hs2sTextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"HS2S HS2SMeasureFinish", @""),self.hs2sTextView.text];
    } DiaposeErrorBlock:^(HS2SDeviceError errorID) {
         [self HS2SError:errorID];
    }];
    
}


- (IBAction)commandStartHS2SGuestMeasureWithUser:(id)sender {
    
    
    HealthUser*user=[HealthUser new];
    
    user.hs2SUserID=self.myHS2SUserID;
    
    user.createTS=[[NSDate date] timeIntervalSince1970];
    
    user.weight=@85;
    
    user.age=@18;
    
    user.height=@180;
    
    user.sex=UserSex_Male;
    
    user.impedanceMark=HS2SImpedanceMark_YES;
    
    user.userType=UserType_Guest;
    
    user.fitnessMark=HS2SFitnessMark_YES;
    
    [self.myHS2S commandStartHS2SMeasureWithUser:user weight:^(NSNumber *unStableWeight) {
        NSLog(@"unStableWeight:%@",unStableWeight);
        self.hs2sTextView.text=[NSString stringWithFormat:@"%@:%@\n%@",NSLocalizedString(@"HS2S unStableWeight", @""),unStableWeight,self.hs2sTextView.text];
    } stableWeight:^(NSNumber *stableWeight) {
        NSLog(@"stableWeight:%@",stableWeight);
        self.hs2sTextView.text=[NSString stringWithFormat:@"%@:%@\n%@",NSLocalizedString(@"HS2S stableWeight", @""),stableWeight,self.hs2sTextView.text];
    } weightAndBodyInfo:^(NSDictionary *weightAndBodyInfoDic) {
        NSLog(@"weightAndBodyInfoDic:%@",weightAndBodyInfoDic);
        self.hs2sTextView.text=[NSString stringWithFormat:@"%@:%@\n%@",NSLocalizedString(@"HS2S weightAndBodyInfoDic", @""),weightAndBodyInfoDic,self.hs2sTextView.text];
    } disposeHS2SMeasureFinish:^{
        NSLog(@"HS2SMeasureFinish");
        self.hs2sTextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"HS2S HS2SMeasureFinish", @""),self.hs2sTextView.text];
    } DiaposeErrorBlock:^(HS2SDeviceError errorID) {
        [self HS2SError:errorID];
    }];
}

- (IBAction)commandResetHS2SDevice:(id)sender {
    
    
    [self.myHS2S commandResetHS2SDevice:^(BOOL result) {
        
        NSLog(@"ResetHS2SDevice:%d",result);
        
        self.hs2sTextView.text=[NSString stringWithFormat:@"%@:%d\n%@",NSLocalizedString(@"HS2S ResetHS2SDevice", @""),result,self.hs2sTextView.text];
        
    } DiaposeErrorBlock:^(HS2SDeviceError errorID) {
        
        [self HS2SError:errorID];
        
    }];
}

- (IBAction)commandDisconnectDevice:(id)sender {
    
    
    [self.myHS2S commandDisconnectDevice];
    
}

- (IBAction)commandCloseDevice:(id)sender {
    
    
    [self.myHS2S commandBroadCastTypeHS2SDevice:^(BOOL result) {
        
        
        NSLog(@"BroadCastTypeHS2SDevice:%d",result);
        
        self.hs2sTextView.text=[NSString stringWithFormat:@"%@:%d\n%@",NSLocalizedString(@"HS2S BroadCastTypeHS2SDevice", @""),result,self.hs2sTextView.text];
        
    } DiaposeErrorBlock:^(HS2SDeviceError errorID) {
        
         [self HS2SError:errorID];
        
    }];
    
}

- (IBAction)commandGetDeviceVersions:(id)sender {

    [[SDKFlowUpdateDevice shareSDKUpdateDeviceInstance] commandGetUpdateVersionWithDeviceUUID:self.myHS2S.currentUUID DeviceType:UpdateFlowDeviceType_HS2S DisposeUpdateVersionResult:^(NSDictionary *updateVersionDic) {
        
        NSLog(@"updateVersionDic:%@",updateVersionDic);
        
         self.hs2sTextView.text=[NSString stringWithFormat:@"%@:%@\n%@",NSLocalizedString(@"HS2S updateVersionDic", @""),updateVersionDic,self.hs2sTextView.text];
        
    } DisposeErrorBlock:^(UpdateFlowDeviceError errorID) {
        
        [self HS2SUpdataError:errorID];
    }];
  
    
   
}

- (IBAction)commandGetUpdateModuleState:(id)sender {
    
    [[SDKFlowUpdateDevice shareSDKUpdateDeviceInstance] commandGetUpdateModuleState:^(NSNumber *updateModuleState) {
        
        
        NSLog(@"updateModuleState:%@",updateModuleState);
        
        self.hs2sTextView.text=[NSString stringWithFormat:@"%@:%@\n%@",NSLocalizedString(@"HS2S updateModuleState", @""),updateModuleState,self.hs2sTextView.text];
        
    }];
    
    
    
}



- (IBAction)commandUpdataDevice:(id)sender {
    
   
    [[SDKFlowUpdateDevice shareSDKUpdateDeviceInstance] commandStartUpdateWithDeviceUUID:self.myHS2S.currentUUID DeviceType:UpdateFlowDeviceType_HS2S DownloadFirmwareStart:^{
        
        NSLog(@"DownloadFirmwareStart");
        
        self.hs2sTextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"HS2S DownloadFirmwareStart", @""),self.hs2sTextView.text];
        
    } DisposeDownloadFirmwareFinish:^{
        
         NSLog(@"DisposeDownloadFirmwareFinish");
        
        self.hs2sTextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"HS2S DisposeDownloadFirmwareFinish", @""),self.hs2sTextView.text];
        
    } DisposeDownloadProgress:^(NSNumber *progress) {
        
        NSLog(@"DisposeDownloadProgress:%@",progress);
        
        self.hs2sTextView.text=[NSString stringWithFormat:@"%@:%@\n%@",NSLocalizedString(@"HS2S DisposeDownloadProgress", @""),progress,self.hs2sTextView.text];
        
    } DisposeUpdateProgress:^(NSNumber *progress) {
        
        NSLog(@"DisposeUpdateProgress:%@",progress);
        
        self.hs2sTextView.text=[NSString stringWithFormat:@"%@:%@\n%@",NSLocalizedString(@"HS2S DisposeUpdateProgress", @""),progress,self.hs2sTextView.text];
        
    } DisposeUpdateResult:^(NSNumber *updateResult) {
        
        NSLog(@"updateResult:%@",updateResult);
        
        self.hs2sTextView.text=[NSString stringWithFormat:@"%@:%@\n%@",NSLocalizedString(@"HS2S updateResult", @""),updateResult,self.hs2sTextView.text];
        
    } TransferSuccess:^(NSNumber *transferSuccess) {
        
         NSLog(@"transferSuccess:%@",transferSuccess);
        
        self.hs2sTextView.text=[NSString stringWithFormat:@"%@:%@\n%@",NSLocalizedString(@"HS2S transferSuccess", @""),transferSuccess,self.hs2sTextView.text];
        
    } DisposeErrorBlock:^(UpdateFlowDeviceError errorID) {
        
        [self HS2SUpdataError:errorID];
        
    }];

}

- (IBAction)commandUpdataDeviceWithLocalFile:(id)sender {
    
    
    NSString *fileinfoPath = [[NSBundle mainBundle] pathForResource:@"HS2S 110705.0.00.6.1info" ofType:@"bin"];

    NSString *fileFirPath = [[NSBundle mainBundle] pathForResource:@"HS2S 110705.0.00.6.1firmware" ofType:@"bin"];
    

    [[SDKFlowUpdateDevice shareSDKUpdateDeviceInstance] commandStartUpdateWithDeviceUUID:self.myHS2S.currentUUID DeviceType:UpdateFlowDeviceType_HS2S InfoFilePath:fileinfoPath UpadteFilePath:fileFirPath DisposeUpdateProgress:^(NSNumber *progress) {

        NSLog(@"DisposeUpdateProgress:%@",progress);
        
        self.hs2sTextView.text=[NSString stringWithFormat:@"%@:%@\n%@",NSLocalizedString(@"HS2S DisposeUpdateProgress", @""),progress,self.hs2sTextView.text];
        

    } DisposeUpdateResult:^(NSNumber *updateResult) {

         NSLog(@"updateResult:%@",updateResult);
        
         self.hs2sTextView.text=[NSString stringWithFormat:@"%@:%@\n%@",NSLocalizedString(@"HS2S updateResult", @""),updateResult,self.hs2sTextView.text];

    } TransferSuccess:^(NSNumber *transferSuccess) {

         NSLog(@"transferSuccess:%@",transferSuccess);
        
        self.hs2sTextView.text=[NSString stringWithFormat:@"%@:%@\n%@",NSLocalizedString(@"HS2S transferSuccess", @""),transferSuccess,self.hs2sTextView.text];

    } DisposeErrorBlock:^(UpdateFlowDeviceError errorID) {

        [self HS2SUpdataError:errorID];
    }];

    
}



- (IBAction)commandDownUpdataDeviceWithLocalFile600:(id)sender {
    
    
    NSString *fileinfoPath = [[NSBundle mainBundle] pathForResource:@"HS2S 110706.0.02.0.2info" ofType:@"bin"];
    
    NSString *fileFirPath = [[NSBundle mainBundle] pathForResource:@"HS2S 110706.0.02.0.2firmware" ofType:@"bin"];
    
    [[SDKFlowUpdateDevice shareSDKUpdateDeviceInstance] commandStartUpdateWithDeviceUUID:self.myHS2S.currentUUID DeviceType:UpdateFlowDeviceType_HS2S InfoFilePath:fileinfoPath UpadteFilePath:fileFirPath DisposeUpdateProgress:^(NSNumber *progress) {
        
        NSLog(@"DisposeUpdateProgress:%@",progress);
        
        self.hs2sTextView.text=[NSString stringWithFormat:@"%@:%@\n%@",NSLocalizedString(@"HS2S DisposeUpdateProgress", @""),progress,self.hs2sTextView.text];
        
    } DisposeUpdateResult:^(NSNumber *updateResult) {
        
        NSLog(@"updateResult:%@",updateResult);
        
        self.hs2sTextView.text=[NSString stringWithFormat:@"%@:%@\n%@",NSLocalizedString(@"HS2S updateResult", @""),updateResult,self.hs2sTextView.text];
        
    } TransferSuccess:^(NSNumber *transferSuccess) {
        
        NSLog(@"transferSuccess:%@",transferSuccess);
        
        self.hs2sTextView.text=[NSString stringWithFormat:@"%@:%@\n%@",NSLocalizedString(@"HS2S transferSuccess", @""),transferSuccess,self.hs2sTextView.text];
        
    } DisposeErrorBlock:^(UpdateFlowDeviceError errorID) {
        
        [self HS2SUpdataError:errorID];
        
    }];
    
    
}



- (IBAction)commandStopUpdataDevice:(id)sender {
    
    [[SDKFlowUpdateDevice shareSDKUpdateDeviceInstance] commandEndUpdateWithDeviceUUID:self.myHS2S.currentUUID DeviceType:UpdateFlowDeviceType_HS2S DisposeEndUpdateResult:^(NSNumber *endUpdate) {
        
        NSLog(@"HS2S endUpdate:%@",endUpdate);
        
         self.hs2sTextView.text=[NSString stringWithFormat:@"%@:%@\n%@",NSLocalizedString(@"HS2S endUpdate", @""),endUpdate,self.hs2sTextView.text];
        
    } DisposeErrorBlock:^(UpdateFlowDeviceError errorID) {
        
        [self HS2SUpdataError:errorID];
        
    }];
}

-(void)HS2SUpdataError:(UpdateFlowDeviceError)errorID{
    
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
    
    self.hs2sTextView.text=[NSString stringWithFormat:@"%@:%lu detial:%@\n%@",NSLocalizedString(@"HS2SUpdataError", @""),(unsigned long)errorID,errorDetail,self.hs2sTextView.text];
    
    NSLog(@"Error Detail:%@",errorDetail);
}

-(void)HS2SError:(HS2SDeviceError)errorID{
    
    NSString*errorDetail=[NSString string];
    
    switch (errorID) {
        case HS2SDeviceError_Unknown:
            errorDetail=@"HS2SDeviceError_Unknown";
            break;
        case HS2SDeviceError_CommunicationTimeout:
            errorDetail=@"HS2SDeviceError_CommunicationTimeout";
            break;
        case HS2SDeviceError_ReceivedCommandError:
            errorDetail=@"HS2SDeviceError_ReceivedCommandError";
            break;
        case HS2SDeviceError_InputParameterError:
            errorDetail=@"HS2SDeviceError_InputParameterError";
            break;
        case HS2SDeviceError_MoreThanMaxNumbersOfUser:
            errorDetail=@"HS2SDeviceError_MoreThanMaxNumbersOfUser";
            break;
        case HS2SDeviceError_WriteFlashError:
            errorDetail=@"HS2SDeviceError_WriteFlashError";
            break;
        case HS2SDeviceError_UserNotExist:
            errorDetail=@"HS2SDeviceError_UserNotExist";
            break;
        case HS2SDeviceError_StartMeasureError:
            errorDetail=@"HS2SDeviceError_StartMeasureError";
            break;
        case HS2SDeviceError_MeasureTimeout:
            errorDetail=@"HS2SDeviceError_MeasureTimeout";
            break;
        case HS2SDeviceError_MeasureOverweight:
            errorDetail=@"HS2SDeviceError_MeasureOverweight";
            break;
        case HS2SDeviceError_Disconnect:
            errorDetail=@"HS2SDeviceError_Disconnect";
            break;
        case HS2SDeviceError_Unsupported:
            errorDetail=@"HS2SDeviceError_Unsupported";
            break;
    }
    
    self.hs2sTextView.text=[NSString stringWithFormat:@"%@:%d detial:%@\n%@",NSLocalizedString(@"HS2S Error:", @""),errorID,errorDetail,self.hs2sTextView.text];
    
    NSLog(@"Error Detail:%@",errorDetail);
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
