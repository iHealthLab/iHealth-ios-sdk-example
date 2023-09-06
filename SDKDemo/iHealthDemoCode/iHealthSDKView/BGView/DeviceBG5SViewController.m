//
//  DeviceBG5SViewController.m
//  iHealthDemoCode
//
//  Created by jing on 2018/10/22.
//  Copyright © 2018年 iHealth Demo Code. All rights reserved.
//

#import "DeviceBG5SViewController.h"
#import "BGHeader.h"
#import "DFUHeader.h"
#import "SDKFlowUpdateDevice.h"
@interface DeviceBG5SViewController ()<BG5SDelegate>
@property (weak, nonatomic) IBOutlet UITextView *bg5STextView;

@property (weak, nonatomic) IBOutlet UILabel *deviceLabel;

@property (weak, nonatomic) IBOutlet UIButton *getDeviceVersionBtn;

@property (weak, nonatomic) IBOutlet UIButton *startUpdateBtn;

@property (weak, nonatomic) IBOutlet UIButton *getCloudVersionBtn;

@property (weak, nonatomic) IBOutlet UIButton *stopUpdateBtn;

@property (weak, nonatomic) IBOutlet UIButton *stopDownloadBtn;

@property (weak, nonatomic) IBOutlet UIButton *startDownLoadBtn;

@property (strong, nonatomic) BG5S *myBg5S;

@property (copy, nonatomic) NSString *modelNumber;
@property (copy, nonatomic) NSString *hardwareVersion;
@property (copy, nonatomic) NSString *currentFirmwareVersion;

@property (copy, nonatomic) NSString *latestFirmwareVersion;
@property (copy, nonatomic) NSString *firmwareIdentifier;
@end

@implementation DeviceBG5SViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.getDeviceVersionBtn setTitle:NSLocalizedString(@"GetDeviceVersion", @"") forState:UIControlStateNormal];
    
    [self.startUpdateBtn setTitle:NSLocalizedString(@"StartUpdate", @"") forState:UIControlStateNormal];
    
    [self.getCloudVersionBtn setTitle:NSLocalizedString(@"GetCloudVersion", @"") forState:UIControlStateNormal];
    
    [self.stopUpdateBtn setTitle:NSLocalizedString(@"StopUpdate", @"") forState:UIControlStateNormal];
    
    [self.stopDownloadBtn setTitle:NSLocalizedString(@"StopDownload", @"") forState:UIControlStateNormal];
    
    [self.startDownLoadBtn setTitle:NSLocalizedString(@"StartDownLoad", @"") forState:UIControlStateNormal];
    
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    
    NSString*deviceMac=[userDefault valueForKey:@"SelectDeviceMac"];
    
    self.deviceLabel.text=[NSString stringWithFormat:@"BG5S %@",deviceMac];
    
    NSArray*deviceArray=[[BG5SController sharedController] getAllCurrentInstace];
    
    for(BG5S *device in deviceArray){
        
        if([deviceMac isEqualToString:device.serialNumber]){
            
            self.myBg5S=device;
            
            self.myBg5S.delegate = self;
            
            self.modelNumber = self.myBg5S.modelNumber;
            self.hardwareVersion = self.myBg5S.hardwareVersion;
            self.currentFirmwareVersion = self.myBg5S.firmwareVersion;
            
        }
    }
    
    
      [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(DeviceDisConnect:) name:kNotificationNameBG5SDidDisConnect object:nil];
   
}
- (IBAction)Cancel:(id)sender {
    
    [self.myBg5S disconnectDevice];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)DeviceDisConnect:(NSNotification *)tempNoti{
    
     self.bg5STextView.text=[NSString stringWithFormat:@"%@:%@\n%@",NSLocalizedString(@"BG5SDisconnect", @""),[tempNoti userInfo],self.bg5STextView.text];
    
}


- (IBAction)queryStateInfo:(id)sender {
    __weak typeof(self) weakSelf = self;

    [self.myBg5S queryStateInfoWithSuccess:^(BG5SStateInfo *stateInfo) {
        
        weakSelf.bg5STextView.text=[NSString stringWithFormat:@"batteryValue:%ld deviceDate:%@ deviceTimeZone:%f stripUsedValue:%ld offlineDataQuantity:%ld bloodCodeVersion:%ld ctlCodeVersion:%ld unit:%lu\n%@",(long)stateInfo.batteryValue,stateInfo.deviceDate,stateInfo.deviceTimeZone,(long)stateInfo.stripUsedValue,(long)stateInfo.offlineDataQuantity,(long)stateInfo.bloodCodeVersion,(long)stateInfo.ctlCodeVersion,(unsigned long)stateInfo.unit,weakSelf.bg5STextView.text];
        
    } errorBlock:^(BG5SError error, NSString *detailInfo) {
        
    }];
}

