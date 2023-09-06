//
//  DeviceBPM1AEViewController.m
//  iHealthDemoCode
//
//  Created by jing on 2019/9/29.
//  Copyright © 2019 iHealth Demo Code. All rights reserved.
//

#import "DeviceBPM1AEViewController.h"

#import "BPHeader.h"
#import "BPMacroFile.h"
#import "BPM1AE.h"

@interface DeviceBPM1AEViewController ()
@property (weak, nonatomic) IBOutlet UITextView *bpm1aeTextView;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (strong, nonatomic) BPM1AE *myBPM1AE;
@end

@implementation DeviceBPM1AEViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.myBPM1AE=[[BPM1AE alloc] init];
    
    // Do any additional setup after loading the view.
}
- (IBAction)Cancel:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}


- (IBAction)UDPGetIDPS:(id)sender {
    
    [self.nameTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
    
//    __block BPM1AE *wifiSetWifiClass = [[BPM1AE alloc] init];
//    if (!wifiSetWifiClass) {
//        NSLog(@"create wifiSetWifiClass fail");
//         self.bpm1aeTextView.text=[NSString stringWithFormat:@"create wifiSetWifiClass fail \n%@",self.bpm1aeTextView.text];
//        return;
//    }
    
    
    [self.myBPM1AE commandStartSearchDeviceGetIDPS:^(NSDictionary *dict) {
        
                NSLog(@"Get IDPS:%@",dict);
//                 self.bpm1aeTextView.text=[NSString stringWithFormat:@"IDPS:%@ \n%@",dict,self.bpm1aeTextView.text];
        
    } blockError:^(WifiSetWifiError error) {
        
    }];
    
}

- (IBAction)UDPGetWifiList:(id)sender {
    
    [self.nameTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
    
//    __block BPM1AE *wifiSetWifiClass = [[BPM1AE alloc] init];
//    if (!wifiSetWifiClass) {
//        NSLog(@"create wifiSetWifiClass fail");
//         self.bpm1aeTextView.text=[NSString stringWithFormat:@"create wifiSetWifiClass fail \n%@",self.bpm1aeTextView.text];
//        return;
//    }
    
    
    [self.myBPM1AE commandGetWifiArrayDictionary:^(NSDictionary *wifiArrayDic) {
        NSArray *arr=[wifiArrayDic objectForKey:@"wifiArray"];
        for (NSDictionary *temp in arr) {
            NSLog(@"%@",[temp objectForKey:@"Wifi_SSID"]);
//                self.bpm1aeTextView.text=[NSString stringWithFormat:@"Wifi_SSID:%@ \n%@",[temp objectForKey:@"Wifi_SSID"],self.bpm1aeTextView.text];
        }
    
    } blockError:^(WifiSetWifiError error) {
        NSLog(@"commandGetWifiArrayDictionary error %lu",(unsigned long)error);
        
        self.bpm1aeTextView.text=[NSString stringWithFormat:@"set wifi error:%lu \n%@",(unsigned long)error,self.bpm1aeTextView.text];
//        [self.myBPM1AE disconnect];
    }];
    
}

- (IBAction)UDPSetWifiTest:(id)sender {
    
    [self.nameTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
    
//    __block BPM1AE *wifiSetWifiClass = [[BPM1AE alloc] init];
//    if (!wifiSetWifiClass) {
//        NSLog(@"create wifiSetWifiClass fail");
//         self.bpm1aeTextView.text=[NSString stringWithFormat:@"create wifiSetWifiClass fail \n%@",self.bpm1aeTextView.text];
//        return;
//    }
//    [self.myBPM1AE commandStartSearchDeviceGetIDPS:^(NSDictionary *IDPSDic) {
//        NSLog(@"wifi IDPS:%@",IDPSDic);
//        self.bpm1aeTextView.text=[NSString stringWithFormat:@"wifi IDPS:%@ \n%@",IDPSDic,self.bpm1aeTextView.text];
//        [self.myBPM1AE commandGetWifiArrayDictionary:^(NSDictionary *wifiArrayDic) {
//            NSArray *arr=[wifiArrayDic objectForKey:@"wifiArray"];
//            for (NSDictionary *temp in arr) {
//                NSLog(@"%@",[temp objectForKey:@"Wifi_SSID"]);
////                self.bpm1aeTextView.text=[NSString stringWithFormat:@"Wifi_SSID:%@ \n%@",[temp objectForKey:@"Wifi_SSID"],self.bpm1aeTextView.text];
//            }
////            [wifiSetWifiClass disconnect];
//
//            return;
            [self.myBPM1AE commandSendWifiName: self.nameTextField.text password:self.passwordTextField.text phoneID:@"123456" withURL: @"https://myvitals.ihealthlabs.com:5089/pushto/phone/B7204E81-627C-4521-B765-8051B3080642/z@y.com/SpqRFLCktvAi*OM2Y1RMhvrSHOCpx-x5bcRZlY2-VGQ5xGpfYK8cZxS6zfu472vavrL5Cskh23xoTDFkiTqjvM5T-OQ3FLRLeaWPIjMCnlGZ1YqrRfSoINR8Lbkbygdx" setResult:^(NSNumber *waitFlg) {
                
                NSLog(@"SSID和Password send success！");
                 self.bpm1aeTextView.text=[NSString stringWithFormat:@"SSID and Password send success! \n%@",self.bpm1aeTextView.text];
                dispatch_async(dispatch_get_main_queue(), ^{
                    if ([waitFlg isEqual:@0]) {
                        NSLog(@"wait connect status。。。");
                         self.bpm1aeTextView.text=[NSString stringWithFormat:@"wait connect status。。。 \n%@",self.bpm1aeTextView.text];
                    }
                    else
                    {
                        NSLog(@"completed! no need to wait!");
                         self.bpm1aeTextView.text=[NSString stringWithFormat:@"completed! no need to wait! \n%@",self.bpm1aeTextView.text];
                    }
                    
                });
            } blockConnectState:^(NSDictionary *connectStepAndState) {
                NSLog(@"connectStepAndState:%@",connectStepAndState);
//                 self.bpm1aeTextView.text=[NSString stringWithFormat:@"connectStepAndState:%@ \n%@",connectStepAndState,self.bpm1aeTextView.text];
                NSString *stepStr=@"";
                NSString *stateStr=@"";
                
                NSNumber *connectStep=[connectStepAndState objectForKey:@"ConnectStep"];
                NSNumber *connectState=[connectStepAndState objectForKey:@"ConnectState"];
                switch (connectStep.integerValue) {
                    case 0:
                        stepStr=@"Step：device connectting。。。 ";
                        break;
                    case 1:
                        stepStr=@"Step：connect wifi ";
                        switch (connectState.integerValue) {
                            case 0:
                                stateStr=@"Status：can not found wifi！";
                                break;
                            case 1:
                                stateStr=@"Status：wifi secret error！";
                                break;
                            case 2:
                                stateStr=@"Status：DHCP error！";
                                break;
                            case 3:
                                stateStr=@"Status：connect success！！！！";
                                break;
                            default:
                                break;
                        }
//                        [self.myBPM1AE disconnect];
                        break;
                    case 2:
                        stepStr=@"Step：connect cloud ！";
                        switch (connectState.integerValue) {
                            case 3:
                                stateStr=@"Status：connect cloud failed！";
                                break;
                            case 4:
                                stateStr=@"Status：cloud authentication failed！";
                                break;
                            case 5:
                                stateStr=@"Status：cloud connect success！！！！";
                                break;
                            default:
                                break;
                        }
//                        [self.myBPM1AE disconnect];
                        break;
                        
                    default:
                        break;
                }
                
//                self.bpm1aeTextView.text=[NSString stringWithFormat:@"stepStr:%@ stateStr:%@ \n%@",stepStr,stateStr,self.bpm1aeTextView.text];
            } blockError:^(WifiSetWifiError error) {
                NSLog(@"set wifi error %lu",(unsigned long)error);
                 self.bpm1aeTextView.text=[NSString stringWithFormat:@"set wifi error:%lu \n%@",(unsigned long)error,self.bpm1aeTextView.text];
//                [self.myBPM1AE disconnect];
            }];
//        }
//    } blockError:^(WifiSetWifiError error) {
//        NSLog(@"commandStartSearchDeviceGetIDPS error %lu",(unsigned long)error);
//        self.bpm1aeTextView.text=[NSString stringWithFormat:@"commandStartSearchDeviceGetIDPS error:%lu \n%@",(unsigned long)error,self.bpm1aeTextView.text];
////        [self.myBPM1AE disconnect];
//    }];
    

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
