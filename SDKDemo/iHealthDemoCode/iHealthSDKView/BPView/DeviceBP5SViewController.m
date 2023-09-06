//
//  DeviceBP5ViewController.m
//  iHealthDemoCode
//
//  Created by jing on 2018/10/11.
//  Copyright © 2018年 iHealth Demo Code. All rights reserved.
//

#import "DeviceBP5SViewController.h"
#import "BPHeader.h"
@interface DeviceBP5SViewController ()

@property (weak, nonatomic) IBOutlet UITextView *bp5sTextView;

@property (weak, nonatomic) IBOutlet UILabel *deviceLabel;

@property (strong, nonatomic) BP5S *myBP5S;

@end

@implementation DeviceBP5SViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    
    NSString*deviceMac=[userDefault valueForKey:@"SelectDeviceMac"];
    
    self.deviceLabel.text=[NSString stringWithFormat:@"BP5S %@",deviceMac];
    
    NSArray*deviceArray=[[BP5SController sharedController] allConnectedInstance];
    
    for(BP5S *device in deviceArray){
        
        if([deviceMac isEqualToString:device.serialNumber]){
            
            self.myBP5S=device;
            
        }
    }
}
- (IBAction)Cancel:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)BP5GetBattary:(UIButton *)sender{
    
    [self.myBP5S commandEnergy:^(NSNumber *energyValue) {
        
        self.bp5sTextView.text=[NSString stringWithFormat:@"%@:%@\n%@",NSLocalizedString(@"energyValue", @""),energyValue,self.bp5sTextView.text];
        
    } errorBlock:^(BPDeviceError error) {
        [self BP5Error:error];
    }];
}

- (IBAction)BP5SDiscinnect:(UIButton *)sender{
    
    [self.myBP5S commandDisconnectDevice];
}

- (IBAction)BP5GetFunction:(UIButton *)sender{
    
    [self.myBP5S commandFunction:^(NSDictionary *dic)  {
        
        self.bp5sTextView.text=[NSString stringWithFormat:@"%@:%@\n%@",NSLocalizedString(@"commandFunction", @""),dic,self.bp5sTextView.text];
        
    } errorBlock:^(BPDeviceError error) {
        [self BP5Error:error];
    }];
}

- (IBAction)BP5CSetUnit:(UIButton *)sender{
    
//     @"mmHg" or @"kPa"
    
    [self.myBP5S commandSetUnit:@"kPa" disposeSetReslut:^{
        
         self.bp5sTextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"SetUnitSucess", @""),self.bp5sTextView.text];
        
    } errorBlock:^(BPDeviceError error) {
         [self BP5Error:error];
    }];
    
}
- (IBAction)BP5CSetAutoMeasure:(UIButton *)sender{
    
   
    
  
    
}
- (IBAction)BP5CGetAutoMeasure:(UIButton *)sender{
    
   
    
}

- (IBAction)BP5CSetID:(UIButton *)sender{
    
    
    
   
    
}


- (IBAction)BP5CGetID:(UIButton *)sender{
    
    
    
   
    
}

- (IBAction)BP5CStartPlan:(UIButton *)sender{
    
    
    
   
    
}

- (IBAction)BP5StartMeasure:(UIButton *)sender{
    
    [self.myBP5S commandStartMeasureWithZeroingState:^(BOOL isComplete) {
        
         self.bp5sTextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"zero complete", @""),self.bp5sTextView.text];
       
    } pressure:^(NSArray *pressureArr) {
        
        self.bp5sTextView.text=[NSString stringWithFormat:@"%@:%@\n%@",NSLocalizedString(@"pressureArr", @""),pressureArr,self.bp5sTextView.text];
       
    } waveletWithHeartbeat:^(NSArray *waveletArr) {
        
         self.bp5sTextView.text=[NSString stringWithFormat:@"%@:%@\n%@",NSLocalizedString(@"waveletWithHeartbeat", @""),waveletArr,self.bp5sTextView.text];
        
    } waveletWithoutHeartbeat:^(NSArray *waveletArr) {
        
         self.bp5sTextView.text=[NSString stringWithFormat:@"%@:%@\n%@",NSLocalizedString(@"waveletWithoutHeartbeat", @""),waveletArr,self.bp5sTextView.text];
       
    } result:^(NSDictionary *resultDic) {
        
        self.bp5sTextView.text=[NSString stringWithFormat:@"%@:%@\n%@",NSLocalizedString(@"resultDic", @""),resultDic,self.bp5sTextView.text];
       
    } errorBlock:^(BPDeviceError error) {
        [self BP5Error:error];
    }];
}


- (IBAction)BP5StopMeasure:(UIButton *)sender{
    
    [self.myBP5S stopBPMeassureSuccessBlock:^{
        
        self.bp5sTextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@" stopBPMeassureSuccess", @""),self.bp5sTextView.text];
    
    } errorBlock:^(BPDeviceError error) {
        [self BP5Error:error];
    }];
}


