//
//  DeviceTHV3ViewController.m
//  iHealthDemoCode
//
//  Created by jing on 2018/10/22.
//  Copyright © 2018年 iHealth Demo Code. All rights reserved.
//

#import "DeviceTHV3ViewController.h"
#import "THV3.h"
#import "THV3Controller.h"
#import "THV3Macro.h"
@interface DeviceTHV3ViewController ()
@property (weak, nonatomic) IBOutlet UITextView *thv3TextView;

@property (weak, nonatomic) IBOutlet UILabel *deviceLabel;

@property (strong, nonatomic) THV3 *myTHV3;
@end

@implementation DeviceTHV3ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    
    NSString*deviceMac=[userDefault valueForKey:@"SelectDeviceMac"];
    
    self.deviceLabel.text=[NSString stringWithFormat:@"THV3 %@",deviceMac];
    
    NSArray*deviceArray=[[THV3Controller sharedController] allCurrentInstance];
    
    for(THV3 *device in deviceArray){
        
        if([deviceMac isEqualToString:device.serialNumber]){
            
            self.myTHV3=device;
            
        }
    }
}
- (IBAction)Cancel:(id)sender {
    
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)readHistoryData:(id)sender{
    
    [self.myTHV3 readHistoryDataWithResultBlock:^(NSArray<THV3HistoryData *> *dataArray) {
        NSLog(@"%@",dataArray);
        
        self.thv3TextView.text=[NSString stringWithFormat:@"%@:%@\n%@",NSLocalizedString(@"SyncTime", @""),dataArray,self.thv3TextView.text];
    }];
    
}
- (IBAction)commandDisconnectDevice:(id)sender{
    
    
    [self.myTHV3 commandDisconnectDevice];
    
     self.thv3TextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"commandDisconnectDevice", @""),self.thv3TextView.text];
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
