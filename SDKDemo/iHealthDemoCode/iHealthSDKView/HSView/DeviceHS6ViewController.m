//
//  DeviceHS6ViewController.m
//  iHealthDemoCode
//
//  Created by jing on 2018/10/22.
//  Copyright © 2018年 iHealth Demo Code. All rights reserved.
//

#import "DeviceHS6ViewController.h"
#import "HSHeader.h"
@interface DeviceHS6ViewController ()
@property (weak, nonatomic) IBOutlet UITextView *hs6TextView;

@property (weak, nonatomic) IBOutlet UILabel *deviceLabel;

@property (strong, nonatomic) iHealthHS6 *myHS6;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;

@end

@implementation DeviceHS6ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.deviceLabel.text=[NSString stringWithFormat:@"HS6"];
    
    [self.cancelBtn setTitle:NSLocalizedString(@"Cancel", @"") forState:UIControlStateNormal];
    
    self.titleLabel.text=NSLocalizedString(@"Functions", @"");
    
}
- (IBAction)Cancel:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)setHS6wifi:(UIButton *)sender{
    
    
    iHealthHS6*hs6=[iHealthHS6 shareIHHS6Controller];
    
    HealthUser*user=[[HealthUser alloc] init];
    
    user.clientSecret=SDKSecret;
    
    user.clientID=SDKKey;
    
    user.userAccount=YourUserName;
    user.serialNub=[NSNumber numberWithInteger:1461140];
    
    
    
    [hs6 commandSetHS6WithPassWord:@"aaaaaaaa" disposeHS6SuccessBlock:^(NSDictionary *deviceInfo) {
        
        NSLog(@"33@---deviceInfo :%@",deviceInfo);
        
        self.hs6TextView.text=[NSString stringWithFormat:@"%@:%@\n%@",NSLocalizedString(@"deviceInfo", @""),deviceInfo,self.hs6TextView.text];
        
    } disposeHS6FailBlock:^(NSString *failmsg) {
        
        NSLog(@"failmsg :%@",failmsg);
        self.hs6TextView.text=[NSString stringWithFormat:@"%@:%@\n%@",NSLocalizedString(@"failmsg", @""),failmsg,self.hs6TextView.text];
        
    } disposeHS6EndBlock:^(NSDictionary *deviceDic) {
        
        NSLog(@"deviceDic :%@",deviceDic);
        self.hs6TextView.text=[NSString stringWithFormat:@"%@:%@\n%@",NSLocalizedString(@"deviceDic", @""),deviceDic,self.hs6TextView.text];
        
    } disposeHS6ErrorBlock:^(NSNumber *error) {
        
        NSLog(@"seterror :%@",error);
        
    }];
    
}



- (IBAction)bangding:(UIButton *)sender {
    
    iHealthHS6*hs6=[iHealthHS6 shareIHHS6Controller];
    
    
    HealthUser*user=[[HealthUser alloc] init];;
    
//    user.clientID=SDKKey;
//
//    user.clientSecret=SDKSecret;
    
    user.userAccount=YourUserName;

    user.sex=UserSex_Female;

    user.height=@170;

    user.weight=@50;

    user.isAthlete=UserIsAthelete_No;

    user.birthday=[NSDate date];

//    user.clientSecret=@"82d04cb118b24a028bede5f839b08b89";
//
//    user.clientID=@"58b4b2b253a2447ea724a49e9e996d2d";
//
//    user.userAccount=@"chennuruashoksssss.rbl@gmail.com";
//
//
//    user.sex=UserSex_Female;
//
//    user.height=@184;
//
//    user.weight=@115;
//
//    user.isAthlete=UserIsAthelete_No;
//
//    user.birthday=[NSDate date];
    
    [hs6 cloudCommandUserBinedQRDeviceWithUser:user deviceID:@"ACCF2337A954"
                                   binedResult:^(NSArray *resultArray) {
                                       
                                       NSLog(@"bangdingresultArray :%@",resultArray);
                                        self.hs6TextView.text=[NSString stringWithFormat:@"%@:%@\n%@",NSLocalizedString(@"BinedQRDevice", @""),resultArray,self.hs6TextView.text];
                                       
                                   } binedError:^(NSString *errorCode) {
                                       
                                       NSLog(@"bangdingerrorCode :%@",errorCode);
                                       
                                      
                                       self.hs6TextView.text=[NSString stringWithFormat:@"%@:%@\n%@",NSLocalizedString(@"BinedQRDeviceErrorCode", @""),errorCode,self.hs6TextView.text];
                                   }];
    
    
}

