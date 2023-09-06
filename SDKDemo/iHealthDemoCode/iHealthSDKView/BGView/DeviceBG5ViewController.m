//
//  DeviceBG5ViewController.m
//  iHealthDemoCode
//
//  Created by jing on 2018/10/22.
//  Copyright © 2018年 iHealth Demo Code. All rights reserved.
//

#import "DeviceBG5ViewController.h"
#import "BGHeader.h"
#define DemoCodeStr @"024C565F4C5614322D1200A02F3485B6F314378BACD61901C67200361C1C"

@interface DeviceBG5ViewController ()
@property (weak, nonatomic) IBOutlet UITextView *bg5TextView;

@property (weak, nonatomic) IBOutlet UILabel *deviceLabel;

@property (strong, nonatomic) BG5 *myBg5;
@end

@implementation DeviceBG5ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    
    NSString*deviceMac=[userDefault valueForKey:@"SelectDeviceMac"];
    
    self.deviceLabel.text=[NSString stringWithFormat:@"BG5 %@",deviceMac];
    
    NSArray*deviceArray=[[BG5Controller shareIHBg5Controller] getAllCurrentBG5Instace];
    
    for(BG5 *device in deviceArray){
        
        if([deviceMac isEqualToString:device.serialNumber]){
            
            self.myBg5=device;
            
        }
    }
}
- (IBAction)Cancel:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)SetTime:(id)sender {
    
    [self.myBg5 commandBGSetTime:^(BOOL setResult) {
        
         self.bg5TextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"SetTimeSucess", @""),self.bg5TextView.text];
        
    } DisposeBGErrorBlock:^(NSNumber *errorID) {
         [self BGError:errorID];
    }];
}
- (IBAction)SetUnit:(id)sender {
    
    [self.myBg5 commandBGSetUnit:BGUnit_mmolPL DisposeSetUnitResult:^(BOOL setResult) {
        self.bg5TextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"SetUnitSucess", @""),self.bg5TextView.text];

    } DisposeBGErrorBlock:^(NSNumber *errorID) {
         [self BGError:errorID];
    }];
}
- (IBAction)GetBattery:(id)sender {
    
    [self.myBg5 commandQueryBattery:^(NSNumber *energy) {
        
        self.bg5TextView.text=[NSString stringWithFormat:@"%@:%@\n%@",NSLocalizedString(@"Battary", @""),energy,self.bg5TextView.text];

        
    } DisposeErrorBlock:^(NSNumber *errorID) {
         [self BGError:errorID];
    }];
}
- (IBAction)TransferMemorryData:(id)sender {
    
    [self.myBg5 commandTransferMemorryData:^(NSNumber *dataCount) {
        
         self.bg5TextView.text=[NSString stringWithFormat:@"%@:%@\n%@",NSLocalizedString(@"MemoryCount", @""),dataCount,self.bg5TextView.text];
        
    } DisposeBGHistoryData:^(NSDictionary *historyDataDic) {
        
         self.bg5TextView.text=[NSString stringWithFormat:@"%@:%@\n%@",NSLocalizedString(@"MemoryData", @""),historyDataDic,self.bg5TextView.text];
        
    } DisposeBGErrorBlock:^(NSNumber *errorID) {
         [self BGError:errorID];
    }];
}
- (IBAction)DeleteMemorryData:(id)sender {
    
    [self.myBg5 commandDeleteMemorryData:^(BOOL deleteOk) {
        self.bg5TextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"DeleteDataSucess", @""),self.bg5TextView.text];

    } DisposeBGErrorBlock:^(NSNumber *errorID) {
         [self BGError:errorID];
    }];
}
- (IBAction)SendBGCodeWithMeasureType:(id)sender {
    
    NSString *validString = @"02395C64395C14322D1200A029426CA4FB145B9C8AC31901237E1711075C";
   
    
    NSString *dateStr = @"2021-01-01";
    NSDateFormatter *dateFormater = [[NSDateFormatter alloc]init];
    [dateFormater setDateFormat:@"yyyy-MM-dd"];
    
    [self.myBg5 commandSendBGCodeWithMeasureType:BGMeasureMode_Blood CodeType:BGCodeMode_GDH CodeString:validString validDate:[dateFormater dateFromString:dateStr] remainNum:@10 DisposeBGSendCodeBlock:^(BOOL sendOk) {
        self.bg5TextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"SendCodeSucess", @""),self.bg5TextView.text];

    } DisposeBGStartModel:^(BGOpenMode mode) {
        
        self.bg5TextView.text=[NSString stringWithFormat:@"%@:%lu\n%@",NSLocalizedString(@"BGOpenMode", @""),(unsigned long)mode,self.bg5TextView.text];

        
    } DisposeBGErrorBlock:^(NSNumber *errorID) {
         [self BGError:errorID];
    }];
}

