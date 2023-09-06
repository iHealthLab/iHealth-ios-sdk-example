//
//  DeviceBP7SViewController.m
//  iHealthDemoCode
//
//  Created by jing on 2018/10/22.
//  Copyright © 2018年 iHealth Demo Code. All rights reserved.
//

#import "DeviceBP7SViewController.h"
#import "BPHeader.h"
@interface DeviceBP7SViewController ()
@property (weak, nonatomic) IBOutlet UITextView *bp7STextView;

@property (weak, nonatomic) IBOutlet UILabel *deviceLabel;

@property (strong, nonatomic) BP7S *myBP7S;
@end

@implementation DeviceBP7SViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    
    NSString*deviceMac=[userDefault valueForKey:@"SelectDeviceMac"];
    
    self.deviceLabel.text=[NSString stringWithFormat:@"BP7S %@",deviceMac];
    
    NSArray*deviceArray=[[BP7SController shareBP7SController] getAllCurrentBP7SInstace];
    
    for(BP7S *device in deviceArray){
        
        if([deviceMac isEqualToString:device.serialNumber]){
            
            self.myBP7S=device;
            
        }
    }
}
- (IBAction)Cancel:(id)sender {
    
    [self.myBP7S commandDisconnectDevice];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)function:(id)sender {
    [self.myBP7S commandFunction:^(NSDictionary *dic) {
        
        self.bp7STextView.text=[NSString stringWithFormat:@"%@:%@\n%@",NSLocalizedString(@"function", @""),dic,self.bp7STextView.text];
        
    } errorBlock:^(BPDeviceError error) {
        [self BP7SError:error];
    }];
}
- (IBAction)energy:(id)sender {
    [self.myBP7S commandEnergy:^(NSNumber *energyValue) {
        self.bp7STextView.text=[NSString stringWithFormat:@"%@:%@\n%@",NSLocalizedString(@"Energy", @""),energyValue,self.bp7STextView.text];
    } errorBlock:^(BPDeviceError error) {
        [self BP7SError:error];
    }];
}
- (IBAction)memoryCount:(id)sender {
    [self.myBP7S commandTransferMemoryTotalCount:^(NSNumber *num) {
        self.bp7STextView.text=[NSString stringWithFormat:@"%@:%@\n%@",NSLocalizedString(@"MemoryTotalCount", @""),num,self.bp7STextView.text];
    } errorBlock:^(BPDeviceError error) {
        [self BP7SError:error];
    }];
}
- (IBAction)memory:(id)sender {
    [self.myBP7S commandTransferMemoryDataWithTotalCount:^(NSNumber *num) {
        self.bp7STextView.text=[NSString stringWithFormat:@"%@:%@\n%@",NSLocalizedString(@"MemoryTotalCount", @""),num,self.bp7STextView.text];
    } progress:^(NSNumber *pregress) {
        self.bp7STextView.text=[NSString stringWithFormat:@"%@:%@\n%@",NSLocalizedString(@"progess", @""),pregress,self.bp7STextView.text];
    } dataArray:^(NSArray *array) {
        self.bp7STextView.text=[NSString stringWithFormat:@"%@:%@\n%@",NSLocalizedString(@"dataArray", @""),array,self.bp7STextView.text];
    } errorBlock:^(BPDeviceError error) {
       [self BP7SError:error];
    }];
}
- (IBAction)configUnit:(id)sender {
    [self.myBP7S commandSetUnit:@"mmHg" disposeSetReslut:^{
        self.bp7STextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"set unit success", @""),self.bp7STextView.text];
    } errorBlock:^(BPDeviceError error) {
        [self BP7SError:error];
    }];
}
- (IBAction)configAngle:(id)sender {
    NSDictionary* dict = @{
                           @"highAngleForLeft":@(90),
                           @"lowAngleForLeft":@(10),
                           @"highAngleForRight":@(90),
                           @"lowAngleForRight":@(10)
                           };
    [self.myBP7S commandSetAngle:dict disposeSetReslut:^{
       
        self.bp7STextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"set Angle success", @""),self.bp7STextView.text];
    } errorBlock:^(BPDeviceError error) {
        [self BP7SError:error];
    }];
}

