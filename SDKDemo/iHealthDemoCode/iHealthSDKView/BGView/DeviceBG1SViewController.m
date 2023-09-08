//
//  DeviceBG1SViewController.m
//  iHealthDemoCode
//
//  Created by jing on 2019/5/6.
//  Copyright © 2019 iHealth Demo Code. All rights reserved.
//

#import "DeviceBG1SViewController.h"
#import "BGHeader.h"
#import "SDKFlowUpdateDevice.h"

@interface DeviceBG1SViewController ()

@property (weak, nonatomic) IBOutlet UITextView *bg1STextView;

@property (strong, nonatomic) BG1S *myBG1S;

@property (nonatomic, strong) BG1SController *bg1SController;

@end

@implementation DeviceBG1SViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    
    NSString*deviceMac=[userDefault valueForKey:@"SelectDeviceMac"];
    
    self.bg1STextView.text=[NSString stringWithFormat:@"BG1S %@",deviceMac];
    
    NSArray*deviceArray=[[BG1SController shareIHBG1SController] getAllCurrentBG1SInstace];
    
    for(BG1S *device in deviceArray){
        
        if([deviceMac isEqualToString:device.serialNumber]){
            
            self.myBG1S=device;
            
        }
    }
    
     [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(deviceBG1SDisconnected:) name:BG1SDisConnectNoti object:nil];
    
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(BG1SNotificationCodeCard:) name:@"BG1SNotificationCodeCard" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(BG1SNotificationCodezhikongCard:) name:@"BG1SNotificationCodezhikongCard" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(BG1SNotificationGZState:) name:@"BG1SNotificationGZState" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(BG1SNotificationTempResult:) name:@"BG1SNotificationTempResult" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(BG1SNotificationBiaoDingNum:) name:@"BG1SNotificationBiaoDingNum" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(BG1SNotificationBiaoDingResult:) name:@"BG1SNotificationBiaoDingResult" object:nil];
    
}



-(void)deviceBG1SDisconnected:(NSNotification *)tempNoti{

    NSDictionary*deviceDic= [tempNoti userInfo];
    
    
     self.bg1STextView.text = [self.bg1STextView.text stringByAppendingString:[NSString stringWithFormat:@"\n Disconnect:%@",deviceDic]];
    
}

-(void)BG1SNotificationCodeCard:(NSNotification *)tempNoti{
 
    NSDictionary*deviceDic= [tempNoti userInfo];
    
    NSString*bloodCodeResult=[deviceDic valueForKey:@"bloodCodeResult"];
    
    
    NSData*bloodCodeCRC=[deviceDic valueForKey:@"bloodCodeCRC"];
    
    NSNumber*codeType=[deviceDic valueForKey:@"codeType"];
    

    self.bg1STextView.text =[NSString stringWithFormat:@"Code:%@ CRC:%@ CodeType:%@",bloodCodeResult,bloodCodeCRC,codeType];
    
    
}
-(void)BG1SNotificationCodezhikongCard:(NSNotification *)tempNoti{
 
    NSDictionary*deviceDic= [tempNoti userInfo];
    
    
    NSNumber*bloodCodeResult=[deviceDic valueForKey:@"bloodCodeResult"];
       
       
    NSData*bloodCodeCRC=[deviceDic valueForKey:@"bloodCodeCRC"];
    
    
   self.bg1STextView.text =[NSString stringWithFormat:@"Code:%@  CRC:%@",bloodCodeResult,bloodCodeCRC];
    
}
-(void)BG1SNotificationGZState:(NSNotification *)tempNoti{
 
    NSDictionary*deviceDic= [tempNoti userInfo];
    
    
     NSNumber*bloodCodeType=[deviceDic valueForKey:@"bloodCodeType"];
    
    
    self.bg1STextView.text =[NSString stringWithFormat:@"Code Type:%@",bloodCodeType];
    
}
-(void)BG1SNotificationTempResult:(NSNotification *)tempNoti{
 
    NSDictionary*deviceDic= [tempNoti userInfo];
    
    NSNumber*tempResult=[deviceDic valueForKey:@"tempResult"];
    
    
    self.bg1STextView.text =[NSString stringWithFormat:@"TempResult:%@",tempResult];
    
    
}
-(void)BG1SNotificationBiaoDingNum:(NSNotification *)tempNoti{
 
    NSDictionary*deviceDic= [tempNoti userInfo];
    
    
      NSNumber*biaodingNum=[deviceDic valueForKey:@"biaodingNum"];
    
    
     self.bg1STextView.text = [NSString stringWithFormat:@"BiaodingNum:%@",biaodingNum];
    
}
-(void)BG1SNotificationBiaoDingResult:(NSNotification *)tempNoti{
 
    NSDictionary*deviceDic= [tempNoti userInfo];
    
    NSNumber*biaodingType=[deviceDic valueForKey:@"biaodingType"];
       
    NSNumber*biaodingResult=[deviceDic valueForKey:@"biaodingResult"];
       
    
    self.bg1STextView.text = [NSString stringWithFormat:@"biaodingType：%@  biaodingResult:%@",biaodingType,biaodingResult];
    
}


       
     