- (IBAction)SendBGCTLCodeWithMeasureType:(id)sender {
    
    NSString *validString = @"02395C64395C14322D1200A029426CA4FB145B9C8AC31901237E1711075C";
   
    
    NSString *dateStr = @"2021-01-01";
    NSDateFormatter *dateFormater = [[NSDateFormatter alloc]init];
    [dateFormater setDateFormat:@"yyyy-MM-dd"];
    
    [self.myBg5 commandSendBGCodeWithMeasureType:BGMeasureMode_NoBlood CodeType:BGCodeMode_GDH CodeString:validString validDate:[dateFormater dateFromString:dateStr] remainNum:@10 DisposeBGSendCodeBlock:^(BOOL sendOk) {
        self.bg5TextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"SendCTLCodeSucess", @""),self.bg5TextView.text];

    } DisposeBGStartModel:^(BGOpenMode mode) {
        
        self.bg5TextView.text=[NSString stringWithFormat:@"%@:%lu\n%@",NSLocalizedString(@"BGOpenMode", @""),(unsigned long)mode,self.bg5TextView.text];

        
    } DisposeBGErrorBlock:^(NSNumber *errorID) {
         [self BGError:errorID];
    }];
}

- (IBAction)ReadBGCodeDic:(id)sender {
    
    [self.myBg5 commandReadBGCodeDic:^(NSDictionary *codeDic) {
        
        self.bg5TextView.text=[NSString stringWithFormat:@"%@:%@\n%@",NSLocalizedString(@"GetCode", @""),codeDic,self.bg5TextView.text];

        
    } DisposeBGErrorBlock:^(NSNumber *errorID) {
         [self BGError:errorID];
    }];
}
- (IBAction)SendBottleID:(id)sender {
    
    [self.myBg5 commandSendBottleID:0x12345678 DisposeBGSendBottleIDBlock:^(BOOL sendOk) {
        self.bg5TextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"SendBottleIDSucess", @""),self.bg5TextView.text];

    } DisposeBGErrorBlock:^(NSNumber *errorID) {
         [self BGError:errorID];
    }];
}
- (IBAction)GetBottleID:(id)sender {
    
    [self.myBg5 commandBGGetBottleID:^(NSNumber *bottleID) {
        self.bg5TextView.text=[NSString stringWithFormat:@"%@:%@\n%@",NSLocalizedString(@"GetBottleID", @""),bottleID,self.bg5TextView.text];

    } DisposeBGErrorBlock:^(NSNumber *errorID) {
         [self BGError:errorID];
    }];
}
- (IBAction)CreateBGtestStripInBlock:(id)sender {
    
    [self.myBg5 commandCreateBGtestStripInBlock:^{
        self.bg5TextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"StripIn", @""),self.bg5TextView.text];

    } DisposeBGBloodBlock:^{
        self.bg5TextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"Blood", @""),self.bg5TextView.text];

    } DisposeBGResultBlock:^(NSDictionary *result) {
        self.bg5TextView.text=[NSString stringWithFormat:@"%@:%@\n%@",NSLocalizedString(@"BGResult", @""),result,self.bg5TextView.text];

    } DisposeBGErrorBlock:^(NSNumber *errorID) {
         [self BGError:errorID];
    }];
}
- (IBAction)CreateBGtestModel:(id)sender {
    
    [self.myBg5 commandCreateBGtestModel:BGMeasureMode_Blood DisposeBGStripInBlock:^{
        self.bg5TextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"StripIn", @""),self.bg5TextView.text];

    } DisposeBGBloodBlock:^{
        self.bg5TextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"Blood", @""),self.bg5TextView.text];

    } DisposeBGResultBlock:^(NSDictionary *result) {
        self.bg5TextView.text=[NSString stringWithFormat:@"%@:%@\n%@",NSLocalizedString(@"BGResult", @""),result,self.bg5TextView.text];

    } DisposeBGErrorBlock:^(NSNumber *errorID) {
         [self BGError:errorID];
    }];
}
- (IBAction)KeepConnect:(id)sender {
    
    [self.myBg5 commandKeepConnect:^(BOOL sendOk) {
        self.bg5TextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"KeepConnectSucess", @""),self.bg5TextView.text];

    } DisposeErrorBlock:^(NSNumber *errorID) {
        
        [self BGError:errorID];
    }];
}
- (IBAction)codeStripStrAnalysis:(id)sender {
    
    [self.myBg5 codeStripStrAnalysis:DemoCodeStr];
    
    self.bg5TextView.text=[NSString stringWithFormat:@"%@:%@\n%@",NSLocalizedString(@"CodeStripStrAnalysis", @""),    [self.myBg5 codeStripStrAnalysis:DemoCodeStr],self.bg5TextView.text];

}



