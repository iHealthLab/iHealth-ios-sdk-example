//
//  DeviceBG1AViewController.m
//  iHealthDemoCode
//
//  Created by jing on 2019/5/6.
//  Copyright © 2019 iHealth Demo Code. All rights reserved.
//

#import "DeviceBG1AViewController.h"
#import "BGHeader.h"
#import "SDKFlowUpdateDevice.h"

@interface DeviceBG1AViewController ()

@property (weak, nonatomic) IBOutlet UITextView *bg1STextView;

@property (strong, nonatomic) BG1A *device;

@end

@implementation DeviceBG1AViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    
    NSString*deviceMac=[userDefault valueForKey:@"SelectDeviceMac"];
    
    self.bg1STextView.text=[NSString stringWithFormat:@"BG1A %@",deviceMac];
    
    self.device = [[BG1AController shareIHBG1AController]getInstanceWithMac:deviceMac];
    
     [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(deviceBG1ADisconnected:) name:BG1ADisConnectNoti object:nil];
    
//     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(BG1SNotificationCodeCard:) name:@"BG1SNotificationCodeCard" object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(BG1SNotificationCodezhikongCard:) name:@"BG1SNotificationCodezhikongCard" object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(BG1SNotificationGZState:) name:@"BG1SNotificationGZState" object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(BG1SNotificationTempResult:) name:@"BG1SNotificationTempResult" object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(BG1SNotificationBiaoDingNum:) name:@"BG1SNotificationBiaoDingNum" object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(BG1SNotificationBiaoDingResult:) name:@"BG1SNotificationBiaoDingResult" object:nil];
    
}



-(void)deviceBG1ADisconnected:(NSNotification *)tempNoti{

    NSDictionary*deviceDic= [tempNoti userInfo];
    
     self.bg1STextView.text = [self.bg1STextView.text stringByAppendingString:[NSString stringWithFormat:@"\n 设备断开:%@",deviceDic]];
    
}

-(void)BG1SNotificationCodeCard:(NSNotification *)tempNoti{
 
    NSDictionary*deviceDic= [tempNoti userInfo];
    
    NSString*bloodCodeResult=[deviceDic valueForKey:@"bloodCodeResult"];
    
    
    NSData*bloodCodeCRC=[deviceDic valueForKey:@"bloodCodeCRC"];
    
    NSNumber*codeType=[deviceDic valueForKey:@"codeType"];
    

    self.bg1STextView.text =[NSString stringWithFormat:@"Code值:%@ CRC:%@ Code类型:%@",bloodCodeResult,bloodCodeCRC,codeType];
    
    
}
-(void)BG1SNotificationCodezhikongCard:(NSNotification *)tempNoti{
 
    NSDictionary*deviceDic= [tempNoti userInfo];
    
    
    NSNumber*bloodCodeResult=[deviceDic valueForKey:@"bloodCodeResult"];
       
       
    NSData*bloodCodeCRC=[deviceDic valueForKey:@"bloodCodeCRC"];
    
    
   self.bg1STextView.text =[NSString stringWithFormat:@"Coed值:%@  CRC:%@",bloodCodeResult,bloodCodeCRC];
    
}
-(void)BG1SNotificationGZState:(NSNotification *)tempNoti{
 
    NSDictionary*deviceDic= [tempNoti userInfo];
    
    
     NSNumber*bloodCodeType=[deviceDic valueForKey:@"bloodCodeType"];
    
    
    self.bg1STextView.text =[NSString stringWithFormat:@"Code 类型:%@",bloodCodeType];
    
}
-(void)BG1SNotificationTempResult:(NSNotification *)tempNoti{
 
    NSDictionary*deviceDic= [tempNoti userInfo];
    
    NSNumber*tempResult=[deviceDic valueForKey:@"tempResult"];
    
    
    self.bg1STextView.text =[NSString stringWithFormat:@"温度值:%@",tempResult];
    
    
}
-(void)BG1SNotificationBiaoDingNum:(NSNotification *)tempNoti{
 
    NSDictionary*deviceDic= [tempNoti userInfo];
    
    
      NSNumber*biaodingNum=[deviceDic valueForKey:@"biaodingNum"];
    
    
     self.bg1STextView.text = [NSString stringWithFormat:@"标定值:%@",biaodingNum];
    
}
-(void)BG1SNotificationBiaoDingResult:(NSNotification *)tempNoti{
 
    NSDictionary*deviceDic= [tempNoti userInfo];
    
    NSNumber*biaodingType=[deviceDic valueForKey:@"biaodingType"];
       
    NSNumber*biaodingResult=[deviceDic valueForKey:@"biaodingResult"];
       
    
    self.bg1STextView.text = [NSString stringWithFormat:@"标定类型：%@  标定值:%@",biaodingType,biaodingResult];
    
}


       
     

