//
//  DeviceBG1ViewController.m
//  iHealthDemoCode
//
//  Created by jing on 2018/10/22.
//  Copyright © 2018年 iHealth Demo Code. All rights reserved.
//

#import "DeviceBG1ViewController.h"
#import "BGHeader.h"

#define DemoCodeStr @"024C565F4C5614322D1200A02F3485B6F314378BACD61901C67200361C1C"


@interface DeviceBG1ViewController ()

@property (weak, nonatomic) IBOutlet UITextView *bg1TextView;

@property (weak, nonatomic) IBOutlet UILabel *deviceLabel;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;

@property (strong, nonatomic) BG1 *myBG1;

@property (nonatomic, strong) BG1Controller *bgController;
@end

@implementation DeviceBG1ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.cancelBtn setTitle:NSLocalizedString(@"Cancel", @"") forState:UIControlStateNormal];
    
    self.titleLabel.text=NSLocalizedString(@"Functions", @"");
    
    self.deviceLabel.text=[NSString stringWithFormat:@"BG1"];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(needAudioPermission:) name:kNotificationNameNeedAudioPermission object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(BG1DidDisConnect:) name:kNotificationNameBG1DidDisConnect object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(audioDeviceInsert:) name:kNotificationNameAudioDeviceInsert object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startAudioModule:)                                             name:UIApplicationWillEnterForegroundNotification
                                               object: NULL];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopAudioModule:)                                             name:UIApplicationDidEnterBackgroundNotification
                                               object: NULL];
    
    self.bgController = [BG1Controller shareBG1Controller];
    [self.bgController initBGAudioModule];
    
    
    self.myBG1 = [[BG1Controller shareBG1Controller]getCurrentBG1Instance];
    
    self.bg1TextView.text =NSLocalizedString(@"Please Insert BG1", @"");

}


-(void)startAudioModule:(NSNotification*)notification
{
    [[BG1Controller shareBG1Controller]initBGAudioModule];
    
}

-(void)stopAudioModule:(NSNotification*)notification
{
    [[BG1Controller shareBG1Controller]stopBGAudioModule];
}



-(void)needAudioPermission:(NSNotification *)info{
    
}

-(void)BG1DidDisConnect:(NSNotification *)info{
    
    self.myBG1 = [[BG1Controller shareBG1Controller] getCurrentBG1Instance];
    
     self.bg1TextView.text = [self.bg1TextView.text stringByAppendingString:[NSString stringWithFormat:@"\n%@",NSLocalizedString(@"DisConnect", @"")]];
    
}
-(void)audioDeviceInsert:(NSNotification *)info{
    
    self.myBG1 = [[BG1Controller shareBG1Controller]getCurrentBG1Instance];
    
    if (self.myBG1 != nil) {
        
        [self.myBG1 commandBG1DeviceModel:@0 withDiscoverBlock:^{
            NSLog(@"Discover");
            
            self.bg1TextView.text = [self.bg1TextView.text stringByAppendingString:[NSString stringWithFormat:@"\n%@",NSLocalizedString(@"Discover", @"")]];
        
            
        } withDiscoverBlock:^(NSDictionary *idpsDic) {
            
            self.bg1TextView.text = [self.bg1TextView.text stringByAppendingString:[NSString stringWithFormat:@"\n IDPS:%@",idpsDic]];
            
        } withConnectBlock:^{
            NSLog(@"Connect");
            self.bg1TextView.text = [self.bg1TextView.text stringByAppendingString:[NSString stringWithFormat:@"\n%@",NSLocalizedString(@"Connect", @"")]];
            
            
            
        } withErrorBlock:^(BG1Error errorID) {
            [self BGError:errorID];
            
        }];
    }
}

- (IBAction)Cancel:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    [[BG1Controller shareBG1Controller]stopBGAudioModule];
}

- (IBAction)measure:(UIButton *)sender {
    
    
        [self.myBG1 commandBG1MeasureMode:BGMeasureMode_Blood withCodeMode:BGCodeMode_GDH withCodeString:DemoCodeStr withSendCodeResultBlock:^{
            NSLog(@"SendCodeResult");
            
            self.bg1TextView.text = [self.bg1TextView.text stringByAppendingString:[NSString stringWithFormat:@"\n%@",NSLocalizedString(@"SendCodeResult",@"")]];
            
        } withStripInBlock:^{
            NSLog(@"StripIn");
            
            self.bg1TextView.text = [self.bg1TextView.text stringByAppendingString:[NSString stringWithFormat:@"\n%@",NSLocalizedString(@"StripIn", @"")]];
            
            
        } withBloodBlock:^{
            NSLog(@"Blood");
            
            self.bg1TextView.text = [self.bg1TextView.text stringByAppendingString:[NSString stringWithFormat:@"\n%@",NSLocalizedString(@"Blood", @"")]];
            
            
        } withResultBlock:^(NSDictionary *result) {
            NSLog(@"%@",result);
            
            self.bg1TextView.text = [self.bg1TextView.text stringByAppendingString:[NSString stringWithFormat:@"\n %@:%@",NSLocalizedString(@"BGResult", @""),result]];
            
            
        } withStripOutBlock:^{
            NSLog(@"StripOut");
            
            self.bg1TextView.text = [self.bg1TextView.text stringByAppendingString:[NSString stringWithFormat:@"\n%@",NSLocalizedString(@"StripOut", @"")]];
            
            
        } withErrorBlock:^(BG1Error errorID) {
            NSLog(@"--%ld",(long)errorID);
            
            [self BGError:errorID];
            
            
        }];
        

    
}

