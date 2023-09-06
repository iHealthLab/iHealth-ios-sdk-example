//
//  DeviceAM3SViewController.m
//  iHealthDemoCode
//
//  Created by jing on 2018/10/22.
//  Copyright © 2018年 iHealth Demo Code. All rights reserved.
//

#import "DeviceAM3SViewController.h"
#import "AMHeader.h"
@interface DeviceAM3SViewController ()
@property (weak, nonatomic) IBOutlet UITextView *am3STextView;

@property (weak, nonatomic) IBOutlet UILabel *deviceLabel;

@property (strong, nonatomic) AM3S_V2 *myAM3S;
@property (strong, nonatomic) HealthUser *myUser;
@property (strong, nonatomic) NSNumber *userIDNumber;
@end

@implementation DeviceAM3SViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    
    NSString*deviceMac=[userDefault valueForKey:@"SelectDeviceMac"];
    
    self.deviceLabel.text=[NSString stringWithFormat:@"AM3S %@",deviceMac];
    
    NSArray*deviceArray=[[AM3SController_V2 shareIHAM3SController] getAllCurrentAM3SInstace];
    
    self.myUser=[[HealthUser alloc] init];
    
    for(AM3S_V2 *device in deviceArray){
        
        if([deviceMac isEqualToString:device.serialNumber]){
            
            self.myAM3S=device;
            
        }
    }
}
- (IBAction)Cancel:(id)sender {
    
    [self.myAM3S commandAM3SDisconnect:^(BOOL resetSuc) {
        
        NSLog(@"commandAM3SDisconnect Ok");
        self.am3STextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"AM3SDisconnect", @""),self.am3STextView.text];
        
    } withErrorBlock:^(AM3SErrorID errorID) {
        
        NSLog(@"AMErrorID:%ld",(unsigned long)errorID);
         self.am3STextView.text=[NSString stringWithFormat:@"AMErrorID:%ld\n%@",(unsigned long)errorID,self.am3STextView.text];
    }];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)commandAM3SSyncTime:(id)sender{
    
    [self.myAM3S commandAM3SSyncTime:^(BOOL resetSuc) {
         self.am3STextView.text=[NSString stringWithFormat:@"%@:%u\n%@",NSLocalizedString(@"SyncTime", @""),resetSuc,self.am3STextView.text];
        
    } withErrorBlock:^(AM3SErrorID errorID) {
       
         self.am3STextView.text=[NSString stringWithFormat:@"AMErrorID:%ld\n%@",(unsigned long)errorID,self.am3STextView.text];
    }];
    
}
- (IBAction)commandAM3SGetDeviceUserID:(id)sender{
    
    [self.myAM3S commandAM3SGetDeviceUserID:^(unsigned int userID) {
        
        self.userIDNumber=[NSNumber numberWithUnsignedInteger:userID];
        self.am3STextView.text=[NSString stringWithFormat:@"%@:%u\n%@",NSLocalizedString(@"GetDeviceUserID", @""),userID,self.am3STextView.text];
        
    } withErrorBlock:^(AM3SErrorID errorID) {
        
        self.am3STextView.text=[NSString stringWithFormat:@"AMErrorID:%ld\n%@",(unsigned long)errorID,self.am3STextView.text];
    }];
}
- (IBAction)commandAM3SSetRandomNumber:(id)sender{
    
    [self.myAM3S commandAM3SSetRandomNumber:^(NSString *randomNumString) {
        
       self.am3STextView.text=[NSString stringWithFormat:@"%@:%@\n%@",NSLocalizedString(@"SetRandomNumber", @""),randomNumString,self.am3STextView.text];
        
    } withErrorBlock:^(AM3SErrorID errorID) {
       
         self.am3STextView.text=[NSString stringWithFormat:@"AMErrorID:%ld\n%@",(unsigned long)errorID,self.am3STextView.text];
    }];
    
}
- (IBAction)commandAM3SSetTimeFormatAndNation:(id)sender{
    
    [self.myAM3S commandAM3SSetTimeFormatAndNation:AM3STimeFormat_EuropeAndhh withFinishResult:^(BOOL resetSuc) {
        
        self.am3STextView.text=[NSString stringWithFormat:@"%@:%u\n%@",NSLocalizedString(@"SetTimeFormatAndNation", @""),resetSuc,self.am3STextView.text];
        
    } withErrorBlock:^(AM3SErrorID errorID) {
        
         self.am3STextView.text=[NSString stringWithFormat:@"AMErrorID:%ld\n%@",(unsigned long)errorID,self.am3STextView.text];
    }];
}
- (IBAction)commandAM3SSetUserInfo:(id)sender{

    self.myUser.age = @12;
    self.myUser.sex = UserSex_Male;
    self.myUser.height = @165;
    self.myUser.weight = @55;
    self.myUser.bmr = @120;
    self.myUser.lengthUnit = LengthUnit_Kilometer;
    self.myUser.activityLevel = @1;
    
    
    [self.myAM3S commandAM3SSetUserInfo:self.myUser withUnit:AM3SKmUnit_mile withActiveGoal:@10000  withSetUserInfoFinishResult:^(BOOL resetSuc) {
        NSLog(@"FinishResultok");
        
        self.am3STextView.text=[NSString stringWithFormat:@"%@:%u\n%@",NSLocalizedString(@"SetUserInfo", @""),resetSuc,self.am3STextView.text];
        
    } withSetBMR:^(BOOL resetSuc) {
        
        NSLog(@"SetBMR ok");
        
        
    } withErrorBlock:^(AM3SErrorID errorID) {
        NSLog(@"AMErrorID:%ld",(unsigned long)errorID);
         self.am3STextView.text=[NSString stringWithFormat:@"AMErrorID:%ld\n%@",(unsigned long)errorID,self.am3STextView.text];
    }];
    
}
- (IBAction)setUserID:(id)sender
{
    [self.myAM3S commandAM3SSetUserID:self.userIDNumber withFinishResult:^(BOOL resetSuc) {
        
        NSLog(@"SetUserIDok");
        
         self.am3STextView.text=[NSString stringWithFormat:@"%@:%u\n%@",NSLocalizedString(@"SetUserID", @""),resetSuc,self.am3STextView.text];
        
    } withErrorBlock:^(AM3SErrorID errorID) {
        
        NSLog(@"AMErrorID:%ld",(unsigned long)errorID);
        
        self.am3STextView.text=[NSString stringWithFormat:@"AMErrorID:%ld\n%@",(unsigned long)errorID,self.am3STextView.text];
    }];
}