- (IBAction)SetTime:(id)sender {
    
    __weak typeof(self) weakSelf = self;

    
    NSString *zone = [[NSTimeZone systemTimeZone] description];
    NSString *time = [[zone componentsSeparatedByString:@"offset "] objectAtIndex:1];
    float floatTimeZone = time.floatValue/3600;
    
    [self.myBg5S setTimeWithDate:[NSDate date] timezone:floatTimeZone successBlock:^{
        
        weakSelf.bg5STextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"SetTimeSucess", @""),weakSelf.bg5STextView.text];

        
    } errorBlock:^(BG5SError error, NSString *detailInfo) {
        
    }];
}
- (IBAction)setUnit:(id)sender {
    __weak typeof(self) weakSelf = self;

    [self.myBg5S setUnit:BGUnit_mmolPL successBlock:^{
        
        weakSelf.bg5STextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"SetUnitSucess", @""),weakSelf.bg5STextView.text];

        
    } errorBlock:^(BG5SError error, NSString *detailInfo) {
        
    }];
}

- (IBAction)startMeasure:(id)sender {
    __weak typeof(self) weakSelf = self;

    [self.myBg5S startMeasure:BGMeasureMode_Blood withSuccessBlock:^{
        
        weakSelf.bg5STextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"StartMeasure", @""),weakSelf.bg5STextView.text];

        
    } errorBlock:^(BG5SError error, NSString *detailInfo) {
        
    }];
}
- (IBAction)startMeasureCTL:(id)sender {
    __weak typeof(self) weakSelf = self;

    [self.myBg5S startMeasure:BGMeasureMode_NoBlood withSuccessBlock:^{
        
        weakSelf.bg5STextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"StartMeasure", @""),weakSelf.bg5STextView.text];

        
    } errorBlock:^(BG5SError error, NSString *detailInfo) {
        
    }];
}


- (IBAction)setBloodCode:(id)sender {
    __weak typeof(self) weakSelf = self;

    [self.myBg5S setCodeWithMeasureMode:BGMeasureMode_Blood resultBlock:^(BOOL success) {
        
         weakSelf.bg5STextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"Set Blood Code", @""),weakSelf.bg5STextView.text];
        
    } errorBlock:^(BG5SError error, NSString *detailInfo) {
        
    }];
}
- (IBAction)setNOBloodCode:(id)sender {
    __weak typeof(self) weakSelf = self;

    [self.myBg5S setCodeWithMeasureMode:BGMeasureMode_NoBlood resultBlock:^(BOOL success) {
        
         weakSelf.bg5STextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"Set NoBlood Code", @""),weakSelf.bg5STextView.text];
        
    } errorBlock:^(BG5SError error, NSString *detailInfo) {
        
    }];
}

- (IBAction)deleteStripUsedInfoWithSuccessBlock:(id)sender {
    
    __weak typeof(self) weakSelf = self;

    
    [self.myBg5S deleteStripUsedInfoWithSuccessBlock:^{
        weakSelf.bg5STextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"deleteStripUsedInfo", @""),weakSelf.bg5STextView.text];
    } errorBlock:^(BG5SError error, NSString *detailInfo) {
        
    }];
}

- (IBAction)deleteMemoryData:(id)sender {
    
    __weak typeof(self) weakSelf = self;

    
    [self.myBg5S deleteRecordWithSuccessBlock:^{
        
        weakSelf.bg5STextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"DeleteDataSucess", @""),weakSelf.bg5STextView.text];
        
    } errorBlock:^(BG5SError error, NSString *detailInfo) {
        
    }];
}

- (IBAction)BG5SGetDevice:(id)sender {
    
    
    __weak typeof(self) weakSelf = self;

    
    [self.myBg5S readDeviceInfoWithSuccessBlock:^(NSDictionary *deviceInfoDic) {
        
         weakSelf.bg5STextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"deviceInfoDic", @""),weakSelf.bg5STextView.text];
        
    } errorBlock:^(BG5SError error, NSString *detailInfo) {
        
    }];
}


