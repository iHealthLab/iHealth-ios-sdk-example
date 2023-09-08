//
//  DeviceHS4ViewController.m
//  iHealthDemoCode
//
//  Created by jing on 2018/10/22.
//  Copyright © 2018年 iHealth Demo Code. All rights reserved.
//

#import "DeviceHS4ViewController.h"
#import "HSHeader.h"
@interface DeviceHS4ViewController ()
@property (weak, nonatomic) IBOutlet UITextView *hs4TextView;

@property (weak, nonatomic) IBOutlet UILabel *deviceLabel;

@property (strong, nonatomic) HS4 *myHS4;
@end

@implementation DeviceHS4ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    
    NSString*deviceMac=[userDefault valueForKey:@"SelectDeviceMac"];
    
    self.deviceLabel.text=[NSString stringWithFormat:@"HS4 %@",deviceMac];
    
    NSArray*deviceArray=[[HS4Controller shareIHHs4Controller] getAllCurrentHS4Instace];
    
    for(HS4 *device in deviceArray){
        
        if([deviceMac isEqualToString:device.deviceID]){
            
            self.myHS4=device;
            
        }
    }
}
- (IBAction)Cancel:(id)sender {
    
    [self.myHS4 commandDisconnectDevice];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)commandHS4GetMemoryPressed:(id)sender{
    
    [self.myHS4 commandTransferMemorryData:^(NSDictionary *startDataDictionary) {
        
        self.hs4TextView.text=[NSString stringWithFormat:@"%@:%@\n%@",NSLocalizedString(@"MemoryData", @""),startDataDictionary,self.hs4TextView.text];
        

    } DisposeProgress:^(NSNumber *progress) {
        self.hs4TextView.text=[NSString stringWithFormat:@"%@:%@\n%@",NSLocalizedString(@"Progress", @""),progress,self.hs4TextView.text];

    } MemorryData:^(NSArray *historyDataArray) {
        
        self.hs4TextView.text=[NSString stringWithFormat:@"%@:%@\n%@",NSLocalizedString(@"AllMemoryData", @""),historyDataArray,self.hs4TextView.text];

        
    } FinishTransmission:^{
        self.hs4TextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"FinishOfflineData", @""),self.hs4TextView.text];

    } DisposeErrorBlock:^(HS4DeviceError errorID) {
        [self HS4Error:errorID];

    }];
    
   
}
- (IBAction)commandHS4MeasurePressed:(id)sender{
    
    [self.myHS4 commandMeasureWithUint:HSUnit_Kg Weight:^(NSNumber *unStableWeight) {
        self.hs4TextView.text=[NSString stringWithFormat:@"%@:%@\n%@",NSLocalizedString(@"unStableWeight", @""),unStableWeight,self.hs4TextView.text];

    } StableWeight:^(NSDictionary *StableWeightDic) {
        self.hs4TextView.text=[NSString stringWithFormat:@"%@:%@\n%@",NSLocalizedString(@"StableWeight", @""),StableWeightDic,self.hs4TextView.text];

    } DisposeErrorBlock:^(HS4DeviceError errorID) {
        [self HS4Error:errorID];
    }];
    
   
    
}

- (IBAction)commandDisHS4Pressed:(id)sender{
    
    
    [self.myHS4 commandDisconnectDevice];
    
}

-(void)HS4Error:(HS4DeviceError)errorID{
    
    switch (errorID) {
        case HS4DataZeor:
            self.hs4TextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"No memory", @""),self.hs4TextView.text];
            break;
        case HS4DeviceEr0:
            self.hs4TextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"The Scale failed to initialize", @""),self.hs4TextView.text];
            break;
        case HS4DeviceEr1:
            self.hs4TextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"Maximum weight has been exceeded", @""),self.hs4TextView.text];
            break;
        case HS4DeviceEr2:
            self.hs4TextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"The Scale can't capture a steady reading", @""),self.hs4TextView.text];
            break;
        case HS4DeviceEr4:
            self.hs4TextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"Bluetooth connection error", @""),self.hs4TextView.text];
            break;
        case HS4DeviceEr7:
            self.hs4TextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"Movement while measuring", @""),self.hs4TextView.text];
            break;
        case HS4DeviceEr8:
            self.hs4TextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"Invalidate", @""),self.hs4TextView.text];
            break;
        case HS4DeviceEr9:
            
            self.hs4TextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"Scale memory access error", @""),self.hs4TextView.text];
            break;
            
        case HS4DeviceLowPower:
            self.hs4TextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"Battery level is low", @""),self.hs4TextView.text];
            break;
        case HS4DeviceDisconnect:
            self.hs4TextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"Device disconnect", @""),self.hs4TextView.text];
            break;
        case HS4DeviceSendTimeout:
            self.hs4TextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"Communication error", @""),self.hs4TextView.text];
            break;
        case HS4DeviceRecWeightError:
            self.hs4TextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@" DeviceRecWeightError", @""),self.hs4TextView.text];
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