- (IBAction)unbind:(UIButton *)sender{
    
    iHealthHS6*hs6=[iHealthHS6 shareIHHS6Controller];
    
    HealthUser*user=[[HealthUser alloc] init];;
    
//    user.clientSecret=SDKSecret;
//
//    user.clientID=SDKKey;
    
    user.userAccount=YourUserName;
    
    
    [hs6 cloudCommandUserDisBinedQRDeviceForUser:user withDeviceID:@"ACCF2337A954" disBinedResult:^(NSArray *resultArray) {
        
        NSLog(@"22@---jiebangresultArray :%@",resultArray);
        
         self.hs6TextView.text=[NSString stringWithFormat:@"%@:%@\n%@",NSLocalizedString(@"DisBinedQRDevice", @""),resultArray,self.hs6TextView.text];
        
    } disBinedError:^(NSString *errorCode) {
        
        NSLog(@"jiebangerrorCode :%@",errorCode);
        self.hs6TextView.text=[NSString stringWithFormat:@"%@:%@\n%@",NSLocalizedString(@"DisBinedQRDeviceErrorCode", @""),errorCode,self.hs6TextView.text];
        
    }];
}

- (IBAction)getHS6token:(UIButton *)sender{
    
    
    iHealthHS6*hs6=[iHealthHS6 shareIHHS6Controller];
    
    HealthUser*user=[[HealthUser alloc] init];;
    
    user.clientSecret=SDKSecret;
    
    user.clientID=SDKKey;
    
    user.userAccount=YourUserName;

    [hs6 commandHS6GetOpenAPITokenWithUser:user withSuccessBlock:^(NSDictionary *openAPIInfo) {
        
        NSLog(@"44@--openAPIInfoToken :%@",openAPIInfo);
        
         self.hs6TextView.text=[NSString stringWithFormat:@"%@:%@\n%@",NSLocalizedString(@"openAPIInfoToken", @""),openAPIInfo,self.hs6TextView.text];
        
        
    } withErrorBlock:^(NSDictionary *errorCode) {
        
        NSLog(@"444---errorCode :%@",errorCode);
        self.hs6TextView.text=[NSString stringWithFormat:@"%@:%@\n%@",NSLocalizedString(@"GetOpenAPITokenError", @""),errorCode,self.hs6TextView.text];
    }];
    
}


- (IBAction)setHS6unit:(UIButton *)sender{
    
    
    iHealthHS6*hs6=[iHealthHS6 shareIHHS6Controller];
    
    HealthUser*user=[[HealthUser alloc] init];;
    
//    user.clientSecret=SDKSecret;
//
//    user.clientID=SDKKey;
    
    user.userAccount=YourUserName;
    
    [hs6 commandHS6WithUser:user withSyncWeightUnit:IHHS6SDKUnitWeight_lbs withSuccessBlock:^(BOOL syncWeightUnit) {
        NSLog(@"syncWeightUnitResult:%d",syncWeightUnit);
        
         self.hs6TextView.text=[NSString stringWithFormat:@"%@:%d\n%@",NSLocalizedString(@"syncWeightUnitResult", @""),syncWeightUnit,self.hs6TextView.text];
    } withErrorBlock:^(NSString *errorCode) {
        NSLog(@"error:%@",errorCode);
          self.hs6TextView.text=[NSString stringWithFormat:@"%@:%@\n%@",NSLocalizedString(@"syncWeightUnitError", @""),errorCode,self.hs6TextView.text];
    }];
}
- (IBAction)downloadUserData:(id)sender {
    
    iHealthHS6*hs6=[iHealthHS6 shareIHHS6Controller];
    
    HealthUser*user=[[HealthUser alloc] init];;
    
//    user.clientSecret=SDKSecret;
//
//    user.clientID=SDKKey;
//
    user.userAccount=YourUserName;
    
    [hs6 commandDownloadHS6Data:user withDownloadTS:1560394218000 withPageSize:100 withSuccessBlock:^(NSDictionary *dataDic) {
        self.hs6TextView.text=[NSString stringWithFormat:@"%@:%@\n%@",NSLocalizedString(@"DownloadHS6Data", @""),dataDic,self.hs6TextView.text];
        
        NSLog(@"dataDicdataDic:%@",dataDic);
        
    } blockHS6LastTSFromCloud:^(NSNumber *lastTS) {
         self.hs6TextView.text=[NSString stringWithFormat:@"%@:%@\n%@",NSLocalizedString(@"lastTS", @""),lastTS,self.hs6TextView.text];
    } withErrorBlock:^(NSNumber *error) {
          self.hs6TextView.text=[NSString stringWithFormat:@"%@:%@\n%@",NSLocalizedString(@"DownloadHS6DataError", @""),error,self.hs6TextView.text];
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
