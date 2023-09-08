//
//  DeviceNT13BViewController.m
//  iHealthDemoCode
//
//  Created by user on 2019/9/20.
//  Copyright © 2019 iHealth Demo Code. All rights reserved.
//

#import "DeviceNT13BViewController.h"
#import "NT13BMacroFile.h"
#import "NT13BHeader.h"
@interface DeviceNT13BViewController ()

@property (weak, nonatomic) IBOutlet UITextView *nt13bTextView;

@property (weak, nonatomic) IBOutlet UILabel *deviceLabel;

@property (weak, nonatomic) IBOutlet UILabel *resultLabel;

@property (strong, nonatomic) NT13B *myNT13B;

@end

@implementation DeviceNT13BViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    
    NSString*deviceMac=[userDefault valueForKey:@"SelectDeviceMac"];
    
    self.deviceLabel.text=[NSString stringWithFormat:@"NT13B %@",deviceMac];
    
    NSArray*deviceArray=[[NT13BController shareIHNT13BController] getAllCurrentNT13BInstace];
    
    for(NT13B *device in deviceArray){
        
        if([deviceMac isEqualToString:device.serialNumber]){
            
            self.myNT13B=device;
            
        }
    }
}

- (IBAction)Cancel:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)measure:(id)sender{
    
    
    [self.myNT13B commandStartMeasure:^(NSDictionary *result) {
        
        
       
        
        NSString*bodyFlag=[NSString string];
        
        if ([[result objectForKey:@"bodyFlag"] intValue]==1) {
            
            bodyFlag=@"body";
            
        }else{
            
            bodyFlag=@"object";
        }
        NSString*unit=[NSString string];
        
        if ([[result objectForKey:@"unit"] intValue]==1) {
            unit=@"C";
            
        }else{
            
            unit=@"F";
        }
        
         self.resultLabel.text=[NSString stringWithFormat:@"%@:%@ %@",bodyFlag,[result objectForKey:@"result"],unit];
        
    }];
}

- (IBAction)disconnect:(id)sender{
    
    [self.myNT13B commandDisconnect:^(BOOL result) {
        
        self.resultLabel.text=@"Disconnect";
        
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
