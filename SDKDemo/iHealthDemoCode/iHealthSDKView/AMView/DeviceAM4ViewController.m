//
//  DeviceAM4ViewController.m
//  iHealthDemoCode
//
//  Created by jing on 2018/10/22.
//  Copyright © 2018年 iHealth Demo Code. All rights reserved.
//

#import "DeviceAM4ViewController.h"
#import "AMHeader.h"
@interface DeviceAM4ViewController ()
@property (weak, nonatomic) IBOutlet UITextView *am4TextView;

@property (weak, nonatomic) IBOutlet UILabel *deviceLabel;

@property (strong, nonatomic) AM4 *myAM4;
@property (strong, nonatomic) HealthUser *myUser;
@property (strong, nonatomic) NSNumber *userIDNumber;
@end

@implementation DeviceAM4ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    
    NSString*deviceMac=[userDefault valueForKey:@"SelectDeviceMac"];
    
    self.deviceLabel.text=[NSString stringWithFormat:@"AM4 %@",deviceMac];
    
    NSArray*deviceArray=[[AM4Controller shareIHAM4Controller] getAllCurrentAM4Instace];
    
    self.myUser=[[HealthUser alloc] init];
    
    for(AM4 *device in deviceArray){
        
        if([deviceMac isEqualToString:device.serialNumber]){
            
            self.myAM4=device;
            
        }
    }
}
- (IBAction)Cancel:(id)sender {
    
    [self.myAM4 commandAM4Disconnect:^(BOOL resetSuc) {
        
        NSLog(@"commandAM4Disconnect Ok");
        self.am4TextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"AM4Disconnect", @""),self.am4TextView.text];
        
    } withErrorBlock:^(AM4ErrorID errorID) {
        
        NSLog(@"AMErrorID:%ld",(unsigned long)errorID);
        self.am4TextView.text=[NSString stringWithFormat:@"AMErrorID:%ld\n%@",(unsigned long)errorID,self.am4TextView.text];
    }];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)commandAM4SyncTime:(id)sender{
    
    [self.myAM4 commandAM4SyncTime:^(BOOL resetSuc) {
        
         self.am4TextView.text=[NSString stringWithFormat:@"%@:%u\n%@",NSLocalizedString(@"SyncTime", @""),resetSuc,self.am4TextView.text];
    } withErrorBlock:^(AM4ErrorID errorID) {
        
        self.am4TextView.text=[NSString stringWithFormat:@"AMErrorID:%ld\n%@",(unsigned long)errorID,self.am4TextView.text];
    }];
    
}
- (IBAction)commandAM4GetDeviceUserID:(id)sender{
    
    [self.myAM4 commandAM4GetDeviceUserID:^(unsigned int userID) {
        
        self.userIDNumber=[NSNumber numberWithUnsignedInteger:userID];
        
        self.am4TextView.text=[NSString stringWithFormat:@"%@:%u\n%@",NSLocalizedString(@"GetDeviceUserID", @""),userID,self.am4TextView.text];
        
    } withErrorBlock:^(AM4ErrorID errorID) {
        
        self.am4TextView.text=[NSString stringWithFormat:@"AMErrorID:%ld\n%@",(unsigned long)errorID,self.am4TextView.text];
    }];
}
- (IBAction)commandAM4SetRandomNumber:(id)sender{
    
    [self.myAM4 commandAM4SetRandomNumber:^(NSString *randomNumString) {
        
        self.am4TextView.text=[NSString stringWithFormat:@"%@:%@\n%@",NSLocalizedString(@"SetRandomNumber", @""),randomNumString,self.am4TextView.text];
        
    } withErrorBlock:^(AM4ErrorID errorID) {
        
        self.am4TextView.text=[NSString stringWithFormat:@"AMErrorID:%ld\n%@",(unsigned long)errorID,self.am4TextView.text];
    }];
    
}
- (IBAction)commandAM4SetTimeFormatAndNation:(id)sender{
    
    [self.myAM4 commandAM4SetTimeFormatAndNation:AM4TimeFormat_EuropeAndhh withFinishResult:^(BOOL resetSuc) {
        
        self.am4TextView.text=[NSString stringWithFormat:@"%@:%u\n%@",NSLocalizedString(@"SetTimeFormatAndNation", @""),resetSuc,self.am4TextView.text];
        
    } withErrorBlock:^(AM4ErrorID errorID) {
        
        self.am4TextView.text=[NSString stringWithFormat:@"AMErrorID:%ld\n%@",(unsigned long)errorID,self.am4TextView.text];
    }];
}
- (IBAction)commandAM4SetSwimmingState:(id)sender{
    
    [self.myAM4 commandAM4SetSwimmingState:YES withSwimmingPoolLength:@10000 withNOSwimmingTime:[NSDate date] withUnit:AM4SwimmingUnit_km withFinishResult:^(BOOL resetSuc) {
        
    } withErrorBlock:^(AM4ErrorID errorID) {
        self.am4TextView.text=[NSString stringWithFormat:@"AMErrorID:%ld\n%@",(unsigned long)errorID,self.am4TextView.text];
    }];
}

