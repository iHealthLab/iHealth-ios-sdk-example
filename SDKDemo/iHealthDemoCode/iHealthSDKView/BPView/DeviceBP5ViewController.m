//
//  DeviceBP5ViewController.m
//  iHealthDemoCode
//
//  Created by jing on 2018/10/11.
//  Copyright © 2018年 iHealth Demo Code. All rights reserved.
//

#import "DeviceBP5ViewController.h"
#import "BPHeader.h"
@interface DeviceBP5ViewController ()

@property (weak, nonatomic) IBOutlet UITextView *bp5TextView;

@property (weak, nonatomic) IBOutlet UILabel *deviceLabel;

@property (strong, nonatomic) BP5 *myBP5;

@end

@implementation DeviceBP5ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    
    NSString*deviceMac=[userDefault valueForKey:@"SelectDeviceMac"];
    
    self.deviceLabel.text=[NSString stringWithFormat:@"BP5 %@",deviceMac];
    
    NSArray*deviceArray=[[BP5Controller shareBP5Controller] getAllCurrentBP5Instace];
    
    for(BP5 *device in deviceArray){
        
        if([deviceMac isEqualToString:device.serialNumber]){
            
            self.myBP5=device;
            
        }
    }
}
- (IBAction)Cancel:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)BP5StartMeasure:(UIButton *)sender{
    
    [self.myBP5 commandStartMeasureWithZeroingState:^(BOOL isComplete) {
        
         self.bp5TextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"zero complete", @""),self.bp5TextView.text];
       
    } pressure:^(NSArray *pressureArr) {
        
        self.bp5TextView.text=[NSString stringWithFormat:@"%@:%@\n%@",NSLocalizedString(@"pressureArr", @""),pressureArr,self.bp5TextView.text];
       
    } waveletWithHeartbeat:^(NSArray *waveletArr) {
        
         self.bp5TextView.text=[NSString stringWithFormat:@"%@:%@\n%@",NSLocalizedString(@"waveletWithHeartbeat", @""),waveletArr,self.bp5TextView.text];
        
    } waveletWithoutHeartbeat:^(NSArray *waveletArr) {
        
         self.bp5TextView.text=[NSString stringWithFormat:@"%@:%@\n%@",NSLocalizedString(@"waveletWithoutHeartbeat", @""),waveletArr,self.bp5TextView.text];
       
    } result:^(NSDictionary *resultDic) {
        
        self.bp5TextView.text=[NSString stringWithFormat:@"%@:%@\n%@",NSLocalizedString(@"resultDic", @""),resultDic,self.bp5TextView.text];
       
    } errorBlock:^(BPDeviceError error) {
        [self BP5Error:error];
    }];
}


- (IBAction)BP5StopMeasure:(UIButton *)sender{
    
    [self.myBP5 stopBPMeassureSuccessBlock:^{
        
        self.bp5TextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@" stopBPMeassureSuccess", @""),self.bp5TextView.text];
    
    } errorBlock:^(BPDeviceError error) {
        [self BP5Error:error];
    }];
}

- (IBAction)BP5GetBattary:(UIButton *)sender{
    
    [self.myBP5 commandEnergy:^(NSNumber *energyValue) {
        
         self.bp5TextView.text=[NSString stringWithFormat:@"%@:%@\n%@",NSLocalizedString(@"energyValue", @""),energyValue,self.bp5TextView.text];
        
    } errorBlock:^(BPDeviceError error) {
        [self BP5Error:error];
    }];
}

- (IBAction)BP5GetFunction:(UIButton *)sender{
    
    [self.myBP5 commandFunction:^(NSDictionary *dic)  {
        
         self.bp5TextView.text=[NSString stringWithFormat:@"%@:%@\n%@",NSLocalizedString(@"commandFunction", @""),dic,self.bp5TextView.text];
       
    } errorBlock:^(BPDeviceError error) {
        [self BP5Error:error];
    }];
}

- (IBAction)BP5SetBlueConnect:(UIButton *)sender{
    
    [self.myBP5 commandSetBlueConnect:1 respond:^(BOOL isOpen) {
        
        self.bp5TextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"SetBlueConnect isOpen", @""),self.bp5TextView.text];
        
    } errorBlock:^(BPDeviceError error) {
        [self BP5Error:error];
    }];
    
}

- (IBAction)BP5SetOffline:(UIButton *)sender{
    
     self.bp5TextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"SetOffline", @""),self.bp5TextView.text];
    
    [self.myBP5 commandSetOffline:1 errorBlock:^(BPDeviceError error) {
        [self BP5Error:error];
    }];
}


