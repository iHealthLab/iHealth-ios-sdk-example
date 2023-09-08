//
//  DeviceAM5ViewController.m
//  iHealthDemoCode
//
//  Created by user on 2019/7/2.
//  Copyright © 2019 iHealth Demo Code. All rights reserved.
//

#import "DeviceAM5ViewController.h"

#import "AMHeader.h"

#import "ScanDeviceController.h"

#import "ConnectDeviceController.h"

@interface DeviceAM5ViewController ()

@property (weak, nonatomic) IBOutlet UITextView *am5TextView;

@property (weak, nonatomic) IBOutlet UILabel *deviceLabel;

@property (strong, nonatomic) AM5 *myAM5;

@end

@implementation DeviceAM5ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(DeviceDisConnect:) name:AM5DisConnectNoti object:nil];
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    
    NSString*deviceMac=[userDefault valueForKey:@"SelectDeviceMac"];
    
    self.deviceLabel.text=[NSString stringWithFormat:@"AM5 %@",deviceMac];
    
    NSArray*deviceArray=[[AM5Controller shareAM5Controller] getAllCurrentAM5Instace];
    
    for(AM5 *device in deviceArray){
        
        if([deviceMac isEqualToString:device.serialNumber]){
            
            self.myAM5=device;
            
        }
    }
}
- (IBAction)Cancel:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


-(void)DeviceDisConnect:(NSNotification *)info{
    
    
    NSLog(@"deviceDisConnect:%@",[info userInfo]);
    
    self.myAM5=nil;
    
    [self dismissViewControllerAnimated:YES completion:nil];
}



- (IBAction)DisConnect:(id)sender {
    
    [self.myAM5 commandAM5Disconnect];
}
- (IBAction)Bindevice:(id)sender {
    
    [self.myAM5 commandBindingDevice:^(BOOL result) {
        
        NSLog(@"BindingDevice:%d",result);
        
    } DiaposeErrorBlock:^(AM5DeviceError errorID) {
        
    }];
}
- (IBAction)UnBindevice:(id)sender {
    
    [self.myAM5 commandUnBindingDevice:^(BOOL result) {
        NSLog(@"UnBindingDevice:%d",result);
    } DiaposeErrorBlock:^(AM5DeviceError errorID) {
        
    }];
}
- (IBAction)GetDeviceInfo:(id)sender {
    
    [self.myAM5 commandGetDeviceInfo:^(NSMutableDictionary *DeviceInfo) {
        
        NSLog(@"DeviceINfo:%@",DeviceInfo);
        
    } DiaposeErrorBlock:^(AM5DeviceError errorID) {
        
    }];
    
}
- (IBAction)GetFuncTable:(id)sender {
    
    [self.myAM5 commandGetFuncTable:^(NSMutableDictionary *DeviceFuncTable) {
        NSLog(@"DeviceFuncTable:%@",DeviceFuncTable);
    } DiaposeErrorBlock:^(AM5DeviceError errorID) {
        
    }];
}
- (IBAction)commandGetDeviceMac:(id)sender {
    
    [self.myAM5 commandGetDeviceMac:^(NSString *deviceMac) {
        NSLog(@"deviceMac:%@",deviceMac);
    } DiaposeErrorBlock:^(AM5DeviceError errorID) {
        
    }];
}
- (IBAction)commandGetLiveData:(id)sender {
    
    [self.myAM5 commandGetLiveData:^(NSMutableDictionary *liveDataDic) {
        NSLog(@"liveDataDic:%@",liveDataDic);
    } DiaposeErrorBlock:^(AM5DeviceError errorID) {
        
    }];
}
- (IBAction)commandGetActivityCount:(id)sender {
    
    [self.myAM5 commandGetActivityCount:^(NSMutableDictionary *activityCountDic) {
        NSLog(@"activityCountDic:%@",activityCountDic);
    } DiaposeErrorBlock:^(AM5DeviceError errorID) {
        
    }];
}
- (IBAction)commandSetCurrentTime:(id)sender {
    
    [self.myAM5 commandSetCurrentTime:^(BOOL result) {
        if (result==YES) {
            NSLog(@"SetCurrentTimeSucess");
        }else{
            
            NSLog(@"SetCurrentTimeFaild");
        }
    } DiaposeErrorBlock:^(AM5DeviceError errorID) {
        
    }];
}
- (IBAction)commandSetAlarm:(id)sender {
    
    NSArray * alarms = [IDOSetAlarmInfoBluetoothModel queryAllNoOpenAlarms];
    
    IDOSetAlarmInfoBluetoothModel * alarmModel = [alarms firstObject];
    
    alarmModel.isOpen=YES;
    alarmModel.isSync=YES;
    alarmModel.isDelete=NO;
    alarmModel.type=1;
    alarmModel.hour=17;
    alarmModel.minute=0;
    
    alarmModel.tsnoozeDuration=1;
    alarmModel.alarmId=1;
    //    IDOSetAlarmInfoBluetoothModel * alarmModel= [IDOSetAlarmInfoBluetoothModel currentModel];
    //
    [self.myAM5 commandSetAlarm:alarmModel setResult:^(BOOL result) {
        
    } DiaposeErrorBlock:^(AM5DeviceError errorID) {
        
    }];
}
- (IBAction)commandSetUserTarget:(id)sender {
    
    IDOSetUserInfoBuletoothModel * userModel= [IDOSetUserInfoBuletoothModel currentModel];
    
    [self.myAM5 commandSetUserTarget:userModel setResult:^(BOOL result) {
        
    } DiaposeErrorBlock:^(AM5DeviceError errorID) {
        
    }];
}
- (IBAction)commandSetUserInfo:(id)sender {
    
    IDOSetUserInfoBuletoothModel * userModel= [IDOSetUserInfoBuletoothModel currentModel];
    
    [self.myAM5 commandSetUserInfo:userModel setResult:^(BOOL result) {
        
    } DiaposeErrorBlock:^(AM5DeviceError errorID) {
        
    }];
}
- (IBAction)commandSetUnit:(id)sender {
    
    IDOSetUnitInfoBluetoothModel * unitInfo = [IDOSetUnitInfoBluetoothModel currentModel];
    
    [self.myAM5 commandSetUnit:unitInfo setResult:^(BOOL result) {
        
    } DiaposeErrorBlock:^(AM5DeviceError errorID) {
        
    }];
}
- (IBAction)commandSetLongSit:(id)sender {
    
    IDOSetLongSitInfoBuletoothModel * longSit = [IDOSetLongSitInfoBuletoothModel currentModel];
    
    [self.myAM5 commandSetLongSit:longSit setResult:^(BOOL result) {
        
    } DiaposeErrorBlock:^(AM5DeviceError errorID) {
        
    }];
}
- (IBAction)commandSetLeftRightHand:(id)sender {
    
    IDOSetLeftOrRightInfoBuletoothModel * leftOrRightModel = [IDOSetLeftOrRightInfoBuletoothModel currentModel];
    
    leftOrRightModel.isRight=YES;
    
    [self.myAM5 commandSetLeftRightHand:leftOrRightModel setResult:^(BOOL result) {
        
    } DiaposeErrorBlock:^(AM5DeviceError errorID) {
        
    }];
}
- (IBAction)commandSetHrInterval:(id)sender {
    
    IDOSetHrIntervalInfoBluetoothModel * hrIntervalInfo = [IDOSetHrIntervalInfoBluetoothModel currentModel];
    
    [self.myAM5 commandSetHrInterval:hrIntervalInfo setResult:^(BOOL result) {
        
    } DiaposeErrorBlock:^(AM5DeviceError errorID) {
        
    }];
}