- (IBAction)queryRecordWithSuccessBlock:(id)sender {
    
    __weak typeof(self) weakSelf = self;

    
    [self.myBg5S queryRecordWithSuccessBlock:^(NSArray *array) {
        
        
//        for (int i=0; i<array.count; i++) {
//
//            BG5SRecordModel *obj=[array objectAtIndex:i];
//
//
//            NSString*result=[NSString stringWithFormat:@"数据ID：%@ 时区：%f,测量时间：%@ 测量值：%ld 能否修正：%@",obj.dataID,obj.timeZone,obj.measureDate,(long)obj.value,obj.canCorrect?@"能":@"不能"];
            
            weakSelf.bg5STextView.text=[NSString stringWithFormat:@"%@:%@\n%@",NSLocalizedString(@"MemoryData", @""),array,weakSelf.bg5STextView.text];
//        }
        
        
      
    } errorBlock:^(BG5SError error, NSString *detailInfo) {
        
    }];
}
- (IBAction)disconnectDevice:(id)sender {
    
    [self.myBg5S disconnectDevice];
}

- (IBAction)setOfflineData:(id)sender {
    
    __weak typeof(self) weakSelf = self;

    [self.myBg5S setIsOfflineMeasurementAllowed:NO successBlock:^{
        
         weakSelf.bg5STextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"setOfflineData", @""),weakSelf.bg5STextView.text];
        
    } errorBlock:^(BG5SError error, NSString *detailInfo) {
        
    }];
}

- (IBAction)setOfflineDataY:(id)sender {
    
    __weak typeof(self) weakSelf = self;

    [self.myBg5S setIsOfflineMeasurementAllowed:YES successBlock:^{
        
         weakSelf.bg5STextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"setOfflineData", @""),weakSelf.bg5STextView.text];
        
    } errorBlock:^(BG5SError error, NSString *detailInfo) {
        
    }];
}

- (IBAction)commandCloseDeviceBLEWithSuccessBlock:(id)sender {
    
    __weak typeof(self) weakSelf = self;

    [self.myBg5S commandCloseDeviceBLEWithSuccessBlock:^{
        
        weakSelf.bg5STextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"CloseDeviceBLE", @""),weakSelf.bg5STextView.text];
        
    } errorBlock:^(BG5SError error, NSString *detailInfo) {
        
    }];
}

- (IBAction)commandSetDeviceDisplayOn:(id)sender {
    
    __weak typeof(self) weakSelf = self;

    [self.myBg5S commandSetDeviceDisplay:YES successBlock:^{
        
        weakSelf.bg5STextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"SetDeviceDisplayOn", @""),weakSelf.bg5STextView.text];
        
        
    } errorBlock:^(BG5SError error, NSString *detailInfo) {
        
    }];
}

- (IBAction)commandSetDeviceDisplayOff:(id)sender {
    
    __weak typeof(self) weakSelf = self;

    [self.myBg5S commandSetDeviceDisplay:NO successBlock:^{
        
        weakSelf.bg5STextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"SetDeviceDisplayOff", @""),weakSelf.bg5STextView.text];
        
        
    } errorBlock:^(BG5SError error, NSString *detailInfo) {
        
    }];
}



#pragma mark - BG5SDelegate
- (void)device:(BG5S *)device occurError:(BG5SError)error errorDescription:(NSString *)errorDescription{
    NSLog(@"下位机主发的错误信息：%d",(int)error);
    
    self.bg5STextView.text=[NSString stringWithFormat:@"%@:%@\n%@",NSLocalizedString(@"errorDescription", @""),errorDescription,self.bg5STextView.text];
}
- (void)device:(BG5S *)device stripStateDidUpdate:(BG5SStripState)state{
    
    if (state == BG5SStripState_Insert) {
         self.bg5STextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"StripIn", @""),self.bg5STextView.text];
    }else if (state == BG5SStripState_PullOff){
        
        self.bg5STextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"StripOut", @""),self.bg5STextView.text];
    }
    
    
    NSLog(@"试条状态：%@",(state == BG5SStripState_Insert)?@"插入":@"拔出");
}
- (void)deviceDropBlood:(BG5S *)device{
    NSLog(@"滴血");
    
    self.bg5STextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"Blood", @""),self.bg5STextView.text];
}
- (void)device:(BG5S *)device dataID:(NSString *)dataID measureReult:(NSInteger)result{
    NSLog(@"结果:%d",(int)result);
    
    self.bg5STextView.text=[NSString stringWithFormat:@"%@:%ld\n%@",NSLocalizedString(@"BGResult", @""),(long)result,self.bg5STextView.text];
}
- (void)device:(BG5S *)device chargeStateDidUpdate:(BG5SChargeState)state{
    NSLog(@"充电线状态：%@",(state == BG5SChargeState_Charging)?@"插入":@"拔出");
    
    self.bg5STextView.text=[NSString stringWithFormat:@"%@:%ld\n%@",NSLocalizedString(@"BG5SChargeState", @""),(long)state,self.bg5STextView.text];
}


