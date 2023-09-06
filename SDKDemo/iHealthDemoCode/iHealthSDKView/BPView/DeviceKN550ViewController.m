//
//  DeviceKN550ViewController.m
//  iHealthDemoCode
//
//  Created by jing on 2018/10/22.
//  Copyright © 2018年 iHealth Demo Code. All rights reserved.
//

#import "DeviceKN550ViewController.h"
#import "BPHeader.h"
@interface DeviceKN550ViewController ()
@property (weak, nonatomic) IBOutlet UITextView *bp550TextView;

@property (weak, nonatomic) IBOutlet UILabel *deviceLabel;

@property (strong, nonatomic) KN550BT *myBP550;
@end

@implementation DeviceKN550ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    
    NSString*deviceMac=[userDefault valueForKey:@"SelectDeviceMac"];
    
    self.deviceLabel.text=[NSString stringWithFormat:@"KN550 %@",deviceMac];
    
    NSArray*deviceArray=[[KN550BTController shareKN550BTController] getAllCurrentKN550BTInstace];
    
    for(KN550BT *device in deviceArray){
        
        if([deviceMac isEqualToString:device.serialNumber]){
            
            self.myBP550=device;
            
        }
    }
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(DeviceDisConnectForKN550BT:) name:KN550BTDisConnectNoti object:nil];
}
-(void)DeviceDisConnectForKN550BT:(NSNotification*)info {
    
    
    NSLog(@"KN550BTDisConnectNoti:%@",[info userInfo]);
    
}
- (IBAction)Cancel:(id)sender {
    
    [self.myBP550 commandDisconnectDevice];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)BP550BTDisconnect:(UIButton *)sender{
    
    [self.myBP550 commandDisconnectDevice];
    
    self.bp550TextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"Device disconnect", @""),self.bp550TextView.text];
    
}

- (IBAction)BP550BTDelete:(UIButton *)sender{
    
    [self.myBP550 commandDeleteMemoryDataResult:^(BOOL result) {
        
        self.bp550TextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"DeleteMemoryData", @""),self.bp550TextView.text];
        
    } errorBlock:^(BPDeviceError error) {
        
        [self BP550Error:error];
    }];
    
    
}

- (IBAction)BBP550BTMemory:(UIButton *)sender{
    
    [self.myBP550 commandTransferMemoryDataWithTotalCount:^(NSNumber *count) {
        self.bp550TextView.text=[NSString stringWithFormat:@"%@:%@\n%@",NSLocalizedString(@"MemoryCount", @""),count,self.bp550TextView.text];
    } progress:^(NSNumber *progress) {
        self.bp550TextView.text=[NSString stringWithFormat:@"%@:%@\n%@",NSLocalizedString(@"progress", @""),progress,self.bp550TextView.text];
       
    } dataArray:^(NSArray *array) {
        self.bp550TextView.text=[NSString stringWithFormat:@"%@:%@\n%@",NSLocalizedString(@"MemoryData", @""),array,self.bp550TextView.text];
        
        NSLog(@"MemoryData:%@",array);
    } errorBlock:^(BPDeviceError error) {
        [self BP550Error:error];
    }];
    
    
}

- (IBAction)BP550BTGetBattary:(UIButton *)sender{
    
    
    [self.myBP550 commandEnergy:^(NSNumber *energyValue) {
        
         self.bp550TextView.text=[NSString stringWithFormat:@"%@:%@\n%@",NSLocalizedString(@"Battary", @""),energyValue,self.bp550TextView.text];
       
    } errorBlock:^(BPDeviceError error) {
        [self BP550Error:error];
    }];
    
}

- (IBAction)BP550BTGetDeviceDate:(UIButton *)sender{
    
    
    [self.myBP550 commandGetDeviceDate:^(NSString *date) {
        self.bp550TextView.text=[NSString stringWithFormat:@"%@:%@\n%@",NSLocalizedString(@"DeviceDate", @""),date,self.bp550TextView.text];
    } errorBlock:^(BPDeviceError error) {
        [self BP550Error:error];
    }];
    
}


- (IBAction)BP550BTGetFunction:(UIButton *)sender{
    
    
    
    [self.myBP550 commandFunction:^(NSDictionary *dic) {
         self.bp550TextView.text=[NSString stringWithFormat:@"%@:%@\n%@",NSLocalizedString(@"Functions", @""),dic,self.bp550TextView.text];
       
    } errorBlock:^(BPDeviceError error) {
       [self BP550Error:error];
    }];
    
}

- (IBAction)BBP550BTMemoryCount:(UIButton *)sender{
    
    
    [self.myBP550 commandTransferMemoryTotalCount:^(NSNumber *count) {
        self.bp550TextView.text=[NSString stringWithFormat:@"%@:%@\n%@",NSLocalizedString(@"MemoryCount", @""),count,self.bp550TextView.text];
    } errorBlock:^(BPDeviceError error) {
        [self BP550Error:error];
    }];
    
    
}