- (IBAction)disconnect:(id)sender {
    
    [self.myBG1S commandDisconnectDevice];
    
}

- (IBAction)getFunction:(id)sender{
    
    [self.myBG1S commandFunction:^(NSDictionary *functionDict) {
        
        
         self.bg1STextView.text = [self.bg1STextView.text stringByAppendingString:[NSString stringWithFormat:@"\n Battery:%@ CodeVersion:%@ DcodeVersion:%@",[functionDict valueForKey:@"Battary"],[functionDict valueForKey:@"CodeVersion"],[functionDict valueForKey:@"DcodeVersion"]]];
        
       
        
    } DisposeBGErrorBlock:^(BG1SDeviceError error) {
        
        
         self.bg1STextView.text = [self.bg1STextView.text stringByAppendingString:[NSString stringWithFormat:@"\n ErrorCode:%lu",(unsigned long)error]];
    }];
    
    
}
- (IBAction)StartTest:(id)sender {
    
    [self.myBG1S commandCreateBG1STestModel:BGMeasureMode_Blood DisposeBGStripInBlock:^(BOOL inORout) {
        
        if (inORout) {
            
            self.bg1STextView.text = [self.bg1STextView.text stringByAppendingString:[NSString stringWithFormat:@"\n Strip In"]];
        }else{
             self.bg1STextView.text = [self.bg1STextView.text stringByAppendingString:[NSString stringWithFormat:@"\n Strip Out"]];
        }
        
    } DisposeBGBloodBlock:^{
         self.bg1STextView.text = [self.bg1STextView.text stringByAppendingString:[NSString stringWithFormat:@"\n Blood"]];
    } DisposeBGResultBlock:^(NSDictionary *result) {
         self.bg1STextView.text = [self.bg1STextView.text stringByAppendingString:[NSString stringWithFormat:@"\n Result:%@",result]];
    } DisposeBGErrorBlock:^(BG1SDeviceError error) {
        self.bg1STextView.text = [self.bg1STextView.text stringByAppendingString:[NSString stringWithFormat:@"\n ErrorCode:%lu",(unsigned long)error]];
    }];
}
- (IBAction)Cancel:(id)sender {
    
    [self.myBG1S commandDisconnectDevice];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}


- (IBAction)commandGetDeviceVersion:(id)sender {

    [[SDKFlowUpdateDevice shareSDKUpdateDeviceInstance] commandGetUpdateVersionWithDeviceUUID:self.myBG1S.currentUUID DeviceType:UpdateFlowDeviceType_BG1S DisposeUpdateVersionResult:^(NSDictionary *updateVersionDic) {
        
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
    
   
    [[SDKFlowUpdateDevice shareSDKUpdateDeviceInstance] commandStartUpdateWithDeviceUUID:self.myBG1S.currentUUID DeviceType:UpdateFlowDeviceType_BG1S DownloadFirmwareStart:^{
        
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
    
    [[SDKFlowUpdateDevice shareSDKUpdateDeviceInstance] commandStartUpdateWithDeviceUUID:self.myBG1S.currentUUID DeviceType:UpdateFlowDeviceType_BG1S InfoFilePath:fileinfoPath UpadteFilePath:fileFirPath DisposeUpdateProgress:^(NSNumber *progress) {
        
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

    [self.myBG1S commandReadBGCodeDic:^(NSDictionary *codeDic) {
        
        self.bg1STextView.text=[NSString stringWithFormat:@"%@:%@\n%@",NSLocalizedString(@"BG1S ReadBGCodeDic", @""),codeDic,self.bg1STextView.text];
        
    } DisposeBGErrorBlock:^(BG1SDeviceError error) {
        
    }];
  
    
   
}

- (IBAction)commandSetBGCodeDic:(id)sender {
    
    NSString*testCode=[NSString stringWithFormat:@"02323C46323C01006400FA00E102016800F000F001F4025814015E3200A0005A00A0032000320046005A006E0082009600AA00B400E60104011801400168017C0190019A0584054F051C04EB04BC04900467045303E803C903AD037B035303430335032F10273D464E6F32496581AC1447689BFA03FF031306170475"];
    
    [self.myBG1S commandSendBGCodeWithCodeString:testCode DisposeBGSendCodeBlock:^(NSNumber *result) {
       
        self.bg1STextView.text=[NSString stringWithFormat:@"%@:%@\n%@",NSLocalizedString(@"BG1S SendCodeResult", @""),result,self.bg1STextView.text];
        
    } DisposeBGErrorBlock:^(BG1SDeviceError error) {
        
    }];
  
    
   
}



@end