- (IBAction)SyncActiveData:(UIButton *)sender {
    
    
    [self.myAM3S commandAM3SStartSyncActiveData:^(NSDictionary *startDataDictionary) {
        
        NSLog(@"StartSyncActive --%@",startDataDictionary);
         self.am3STextView.text=[NSString stringWithFormat:@"%@:%@\n%@",NSLocalizedString(@"SyncActiveData", @""),startDataDictionary,self.am3STextView.text];
        
    } withActiveHistoryData:^(NSArray *historyDataArray) {
        
        NSLog(@"historyData --%@",historyDataArray);
        
         self.am3STextView.text=[NSString stringWithFormat:@"%@:%@\n%@",NSLocalizedString(@"ActiveHistoryData", @""),historyDataArray,self.am3STextView.text];
        
    } withActiveFinishTransmission:^{
        
        NSLog(@"ok");
        self.am3STextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"ActiveFinishTransmission", @""),self.am3STextView.text];
        
        
    } withErrorBlock:^(AM3SErrorID errorID) {
        NSLog(@"AMErrorID:%ld",(unsigned long)errorID);
         self.am3STextView.text=[NSString stringWithFormat:@"AMErrorID:%ld\n%@",(unsigned long)errorID,self.am3STextView.text];
    }];
    
    
}