- (IBAction)BP7sDisconnect:(UIButton *)sender{
    
    [self.myBP7S commandDisconnectDevice];
    
    self.bp7STextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"Device disconnect", @""),self.bp7STextView.text];
    
}
-(void)BP7SError:(BPDeviceError)errorID{
    
    switch (errorID) {
        case BPError0:
            self.bp7STextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"Unable to take measurements due to arm/wrist movements.", @""),self.bp7STextView.text];
            break;
        case BPError1:
            self.bp7STextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"Failed to detect systolic pressure", @""),self.bp7STextView.text];
            break;
        case BPError2:
            self.bp7STextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"Failed to detect diastolic pressure", @""),self.bp7STextView.text];
            break;
        case BPError3:
            self.bp7STextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"Pneumatic system blocked or cuff is too tight during inflation", @""),self.bp7STextView.text];
            break;
        case BPError4:
            self.bp7STextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"Pneumatic system leakage or cuff is too loose during inflation", @""),self.bp7STextView.text];
            break;
        case BPError5:
            self.bp7STextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"Cuff pressure reached over 300mmHg", @""),self.bp7STextView.text];
            break;
        case BPError6:
            self.bp7STextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"Cuff pressure reached over 15 mmHg for more than 160 seconds", @""),self.bp7STextView.text];
            break;
        case BPError7:
        case BPError8:
        case BPError9:
        case BPError10:
            self.bp7STextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"Data retrieving error", @""),self.bp7STextView.text];
            break;
        case BPError11:
        case BPError12:
            self.bp7STextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"Communication Error", @""),self.bp7STextView.text];
            break;
        case BPError13:
            self.bp7STextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"Low battery", @""),self.bp7STextView.text];
            break;
        case BPError14:
            self.bp7STextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"Device bluetooth set failed", @""),self.bp7STextView.text];
            break;
        case BPError15:
            self.bp7STextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@" Systolic exceeds 260mmHg or diastolic exceeds 199mmHg", @""),self.bp7STextView.text];
            break;
        case BPError16:
            self.bp7STextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"Systolic below 60mmHg or diastolic below 40mmHg", @""),self.bp7STextView.text];
            break;
        case BPError17:
            self.bp7STextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"Arm/wrist movement beyond range", @""),self.bp7STextView.text];
            break;
        case BPError18:
        case BPError19:
            self.bp7STextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"Heart rate in measure result exceeds max limit", @""),self.bp7STextView.text];
            break;
        case BPError20:
            self.bp7STextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"PP(Average BP) exceeds limit", @""),self.bp7STextView.text];
            break;
        case BPErrorUserStopMeasure:
            self.bp7STextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"User stop measure(for ABPM history measurement only)", @""),self.bp7STextView.text];
            break;
        case BPNormalError:
            self.bp7STextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"device error, error message displayed automatically", @""),self.bp7STextView.text];
            break;
        case BPOverTimeError:
        case BPNoRespondError:
            self.bp7STextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"Abnormal communication", @""),self.bp7STextView.text];
            break;
        case BPBeyondRangeError:
            self.bp7STextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"device is out of communication range.", @""),self.bp7STextView.text];
            break;
        case BPDidDisconnect:
            self.bp7STextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"Device disconnect", @""),self.bp7STextView.text];
            break;
        case BPAskToStopMeasure:
            self.bp7STextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"measurement has been stopped.", @""),self.bp7STextView.text];
            break;
        case BPDeviceBusy:
            self.bp7STextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"device is busy doing other things", @""),self.bp7STextView.text];
            break;
        case BPInputParameterError:
        case BPInvalidOperation:
            self.bp7STextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"Parameter input error.", @""),self.bp7STextView.text];
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
