//
//  DeviceConnectViewController.m
//  iHealthDemoCode
//
//  Created by jing on 2018/9/30.
//  Copyright © 2018年 iHealth Demo Code. All rights reserved.
//

#import "DeviceConnectViewController.h"
#import "ScanDeviceController.h"
#import "HealthHeader.h"
#import "DeviceListCell.h"
#import "BPHeader.h"
#import "BPMacroFile.h"
#import "BGHeader.h"
#import "HSHeader.h"
#import "AMHeader.h"
#import "THV3Macro.h"
#import "POHeader.h"
#import "ECGHeader.h"
#import "NT13BMacroFile.h"
#import "NT13BHeader.h"
#import "DeviceBP5ViewController.h"
#import "DevicePO3ViewController.h"
#import "HS2SController.h"
#import "MBProgressHUD.h"
#import "PT3SBTMacroFile.h"
#import "PT3SBT.h"
#import "PT3SBTController.h"
#import "BG1AController.h"
@interface DeviceConnectViewController ()
@property (weak, nonatomic) IBOutlet UITableView *deviceTable;
@property (weak, nonatomic) IBOutlet UILabel *deviceName;
@property (weak, nonatomic) IBOutlet UIImageView *authImage;
@property (nonatomic) HealthDeviceType SDKDeviceType;
@property (strong,nonatomic) NSMutableArray* deviceArray;
@property (strong,nonatomic) NSMutableArray* deviceMacArray;
@property (weak, nonatomic) IBOutlet UITextView *testLogView;
@property (strong, nonatomic) MBProgressHUD *progressHud;

@property (weak, nonatomic) IBOutlet UILabel *selectdevice;
@end