- (IBAction)bp5GetMemoryCount:(id)sender {
    
    [self.myBP5 commandTransferMemoryTotalCount:^(NSNumber *count) {
        self.bp5TextView.text=[NSString stringWithFormat:@"%@:%@\n%@",NSLocalizedString(@"MemoryTotalCount", @""),count,self.bp5TextView.text];
       
    } errorBlock:^(BPDeviceError error) {
        [self BP5Error:error];
    }];
    
}

- (IBAction)BP5GetMemory:(UIButton *)sender{
    
    [self.myBP5 commandBatchUpload:^(NSNumber *num) {
         self.bp5TextView.text=[NSString stringWithFormat:@"%@:%@\n%@",NSLocalizedString(@"MemoryTotalCount", @""),num,self.bp5TextView.text];
       
    } progress:^(NSNumber *pregress) {
         self.bp5TextView.text=[NSString stringWithFormat:@"%@:%@\n%@",NSLocalizedString(@"progress", @""),pregress,self.bp5TextView.text];
    } dataArray:^(NSArray *array) {
         self.bp5TextView.text=[NSString stringWithFormat:@"%@:%@\n%@",NSLocalizedString(@"BP5 history data", @""),array,self.bp5TextView.text];
        
    } errorBlock:^(BPDeviceError error) {
        [self BP5Error:error];
    }];
}


-(void)BP5Error:(BPDeviceError)errorID{
    
    switch (errorID) {
        case BPError0:
            self.bp5TextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"Unable to take measurements due to arm/wrist movements.", @""),self.bp5TextView.text];
            break;
        case BPError1:
            self.bp5TextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"Failed to detect systolic pressure", @""),self.bp5TextView.text];
            break;
        case BPError2:
             self.bp5TextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"Failed to detect diastolic pressure", @""),self.bp5TextView.text];
            break;
        case BPError3:
            self.bp5TextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"Pneumatic system blocked or cuff is too tight during inflation", @""),self.bp5TextView.text];
            break;
        case BPError4:
            self.bp5TextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"Pneumatic system leakage or cuff is too loose during inflation", @""),self.bp5TextView.text];
            break;
        case BPError5:
            self.bp5TextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"Cuff pressure reached over 300mmHg", @""),self.bp5TextView.text];
            break;
        case BPError6:
            self.bp5TextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"Cuff pressure reached over 15 mmHg for more than 160 seconds", @""),self.bp5TextView.text];
            break;
        case BPError7:
        case BPError8:
        case BPError9:
        case BPError10:
            self.bp5TextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"Data retrieving error", @""),self.bp5TextView.text];
            break;
        case BPError11:
        case BPError12:
            self.bp5TextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"Communication Error", @""),self.bp5TextView.text];
            break;
        case BPError13:
            self.bp5TextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"Low battery", @""),self.bp5TextView.text];
            break;
        case BPError14:
            self.bp5TextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"Device bluetooth set failed", @""),self.bp5TextView.text];
            break;
        case BPError15:
            self.bp5TextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@" Systolic exceeds 260mmHg or diastolic exceeds 199mmHg", @""),self.bp5TextView.text];
            break;
        case BPError16:
            self.bp5TextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"Systolic below 60mmHg or diastolic below 40mmHg", @""),self.bp5TextView.text];
            break;
        case BPError17:
            self.bp5TextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"Arm/wrist movement beyond range", @""),self.bp5TextView.text];
            break;
        case BPError18:
        case BPError19:
            self.bp5TextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"Heart rate in measure result exceeds max limit", @""),self.bp5TextView.text];
            break;
        case BPError20:
            self.bp5TextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"PP(Average BP) exceeds limit", @""),self.bp5TextView.text];
            break;
        case BPErrorUserStopMeasure:
            self.bp5TextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"User stop measure(for ABPM history measurement only)", @""),self.bp5TextView.text];
            break;
        case BPNormalError:
            self.bp5TextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"device error, error message displayed automatically", @""),self.bp5TextView.text];
            break;
        case BPOverTimeError:
        case BPNoRespondError:
            self.bp5TextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"Abnormal communication", @""),self.bp5TextView.text];
            break;
        case BPBeyondRangeError:
            self.bp5TextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"device is out of communication range.", @""),self.bp5TextView.text];
            break;
        case BPDidDisconnect:
            self.bp5TextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"Device Disconnect", @""),self.bp5TextView.text];
            break;
        case BPAskToStopMeasure:
            self.bp5TextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"measurement has been stopped.", @""),self.bp5TextView.text];
            break;
        case BPDeviceBusy:
            self.bp5TextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"device is busy doing other things", @""),self.bp5TextView.text];
            break;
        case BPInputParameterError:
        case BPInvalidOperation:
            self.bp5TextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"Parameter input error.", @""),self.bp5TextView.text];
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