- (IBAction)SyncSleepData:(id)sender {
    
    [self.myAM3S commandAM3SStartSyncSleepData:^(NSDictionary *startDataDictionary) {
        NSLog(@"StartSyncSleep --%@",startDataDictionary);
         self.am3STextView.text=[NSString stringWithFormat:@"%@:%@\n%@",NSLocalizedString(@"SyncSleepData", @""),startDataDictionary,self.am3STextView.text];
    } withSleepHistoryData:^(NSArray *historyDataArray) {
        NSLog(@"historyData --%@",historyDataArray);
          self.am3STextView.text=[NSString stringWithFormat:@"%@:%@\n%@",NSLocalizedString(@"SleepHistoryData", @""),historyDataArray,self.am3STextView.text];
    } withSleepFinishTransmission:^{
        NSLog(@"ok");
         self.am3STextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"SleepFinishTransmission", @""),self.am3STextView.text];
    } withErrorBlock:^(AM3SErrorID errorID) {
        NSLog(@"AMErrorID:%ld",(unsigned long)errorID);
         self.am3STextView.text=[NSString stringWithFormat:@"AMErrorID:%ld\n%@",(unsigned long)errorID,self.am3STextView.text];
    }];
}

- (IBAction)SyncCurrentActive:(id)sender {
    
    
    [self.myAM3S commandAM3SStartSyncCurrentActiveData:^(NSDictionary *activeDictionary) {
        NSLog(@"StartSyncCurrentActive --%@",activeDictionary);
         self.am3STextView.text=[NSString stringWithFormat:@"%@:%@\n%@",NSLocalizedString(@"SyncCurrentActiveData", @""),activeDictionary,self.am3STextView.text];
    } withErrorBlock:^(AM3SErrorID errorID) {
        NSLog(@"AMErrorID:%ld",(unsigned long)errorID);
         self.am3STextView.text=[NSString stringWithFormat:@"AMErrorID:%ld\n%@",(unsigned long)errorID,self.am3STextView.text];
    }];
    
}

- (IBAction)SyncStageData:(id)sender {
    
    [self.myAM3S commandAM3SStartSyncStageData:^(NSArray *measureDataArray) {
        NSLog(@"historyData --%@",measureDataArray);
        self.am3STextView.text=[NSString stringWithFormat:@"%@:%@\n%@",NSLocalizedString(@"SyncStageData", @""),measureDataArray,self.am3STextView.text];
    } withStageDataFinishTransmission:^(BOOL resetSuc) {
        NSLog(@"ok");
        self.am3STextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"StageDataFinishTransmission", @""),self.am3STextView.text];
    } withErrorBlock:^(AM3SErrorID errorID) {
        NSLog(@"AMErrorID:%ld",(unsigned long)errorID);
         self.am3STextView.text=[NSString stringWithFormat:@"AMErrorID:%ld\n%@",(unsigned long)errorID,self.am3STextView.text];
    }];
    
}

- (IBAction)commandAM3SGetDeviceStateInfo:(id)sender {
    [self.myAM3S commandAM3SGetDeviceStateInfo:^(AM3SQueryState queryState) {
        NSLog(@"DeviceStateInfo:%ld",(unsigned long)queryState);
        self.am3STextView.text=[NSString stringWithFormat:@"%@:%lu\n%@",NSLocalizedString(@"GetDeviceStateInfo", @""),(unsigned long)queryState,self.am3STextView.text];
    } withBattery:^(NSNumber *battery) {
        NSLog(@"battery:%d",battery.intValue);
         self.am3STextView.text=[NSString stringWithFormat:@"%@:%@\n%@",NSLocalizedString(@"battery", @""),battery,self.am3STextView.text];
    } withErrorBlock:^(AM3SErrorID errorID) {
        NSLog(@"AMErrorID:%ld",(unsigned long)errorID);
         self.am3STextView.text=[NSString stringWithFormat:@"AMErrorID:%ld\n%@",(unsigned long)errorID,self.am3STextView.text];
    }];
}

- (IBAction)commandAM3SResetDevice:(id)sender {
    [self.myAM3S commandAM3SResetDevice:^(BOOL resetSuc) {
        NSLog(@"ResetDevice Ok");
          self.am3STextView.text=[NSString stringWithFormat:@"%@:%u\n%@",NSLocalizedString(@"ResetDevice", @""),resetSuc,self.am3STextView.text];
    } withErrorBlock:^(AM3SErrorID errorID) {
        NSLog(@"AMErrorID:%ld",(unsigned long)errorID);
         self.am3STextView.text=[NSString stringWithFormat:@"AMErrorID:%ld\n%@",(unsigned long)errorID,self.am3STextView.text];
    }];
}