-(void)BGError:(NSNumber*)errorID{
    
    switch ([errorID intValue]) {
            case BG5Error_LowBattery:
            self.bg5TextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"Battery is low.", @""),self.bg5TextView.text];
            break;
            case BG5Error_ResultOutOfMeasurementRage:
            self.bg5TextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"Glucose test result is out of the measurement range.", @""),self.bg5TextView.text];
            break;
            case BG5Error_UnvalidReferenceVoltage:
            self.bg5TextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"Reference voltage error, not normal measurement, please repeat", @""),self.bg5TextView.text];
            break;
            case BG5Error_StripUsed:
            self.bg5TextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"Strip is used or unknown moisture detected, discard the test strip and repeat", @""),self.bg5TextView.text];
            break;
            case BG5Error_ErrorOccurInEEPROM:
            self.bg5TextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"Reading transmission error. Repeat the test with a new test strip.", @""),self.bg5TextView.text];
            break;
            case BG5Error_RoomTemperatureOutOfRange1:
            case BG5Error_RoomTemperatureOutOfRange2:
            self.bg5TextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"The environmental temperature is beyond normal range", @""),self.bg5TextView.text];
            break;
            case BG5Error_TestStripCodingError1:
            case BG5Error_TestStripCodingError2:
            self.bg5TextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"Test strip coding error.", @""),self.bg5TextView.text];
            break;
            
            case BG5Error_PullOffStripWhenMeasuring:
            self.bg5TextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@" Strip removed in the middle of reading, repeat the test with a new strip", @""),self.bg5TextView.text];
            break;
           
            case BG5Error_ShouldPullOffStripAfterReadingResult:
            self.bg5TextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"Pull off strips after measuring", @""),self.bg5TextView.text];
            break;
            case BG5Error_CannotWriteSNOrKey:
            self.bg5TextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"SN or KEY write error", @""),self.bg5TextView.text];
            break;
            case BG5Error_NeedSetTime:
            self.bg5TextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"Please set time", @""),self.bg5TextView.text];
            break;
            case BG5Error_StripNumberIsZero:
            self.bg5TextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"0 test strips remaining.", @""),self.bg5TextView.text];
            break;
            case BG5Error_StripExpired:
            self.bg5TextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"Test strip expired.", @""),self.bg5TextView.text];
            break;
            case BG5Error_CannotMeasureWhenCharging:
            self.bg5TextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"Unplug the charging cable before testing.", @""),self.bg5TextView.text];
            break;
            
            case BG5Error_InputParametersError:
            self.bg5TextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"Parameter input error.", @""),self.bg5TextView.text];
            break;
            case BG5Error_FunctionCallOrderError:
            self.bg5TextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"Fucntion call order error", @""),self.bg5TextView.text];
            break;
            case BG5Error_MeasureModeNotMatch:
            self.bg5TextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"Measure mode is not match.", @""),self.bg5TextView.text];
            break;
            case BG5Error_CommandTimeout:
            self.bg5TextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"Command timeout", @""),self.bg5TextView.text];
            break;
            
            case BG5Error_CommandNotSupport:
            self.bg5TextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@" Command is not supported for current device.", @""),self.bg5TextView.text];
            break;
            
        default:
            break;
    }
    
    
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