- (IBAction)disconnect:(id)sender {
    
//    [self.device commandDisconnectDevice];
    
}

- (IBAction)getFunction:(id)sender{
    
//    [self.device commandGetBattery:^(uint8_t battery) {
//        self.bg1STextView.text = [NSString stringWithFormat:@"%d",battery];
//    } fail:^(BG1ADeviceError error) {
//        
//    }];
    
}
- (IBAction)StartTest:(id)sender {
    
    [self.device commandSetMeasureType:BG1AMeasureType_BloodSugar success:^{
        
        self.bg1STextView.text = [NSString stringWithFormat:@"sucess"];
        
    } fail:^(BG1ADeviceError error) {
        
        self.bg1STextView.text = [NSString stringWithFormat:@"error :%d",error];
    }];
    
    
//    [self.device commandCreateBG1STestModel:BGMeasureMode_Blood DisposeBGStripInBlock:^(BOOL inORout) {
//
//        if (inORout) {
//
//            self.bg1STextView.text = [self.bg1STextView.text stringByAppendingString:[NSString stringWithFormat:@"\n 试条插入请滴血"]];
//        }else{
//             self.bg1STextView.text = [self.bg1STextView.text stringByAppendingString:[NSString stringWithFormat:@"\n 试条拔出"]];
//        }
//
//    } DisposeBGBloodBlock:^{
//         self.bg1STextView.text = [self.bg1STextView.text stringByAppendingString:[NSString stringWithFormat:@"\n 滴血成功"]];
//    } DisposeBGResultBlock:^(NSDictionary *result) {
//         self.bg1STextView.text = [self.bg1STextView.text stringByAppendingString:[NSString stringWithFormat:@"\n 测量结果:%@",result]];
//    } DisposeBGErrorBlock:^(BG1SDeviceError error) {
//        self.bg1STextView.text = [self.bg1STextView.text stringByAppendingString:[NSString stringWithFormat:@"\n 错误码:%lu",(unsigned long)error]];
//    }];
}
- (IBAction)Cancel:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}


- (IBAction)commandGetDeviceVersion:(id)sender {

    [[SDKFlowUpdateDevice shareSDKUpdateDeviceInstance] commandGetUpdateVersionWithDeviceUUID:self.device.currentUUID DeviceType:UpdateFlowDeviceType_BG1S DisposeUpdateVersionResult:^(NSDictionary *updateVersionDic) {
        
        NSLog(@"updateVersionDic:%@",updateVersionDic);
        
         self.bg1STextView.text=[NSString stringWithFormat:@"%@:%@\n%@",NSLocalizedString(@"BG1S updateVersionDic", @""),updateVersionDic,self.bg1STextView.text];
        
    } DisposeErrorBlock:^(UpdateFlowDeviceError errorID) {
        
//        [self HS2SUpdataError:errorID];
    }];
  
    
   
}

- (IBAction)commandGetUpdateModuleState:(id)sender {
    
    [[SDKFlowUpdateDevice shareSDKUpdateDeviceInstance] commandGetUpdateModuleState:^(NSNumber *updateModuleState) {
        
        
        NSLog(@"updateModuleState:%@",updateModuleState);
        
        self.bg1STextView.text=[NSString stringWithFormat:@"%@:%@\n%@",NSLocalizedString(@"HS2S updateModuleState", @""),updateModuleState,self.bg1STextView.text];
        
    }];
    
    
    
}