- (IBAction)bp5CGetMemoryCount:(id)sender {
    
    [self.myBP5S commandTransferMemoryTotalCount:^(NSNumber *count) {
       
         self.bp5sTextView.text=[NSString stringWithFormat:@"%@:%@\n%@",NSLocalizedString(@"MemoryCount", @""),count,self.bp5sTextView.text];
    } errorBlock:^(BPDeviceError error) {
        
    }];
    
}

- (IBAction)BP5GetMemory:(UIButton *)sender{
    
    [self.myBP5S commandTransferMemoryDataWithTotalCount:^(NSNumber *count) {
        
        self.bp5sTextView.text=[NSString stringWithFormat:@"%@:%@\n%@",NSLocalizedString(@"MemoryCount", @""),count,self.bp5sTextView.text];
        
    } progress:^(NSNumber *progressValue) {
        
        self.bp5sTextView.text=[NSString stringWithFormat:@"%@:%@\n%@",NSLocalizedString(@"progress", @""),progressValue,self.bp5sTextView.text];
        
        
    } dataArray:^(NSArray *bachArray) {
        
        self.bp5sTextView.text=[NSString stringWithFormat:@"%@:%@\n%@",NSLocalizedString(@"MemoryData", @""),bachArray,self.bp5sTextView.text];
        
        NSLog(@"bachArray:%@",bachArray);
        
    } errorBlock:^(BPDeviceError error) {
        
    }];
}

- (IBAction)BP5CDeleteMemory:(UIButton *)sender{
    
    [self.myBP5S commandDeleteDataSuccessBlock:^{
        
        
        NSLog(@"DeleteDataSuccess");
        
        
    } errorBlock:^(BPDeviceError error) {
        
    }];
}



-(void)BP5Error:(BPDeviceError)errorID{
    
    switch (errorID) {
        case BPError0:
            self.bp5sTextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"Unable to take measurements due to arm/wrist movements.", @""),self.bp5sTextView.text];
            break;
        case BPError1:
            self.bp5sTextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"Failed to detect systolic pressure", @""),self.bp5sTextView.text];
            break;
        case BPError2:
             self.bp5sTextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"Failed to detect diastolic pressure", @""),self.bp5sTextView.text];
            break;
        case BPError3:
            self.bp5sTextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"Pneumatic system blocked or cuff is too tight during inflation", @""),self.bp5sTextView.text];
            break;
        case BPError4:
            self.bp5sTextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"Pneumatic system leakage or cuff is too loose during inflation", @""),self.bp5sTextView.text];
            break;
        case BPError5:
            self.bp5sTextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"Cuff pressure reached over 300mmHg", @""),self.bp5sTextView.text];
            break;
        case BPError6:
            self.bp5sTextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"Cuff pressure reached over 15 mmHg for more than 160 seconds", @""),self.bp5sTextView.text];
            break;
        case BPError7:
        case BPError8:
        case BPError9:
        case BPError10:
            self.bp5sTextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"Data retrieving error", @""),self.bp5sTextView.text];
            break;
        case BPError11:
        case BPError12:
            self.bp5sTextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"Communication Error", @""),self.bp5sTextView.text];
            break;
        case BPError13:
            self.bp5sTextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"Low battery", @""),self.bp5sTextView.text];
            break;
        case BPError14:
            self.bp5sTextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"Device bluetooth set failed", @""),self.bp5sTextView.text];
            break;
        case BPError15:
            self.bp5sTextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@" Systolic exceeds 260mmHg or diastolic exceeds 199mmHg", @""),self.bp5sTextView.text];
            break;
        case BPError16:
            self.bp5sTextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"Systolic below 60mmHg or diastolic below 40mmHg", @""),self.bp5sTextView.text];
            break;
        case BPError17:
            self.bp5sTextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"Arm/wrist movement beyond range", @""),self.bp5sTextView.text];
            break;
        case BPError18:
        case BPError19:
            self.bp5sTextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"Heart rate in measure result exceeds max limit", @""),self.bp5sTextView.text];
            break;
        case BPError20:
            self.bp5sTextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"PP(Average BP) exceeds limit", @""),self.bp5sTextView.text];
            break;
        case BPErrorUserStopMeasure:
            self.bp5sTextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"User stop measure(for ABPM history measurement only)", @""),self.bp5sTextView.text];
            break;
        case BPNormalError:
            self.bp5sTextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"device error, error message displayed automatically", @""),self.bp5sTextView.text];
            break;
        case BPOverTimeError:
        case BPNoRespondError:
            self.bp5sTextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"Abnormal communication", @""),self.bp5sTextView.text];
            break;
        case BPBeyondRangeError:
            self.bp5sTextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"device is out of communication range.", @""),self.bp5sTextView.text];
            break;
        case BPDidDisconnect:
            self.bp5sTextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"Device Disconnect", @""),self.bp5sTextView.text];
            break;
        case BPAskToStopMeasure:
            self.bp5sTextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"measurement has been stopped.", @""),self.bp5sTextView.text];
            break;
        case BPDeviceBusy:
            self.bp5sTextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"device is busy doing other things", @""),self.bp5sTextView.text];
            break;
        case BPInputParameterError:
        case BPInvalidOperation:
            self.bp5sTextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"Parameter input error.", @""),self.bp5sTextView.text];
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