#pragma mark -


- (IBAction)getDeviceFirmwareInfo:(id)sender {
    
//    [[DFUController shareInstance] queryDeviceFirmwareInfoWithDeviceType:DFUDeviceType_BG5S uuid:self.myBg5S.currentUUID successBlock:^(DFUDeviceFirmwareInfo *deviceFirmwareInfo) {
//         self.bg5STextView.text=[NSString stringWithFormat:@"%@:%@\n%@",NSLocalizedString(@"updateVersionDic", @""),deviceFirmwareInfo,self.bg5STextView.text];
//    } errorBlock:^(DFUError error) {
//
//    }];
    
    [[SDKFlowUpdateDevice shareSDKUpdateDeviceInstance] commandGetUpdateVersionWithDeviceUUID:self.myBg5S.currentUUID DeviceType:UpdateFlowDeviceType_BG5S DisposeUpdateVersionResult:^(NSDictionary *updateVersionDic) {
        
        NSLog(@"updateVersionDic:%@",updateVersionDic);
        
         self.bg5STextView.text=[NSString stringWithFormat:@"%@:%@\n%@",NSLocalizedString(@"HS2S updateVersionDic", @""),updateVersionDic,self.bg5STextView.text];
        
    } DisposeErrorBlock:^(UpdateFlowDeviceError errorID) {
        
        [self HS2SUpdataError:errorID];
    }];
}
- (IBAction)getServerFirmwareInfo:(id)sender {
    
    [[DFUController shareInstance] queryServerFirmwareInfoWithDeviceType:DFUDeviceType_BG5S productModel:self.modelNumber currentFirmwareVersion:self.currentFirmwareVersion hardwareVersion:self.hardwareVersion  successBlock:^(DFUServerFirmwareInfo *serverFirmwareInfo) {
        
        self.bg5STextView.text=[NSString stringWithFormat:@"%@:%@\n%@",NSLocalizedString(@"serverFirmwareInfo", @""),serverFirmwareInfo,self.bg5STextView.text];
        
    } errorBlock:^(DFUError error) {
        
    }];
    
}