- (IBAction)measureCTL:(UIButton *)sender {
    
    
        [self.myBG1 commandBG1MeasureMode:BGMeasureMode_NoBlood withCodeMode:BGCodeMode_GDH withCodeString:DemoCodeStr withSendCodeResultBlock:^{
            NSLog(@"SendCodeResult");
            
            self.bg1TextView.text = [self.bg1TextView.text stringByAppendingString:[NSString stringWithFormat:@"\n%@",NSLocalizedString(@"SendCodeResult",@"")]];
            
        } withStripInBlock:^{
            NSLog(@"StripIn");
            
            self.bg1TextView.text = [self.bg1TextView.text stringByAppendingString:[NSString stringWithFormat:@"\n%@",NSLocalizedString(@"StripIn", @"")]];
            
            
        } withBloodBlock:^{
            NSLog(@"Blood");
            
            self.bg1TextView.text = [self.bg1TextView.text stringByAppendingString:[NSString stringWithFormat:@"\n%@",NSLocalizedString(@"Blood", @"")]];
            
            
        } withResultBlock:^(NSDictionary *result) {
            NSLog(@"%@",result);
            
            self.bg1TextView.text = [self.bg1TextView.text stringByAppendingString:[NSString stringWithFormat:@"\n %@:%@",NSLocalizedString(@"BGResult", @""),result]];
            
            
        } withStripOutBlock:^{
            NSLog(@"StripOut");
            
            self.bg1TextView.text = [self.bg1TextView.text stringByAppendingString:[NSString stringWithFormat:@"\n%@",NSLocalizedString(@"StripOut", @"")]];
            
            
        } withErrorBlock:^(BG1Error errorID) {
            NSLog(@"--%ld",(long)errorID);
            
            [self BGError:errorID];
            
            
        }];
        

    
}

- (IBAction)codeStripAnalysis:(UIButton *)sender {
    
    NSDictionary *dic =  [self.myBG1 codeStripStrAnalysis:DemoCodeStr];
    self.bg1TextView.text = [NSString stringWithFormat:@"\n %@:%@",NSLocalizedString(@"StripAnalysis", @""),dic];
    
    
    
}

-(void)BGError:(BG1Error)errorID{
    
    switch (errorID) {
        case BG1Error_LowBattery:
            self.bg1TextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"Battery is low.", @""),self.bg1TextView.text];
            break;
        case BG1Error_ResultOutOfMeasurementRage:
            self.bg1TextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"Glucose test result is out of the measurement range.", @""),self.bg1TextView.text];
            break;
        case BG1Error_UnvalidReferenceVoltage:
            self.bg1TextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"Reference voltage error, not normal measurement, please repeat", @""),self.bg1TextView.text];
            break;
        case BG1Error_StripUsed:
            self.bg1TextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"Strip is used or unknown moisture detected, discard the test strip and repeat", @""),self.bg1TextView.text];
            break;
        case BG1Error_CodeError:
            self.bg1TextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"CODE value check error. This error need let user scan code and call the send code function again,no alert need to show.", @""),self.bg1TextView.text];
            break;
        case BG1Error_AuthenticationFailed:
            self.bg1TextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"Authentication failed more than 10 times.", @""),self.bg1TextView.text];
            break;
        case BG1Error_CodeSendLost:
            self.bg1TextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"Packet loss in the process of sending CODE.", @""),self.bg1TextView.text];
            break;
            
        case BG1Error_ToolingTestFailed:
            self.bg1TextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"Tooling inspection process is not completed.", @""),self.bg1TextView.text];
            break;
            
        case BG1Error_EncryptionFailed:
            self.bg1TextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"Encryption burn write bit is empty.", @""),self.bg1TextView.text];
            break;
        case BG1Error_CompulsoryAuthenticationFaild:
            self.bg1TextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"Compulsory Authentication is not passed.", @""),self.bg1TextView.text];
            break;
        case BG1Error_ResultLow:
            self.bg1TextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"Glucose test result is low.", @""),self.bg1TextView.text];
            break;
        case BG1Error_ResultHigh:
            self.bg1TextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"Glucose test result is high.", @""),self.bg1TextView.text];
            break;
        case BG1Error_Unknown:
            self.bg1TextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"BG1Error_Unknown", @""),self.bg1TextView.text];
            break;
        case BG1Error_TimeOut:
            self.bg1TextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"BG time out.", @""),self.bg1TextView.text];
            break;
            
        case BG1Error_DisConnented:
            self.bg1TextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"BG disConnented.", @""),self.bg1TextView.text];
            break;
        case BG1Error_SleepingMode:
            self.bg1TextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"BG sleeping mode.", @""),self.bg1TextView.text];
            break;
        case BG1Error_HandShakeFailed:
            self.bg1TextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"Hand shake failed.", @""),self.bg1TextView.text];
            break;
        case BG1Error_ParameterError:
            self.bg1TextView.text=[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"Parameter input error.", @""),self.bg1TextView.text];
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