- (IBAction)commandAM4SetUserInfo:(id)sender{
    
    self.myUser.age = @12;
    self.myUser.sex = UserSex_Male;
    self.myUser.height = @165;
    self.myUser.weight = @55;
    self.myUser.bmr = @120;
    self.myUser.lengthUnit = LengthUnit_Kilometer;
    self.myUser.activityLevel = @1;
    
    [self.myAM4 commandAM4SetUserInfo:self.myUser  withUnit:AM4KmUnit_mile withActiveGoal:@10000 withSwimmingGoal:@1000 withSetUserInfoFinishResult:^(BOOL resetSuc) {
         self.am4TextView.text=[NSString stringWithFormat:@"%@:%u\n%@",NSLocalizedString(@"SetUserInfo", @""),resetSuc,self.am4TextView.text];
    } withSetBMR:^(BOOL resetSuc) {
        
    } withErrorBlock:^(AM4ErrorID errorID) {
        self.am4TextView.text=[NSString stringWithFormat:@"AMErrorID:%ld\n%@",(unsigned long)errorID,self.am4TextView.text];
    }];
   
    
}
- (IBAction)setUserID:(id)sender
{
    [self.myAM4 commandAM4SetUserID:self.userIDNumber withFinishResult:^(BOOL resetSuc) {
        
        NSLog(@"SetUserIDok");
        
        self.am4TextView.text=[NSString stringWithFormat:@"%@:%u\n%@",NSLocalizedString(@"SetUserIDOK", @""),resetSuc,self.am4TextView.text];
        
    } withErrorBlock:^(AM4ErrorID errorID) {
        
        NSLog(@"AMErrorID:%ld",(unsigned long)errorID);
         self.am4TextView.text=[NSString stringWithFormat:@"AMErrorID:%ld\n%@",(unsigned long)errorID,self.am4TextView.text];
    }];
}



- (IBAction)SyncActiveData:(UIButton *)sender {
    
    
    [self.myAM4 commandAM4StartSyncActiveData:^(NSDictionary *startDataDictionary) {
        
        NSLog(@"StartSyncActive --%@",startDataDictionary);
        self.am4TextView.text=[NSString stringWithFormat:@"%@:%@\n%@",NSLocalizedString(@"SyncActiveData", @""),startDataDictionary,self.am4TextView.text];
        
    } withActiveHistoryData:^(NSArray *historyDataArray) {
        
        NSLog(@"historyData --%@",historyDataArray);
        
        self.am4TextView.text=[NSString stringWithFormat:@"%@:%@\n%@",NSLocalizedString(@"ActiveHistoryData", @""),historyDataArray,self.am4TextView.text];
        
    } withActiveFinishTransmission:^{
        
        NSLog(@"ok");
        self.am4TextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"ActiveFinishTransmission", @""),self.am4TextView.text];
        
        
    } withErrorBlock:^(AM4ErrorID errorID) {
        NSLog(@"AMErrorID:%ld",(unsigned long)errorID);
        self.am4TextView.text=[NSString stringWithFormat:@"AMErrorID:%ld\n%@",(unsigned long)errorID,self.am4TextView.text];
    }];
    
    
}