- (IBAction)downloadFirmware:(id)sender {
    
    [[DFUController shareInstance] downloadFirmwareWithDeviceType:DFUDeviceType_BG5S productModel:self.modelNumber firmwareVersion:self.currentFirmwareVersion hardwareVersion:self.hardwareVersion downloadStartBlock:^{
         self.bg5STextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"StartDownload", @""),self.bg5STextView.text];
    } downloadFirmwareProgressBlock:^(NSInteger progress) {
        
        self.bg5STextView.text=[NSString stringWithFormat:@"%@:%ld\n%@",NSLocalizedString(@"DownloadFirmwareProgress", @""),(long)progress,self.bg5STextView.text];
        
    } successblock:^(NSString *firmwareIdentifier) {
        self.firmwareIdentifier = firmwareIdentifier;
        
         self.bg5STextView.text=[NSString stringWithFormat:@"%@:%@\n%@",NSLocalizedString(@"firmwareIdentifier", @""),firmwareIdentifier,self.bg5STextView.text];
        
    } errorBlock:^(DFUError error) {
        
    }];
}
- (IBAction)startDFU:(id)sender {
    
//    [[DFUController shareInstance]startUpgradeWithDeviceType:DFUDeviceType_BG5S productModel:self.modelNumber uuid:self.myBg5S.currentUUID firmwareVersion:self.currentFirmwareVersion hardwareVersion:self.hardwareVersion firmwareIdentifier:self.firmwareIdentifier deviceReplyCannotUpgradeBlock:^(DFUDeviceReplyCannotUpgradeReason reason) {
//
//        switch (reason) {
//            case DFUDeviceReplyCannotUpgradeReason_Unknown:
//               self.bg5STextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"DFUDeviceReplyCannotUpgradeReason_Unknown", @""),self.bg5STextView.text];
//                break;
//            case DFUDeviceReplyCannotUpgradeReason_Battery:
//                 self.bg5STextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"DFUDeviceReplyCannotUpgradeReason_Battery", @""),self.bg5STextView.text];
//                break;
//            case DFUDeviceReplyCannotUpgradeReason_InMeasuring:
//                 self.bg5STextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"DFUDeviceReplyCannotUpgradeReason_InMeasuring", @""),self.bg5STextView.text];
//                break;
//            default:
//                break;
//        }
//
//    } transferBeginBlock:^{
//        self.bg5STextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"transferBegin", @""),self.bg5STextView.text];
//    } transferProgressBlock:^(NSInteger progress) {
//
//        self.bg5STextView.text=[NSString stringWithFormat:@"%@:%ld\n%@",NSLocalizedString(@"transferProgress", @""),(long)progress,self.bg5STextView.text];
//
//    } transferSuccessBlock:^(NSUInteger writeMCUSpeed) {
//
//         self.bg5STextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"transferSuccess", @""),self.bg5STextView.text];
//
//    } transferResultBlock:^(DFUTransmissionResultType type, DFUPauseReason reason, NSInteger pauseLength) {
//
//    } upgradeSuccessBlock:^{
//         self.bg5STextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"upgradeSuccess", @""),self.bg5STextView.text];
//    } upgradeFailBlock:^(DFUUpgradeFailReason reason) {
//
//        switch (reason) {
//            case DFUUpgradeFailReason_Unknown:
//                 self.bg5STextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"DFUUpgradeFailReason_Unknown", @""),self.bg5STextView.text];
//                break;
//            case DFUUpgradeFailReason_DeviceRecieveWrongDataOrNotRecieve:
//                self.bg5STextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"DFUUpgradeFailReason_DeviceRecieveWrongDataOrNotRecieve", @""),self.bg5STextView.text];
//                break;
//            case DFUUpgradeFailReason_WriteMCUError:
//                self.bg5STextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"DFUUpgradeFailReason_WriteMCUError", @""),self.bg5STextView.text];
//                break;
//            case DFUUpgradeFailReason_DeviceStopUpgrade:
//                self.bg5STextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"DFUUpgradeFailReason_DeviceStopUpgrade", @""),self.bg5STextView.text];                break;
//            default:
//                break;
//        }
//    } upgradeErrorBlock:^(DFUError error) {
//
//    }];
    
    NSString *fileinfoPath = [[NSBundle mainBundle] pathForResource:@"BG5S 110701.0.02.0.0info" ofType:@"bin"];

    NSString *fileFirPath = [[NSBundle mainBundle] pathForResource:@"BG5S 110701.0.02.0.0firmware" ofType:@"bin"];
    

    [[SDKFlowUpdateDevice shareSDKUpdateDeviceInstance] commandStartUpdateWithDeviceUUID:self.myBg5S.currentUUID DeviceType:UpdateFlowDeviceType_BG5S InfoFilePath:fileinfoPath UpadteFilePath:fileFirPath DisposeUpdateProgress:^(NSNumber *progress) {

        NSLog(@"DisposeUpdateProgress:%@",progress);
        
        self.bg5STextView.text=[NSString stringWithFormat:@"%@:%@\n%@",NSLocalizedString(@"HS2S DisposeUpdateProgress", @""),progress,self.bg5STextView.text];
        

    } DisposeUpdateResult:^(NSNumber *updateResult) {

         NSLog(@"updateResult:%@",updateResult);
        
         self.bg5STextView.text=[NSString stringWithFormat:@"%@:%@\n%@",NSLocalizedString(@"HS2S updateResult", @""),updateResult,self.bg5STextView.text];

    } TransferSuccess:^(NSNumber *transferSuccess) {

         NSLog(@"transferSuccess:%@",transferSuccess);
        
        self.bg5STextView.text=[NSString stringWithFormat:@"%@:%@\n%@",NSLocalizedString(@"HS2S transferSuccess", @""),transferSuccess,self.bg5STextView.text];

    } DisposeErrorBlock:^(UpdateFlowDeviceError errorID) {

        [self HS2SUpdataError:errorID];
    }];
}

- (IBAction)cancelDownload:(id)sender {
   
    [[DFUController shareInstance] cancelDownloadFirmwareWithDeviceType:DFUDeviceType_BG5S successBlock:^{
       self.bg5STextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"StopDownload", @""),self.bg5STextView.text];
    }];
}
- (IBAction)stopDFU:(id)sender {
    
    [[SDKFlowUpdateDevice shareSDKUpdateDeviceInstance] commandEndUpdateWithDeviceUUID:self.myBg5S.currentUUID DeviceType:UpdateFlowDeviceType_BG5S DisposeEndUpdateResult:^(NSNumber *endUpdate) {
        
        self.bg5STextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"StopUpdate", @""),self.bg5STextView.text];
        
    } DisposeErrorBlock:^(UpdateFlowDeviceError errorID) {
        
    }];
    
