//
//  DevicePO1ViewController.m
//  iHealthDemoCode
//
//  Created by jing on 2018/10/12.
//  Copyright © 2018年 iHealth Demo Code. All rights reserved.
//

#import "DevicePO1ViewController.h"
#import "POHeader.h"
#import "SDKUpdateDevice.h"
@interface DevicePO1ViewController ()
@property (weak, nonatomic) IBOutlet UITextView *po1TextView;

@property (weak, nonatomic) IBOutlet UILabel *deviceLabel;

@property (weak, nonatomic) IBOutlet UIButton *getVersionBtn;

@property (weak, nonatomic) IBOutlet UIButton *startUpdateBtn;

@property (strong, nonatomic) PO1 *myPO1;

@end

@implementation DevicePO1ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.getVersionBtn setTitle:NSLocalizedString(@"GetUpdateVersion", @"") forState:UIControlStateNormal];
    
    [self.startUpdateBtn setTitle:NSLocalizedString(@"StartUpdate", @"") forState:UIControlStateNormal];
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    
    NSString*deviceMac=[userDefault valueForKey:@"SelectDeviceMac"];
    
    self.deviceLabel.text=[NSString stringWithFormat:@"PO1 %@",deviceMac];
    
    NSArray*deviceArray=[[PO1Controller shareIHPO1Controller] getAllCurrentPO1Instace];
    
    for(PO1 *device in deviceArray){
        
        if([deviceMac isEqualToString:device.serialNumber]){
            
            self.myPO1=device;
           
        }
    }
    
    
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(devicePO1Measure:) name:@"PO1NotificationMeasureData" object:nil];
    
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(devicePO1Disconnect:) name:PO1DisConnectNoti object:nil];
}

- (IBAction)Cancel:(id)sender {
    
    
    
     [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)Disconnect:(id)sender {
    
    [self.myPO1 commandDisconnectDevice];
}

-(void)devicePO1Disconnect:(NSNotification *)tempNoti{
 
    NSDictionary*deviceDic= [tempNoti userInfo];
    
    NSLog(@"devicePO1Disconnect:%@",deviceDic);
    
    
     self.po1TextView.text=[NSString stringWithFormat:@"%@:%@\n%@",NSLocalizedString(@"devicePO1Disconnect", @""),deviceDic,self.po1TextView.text];
}


-(void)devicePO1Measure:(NSNotification *)tempNoti{
 
    NSDictionary*deviceDic= [tempNoti userInfo];
    
    NSLog(@"devicePO1Measure:%@",deviceDic);
    
    
     self.po1TextView.text=[NSString stringWithFormat:@"%@:%@\n%@",NSLocalizedString(@"measureData", @""),deviceDic,self.po1TextView.text];
}



- (IBAction)GetBattery:(id)sender {
    
    [self.myPO1 commandPO1GetDeviceBattery:^(NSNumber *battery) {
        
        NSLog(@"battery:%@",battery);
        
        
         self.po1TextView.text=[NSString stringWithFormat:@"%@:%@\n%@",NSLocalizedString(@"battery", @""),battery,self.po1TextView.text];
        
    } withErrorBlock:^(PO1ErrorID errorID) {
        
    }];
}


- (IBAction)GetDeviceIDPS:(id)sender {
    
    [self.myPO1 commandFunction:^(NSDictionary *functionDict) {
        
         NSLog(@"functionDict:%@",functionDict);
        
         self.po1TextView.text=[NSString stringWithFormat:@"%@:%@\n%@",NSLocalizedString(@"functionDict", @""),functionDict,self.po1TextView.text];
        
    } DisposeErrorBlock:^(PO1ErrorID errorID) {
        
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
