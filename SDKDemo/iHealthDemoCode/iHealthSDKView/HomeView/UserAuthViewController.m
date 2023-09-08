//
//  UserAuthViewController.m
//  iHealthDemoCode
//
//  Created by daiqingquan on 2017/4/11.
//  Copyright © 2017年 zhiwei jing. All rights reserved.
//

#import "UserAuthViewController.h"

#import "IHSDKCloudUser.h"


#import "DeviceViewController.h"

#define APP_VERSION [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
#define APP_BUILD [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]

@interface UserAuthViewController ()

@property (weak, nonatomic) IBOutlet UIButton *authButton;

@property (weak, nonatomic) IBOutlet UITextView *ResultTestView;

@property (weak, nonatomic) IBOutlet UIImageView *ResultImageView;


@end

@implementation UserAuthViewController

- (void)viewDidLoad {
    
    
    [super viewDidLoad];
    
    
    self.navigationItem.title=NSLocalizedString(@"Authorization", @"Authorization");
    
    [self.authButton setTitle:NSLocalizedString(@"Authentication", @"Authentication") forState:UIControlStateNormal];
    
    
    
    self.ResultTestView.text=NSLocalizedString(@"                        Attention \n \n You can use SDK only after pass the authorization. \n \n According to the order, please call the SDK \n \n Get more information at                                                   https://dev.ihealthlabs.com",@"SDKattention");
    
    [self.ResultImageView setImage:[UIImage imageNamed:@"authImage"]];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)UserAuthApplicense:(id)sender{
    

     NSString *filePath = [[NSBundle mainBundle] pathForResource:@"com_iHealthSDK_SDKDemo_ios" ofType:@"pem"];
    
     NSData*data = [NSData dataWithContentsOfFile:filePath];

    [[IHSDKCloudUser commandGetSDKUserInstance] commandSDKUserValidationWithLicense:data UserDeviceAccess:^(NSArray *DeviceAccessArray) {
        
//        NSLog(@"DeviceAccessArray :%@",DeviceAccessArray);
        
    } UserValidationSuccess:^(UserAuthenResult result) {
        
         self.ResultTestView.text=[NSString stringWithFormat:NSLocalizedString(@"Sucess", @"Sucess")];
        
       [self performSegueWithIdentifier:@"deviceView" sender:self];
        
    } DisposeErrorBlock:^(UserAuthenResult errorID) {
        
        NSString*failMessage=[NSString string];
        
        switch (errorID) {
            case UserAuthen_InputError:
                failMessage=NSLocalizedString(@"Input error", @"Input error");
                break;
            case UserAuthen_CertificateExpired:
                failMessage=NSLocalizedString(@"Certificate expired", @"Certificate expired");
                break;
            case UserAuthen_InvalidCertificate:
                failMessage=NSLocalizedString(@"Invalid certificate", @"Invalid certificate");
                break;
            default:
                break;
        }
        
        NSString*authMessage=NSLocalizedString(@"Authorization failed", @"Authorization failed");
        
        self.ResultTestView.text=[NSString stringWithFormat:@"           %@ \n\n %@",authMessage,failMessage];
        
        [self.ResultImageView setImage:[UIImage imageNamed:@"authFail"]];
        
    }];

}



@end