//    [[DFUController shareInstance]stopUpgradeWithDeviceType:DFUDeviceType_BG5S uuid:self.myBg5S.currentUUID successBlock:^{
//
//         self.bg5STextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"StopUpdate", @""),self.bg5STextView.text];
//
//    } failBlock:^(DFUError error) {
//
//    }];
    
    
}



- (IBAction)commandGetDeviceVersion:(id)sender {

    [[SDKFlowUpdateDevice shareSDKUpdateDeviceInstance] commandGetUpdateVersionWithDeviceUUID:self.myBg5S.currentUUID DeviceType:UpdateFlowDeviceType_BG5S DisposeUpdateVersionResult:^(NSDictionary *updateVersionDic) {
        
        NSLog(@"updateVersionDic:%@",updateVersionDic);
        
         self.bg5STextView.text=[NSString stringWithFormat:@"%@:%@\n%@",NSLocalizedString(@"HS2S updateVersionDic", @""),updateVersionDic,self.bg5STextView.text];
        
    } DisposeErrorBlock:^(UpdateFlowDeviceError errorID) {
        
        [self HS2SUpdataError:errorID];
    }];
  
    
   
}

- (IBAction)commandGetUpdateModuleState:(id)sender {
    
    [[SDKFlowUpdateDevice shareSDKUpdateDeviceInstance] commandGetUpdateModuleState:^(NSNumber *updateModuleState) {
        
        
        NSLog(@"updateModuleState:%@",updateModuleState);
        
        self.bg5STextView.text=[NSString stringWithFormat:@"%@:%@\n%@",NSLocalizedString(@"HS2S updateModuleState", @""),updateModuleState,self.bg5STextView.text];
        
    }];
    
    
    
}



- (IBAction)commandUpdataDevice:(id)sender {
    
   
    [[SDKFlowUpdateDevice shareSDKUpdateDeviceInstance] commandStartUpdateWithDeviceUUID:self.myBg5S.currentUUID DeviceType:UpdateFlowDeviceType_HS2S DownloadFirmwareStart:^{
        
        NSLog(@"DownloadFirmwareStart");
        
        self.bg5STextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"HS2S DownloadFirmwareStart", @""),self.bg5STextView.text];
        
    } DisposeDownloadFirmwareFinish:^{
        
         NSLog(@"DisposeDownloadFirmwareFinish");
        
        self.bg5STextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"HS2S DisposeDownloadFirmwareFinish", @""),self.bg5STextView.text];
        
    } DisposeDownloadProgress:^(NSNumber *progress) {
        
        NSLog(@"DisposeDownloadProgress:%@",progress);
        
        self.bg5STextView.text=[NSString stringWithFormat:@"%@:%@\n%@",NSLocalizedString(@"HS2S DisposeDownloadProgress", @""),progress,self.bg5STextView.text];
        
    } DisposeUpdateProgress:^(NSNumber *progress) {
        
        NSLog(@"DisposeUpdateProgress:%@",progress);
        
        self.bg5STextView.text=[NSString stringWithFormat:@"%@:%@\n%@",NSLocalizedString(@"HS2S DisposeUpdateProgress", @""),progress,self.bg5STextView.text];
        
    } DisposeUpdateResult:^(NSNumber *updateResult) {
        
        NSLog(@"updateResult:%@",updateResult);
        
        self.bg5STextView.text=[NSString stringWithFormat:@"%@:%@\n%@",NSLocalizedString(@"HS2S updateResult", @""),updateResult,self.bg5STextView.text];
        
    } TransferSuccess:^(NSNumber *transferSuccess) {
        
         NSLog(@"transferSuccess:%@",transferSuccess);
        
        self.bg5STextView.text=[NSString stringWithFormat:@"%@:%@\n%@",NSLocalizedString(@"HS2S transferSuccess", @""),transferSuccess,self.bg5STextView.text];
        
    } DisposeErrorBlock:^(UpdateFlowDeviceError errorID) {
        
        [self HS2SUpdataError:errorID];
        
    }];

}