- (IBAction)commandSetSwitchNotice:(id)sender {
    
    IDOSetNoticeInfoBuletoothModel* time = [IDOSetNoticeInfoBuletoothModel currentModel];
    
    time.isOnChild=YES;
    
    [self.myAM5 commandSetSwitchNotice:time setResult:^(BOOL result) {
        
        
        
    } DiaposeErrorBlock:^(AM5DeviceError errorID) {
        
    }];
}

- (IBAction)commandSetAppReboot:(id)sender {
    
    [self.myAM5 commandSetAppReboot:^(BOOL result) {
        
    } DiaposeErrorBlock:^(AM5DeviceError errorID) {
        
    }];
}

- (IBAction)commandcommandSetHandUp:(id)sender {
    
    IDOSetHandUpInfoBuletoothModel * handUpModel= [IDOSetHandUpInfoBuletoothModel currentModel];
    
    handUpModel.isOpen=YES;
    
    [self.myAM5 commandSetHandUp:handUpModel setResult:^(BOOL result) {
        
    } DiaposeErrorBlock:^(AM5DeviceError errorID) {
        
    }];
}
- (IBAction)commandSetSportModeSelect:(id)sender {
    
    IDOSetSportShortcutInfoBluetoothModel * sportShortcutInfo = [IDOSetSportShortcutInfoBluetoothModel currentModel];
    
    sportShortcutInfo.isWalk=YES;
    
    sportShortcutInfo.isRun=YES;

    sportShortcutInfo.isByBike=YES;

    sportShortcutInfo.isOnFoot=YES;

    sportShortcutInfo.isMountainClimbing=YES;

    sportShortcutInfo.isBadminton=YES;

    sportShortcutInfo.isFitness=YES;

    sportShortcutInfo.isSpinning=YES;

    sportShortcutInfo.isTreadmill=YES;

    sportShortcutInfo.isYoga=YES;

    sportShortcutInfo.isBasketball=YES;

    sportShortcutInfo.isFootball=YES;

    sportShortcutInfo.isTennis=YES;
    
    sportShortcutInfo.isDance=YES;
    
    
    [self.myAM5 commandSetSportModeSelect:sportShortcutInfo setResult:^(BOOL result) {
        
        NSLog(@"SetSportModeSelectResult:%d",result);
        
        self.am5TextView.text=[NSString stringWithFormat:@"SetSportModeSelectResult:%d\n%@",result,self.am5TextView.text];

        
    } DiaposeErrorBlock:^(AM5DeviceError errorID) {
        
    }];
}
- (IBAction)commandSyncConfigComplete:(id)sender {
    
    [self.myAM5 commandSyncConfigComplete:^(BOOL result) {
        
    } DiaposeErrorBlock:^(AM5DeviceError errorID) {
        
    }];
}

- (IBAction)commandSyncData:(id)sender {
    
    
    [self.myAM5 commandSyncData:^(NSDictionary *syncDataDic) {
        
        NSLog(@"syncHeartRateDataDic:%@",syncDataDic);
        
    } syncSleepData:^(NSDictionary *syncDataDic) {
        
        NSLog(@"syncSleepDataDic:%@",syncDataDic);
        
    } syncActivityData:^(NSDictionary *syncDataDic) {
        
        NSLog(@"syncActivityDataDic:%@",syncDataDic);
        
    } syncDataProgress:^(NSNumber *syncDataProgress) {
        
        NSLog(@"syncDataProgress:%@",syncDataProgress);
        
    } syncDataSuccess:^{
        
        NSLog(@"syncDataSuccess");
        
    } DiaposeErrorBlock:^(AM5DeviceError errorID) {
        
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