- (IBAction)SyncSleepData:(id)sender {
    
    [self.myAM4 commandAM4StartSyncSleepData:^(NSDictionary *startDataDictionary) {
        NSLog(@"StartSyncSleep --%@",startDataDictionary);
        self.am4TextView.text=[NSString stringWithFormat:@"%@:%@\n%@",NSLocalizedString(@"SyncSleepData", @""),startDataDictionary,self.am4TextView.text];
    } withSleepHistoryData:^(NSArray *historyDataArray) {
        NSLog(@"historyData --%@",historyDataArray);
        self.am4TextView.text=[NSString stringWithFormat:@"%@:%@\n%@",NSLocalizedString(@"SleepHistoryData", @""),historyDataArray,self.am4TextView.text];
    } withSleepFinishTransmission:^{
        NSLog(@"ok");
        self.am4TextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"SleepFinishTransmission", @""),self.am4TextView.text];
    } withErrorBlock:^(AM4ErrorID errorID) {
        NSLog(@"AMErrorID:%ld",(unsigned long)errorID);
        self.am4TextView.text=[NSString stringWithFormat:@"AMErrorID:%ld\n%@",(unsigned long)errorID,self.am4TextView.text];
    }];
}

- (IBAction)SyncCurrentActive:(id)sender {
    
    
    [self.myAM4 commandAM4StartSyncCurrentActiveData:^(NSDictionary *activeDictionary) {
        NSLog(@"StartSyncCurrentActive --%@",activeDictionary);
        self.am4TextView.text=[NSString stringWithFormat:@"%@:%@\n%@",NSLocalizedString(@"SyncCurrentActiveData", @""),activeDictionary,self.am4TextView.text];
    } withErrorBlock:^(AM4ErrorID errorID) {
        NSLog(@"AMErrorID:%ld",(unsigned long)errorID);
       self.am4TextView.text=[NSString stringWithFormat:@"AMErrorID:%ld\n%@",(unsigned long)errorID,self.am4TextView.text];
    }];
    
}

- (IBAction)SyncStageData:(id)sender {
    
    [self.myAM4 commandAM4StartSyncStageData:^(NSArray *measureDataArray) {
        NSLog(@"historyData --%@",measureDataArray);
        self.am4TextView.text=[NSString stringWithFormat:@"%@:%@\n%@",NSLocalizedString(@"SyncStageData", @""),measureDataArray,self.am4TextView.text];
    } withStageDataFinishTransmission:^(BOOL resetSuc) {
        NSLog(@"ok");
        self.am4TextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"StageDataFinishTransmission", @""),self.am4TextView.text];
    } withErrorBlock:^(AM4ErrorID errorID) {
        NSLog(@"AMErrorID:%ld",(unsigned long)errorID);
        self.am4TextView.text=[NSString stringWithFormat:@"AMErrorID:%ld\n%@",(unsigned long)errorID,self.am4TextView.text];
    }];
    
}

- (IBAction)commandAM4GetDeviceStateInfo:(id)sender {
    [self.myAM4 commandAM4GetDeviceStateInfo:^(AM4QueryState queryState) {
        NSLog(@"DeviceStateInfo:%ld",(unsigned long)queryState);
        self.am4TextView.text=[NSString stringWithFormat:@"%@:%lu\n%@",NSLocalizedString(@"GetDeviceStateInfo", @""),(unsigned long)queryState,self.am4TextView.text];
    } withBattery:^(NSNumber *battery) {
        NSLog(@"battery:%d",battery.intValue);
        self.am4TextView.text=[NSString stringWithFormat:@"%@:%@\n%@",NSLocalizedString(@"battery", @""),battery,self.am4TextView.text];
    } withErrorBlock:^(AM4ErrorID errorID) {
        NSLog(@"AMErrorID:%ld",(unsigned long)errorID);
        self.am4TextView.text=[NSString stringWithFormat:@"AMErrorID:%ld\n%@",(unsigned long)errorID,self.am4TextView.text];
    }];
}

- (IBAction)commandAM4ResetDevice:(id)sender {
    [self.myAM4 commandAM4ResetDevice:^(BOOL resetSuc) {
        NSLog(@"ResetDevice Ok");
        self.am4TextView.text=[NSString stringWithFormat:@"%@:%u\n%@",NSLocalizedString(@"ResetDevice", @""),resetSuc,self.am4TextView.text];
    } withErrorBlock:^(AM4ErrorID errorID) {
        NSLog(@"AMErrorID:%ld",(unsigned long)errorID);
        self.am4TextView.text=[NSString stringWithFormat:@"AMErrorID:%ld\n%@",(unsigned long)errorID,self.am4TextView.text];
    }];
}