- (IBAction)commandGetStatusOfDisplay:(UIButton *)sender{
    
    [self.myBP550 commandGetStatusOfDisplay:^(NSDictionary *statusDict) {
        
        self.bp550TextView.text=[NSString stringWithFormat:@"%@:%@\n%@",NSLocalizedString(@"GetStatusOfDisplay", @""),statusDict,self.bp550TextView.text];
        
    } error:^(BPDeviceError error) {
        [self BP550Error:error];
    }];
    
   
    
}

- (IBAction)commandSetStatusOfDisplay:(UIButton *)sender{
    
    [self.myBP550 commandSetStatusOfDisplayForBackLight:YES andClock:YES resultSuccess:^{
        
        self.bp550TextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"SetStatusOfDisplay", @""),self.bp550TextView.text];
        
    } error:^(BPDeviceError error) {
        [self BP550Error:error];
    }];
    
    
    
}


-(void)BP550Error:(BPDeviceError)errorID{
    
    switch (errorID) {
        case BPError0:
            self.bp550TextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"Unable to take measurements due to arm/wrist movements.", @""),self.bp550TextView.text];
            break;
        case BPError1:
            self.bp550TextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"Failed to detect systolic pressure", @""),self.bp550TextView.text];
            break;
        case BPError2:
            self.bp550TextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"Failed to detect diastolic pressure", @""),self.bp550TextView.text];
            break;
        case BPError3:
            self.bp550TextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"Pneumatic system blocked or cuff is too tight during inflation", @""),self.bp550TextView.text];
            break;
        case BPError4:
            self.bp550TextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"Pneumatic system leakage or cuff is too loose during inflation", @""),self.bp550TextView.text];
            break;
        case BPError5:
            self.bp550TextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"Cuff pressure reached over 300mmHg", @""),self.bp550TextView.text];
            break;
        case BPError6:
            self.bp550TextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"Cuff pressure reached over 15 mmHg for more than 160 seconds", @""),self.bp550TextView.text];
            break;
        case BPError7:
        case BPError8:
        case BPError9:
        case BPError10:
            self.bp550TextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"Data retrieving error", @""),self.bp550TextView.text];
            break;
        case BPError11:
        case BPError12:
            self.bp550TextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"Communication Error", @""),self.bp550TextView.text];
            break;
        case BPError13:
            self.bp550TextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"Low battery", @""),self.bp550TextView.text];
            break;
        case BPError14:
            self.bp550TextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"Device bluetooth set failed", @""),self.bp550TextView.text];
            break;
        case BPError15:
            self.bp550TextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@" Systolic exceeds 260mmHg or diastolic exceeds 199mmHg", @""),self.bp550TextView.text];
            break;
        case BPError16:
            self.bp550TextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"Systolic below 60mmHg or diastolic below 40mmHg", @""),self.bp550TextView.text];
            break;
        case BPError17:
            self.bp550TextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"Arm/wrist movement beyond range", @""),self.bp550TextView.text];
            break;
        case BPError18:
        case BPError19:
            self.bp550TextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"Heart rate in measure result exceeds max limit", @""),self.bp550TextView.text];
            break;
        case BPError20:
            self.bp550TextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"PP(Average BP) exceeds limit", @""),self.bp550TextView.text];
            break;
        case BPErrorUserStopMeasure:
            self.bp550TextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"User stop measure(for ABPM history measurement only)", @""),self.bp550TextView.text];
            break;
        case BPNormalError:
            self.bp550TextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"device error, error message displayed automatically", @""),self.bp550TextView.text];
            break;
        case BPOverTimeError:
        case BPNoRespondError:
            self.bp550TextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"Abnormal communication", @""),self.bp550TextView.text];
            break;
        case BPBeyondRangeError:
            self.bp550TextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"device is out of communication range.", @""),self.bp550TextView.text];
            break;
        case BPDidDisconnect:
            self.bp550TextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"Device Disconnect", @""),self.bp550TextView.text];
            break;
        case BPAskToStopMeasure:
            self.bp550TextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"measurement has been stopped.", @""),self.bp550TextView.text];
            break;
        case BPDeviceBusy:
            self.bp550TextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"device is busy doing other things", @""),self.bp550TextView.text];
            break;
        case BPInputParameterError:
        case BPInvalidOperation:
            self.bp550TextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"Parameter input error.", @""),self.bp550TextView.text];
            break;
        case BPDeviceError_CommunicationTimeout:
            self.bp550TextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"CommunicationTimeout.", @""),self.bp550TextView.text];
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