- (IBAction)commandUpdataDeviceWithLocalFile:(id)sender {
    
    
    NSString *fileinfoPath = [[NSBundle mainBundle] pathForResource:@"HS2S 110705.0.00.6.1info" ofType:@"bin"];

    NSString *fileFirPath = [[NSBundle mainBundle] pathForResource:@"HS2S 110705.0.00.6.1firmware" ofType:@"bin"];
    

    [[SDKFlowUpdateDevice shareSDKUpdateDeviceInstance] commandStartUpdateWithDeviceUUID:self.myBg5S.currentUUID DeviceType:UpdateFlowDeviceType_HS2S InfoFilePath:fileinfoPath UpadteFilePath:fileFirPath DisposeUpdateProgress:^(NSNumber *progress) {

        NSLog(@"DisposeUpdateProgress:%@",progress);
        
        self.bg5STextView.text=[NSString stringWithFormat:@"%@:%@\n%@",NSLocalizedString(@"HS2S DisposeUpdateProgress", @""),progress,self.bg5STextView.text];
        

    } DisposeUpdateResult:^(NSNumber *updateResult) {

         NSLog(@"updateResult:%@",updateResult);
        
         self.bg5STextView.text=[NSString stringWithFormat:@"%@:%@\n%@",NSLocalizedString(@"HS2S updateResult", @""),updateResult,self.bg5STextView.text];

    } TransferSuccess:^(NSNumber *transferSuccess) {

         NSLog(@"transferSuccess:%@",transferSuccess);
        
        self.bg5STextView.text=[NSString stringWithFormat:@"%@:%@\n%@",NSLocalizedString(@"HS2S transferSuccess", @""),transferSuccess,self.bg5STextView.text];

    } DisposeErrorBlock:^(UpdateFlowDeviceError errorID) {

        [self HS2SUpdataError:errorID];
    }];

    
}

- (IBAction)commandDownUpdataDeviceWithLocalFile:(id)sender {
    
    
    NSString *fileinfoPath = [[NSBundle mainBundle] pathForResource:@"HS2S 110705.0.09.0.0info" ofType:@"bin"];
    
    NSString *fileFirPath = [[NSBundle mainBundle] pathForResource:@"HS2S 110705.0.09.0.0firmware" ofType:@"bin"];
    
    //    HS2S 110701.0.00.5.7
    
    //    [[SDKFlowDFUController shareInstance] startUpgradeWithDeviceUuid:self.myBg5S.currentUUID firmwareVersion:@"0.6.1" firmwareIdentifier:@"HS2S 110705.0.00.6.1" deviceReplyCannotUpgradeBlock:^(DFUDeviceReplyCannotUpgradeReason reason) {
    //
    //    } transferBeginBlock:^{
    //
    //    } transferProgressBlock:^(NSInteger progress) {
    //
    //    } transferResultBlock:^(DFUTransmissionResultType type, DFUPauseReason reason, NSInteger pauseLength) {
    //
    //    } upgradeFailBlock:^(DFUUpgradeFailReason reason) {
    //
    //    } upgradeErrorBlock:^(DFUError error) {
    //
    //    }];
    //
    
    [[SDKFlowUpdateDevice shareSDKUpdateDeviceInstance] commandStartUpdateWithDeviceUUID:self.myBg5S.currentUUID DeviceType:UpdateFlowDeviceType_HS2S InfoFilePath:fileinfoPath UpadteFilePath:fileFirPath DisposeUpdateProgress:^(NSNumber *progress) {
        
        NSLog(@"DisposeUpdateProgress:%@",progress);
        
         self.bg5STextView.text=[NSString stringWithFormat:@"%@:%@\n%@",NSLocalizedString(@"HS2S DisposeUpdateProgress", @""),progress,self.bg5STextView.text];
        
    } DisposeUpdateResult:^(NSNumber *updateResult) {
        
        NSLog(@"updateResult:%@",updateResult);
        
         self.bg5STextView.text=[NSString stringWithFormat:@"%@:%@\n%@",NSLocalizedString(@"HS2S updateResult", @""),updateResult,self.bg5STextView.text];
        
    } TransferSuccess:^(NSNumber *transferSuccess) {
        
        NSLog(@"transferSuccess:%@",transferSuccess);
        
        self.bg5STextView.text=[NSString stringWithFormat:@"%@:%@\n%@",NSLocalizedString(@"HS2S transferSuccess", @""),transferSuccess,self.bg5STextView.text];
        
    } DisposeErrorBlock:^(UpdateFlowDeviceError errorID) {
        
        [self HS2SUpdataError:errorID];
        
    }];
    
    
}