- (IBAction)commandAM4Disconnect:(id)sender {
    
    [self.myAM4 commandAM4Disconnect:^(BOOL resetSuc) {
        
        NSLog(@"commandAM4Disconnect Ok");
        self.am4TextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"AM4Disconnect", @""),self.am4TextView.text];
        
    } withErrorBlock:^(AM4ErrorID errorID) {
        
        NSLog(@"AMErrorID:%ld",(unsigned long)errorID);
        self.am4TextView.text=[NSString stringWithFormat:@"AMErrorID:%ld\n%@",(unsigned long)errorID,self.am4TextView.text];
    }];
}

- (IBAction)commandAM4GetTotoalAlarmInfo:(id)sender {
    
    [self.myAM4 commandAM4GetTotoalAlarmInfo:^(NSMutableArray *totoalAlarmArray) {
        
        self.am4TextView.text=[NSString stringWithFormat:@"%@:%@\n%@",NSLocalizedString(@"GetTotoalAlarmInfo", @""),totoalAlarmArray,self.am4TextView.text];
        NSLog(@"GetTotoalAlarmInfo %@",totoalAlarmArray);
        
    } withErrorBlock:^(AM4ErrorID errorID) {
        
        NSLog(@"AMErrorID:%ld",(unsigned long)errorID);
        self.am4TextView.text=[NSString stringWithFormat:@"AMErrorID:%ld\n%@",(unsigned long)errorID,self.am4TextView.text];
    }];
    
    
}

- (IBAction)commandAM4SetAlarmDictionary:(id)sender {
    
     NSDictionary *tempClockDic = [NSDictionary dictionaryWithObjectsAndKeys:@1,@"AlarmId",@[@1,@1,@1,@1,@1,@1,@1],@"Week",[NSDate date],@"Time",@1,@"IsRepeat",@1,@"Switch",nil];
    
    
    [self.myAM4 commandAM4SetAlarmDictionary:tempClockDic withFinishResult:^(BOOL resetSuc) {
        
        NSLog(@"commandAM4SetAlarmDictionary ok");
        self.am4TextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"SetAlarmOK", @""),self.am4TextView.text];
    } withErrorBlock:^(AM4ErrorID errorID) {
        
        NSLog(@"AMErrorID:%ld",(unsigned long)errorID);
        self.am4TextView.text=[NSString stringWithFormat:@"AMErrorID:%ld\n%@",(unsigned long)errorID,self.am4TextView.text];
    }];
}

- (IBAction)commandAM4DeleteAlarmID:(id)sender {
    
    [self.myAM4 commandAM4DeleteAlarmID:@1 withFinishResult:^(BOOL resetSuc) {
        
        NSLog(@"commandAM4DeleteAlarmID ok");
        self.am4TextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"DeleteAlarm", @""),self.am4TextView.text];
    } withErrorBlock:^(AM4ErrorID errorID) {
        
        NSLog(@"AMErrorID:%ld",(unsigned long)errorID);
        self.am4TextView.text=[NSString stringWithFormat:@"AMErrorID:%ld\n%@",(unsigned long)errorID,self.am4TextView.text];
    }];
}

- (IBAction)commandAM4GetReminderInfo:(id)sender {
    
    [self.myAM4 commandAM4GetReminderInfo:^(NSArray *remindInfo) {
        
        NSLog(@"commandAM4GetReminderInfo %@",remindInfo);
        self.am4TextView.text=[NSString stringWithFormat:@"%@:%@\n%@",NSLocalizedString(@"GetReminderInfo", @""),remindInfo,self.am4TextView.text];
        
    } withErrorBlock:^(AM4ErrorID errorID) {
        
        NSLog(@"AMErrorID:%ld",(unsigned long)errorID);
        self.am4TextView.text=[NSString stringWithFormat:@"AMErrorID:%ld\n%@",(unsigned long)errorID,self.am4TextView.text];
    }];
}