- (IBAction)commandAM3SDisconnect:(id)sender {
    
    [self.myAM3S commandAM3SDisconnect:^(BOOL resetSuc) {
        
        NSLog(@"commandAM3SDisconnect Ok");
         self.am3STextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"AM3SDisconnect", @""),self.am3STextView.text];
        
    } withErrorBlock:^(AM3SErrorID errorID) {
        
        NSLog(@"AMErrorID:%ld",(unsigned long)errorID);
         self.am3STextView.text=[NSString stringWithFormat:@"AMErrorID:%ld\n%@",(unsigned long)errorID,self.am3STextView.text];
    }];
}

- (IBAction)commandAM3SGetTotoalAlarmInfo:(id)sender {
    
    [self.myAM3S commandAM3SGetTotoalAlarmInfo:^(NSMutableArray *totoalAlarmArray) {
        
         self.am3STextView.text=[NSString stringWithFormat:@"%@:%@\n%@",NSLocalizedString(@"GetTotoalAlarmInfo", @""),totoalAlarmArray,self.am3STextView.text];
        NSLog(@"GetTotoalAlarmInfo %@",totoalAlarmArray);
        
    } withErrorBlock:^(AM3SErrorID errorID) {
        
        NSLog(@"AMErrorID:%ld",(unsigned long)errorID);
         self.am3STextView.text=[NSString stringWithFormat:@"AMErrorID:%ld\n%@",(unsigned long)errorID,self.am3STextView.text];
    }];
    
    
}

- (IBAction)commandAM3SSetAlarmDictionary:(id)sender {
    
    NSDictionary *tempClockDic = [NSDictionary dictionaryWithObjectsAndKeys:@1,@"AlarmId",@[@1,@1,@1,@1,@1,@1,@1],@"Week",[NSDate date],@"Time",@1,@"IsRepeat",@1,@"Switch",nil];
    
    
    [self.myAM3S commandAM3SSetAlarmDictionary:tempClockDic withFinishResult:^(BOOL resetSuc) {
        
        NSLog(@"commandAM3SSetAlarmDictionary ok");
        self.am3STextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"SetAlarmOK", @""),self.am3STextView.text];
    } withErrorBlock:^(AM3SErrorID errorID) {
        
        NSLog(@"AMErrorID:%ld",(unsigned long)errorID);
         self.am3STextView.text=[NSString stringWithFormat:@"AMErrorID:%ld\n%@",(unsigned long)errorID,self.am3STextView.text];
    }];
}

- (IBAction)commandAM3SDeleteAlarmID:(id)sender {
    
    [self.myAM3S commandAM3SDeleteAlarmID:@1 withFinishResult:^(BOOL resetSuc) {
        
        NSLog(@"commandAM3SDeleteAlarmID ok");
         self.am3STextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"DeleteAlarm", @""),self.am3STextView.text];
    } withErrorBlock:^(AM3SErrorID errorID) {
        
        NSLog(@"AMErrorID:%ld",(unsigned long)errorID);
         self.am3STextView.text=[NSString stringWithFormat:@"AMErrorID:%ld\n%@",(unsigned long)errorID,self.am3STextView.text];
    }];
}

- (IBAction)commandAM3SGetReminderInfo:(id)sender {
    
    [self.myAM3S commandAM3SGetReminderInfo:^(NSArray *remindInfo) {
        
        NSLog(@"commandAM3SGetReminderInfo %@",remindInfo);
        self.am3STextView.text=[NSString stringWithFormat:@"%@:%@\n%@",NSLocalizedString(@"GetReminderInfo", @""),remindInfo,self.am3STextView.text];
        
    } withErrorBlock:^(AM3SErrorID errorID) {
        
        NSLog(@"AMErrorID:%ld",(unsigned long)errorID);
         self.am3STextView.text=[NSString stringWithFormat:@"AMErrorID:%ld\n%@",(unsigned long)errorID,self.am3STextView.text];
    }];
}