- (IBAction)commandDownUpdataDeviceWithLocalFile600:(id)sender {
    
    
    NSString *fileinfoPath = [[NSBundle mainBundle] pathForResource:@"HS2S 110705.0.00.6.2info" ofType:@"bin"];
    
    NSString *fileFirPath = [[NSBundle mainBundle] pathForResource:@"HS2S 110705.0.00.6.2firmware" ofType:@"bin"];
    
    [[SDKFlowUpdateDevice shareSDKUpdateDeviceInstance] commandStartUpdateWithDeviceUUID:self.myBg5S.currentUUID DeviceType:UpdateFlowDeviceType_HS2S InfoFilePath:fileinfoPath UpadteFilePath:fileFirPath DisposeUpdateProgress:^(NSNumber *progress) {
        
        NSLog(@"DisposeUpdateProgress:%@",progress);
        
        self.bg5STextView.text=[NSString stringWithFormat:@"%@:%@\n%@",NSLocalizedString(@"HS2S DisposeUpdateProgress", @""),progress,self.bg5STextView.text];
        
    } DisposeUpdateResult:^(NSNumber *updateResult) {
        
        NSLog(@"updateResult:%@",updateResult);
        
        self.bg5STextView.text=[NSString stringWithFormat:@"%@:%@\n%@",NSLocalizedString(@"HS2S updateResult", @""),updateResult,self.bg5STextView.text];
        
    } TransferSuccess:^(NSNumber *transferSuccess) {
        
        NSLog(@"transferSuccess:%@",transferSuccess);
        
        self.bg5STextView.text=[NSString stringWithFormat:@"%@:%@\n%@",NSLocalizedString(@"HS2S transferSuccess", @""),transferSuccess,self.bg5STextView.text];
        
    } DisposeErrorBlock:^(UpdateFlowDeviceError errorID) {
        
        [self HS2SUpdataError:errorID];
        
    }];
    
    
}

- (IBAction)commandDownUpdataDeviceWithLocalFileTo610:(id)sender {
    
    
    NSString *fileinfoPath = [[NSBundle mainBundle] pathForResource:@"HS2S 110705.0.00.6.3info" ofType:@"bin"];
    
    NSString *fileFirPath = [[NSBundle mainBundle] pathForResource:@"HS2S 110705.0.00.6.3firmware" ofType:@"bin"];
    
    [[SDKFlowUpdateDevice shareSDKUpdateDeviceInstance] commandStartUpdateWithDeviceUUID:self.myBg5S.currentUUID DeviceType:UpdateFlowDeviceType_HS2S InfoFilePath:fileinfoPath UpadteFilePath:fileFirPath DisposeUpdateProgress:^(NSNumber *progress) {
        
        NSLog(@"DisposeUpdateProgress:%@",progress);
        
        self.bg5STextView.text=[NSString stringWithFormat:@"%@:%@\n%@",NSLocalizedString(@"HS2S DisposeUpdateProgress", @""),progress,self.bg5STextView.text];
        
    } DisposeUpdateResult:^(NSNumber *updateResult) {
        
        NSLog(@"updateResult:%@",updateResult);
        
        self.bg5STextView.text=[NSString stringWithFormat:@"%@:%@\n%@",NSLocalizedString(@"HS2S updateResult", @""),updateResult,self.bg5STextView.text];
        
    } TransferSuccess:^(NSNumber *transferSuccess) {
        
        NSLog(@"transferSuccess:%@",transferSuccess);
        
        self.bg5STextView.text=[NSString stringWithFormat:@"%@:%@\n%@",NSLocalizedString(@"HS2S transferSuccess", @""),transferSuccess,self.bg5STextView.text];
        
    } DisposeErrorBlock:^(UpdateFlowDeviceError errorID) {
        
        [self HS2SUpdataError:errorID];
        
    }];
    
    
}



- (IBAction)commandStopUpdataDevice:(id)sender {
    
    [[SDKFlowUpdateDevice shareSDKUpdateDeviceInstance] commandEndUpdateWithDeviceUUID:self.myBg5S.currentUUID DeviceType:UpdateFlowDeviceType_HS2S DisposeEndUpdateResult:^(NSNumber *endUpdate) {
        
        NSLog(@"HS2S endUpdate:%@",endUpdate);
        
         self.bg5STextView.text=[NSString stringWithFormat:@"%@:%@\n%@",NSLocalizedString(@"HS2S endUpdate", @""),endUpdate,self.bg5STextView.text];
        
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
    
    self.bg5STextView.text=[NSString stringWithFormat:@"%@:%lu detial:%@\n%@",NSLocalizedString(@"HS2SUpdataError", @""),(unsigned long)errorID,errorDetail,self.bg5STextView.text];
    
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
