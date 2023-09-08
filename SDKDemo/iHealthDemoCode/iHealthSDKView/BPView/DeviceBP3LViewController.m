//
//  DeviceBP3LViewController.m
//  iHealthDemoCode
//
//  Created by jing on 2018/10/22.
//  Copyright © 2018年 iHealth Demo Code. All rights reserved.
//

#import "DeviceBP3LViewController.h"
#import "BPHeader.h"
@interface DeviceBP3LViewController ()
@property (weak, nonatomic) IBOutlet UITextView *bp3LTextView;

@property (weak, nonatomic) IBOutlet UILabel *deviceLabel;

@property (strong, nonatomic) BP3L *myBP3L;
@end

@implementation DeviceBP3LViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    
    NSString*deviceMac=[userDefault valueForKey:@"SelectDeviceMac"];
    
    self.deviceLabel.text=[NSString stringWithFormat:@"BP3L %@",deviceMac];
    
    NSArray*deviceArray=[[BP3LController shareBP3LController] getAllCurrentBP3LInstace];
    
    for(BP3L *device in deviceArray){
        
        if([deviceMac isEqualToString:device.serialNumber]){
            
            self.myBP3L=device;
            
        }
    }
}
- (IBAction)Cancel:(id)sender {
    
    [self.myBP3L commandDisconnectDevice];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)BP3LStartMeasure:(UIButton *)sender{
    
    [self.myBP3L commandStartMeasureWithZeroingState:^(BOOL isComplete) {
        
        self.bp3LTextView.text=[NSString stringWithFormat:@"%@:%d\n%@",NSLocalizedString(@"zeroing complete", @""),isComplete,self.bp3LTextView.text];
        
    } pressure:^(NSArray *pressureArr) {
        self.bp3LTextView.text=[NSString stringWithFormat:@"%@:%@\n%@",NSLocalizedString(@"pressureArr", @""),pressureArr,self.bp3LTextView.text];
      
    } waveletWithHeartbeat:^(NSArray *waveletArr) {
        
         self.bp3LTextView.text=[NSString stringWithFormat:@"%@:%@\n%@",NSLocalizedString(@"waveletWithHeartbeat", @""),waveletArr,self.bp3LTextView.text];
        
    } waveletWithoutHeartbeat:^(NSArray *waveletArr) {
        self.bp3LTextView.text=[NSString stringWithFormat:@"%@:%@\n%@",NSLocalizedString(@"waveletWithoutHeartbeat", @""),waveletArr,self.bp3LTextView.text];
        
    } result:^(NSDictionary *dic) {
        
         self.bp3LTextView.text=[NSString stringWithFormat:@"%@:%@\n%@",NSLocalizedString(@"BP3LResult dic", @""),dic,self.bp3LTextView.text];
        
    } errorBlock:^(BPDeviceError error) {
        [self BPError:error];
    }];
    
}

- (IBAction)BP3LStopMeasure:(UIButton *)sender{
    
    
    [self.myBP3L stopBPMeassureSuccessBlock:^{
        
         self.bp3LTextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"stopBPMeassureSuccess", @""),self.bp3LTextView.text];
        
    } errorBlock:^(BPDeviceError error) {
        
         [self BPError:error];
        
    }];
    
}

- (IBAction)BP3LGetBattary:(UIButton *)sender{
    
    [self.myBP3L commandEnergy:^(NSNumber *energyValue) {
        
        NSLog(@"BP3LEnergy%@",energyValue);
        
           self.bp3LTextView.text=[NSString stringWithFormat:@"%@:%@\n%@",NSLocalizedString(@"Battary", @""),energyValue,self.bp3LTextView.text];
        
        
    } errorBlock:^(BPDeviceError error) {
        
        [self BPError:error];
    }];
    
    
}