- (IBAction)commandAM4SetReminderDictionary:(id)sender {
    
    NSDictionary *tempReminderDic = [NSDictionary dictionaryWithObjectsAndKeys:[NSDate date],@"Time",@1,@"Switch",nil];
    
    [self.myAM4 commandAM4SetReminderDictionary:tempReminderDic withFinishResult:^(BOOL resetSuc) {
        
        NSLog(@"SetReminderDictionary ok");
        self.am4TextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"SetReminder", @""),self.am4TextView.text];
        
    } withErrorBlock:^(AM4ErrorID errorID) {
        
        NSLog(@"AMErrorID:%ld",(unsigned long)errorID);
        self.am4TextView.text=[NSString stringWithFormat:@"AMErrorID:%ld\n%@",(unsigned long)errorID,self.am4TextView.text];
    }];
    
}

- (IBAction)commandAM4GetTimeFormatAndNation:(id)sender {
    
    [self.myAM4 commandAM4GetTimeFormatAndNation:^(AM4TimeFormatAndNation timeFormatAndNation) {
        
        NSLog(@"commandAM4GetTimeFormatAndNation %ld",(unsigned long)timeFormatAndNation);
        self.am4TextView.text=[NSString stringWithFormat:@"%@:%lu\n%@",NSLocalizedString(@"GetTimeFormatAndNation", @""),(unsigned long)timeFormatAndNation,self.am4TextView.text];
        
    } withErrorBlock:^(AM4ErrorID errorID) {
        
        NSLog(@"AMErrorID:%ld",(unsigned long)errorID);
        self.am4TextView.text=[NSString stringWithFormat:@"AMErrorID:%ld\n%@",(unsigned long)errorID,self.am4TextView.text];
    }];
}

- (IBAction)commandAM4GetUserInfo:(id)sender {
    
    
    
    [self.myAM4 commandAM4GetUserInfo:^(NSDictionary *userInfo) {
        NSLog(@"userInfo:%@",userInfo);
        self.am4TextView.text=[NSString stringWithFormat:@"%@:%@\n%@",NSLocalizedString(@"GetUserInfo", @""),userInfo,self.am4TextView.text];
        
    } withErrorBlock:^(AM4ErrorID errorID) {
        NSLog(@"AMErrorID:%ld",(unsigned long)errorID);
        self.am4TextView.text=[NSString stringWithFormat:@"AMErrorID:%ld\n%@",(unsigned long)errorID,self.am4TextView.text];
    }];
}



- (IBAction)commandAM4GetSwimmingInfo:(UIButton *)sender {
    
    [self.myAM4 commandAM4GetSwimmingInfo:^(BOOL swimmingIsOpen, NSNumber *swimmingLaneLength, NSNumber *NOSwimmingTime, AM4SwimmingUnit unit) {
        self.am4TextView.text=[NSString stringWithFormat:@"%@:%u %@:%@ %@:%@ %@:%lu\n%@",NSLocalizedString(@"swimmingIsOpen", @""),swimmingIsOpen,NSLocalizedString(@"swimmingLaneLength", @""),swimmingLaneLength,NSLocalizedString(@"NOSwimmingTime", @""),NOSwimmingTime,NSLocalizedString(@"AM4SwimmingUnit", @""),(unsigned long)unit,self.am4TextView.text];
    } withErrorBlock:^(AM4ErrorID errorID) {
        self.am4TextView.text=[NSString stringWithFormat:@"AMErrorID:%ld\n%@",(unsigned long)errorID,self.am4TextView.text];
    }];
}

- (IBAction)setBMR:(UIButton *)sender {
    
    [self.myAM4 commandAM4SetBMR:@11 withFinishResult:^(BOOL resetSuc) {
        
        NSLog(@"resetSuc:%u",resetSuc);
        self.am4TextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"SetBMR", @""),self.am4TextView.text];
        
    } withErrorBlock:^(AM4ErrorID errorID) {
        NSLog(@"AMErrorID:%ld",(unsigned long)errorID);
        self.am4TextView.text=[NSString stringWithFormat:@"AMErrorID:%ld\n%@",(unsigned long)errorID,self.am4TextView.text];
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