- (IBAction)commandAM3SSetReminderDictionary:(id)sender {
    
    NSDictionary *tempReminderDic = [NSDictionary dictionaryWithObjectsAndKeys:[NSDate date],@"Time",@1,@"Switch",nil];
    
    [self.myAM3S commandAM3SSetReminderDictionary:tempReminderDic withFinishResult:^(BOOL resetSuc) {
        
        NSLog(@"SetReminderDictionary ok");
        self.am3STextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"SetReminder", @""),self.am3STextView.text];
        
    } withErrorBlock:^(AM3SErrorID errorID) {
        
        NSLog(@"AMErrorID:%ld",(unsigned long)errorID);
         self.am3STextView.text=[NSString stringWithFormat:@"AMErrorID:%ld\n%@",(unsigned long)errorID,self.am3STextView.text];
    }];
    
}

- (IBAction)commandAM3SGetTimeFormatAndNation:(id)sender {
    
    [self.myAM3S commandAM3SGetTimeFormatAndNation:^(AM3STimeFormatAndNation timeFormatAndNation) {
        
        NSLog(@"commandAM3SGetTimeFormatAndNation %ld",(unsigned long)timeFormatAndNation);
        self.am3STextView.text=[NSString stringWithFormat:@"%@:%lu\n%@",NSLocalizedString(@"GetTimeFormatAndNation", @""),(unsigned long)timeFormatAndNation,self.am3STextView.text];
        
    } withErrorBlock:^(AM3SErrorID errorID) {
        
        NSLog(@"AMErrorID:%ld",(unsigned long)errorID);
         self.am3STextView.text=[NSString stringWithFormat:@"AMErrorID:%ld\n%@",(unsigned long)errorID,self.am3STextView.text];
    }];
}

- (IBAction)commandAM3SGetUserInfo:(id)sender {
    
    
    
    [self.myAM3S commandAM3SGetUserInfo:^(NSDictionary *userInfo) {
        NSLog(@"userInfo:%@",userInfo);
        self.am3STextView.text=[NSString stringWithFormat:@"%@:%@\n%@",NSLocalizedString(@"GetUserInfo", @""),userInfo,self.am3STextView.text];
        
    } withErrorBlock:^(AM3SErrorID errorID) {
        NSLog(@"AMErrorID:%ld",(unsigned long)errorID);
         self.am3STextView.text=[NSString stringWithFormat:@"AMErrorID:%ld\n%@",(unsigned long)errorID,self.am3STextView.text];
    }];
}

- (IBAction)setPicture:(UIButton *)sender {
    
    [self.myAM3S commandAM3SSetPicture:AM3SPicture_one withFinishResult:^(BOOL resetSuc) {
        
        NSLog(@"ok");
          self.am3STextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"SetPicture", @""),self.am3STextView.text];
    } withErrorBlock:^(AM3SErrorID errorID) {
        NSLog(@"AMErrorID:%ld",(unsigned long)errorID);
         self.am3STextView.text=[NSString stringWithFormat:@"AMErrorID:%ld\n%@",(unsigned long)errorID,self.am3STextView.text];
    }];
}

- (IBAction)getPicture:(UIButton *)sender {
    
    [self.myAM3S commandAM3SGetPicture:^(AM3SPicture picture) {
        
        NSLog(@"picture:%ld",(unsigned long)picture);
        self.am3STextView.text=[NSString stringWithFormat:@"%@:%lu\n%@",NSLocalizedString(@"GetPicture", @""),(unsigned long)picture,self.am3STextView.text];
    } withErrorBlock:^(AM3SErrorID errorID) {
        NSLog(@"AMErrorID:%ld",(unsigned long)errorID);
         self.am3STextView.text=[NSString stringWithFormat:@"AMErrorID:%ld\n%@",(unsigned long)errorID,self.am3STextView.text];
    }];
}

- (IBAction)setBMR:(UIButton *)sender {
    
    [self.myAM3S commandAM3SSetBMR:@11 withFinishResult:^(BOOL resetSuc) {
        
        NSLog(@"resetSuc:%u",resetSuc);
        self.am3STextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"SetBMR", @""),self.am3STextView.text];

    } withErrorBlock:^(AM3SErrorID errorID) {
        NSLog(@"AMErrorID:%ld",(unsigned long)errorID);
         self.am3STextView.text=[NSString stringWithFormat:@"AMErrorID:%ld\n%@",(unsigned long)errorID,self.am3STextView.text];
    }];}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