- (IBAction)BP3LGetFunction:(UIButton *)sender{
    
    [self.myBP3L commandFunction:^(NSDictionary *dic) {
        
        NSLog(@"BP3LFunction%@",dic);
        self.bp3LTextView.text=[NSString stringWithFormat:@"%@:%@\n%@",NSLocalizedString(@"BP3LFunction", @""),dic,self.bp3LTextView.text];
        
    } errorBlock:^(BPDeviceError error) {
        
        [self BPError:error];
        
    }];
}

- (IBAction)BP3LDisConnect:(UIButton *)sender{
    
    [self.myBP3L commandDisconnectDevice];
    
    self.bp3LTextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"Device disconnect", @""),self.bp3LTextView.text];
    
}
-(void)BPError:(BPDeviceError)errorID{
    
    switch (errorID) {
            case BPError0:
            self.bp3LTextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"Unable to take measurements due to arm/wrist movements.", @""),self.bp3LTextView.text];
            break;
            case BPError1:
            self.bp3LTextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"Failed to detect systolic pressure", @""),self.bp3LTextView.text];
            break;
            case BPError2:
            self.bp3LTextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"Failed to detect diastolic pressure", @""),self.bp3LTextView.text];
            break;
            case BPError3:
            self.bp3LTextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"Pneumatic system blocked or cuff is too tight during inflation", @""),self.bp3LTextView.text];
            break;
            case BPError4:
            self.bp3LTextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"Pneumatic system leakage or cuff is too loose during inflation", @""),self.bp3LTextView.text];
            break;
            case BPError5:
            self.bp3LTextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"Cuff pressure reached over 300mmHg", @""),self.bp3LTextView.text];
            break;
            case BPError6:
            self.bp3LTextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"Cuff pressure reached over 15 mmHg for more than 160 seconds", @""),self.bp3LTextView.text];
            break;
            case BPError7:
            case BPError8:
            case BPError9:
            case BPError10:
            self.bp3LTextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"Data retrieving error", @""),self.bp3LTextView.text];
            break;
            case BPError11:
            case BPError12:
            self.bp3LTextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"Communication Error", @""),self.bp3LTextView.text];
            break;
            case BPError13:
            self.bp3LTextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"Low battery", @""),self.bp3LTextView.text];
            break;
            case BPError14:
            self.bp3LTextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"Device bluetooth set failed", @""),self.bp3LTextView.text];
            break;
            case BPError15:
            self.bp3LTextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@" Systolic exceeds 260mmHg or diastolic exceeds 199mmHg", @""),self.bp3LTextView.text];
            break;
            case BPError16:
            self.bp3LTextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"Systolic below 60mmHg or diastolic below 40mmHg", @""),self.bp3LTextView.text];
            break;
            case BPError17:
            self.bp3LTextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"Arm/wrist movement beyond range", @""),self.bp3LTextView.text];
            break;
            case BPError18:
            case BPError19:
            self.bp3LTextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"Heart rate in measure result exceeds max limit", @""),self.bp3LTextView.text];
            break;
            case BPError20:
            self.bp3LTextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"PP(Average BP) exceeds limit", @""),self.bp3LTextView.text];
            break;
            case BPErrorUserStopMeasure:
            self.bp3LTextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"User stop measure(for ABPM history measurement only)", @""),self.bp3LTextView.text];
            break;
            case BPNormalError:
            self.bp3LTextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"device error, error message displayed automatically", @""),self.bp3LTextView.text];
            break;
            case BPOverTimeError:
            case BPNoRespondError:
            self.bp3LTextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"Abnormal communication", @""),self.bp3LTextView.text];
            break;
            case BPBeyondRangeError:
            self.bp3LTextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"device is out of communication range.", @""),self.bp3LTextView.text];
            break;
            case BPDidDisconnect:
            self.bp3LTextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"Device Disconnect", @""),self.bp3LTextView.text];
            break;
            case BPAskToStopMeasure:
            self.bp3LTextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"measurement has been stopped.", @""),self.bp3LTextView.text];
            break;
            case BPDeviceBusy:
            self.bp3LTextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"device is busy doing other things", @""),self.bp3LTextView.text];
            break;
            case BPInputParameterError:
            case BPInvalidOperation:
            self.bp3LTextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"Parameter input error.", @""),self.bp3LTextView.text];
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