- (IBAction)commandUpdataDevice:(id)sender {
    
   
    [[SDKFlowUpdateDevice shareSDKUpdateDeviceInstance] commandStartUpdateWithDeviceUUID:self.device.currentUUID DeviceType:UpdateFlowDeviceType_BG1S DownloadFirmwareStart:^{
        
        NSLog(@"DownloadFirmwareStart");
        
        self.bg1STextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"HS2S DownloadFirmwareStart", @""),self.bg1STextView.text];
        
    } DisposeDownloadFirmwareFinish:^{
        
         NSLog(@"DisposeDownloadFirmwareFinish");
        
        self.bg1STextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"HS2S DisposeDownloadFirmwareFinish", @""),self.bg1STextView.text];
        
    } DisposeDownloadProgress:^(NSNumber *progress) {
        
        NSLog(@"DisposeDownloadProgress:%@",progress);
        
        self.bg1STextView.text=[NSString stringWithFormat:@"%@:%@\n%@",NSLocalizedString(@"HS2S DisposeDownloadProgress", @""),progress,self.bg1STextView.text];
        
    } DisposeUpdateProgress:^(NSNumber *progress) {
        
        NSLog(@"DisposeUpdateProgress:%@",progress);
        
        self.bg1STextView.text=[NSString stringWithFormat:@"%@:%@\n%@",NSLocalizedString(@"HS2S DisposeUpdateProgress", @""),progress,self.bg1STextView.text];
        
    } DisposeUpdateResult:^(NSNumber *updateResult) {
        
        NSLog(@"updateResult:%@",updateResult);
        
        self.bg1STextView.text=[NSString stringWithFormat:@"%@:%@\n%@",NSLocalizedString(@"HS2S updateResult", @""),updateResult,self.bg1STextView.text];
        
    } TransferSuccess:^(NSNumber *transferSuccess) {
        
         NSLog(@"transferSuccess:%@",transferSuccess);
        
        self.bg1STextView.text=[NSString stringWithFormat:@"%@:%@\n%@",NSLocalizedString(@"HS2S transferSuccess", @""),transferSuccess,self.bg1STextView.text];
        
    } DisposeErrorBlock:^(UpdateFlowDeviceError errorID) {
        
//        [self HS2SUpdataError:errorID];
        
    }];

}


- (IBAction)commandDownUpdataDeviceWithLocalFileTo111:(id)sender {
    
    
    NSString *fileinfoPath = [[NSBundle mainBundle] pathForResource:@"BG1S 110701.1.11.1.1info" ofType:@"bin"];
    
    NSString *fileFirPath = [[NSBundle mainBundle] pathForResource:@"BG1S 110701.1.11.1.1Firmware" ofType:@"bin"];
    
    [[SDKFlowUpdateDevice shareSDKUpdateDeviceInstance] commandStartUpdateWithDeviceUUID:self.device.currentUUID DeviceType:UpdateFlowDeviceType_BG1S InfoFilePath:fileinfoPath UpadteFilePath:fileFirPath DisposeUpdateProgress:^(NSNumber *progress) {
        
        NSLog(@"DisposeUpdateProgress:%@",progress);
        
        self.bg1STextView.text=[NSString stringWithFormat:@"%@:%@\n%@",NSLocalizedString(@"BG1S DisposeUpdateProgress", @""),progress,self.bg1STextView.text];
        
    } DisposeUpdateResult:^(NSNumber *updateResult) {
        
        NSLog(@"updateResult:%@",updateResult);
        
        self.bg1STextView.text=[NSString stringWithFormat:@"%@:%@\n%@",NSLocalizedString(@"BG1S updateResult", @""),updateResult,self.bg1STextView.text];
        
    } TransferSuccess:^(NSNumber *transferSuccess) {
        
        NSLog(@"transferSuccess:%@",transferSuccess);
        
        self.bg1STextView.text=[NSString stringWithFormat:@"%@:%@\n%@",NSLocalizedString(@"BG1S transferSuccess", @""),transferSuccess,self.bg1STextView.text];
        
    } DisposeErrorBlock:^(UpdateFlowDeviceError errorID) {
        
//        [self HS2SUpdataError:errorID];
        
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

- (IBAction)commandReadBGCodeDic:(id)sender {

//    [self.device commandReadBGCodeDic:^(NSDictionary *codeDic) {
//        
//        self.bg1STextView.text=[NSString stringWithFormat:@"%@:%@\n%@",NSLocalizedString(@"BG1S ReadBGCodeDic", @""),codeDic,self.bg1STextView.text];
//        
//    } DisposeBGErrorBlock:^(BG1SDeviceError error) {
//        
//    }];
  
    
   
}

@end