@implementation DeviceConnectViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    
    NSNumber*devicetypes=[userDefault valueForKey:@"DeviceSDKTypeTag"];
    
    NSString*deviceselectName=[NSString string];
    
    self.deviceMacArray=[[NSMutableArray alloc] init];
    
    self.testLogView.text=@"";
    
    self.selectdevice.text=NSLocalizedString(@"Available devices", @"");
    
    switch ([devicetypes integerValue]) {
        case 1:{
            deviceselectName =@"BP5";
            _SDKDeviceType = HealthDeviceType_BP5;
            
            [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(DeviceConnect:) name:BP5ConnectNoti object:nil];
            [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(DeviceDisConnect:) name:BP5DisConnectNoti object:nil];
            [BP5Controller shareBP5Controller];
        }
            break;
        case 2:{
            deviceselectName =@"KN550BT";
            _SDKDeviceType = HealthDeviceType_KN550BT;
            [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(DeviceDiscover:) name:KN550BTDiscover object:nil];
            [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(DeviceConnectFail:) name:KN550BTConnectFailed object:nil];
            [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(DeviceConnect:) name:KN550BTConnectNoti object:nil];
            [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(DeviceDisConnect:) name:KN550BTDisConnectNoti object:nil];
            
            [KN550BTController shareKN550BTController];
        }
            break;
        case 3:{
            deviceselectName =@"BP7S";
            _SDKDeviceType = HealthDeviceType_BP7S;
            [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(DeviceDiscover:) name:BP7SDiscover object:nil];
            [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(DeviceConnectFail:) name:BP7SConnectFailed object:nil];
            [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(DeviceConnect:) name:BP7SConnectNoti object:nil];
            [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(DeviceDisConnect:) name:BP7SDisConnectNoti object:nil];
            [BP7SController shareBP7SController];
        }
            break;
        case 4:{
            deviceselectName =@"BP3L";
            _SDKDeviceType = HealthDeviceType_BP3L;
            [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(DeviceDiscover:) name:BP3LDiscover object:nil];
            [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(DeviceConnectFail:) name:BP3LConnectFailed object:nil];
            [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(DeviceConnect:) name:BP3LConnectNoti object:nil];
            [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(DeviceDisConnect:) name:BP3LDisConnectNoti object:nil];
            
            
            [BP3LController shareBP3LController];
        }
            break;
        case 5:{
            deviceselectName =@"BG1";
            _SDKDeviceType = HealthDeviceType_BG1;
            [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(DeviceConnect:) name:kNotificationNameNeedAudioPermission object:nil];
            [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(DeviceDisConnect:) name:kNotificationNameBG1DidDisConnect object:nil];
            [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(DeviceDiscover:) name:kNotificationNameAudioDeviceInsert object:nil];
            [[BG1Controller shareBG1Controller] initBGAudioModule];
        }
            break;
        case 6:{
            deviceselectName =@"BG1S";
            _SDKDeviceType = HealthDeviceType_BG1S;
            
            [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(DeviceDiscover:) name:BG1SDiscover object:nil];
            [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(DeviceConnectFail:) name:BG1SConnectFailed object:nil];
            [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(DeviceConnect:) name:BG1SConnectNoti object:nil];
            [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(DeviceDisConnect:) name:BG1SDisConnectNoti object:nil];
            
            [BG1SController shareIHBG1SController];
        }
            break;
        case 7:{
            deviceselectName =@"BG5";
            _SDKDeviceType = HealthDeviceType_BG5;
            [BG5Controller shareIHBg5Controller];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(DeviceConnect:) name:BG5ConnectNoti object:nil];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(DeviceDisConnect:) name:BG5DisConnectNoti object:nil];
        }
            break;
        case 8:{
            deviceselectName =@"BG5S";
            _SDKDeviceType = HealthDeviceType_BG5S;
            
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(DeviceDiscover:) name:kNotificationNameBG5SDidDiscover object:nil];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(DeviceConnectFail:) name:kNotificationNameBG5SConnectFail object:nil];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(DeviceConnect:) name:kNotificationNameBG5SConnectSuccess object:nil];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(DeviceDisConnect:) name:kNotificationNameBG5SDidDisConnect object:nil];
            [BG5SController sharedController];
            
        }
            break;
        case 9:{
            deviceselectName =@"HS2";
            _SDKDeviceType = HealthDeviceType_HS2;
            [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(DeviceDiscover:) name:HS2Discover object:nil];
            [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(DeviceConnectFail:) name:HS2ConnectFailed object:nil];
            [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(DeviceConnect:) name:HS2ConnectNoti object:nil];
            [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(DeviceDisConnect:) name:HS2DisConnectNoti object:nil];
            [HS2Controller shareIHHs2Controller];
        }
            break;
        case 10:{
            deviceselectName =@"HS4";
            _SDKDeviceType = HealthDeviceType_HS4;
            [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(DeviceDiscover:) name:HS4Discover object:nil];
            [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(DeviceConnectFail:) name:HS4ConnectFailed object:nil];
            [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(DeviceConnect:) name:HS4ConnectNoti object:nil];
            [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(DeviceDisConnect:) name:HS4DisConnectNoti object:nil];
            [HS4Controller shareIHHs4Controller];
            
        }
            break;
        case 11:{
            deviceselectName =@"HS6";
            _SDKDeviceType = HealthDeviceType_HS6;
            
            
        }
            break;
        case 12:{
            deviceselectName =@"HS2S";
            _SDKDeviceType = HealthDeviceType_HS2S;
            
            [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(DeviceDiscover:) name:HS2SDiscover object:nil];
            [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(DeviceConnectFail:) name:HS2SConnectFailed object:nil];
            [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(DeviceConnect:) name:HS2SConnectNoti object:nil];
            [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(DeviceDisConnect:) name:HS2SDisConnectNoti object:nil];
            
            [HS2SController shareIHHS2SController];
            
            
        }
            break;
        case 13:{
            deviceselectName =@"AM3S";
            _SDKDeviceType = HealthDeviceType_AM3S;
            
            [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(DeviceDiscover:) name:AM3SDiscover object:nil];
            
            [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(DeviceConnectFail:) name:AM3SConnectFailed object:nil];
            
            [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(DeviceConnect:) name:AM3SConnectNoti object:nil];
            
            [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(DeviceDisConnect:) name:AM3SDisConnectNoti object:nil];
            
            
            
            [AM3SController_V2 shareIHAM3SController];
        }
            break;
        case 14:{
            deviceselectName =@"AM4";
            _SDKDeviceType = HealthDeviceType_AM4;
            [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(DeviceDiscover:) name:AM4Discover object:nil];
            
            [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(DeviceConnectFail:) name:AM4ConnectFailed object:nil];
            
            [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(DeviceConnect:) name:AM4ConnectNoti object:nil];
            
            [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(DeviceDisConnect:) name:AM4DisConnectNoti object:nil];
            
            
            
            [AM4Controller shareIHAM4Controller];
            
        }
            break;
        case 15:{
            deviceselectName =@"AM5";
            _SDKDeviceType = HealthDeviceType_AM5;
            [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(DeviceDiscover:) name:AM5Discover object:nil];
            
            [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(DeviceConnectFail:) name:AM5ConnectFailed object:nil];
            
            [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(DeviceConnect:) name:AM5ConnectNoti object:nil];
            
            [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(DeviceDisConnect:) name:AM5DisConnectNoti object:nil];
            
            
            
            [AM5Controller shareAM5Controller];
            
        }
            break;
        case 16:{
            deviceselectName =@"TS28B";
            _SDKDeviceType = HealthDeviceType_TS28B;
            
          
        }
            break;
        case 17:{
            deviceselectName =@"THV3";
            _SDKDeviceType = HealthDeviceType_THV3;
            
            [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(DeviceDiscover:) name:THV3Discover object:nil];
            [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(DeviceConnectFail:) name:THV3ConnectFailed object:nil];
            [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(DeviceConnect:) name:THV3ConnectNoti object:nil];
            [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(DeviceDisConnect:) name:THV3DisConnectNoti object:nil];
            [THV3Controller sharedController];
            
        }
            break;
        case 18:{
            deviceselectName =@"NT13B";
            _SDKDeviceType = HealthDeviceType_NT13B;
            
            [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(DeviceDiscover:) name:NT13BDiscover object:nil];
            [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(DeviceConnectFail:) name:NT13BConnectFailed object:nil];
            [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(DeviceConnect:) name:NT13BConnectNoti object:nil];
            [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(DeviceDisConnect:) name:NT13BDisConnectNoti object:nil];
            
            [NT13BController shareIHNT13BController];
        }
            break;
        case 19:{
            deviceselectName =@"PT3SBT";
            _SDKDeviceType = HealthDeviceType_PT3SBT;
            
            [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(DeviceDiscover:) name:PT3SBTDiscover object:nil];
            [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(DeviceConnectFail:) name:PT3SBTConnectFailed object:nil];
            [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(DeviceConnect:) name:PT3SBTConnectNoti object:nil];
            [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(DeviceDisConnect:) name:PT3SBTDisConnectNoti object:nil];
            
            [PT3SBTController shareIHPT3SBTController];
        }
            break;
        case 20:{
            deviceselectName =@"PO3/PO3M";
            _SDKDeviceType = HealthDeviceType_PO3;
            
            [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(DeviceConnect:) name:PO3ConnectNoti object:nil];
            [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(DeviceDisConnect:) name:PO3DisConnectNoti object:nil];
            [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(DeviceDiscover:) name:PO3Discover object:nil];
            [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(DeviceConnectFail:) name:PO3ConnectFailed object:nil];
            
            [PO3Controller shareIHPO3Controller];
        }
            break;
        case 21:{
            deviceselectName =@"PO1";
            _SDKDeviceType = HealthDeviceType_PO1;
            
            [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(DeviceDiscover:) name:PO1Discover object:nil];
            [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(DeviceConnectFail:) name:PO1ConnectFailed object:nil];
            [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(DeviceConnect:) name:PO1ConnectNoti object:nil];
            [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(DeviceDisConnect:) name:PO1DisConnectNoti object:nil];
            
            [PO1Controller shareIHPO1Controller];
        }
            break;
        case 22:{
            deviceselectName =@"ECG3";
            _SDKDeviceType = HealthDeviceType_ECG3;
            
            [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(DeviceDiscover:) name:ECG3Discover object:nil];
            [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(DeviceConnectFail:) name:ECG3ConnectFailed object:nil];
            [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(DeviceConnect:) name:ECG3ConnectNoti object:nil];
            [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(DeviceDisConnect:) name:ECG3DisConnectNoti object:nil];
            
            [ECG3Controller shareECG3Controller];
        }
            break;
        case 23:{
            deviceselectName =@"ECG3USB";
            _SDKDeviceType = HealthDeviceType_USBECG;
            
            [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(DeviceDiscover:) name:ECGUSBConnectNoti object:nil];
            [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(DeviceConnectFail:) name:ECG3ConnectFailed object:nil];
            [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(DeviceConnect:) name:ECGUSBConnectNoti object:nil];
            [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(DeviceDisConnect:) name:ECGUSBDisConnectNoti object:nil];
            
            [ECG3USBController shareECG3USBController];
        }
            break;

    
       
        case 25:{
                    deviceselectName =@"BP5S";
                    _SDKDeviceType = HealthDeviceType_BP5S;
                    
                    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(DeviceDiscover:) name:BP5SDiscover object:nil];
                    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(DeviceConnectFail:) name:BP5SConnectFailed object:nil];
                    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(DeviceConnect:) name:BP5SConnectNoti object:nil];
                    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(DeviceDisConnect:) name:BP5SDisConnectNoti object:nil];
        
                    [BP5SController sharedController];
                }
                    break;
            
        case 26:{
                    deviceselectName =@"BP5C";
                    _SDKDeviceType = HealthDeviceType_BP5C;
                    
            [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(DeviceDiscover:) name:BP5CDiscover object:nil];
            [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(DeviceConnectFail:) name:BP5CConnectFailed object:nil];
            [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(DeviceConnect:) name:BP5CConnectNoti object:nil];
            [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(DeviceDisConnect:) name:BP5CDisConnectNoti object:nil];
        
                    [BP5CController sharedController];
                }
                    break;
        case 27:{
            deviceselectName =@"HS2S Pro";
            _SDKDeviceType = HealthDeviceType_HS2SPro;
            
            [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(DeviceDiscover:) name:HS2SPRODiscover object:nil];
            [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(DeviceConnectFail:) name:HS2SPROConnectFailed object:nil];
            [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(DeviceConnect:) name:HS2SPROConnectNoti object:nil];
            [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(DeviceDisConnect:) name:HS2SPRODisConnectNoti object:nil];
            
            [HS2SPROController shareIHHS2SPROController];
            
            
        }
            break;
        case 29:{
            deviceselectName = @"BG1A";
            _SDKDeviceType = HealthDeviceType_BG1A;
            [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(DeviceDiscover:) name:BG1ADiscover object:nil];
            [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(DeviceConnectFail:) name:BG1AConnectFailed object:nil];
            [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(DeviceConnect:) name:BG1AConnectNoti object:nil];
            [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(DeviceDisConnect:) name:BG1ADisConnectNoti object:nil];
            
            [BG1AController shareIHBG1AController];
        }
            break;
        default:
            break;
    }
    NSString*string=NSLocalizedString(@"Selected device", @"");
    self.deviceName.text=[NSString stringWithFormat:@"%@ %@",string,deviceselectName];
    // Do any additional setup after loading the view.
}
- (IBAction)StartDiscover:(id)sender {
    
    if(_SDKDeviceType==HealthDeviceType_HS6){
        
        
         [self performSegueWithIdentifier:@"ConnectHS6View" sender:self];
        
    }else if(_SDKDeviceType==HealthDeviceType_TS28B){
        
        [self performSegueWithIdentifier:@"ConnectTS28BView" sender:self];
    }else{
        
        [[ScanDeviceController commandGetInstance] commandScanDeviceType:_SDKDeviceType];

    }
    if(_SDKDeviceType==HealthDeviceType_BG5){
       
        
        NSArray*deviceArray=[[BG5Controller shareIHBg5Controller] getAllCurrentBG5Instace];
        
        if (deviceArray) {
            for(BG5 *device in deviceArray){
                
                if (![self.deviceMacArray containsObject:device.serialNumber]) {
                    
                    
                    [self.deviceMacArray addObject:device.serialNumber];
                    
                    [self.deviceTable reloadData];
                }
            }
        }

    }else if(_SDKDeviceType==HealthDeviceType_BP5){
        
        
        NSArray*deviceArray=[[BP5Controller shareBP5Controller] getAllCurrentBP5Instace];
        
        if (deviceArray) {
            for(BP5 *device in deviceArray){
                
                if (![self.deviceMacArray containsObject:device.serialNumber]) {
                    
                    
                    [self.deviceMacArray addObject:device.serialNumber];
                    
                    [self.deviceTable reloadData];
                }
            }
        }
        
    }else if(_SDKDeviceType==HealthDeviceType_USBECG){
        
        
        ECG3USB *device=[[ECG3USBController shareECG3USBController] getCurrentECG3USBInstace];
        
        if(device!=nil){
            
            if (![self.deviceMacArray containsObject:device.serialNumber]) {
                
                [self.deviceMacArray addObject:device.serialNumber];
                
                [self.deviceTable reloadData];
            }
        }
        
        
    }
    
}
- (IBAction)cancelBack:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
-(void)DeviceDiscover:(NSNotification *)tempNoti{
    
    NSDictionary *dic = [tempNoti userInfo];
    
    
    if (dic[@"ID"]!=nil &&(_SDKDeviceType!=HealthDeviceType_NT13B)) {
        
        [[ConnectDeviceController commandGetInstance] commandContectDeviceWithDeviceType:_SDKDeviceType andSerialNub:dic[@"ID"]];
        
        return;
    }
    
     NSString*deviceMacStr=[NSString stringWithFormat:@"%@",[dic objectForKey:@"SerialNumber"]];
    
    if (![self.deviceMacArray containsObject:deviceMacStr] && deviceMacStr!=nil &&(_SDKDeviceType!=HealthDeviceType_NT13B)) {
       
        
        [self.deviceMacArray addObject:deviceMacStr];
        
        [self.deviceTable reloadData];
    }
    
    if (_SDKDeviceType==HealthDeviceType_NT13B) {
        
        [self.deviceMacArray addObject:dic[@"ID"]];
        
        [self.deviceTable reloadData];
    }
    
}
-(void)DeviceConnectFail:(NSNotification *)tempNoti{
    
    [self stopAnimation];
    
    [[ScanDeviceController commandGetInstance] commandScanDeviceType:_SDKDeviceType];
    
    self.testLogView.text=[NSString stringWithFormat:@"Connect Fail:%@",[tempNoti userInfo]];
    NSLog(@"connect fail - noti:%@",tempNoti.userInfo);
    
}
-(void)DeviceConnect:(NSNotification *)tempNoti{
    
    NSDictionary *dic = [tempNoti userInfo];
    
    [self stopAnimation];
    
    self.testLogView.text=@"Connect Success";
    
    NSString*deviceMacStr=[dic objectForKey:@"SerialNumber"];
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    
    [userDefault setObject:deviceMacStr forKey:@"SelectDeviceMac"];
   
    [userDefault synchronize];
    
    switch (_SDKDeviceType) {
        case HealthDeviceType_BP5:{
            
              [self performSegueWithIdentifier:@"ConnectBP5View" sender:self];
        }
            break;
        case HealthDeviceType_PO3:{
            
             [self performSegueWithIdentifier:@"ConnectPO3View" sender:self];
        }
            break;
        case HealthDeviceType_KN550BT:{
            
            [self performSegueWithIdentifier:@"Connect550BTView" sender:self];
        }
            break;
        case HealthDeviceType_BP7S:{
            
            [self performSegueWithIdentifier:@"ConnectBP7SView" sender:self];
        }
            break;
        case HealthDeviceType_BP3L:{
            
            [self performSegueWithIdentifier:@"ConnectBP3LView" sender:self];
        }
            break;
        case HealthDeviceType_BG1:{
            
            [self performSegueWithIdentifier:@"ConnectBG1View" sender:self];
        }
            break;
        case HealthDeviceType_BG5:{
            
            [self performSegueWithIdentifier:@"ConnectBG5View" sender:self];
        }
            break;
        case HealthDeviceType_BG5S:{
            
            [self performSegueWithIdentifier:@"ConnectBG5SView" sender:self];
        }
            break;
        case HealthDeviceType_HS2:{
            
            [self performSegueWithIdentifier:@"ConnectHS2View" sender:self];
        }
            break;
        case HealthDeviceType_HS4:{
            
            [self performSegueWithIdentifier:@"ConnectHS4View" sender:self];
        }
            break;
        case HealthDeviceType_HS6:{
            
            [self performSegueWithIdentifier:@"ConnectHS6View" sender:self];
        }
            break;
        case HealthDeviceType_AM3S:{
            
            [self performSegueWithIdentifier:@"ConnectAM3SView" sender:self];
        }
            break;
        case HealthDeviceType_AM4:{
            
            [self performSegueWithIdentifier:@"ConnectAM4View" sender:self];
        }
            break;
        case HealthDeviceType_AM5:{
            
            [self performSegueWithIdentifier:@"ConnectAM5View" sender:self];
        }
            break;
        case HealthDeviceType_TS28B:{
            
            [self performSegueWithIdentifier:@"ConnectTS28BView" sender:self];
        }
            break;
        case HealthDeviceType_THV3:{
            
            [self performSegueWithIdentifier:@"ConnectTHV3View" sender:self];
        }
            break;
        case HealthDeviceType_ECG3:{
            
            [self performSegueWithIdentifier:@"ConnectECG3View" sender:self];
        }
            break;
        case HealthDeviceType_USBECG:{
            
            [self performSegueWithIdentifier:@"ConnectUSBECGView" sender:self];
        }
            break;
        case HealthDeviceType_BP5C:{
            
            [self performSegueWithIdentifier:@"ConnectBP5CView" sender:self];
        }
            break;
        case HealthDeviceType_HS2S:{
            
            [self performSegueWithIdentifier:@"ConnectHS2SView" sender:self];
        }
            break;
        case HealthDeviceType_BG1S:{
            
            [self performSegueWithIdentifier:@"ConnectBG1SView" sender:self];
        }
            break;
        case HealthDeviceType_NT13B:{
            
            [self performSegueWithIdentifier:@"ConnectNT13BView" sender:self];
        }
            break;
       
        case HealthDeviceType_PT3SBT:{
//            PT3SBT *device = [[[PT3SBTController shareIHPT3SBTController]getAllCurrentPT3SBTInstace]objectAtIndex:0];
//            [device commandDisconnectDevice];
//            return;
            [self performSegueWithIdentifier:@"ConnectPT3SBTView" sender:self];
        }
            break;
        case HealthDeviceType_PO1:{
//            PO1 *device = [[[PO1Controller shareIHPO1Controller]getAllCurrentPO1Instace]objectAtIndex:0];
//            [device commandDisconnectDevice];
//            return;
            [self performSegueWithIdentifier:@"ConnectPO1View" sender:self];
        }
            break;
        case HealthDeviceType_BP5S:{
            
            [self performSegueWithIdentifier:@"ConnectBP5SView" sender:self];
        }
            break;
        case HealthDeviceType_HS2SPro:{
            
            [self performSegueWithIdentifier:@"ConnectHS2SPROView" sender:self];
        }
            break;
        case HealthDeviceType_BG1A:{
            [self performSegueWithIdentifier:@"ConnectBG1AView" sender:self];
        }
            break;
        default:
            break;
    }
    
   
    
}
-(void)DeviceDisConnect:(NSNotification *)tempNoti{
    
    [self stopAnimation];
    
      self.testLogView.text=[NSString stringWithFormat:@"DisConnect:%@",[tempNoti userInfo]];
    
    NSDictionary *dic = [tempNoti userInfo];
    
    NSString*deviceMacStr=[NSString stringWithFormat:@"%@",[dic objectForKey:@"SerialNumber"]];
    
    if ([self.deviceMacArray containsObject:deviceMacStr] && deviceMacStr!=nil) {
        
        [self.deviceMacArray removeObject:deviceMacStr];
        
        [self.deviceTable reloadData];
    }
    
    
    [[ScanDeviceController commandGetInstance] commandScanDeviceType:_SDKDeviceType];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.deviceMacArray.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"DeviceDiscoverList";
    
    DeviceListCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
   
    if (!cell) {
        cell = [[DeviceListCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    
    if (self.deviceMacArray.count>0) {
         cell.deviceMac.text=self.deviceMacArray[indexPath.row];
         [cell.deviceConnects setTitle:NSLocalizedString(@"Click to connect", @"") forState:UIControlStateNormal];
        
        [cell.deviceConnects addTarget:self action:@selector(deviceConnectButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        cell.deviceConnects.tag=indexPath.row;
    }
   
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}
-(void)deviceConnectButtonClicked:(UIButton *)sender{
    
    if (_SDKDeviceType==HealthDeviceType_BG5 ||_SDKDeviceType==HealthDeviceType_BP5 ||_SDKDeviceType==HealthDeviceType_USBECG) {
        
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        
        [userDefault setObject:self.deviceMacArray[sender.tag] forKey:@"SelectDeviceMac"];
        
        [userDefault synchronize];
        
        if (_SDKDeviceType==HealthDeviceType_BG5) {
              [self performSegueWithIdentifier:@"ConnectBG5View" sender:self];
        }else if(_SDKDeviceType==HealthDeviceType_BP5) {
            [self performSegueWithIdentifier:@"ConnectBP5View" sender:self];
        }else if(_SDKDeviceType==HealthDeviceType_USBECG) {
            [self performSegueWithIdentifier:@"ConnectUSBECGView" sender:self];
        }
        
      
        
        return;
    }
    
    [self startAnimation];
        
    [[ConnectDeviceController commandGetInstance] commandContectDeviceWithDeviceType:_SDKDeviceType andSerialNub:self.deviceMacArray[sender.tag]];
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   
        [[ConnectDeviceController commandGetInstance] commandContectDeviceWithDeviceType:_SDKDeviceType andSerialNub:self.deviceMacArray[indexPath.row]];
    

}

- (void)startAnimation{
    
    [MBProgressHUD hideHUDForView:self.view animated:NO];
    
    self.progressHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
   
//    self.progressHud.mode = MBProgressHUDModeDeterminateHorizontalBar;
    
}

- (void)stopAnimation{
    
    [MBProgressHUD hideHUDForView:self.view animated:NO];
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
