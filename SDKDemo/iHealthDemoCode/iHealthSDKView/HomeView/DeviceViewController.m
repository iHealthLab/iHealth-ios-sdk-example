//
//  DeviceViewController.m
//  iHealthDemoCode
//
//  Created by jing on 2018/9/29.
//  Copyright © 2018年 iHealth Demo Code. All rights reserved.
//

#import "DeviceViewController.h"
#import "DeviceCustomCell.h"
#import "DeviceConnectViewController.h"
@interface DeviceViewController ()


@end

@implementation DeviceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.deviceTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 9;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 创建常量标识符
    static NSString *identifier = @"DeviceList";
    // 从重用队列里查找可重用的cell
    DeviceCustomCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    // 判断如果没有可以重用的cell，创建
    if (!cell) {
        cell = [[DeviceCustomCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    // 设置数据
    // 取出model对象
    
    switch (indexPath.section) {
        case 0:{
            cell.deviceTitle.text=NSLocalizedString(@"Blood pressure monitors", @"");
            [cell.deviceBtn1 setBackgroundImage:[UIImage imageNamed:@"BP5"] forState:UIControlStateNormal];
             [cell.deviceBtn1 removeTarget:self action:@selector(deviceECGButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            cell.deviceBtn1.tag=indexPath.section+1;
            [cell.deviceBtn1 addTarget:self action:@selector(deviceButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            cell.deviceName1.text=NSLocalizedString(@"Feel/BP5", @"");
            
            [cell.deviceBtn2 setBackgroundImage:[UIImage imageNamed:@"KN550BT"] forState:UIControlStateNormal];
            cell.deviceBtn2.tag=indexPath.section+2;
            [cell.deviceBtn2 addTarget:self action:@selector(deviceButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            cell.deviceName2.text=NSLocalizedString(@"Track/KN550BT", @"");
            
            [cell.deviceBtn3 setBackgroundImage:[UIImage imageNamed:@"BP7S"] forState:UIControlStateNormal];
            cell.deviceBtn3.tag=indexPath.section+3;
            [cell.deviceBtn3 addTarget:self action:@selector(deviceButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            cell.deviceName3.text=NSLocalizedString(@"View/BP7S", @"");
            
            [cell.deviceBtn4 setBackgroundImage:[UIImage imageNamed:@"BP3L"] forState:UIControlStateNormal];
            cell.deviceBtn4.tag=indexPath.section+4;
            [cell.deviceBtn4 addTarget:self action:@selector(deviceButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            cell.deviceName4.text=NSLocalizedString(@"Ease/BP3L", @"");
        }
            break;
        case 1:{
            cell.deviceTitle.text=NSLocalizedString(@"Glucose Meters", @"");
            [cell.deviceBtn1 setBackgroundImage:[UIImage imageNamed:@"BG1"] forState:UIControlStateNormal];
            cell.deviceName1.text=NSLocalizedString(@"Align/BG1", @"");
            
            [cell.deviceBtn2 setBackgroundImage:[UIImage imageNamed:@"BG1S"] forState:UIControlStateNormal];
            cell.deviceName2.text=NSLocalizedString(@"BG1S", @"");
            
            [cell.deviceBtn3 setBackgroundImage:[UIImage imageNamed:@"BG5"] forState:UIControlStateNormal];
            cell.deviceName3.text=NSLocalizedString(@"Smart/BG5", @"");
            [cell.deviceBtn4 setBackgroundImage:[UIImage imageNamed:@"BG5S"] forState:UIControlStateNormal];
            cell.deviceName4.text=NSLocalizedString(@"Gluco+/BG5S", @"");
    
             [cell.deviceBtn1 removeTarget:self action:@selector(deviceECGButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            cell.deviceBtn1.tag=indexPath.section+4;
            [cell.deviceBtn1 addTarget:self action:@selector(deviceButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            cell.deviceBtn2.tag=indexPath.section+5;
            [cell.deviceBtn2 addTarget:self action:@selector(deviceButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            cell.deviceBtn3.tag=indexPath.section+6;
            [cell.deviceBtn3 addTarget:self action:@selector(deviceButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            cell.deviceBtn4.tag=indexPath.section+7;
                       [cell.deviceBtn4 addTarget:self action:@selector(deviceButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        }
            break;
        case 2:{
            cell.deviceTitle.text=NSLocalizedString(@"Scales", @"");
            [cell.deviceBtn1 setBackgroundImage:[UIImage imageNamed:@"HS2"] forState:UIControlStateNormal];
            cell.deviceName1.text=NSLocalizedString(@"Lina/HS2", @"");
            [cell.deviceBtn2 setBackgroundImage:[UIImage imageNamed:@"HS4"] forState:UIControlStateNormal];
            cell.deviceName2.text=NSLocalizedString(@"Lite/HS4", @"");
            [cell.deviceBtn3 setBackgroundImage:[UIImage imageNamed:@"HS6"] forState:UIControlStateNormal];
            cell.deviceName3.text=NSLocalizedString(@"Core/HS6", @"");
            [cell.deviceBtn4 setBackgroundImage:[UIImage imageNamed:@"HS2S"] forState:UIControlStateNormal];
            cell.deviceName4.text=NSLocalizedString(@"HS2S", @"");
             [cell.deviceBtn1 removeTarget:self action:@selector(deviceECGButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            cell.deviceBtn1.tag=indexPath.section+7;
            [cell.deviceBtn1 addTarget:self action:@selector(deviceButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            cell.deviceBtn2.tag=indexPath.section+8;
            [cell.deviceBtn2 addTarget:self action:@selector(deviceButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            cell.deviceBtn3.tag=indexPath.section+9;
            [cell.deviceBtn3 addTarget:self action:@selector(deviceButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            cell.deviceBtn4.tag=indexPath.section+10;
            [cell.deviceBtn4 addTarget:self action:@selector(deviceButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        }
            break;
        case 3:{
            cell.deviceTitle.text=NSLocalizedString(@"Activity Trackers", @"");
            [cell.deviceBtn1 setBackgroundImage:[UIImage imageNamed:@"AM3S"] forState:UIControlStateNormal];
            cell.deviceName1.text=NSLocalizedString(@"Edge/AM3S", @"");
            [cell.deviceBtn2 setBackgroundImage:[UIImage imageNamed:@"AM4"] forState:UIControlStateNormal];
            cell.deviceName2.text=NSLocalizedString(@"Wave/AM4", @"");
            [cell.deviceBtn3 setBackgroundImage:[UIImage imageNamed:@"AM5"]  forState:UIControlStateNormal];
            cell.deviceName3.text=NSLocalizedString(@"AM5", @"");
            [cell.deviceBtn4 setBackgroundImage:nil forState:UIControlStateNormal];
            cell.deviceName4.text=NSLocalizedString(@"", @"");
            [cell.deviceBtn1 removeTarget:self action:@selector(deviceECGButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            cell.deviceBtn1.tag=indexPath.section+10;
            [cell.deviceBtn1 addTarget:self action:@selector(deviceButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            cell.deviceBtn2.tag=indexPath.section+11;
            [cell.deviceBtn2 addTarget:self action:@selector(deviceButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            cell.deviceBtn3.tag=indexPath.section+12;
            [cell.deviceBtn3 addTarget:self action:@selector(deviceButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        }
            break;
        case 4:{
            cell.deviceTitle.text=NSLocalizedString(@"Thermometers", @"");
            [cell.deviceBtn1 setBackgroundImage:[UIImage imageNamed:@"TS28B"] forState:UIControlStateNormal];
            cell.deviceName1.text=NSLocalizedString(@"TS28B", @"");
            [cell.deviceBtn2 setBackgroundImage:[UIImage imageNamed:@"THV3"] forState:UIControlStateNormal];
            cell.deviceName2.text=NSLocalizedString(@"FDIR-V3", @"");
            [cell.deviceBtn3 setBackgroundImage:[UIImage imageNamed:@"THV3"] forState:UIControlStateNormal];
            cell.deviceName3.text=NSLocalizedString(@"NT13B", @"");
            [cell.deviceBtn4 setBackgroundImage:[UIImage imageNamed:@"PT3sbt"] forState:UIControlStateNormal];
            cell.deviceName4.text=NSLocalizedString(@"PT3SBT", @"");
            
            [cell.deviceBtn1 removeTarget:self action:@selector(deviceECGButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            cell.deviceBtn1.tag=indexPath.section+12;
            [cell.deviceBtn1 addTarget:self action:@selector(deviceButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            cell.deviceBtn2.tag=indexPath.section+13;
            [cell.deviceBtn2 addTarget:self action:@selector(deviceButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            cell.deviceBtn3.tag=indexPath.section+14;
            [cell.deviceBtn3 addTarget:self action:@selector(deviceButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            cell.deviceBtn4.tag=indexPath.section+15;
            [cell.deviceBtn4 addTarget:self action:@selector(deviceButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        }
            break;
        case 5:{
            cell.deviceTitle.text=NSLocalizedString(@"Pulse Oximeter", @"");
            [cell.deviceBtn1 setBackgroundImage:[UIImage imageNamed:@"PO3M"] forState:UIControlStateNormal];
            cell.deviceName1.text=NSLocalizedString(@"Air/PO3M", @"");
            [cell.deviceBtn2 setBackgroundImage:[UIImage imageNamed:@"PO1"] forState:UIControlStateNormal];
            cell.deviceName2.text=NSLocalizedString(@"PO1", @"");
            [cell.deviceBtn3 setBackgroundImage:nil forState:UIControlStateNormal];
            cell.deviceName3.text=NSLocalizedString(@"", @"");
            [cell.deviceBtn4 setBackgroundImage:nil forState:UIControlStateNormal];
            cell.deviceName4.text=NSLocalizedString(@"", @"");
    
            cell.deviceBtn1.tag=indexPath.section+15;
            [cell.deviceBtn1 addTarget:self action:@selector(deviceButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            cell.deviceBtn2.tag=indexPath.section+16;
            [cell.deviceBtn2 addTarget:self action:@selector(deviceButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        }
            break;
        case 6:{
            cell.deviceTitle.text=NSLocalizedString(@"Portable ECG monitor", @"");
            [cell.deviceBtn1 setBackgroundImage:[UIImage imageNamed:@"ECG3"] forState:UIControlStateNormal];
            cell.deviceName1.text=NSLocalizedString(@"Rhythm/ECG3", @"");
            [cell.deviceBtn2 setBackgroundImage:nil forState:UIControlStateNormal];
            cell.deviceName2.text=NSLocalizedString(@"", @"");
            [cell.deviceBtn3 setBackgroundImage:nil forState:UIControlStateNormal];
            cell.deviceName3.text=NSLocalizedString(@"", @"");
            [cell.deviceBtn3 setBackgroundImage:nil forState:UIControlStateNormal];
            cell.deviceName3.text=NSLocalizedString(@"", @"");
            [cell.deviceBtn4 setBackgroundImage:nil forState:UIControlStateNormal];
            cell.deviceName4.text=NSLocalizedString(@"", @"");
            
            cell.deviceBtn1.tag=indexPath.section+16;
            [cell.deviceBtn1 removeTarget:self action:@selector(deviceButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            [cell.deviceBtn1 addTarget:self action:@selector(deviceECGButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        }
            break;
        case 7:{
            cell.deviceTitle.text=NSLocalizedString(@"More", @"");
            [cell.deviceBtn1 setBackgroundImage:[UIImage imageNamed:@"BPM1AE"] forState:UIControlStateNormal];
            cell.deviceName1.text=NSLocalizedString(@"BPM1AE", @"");

            [cell.deviceBtn2 setBackgroundImage:[UIImage imageNamed:@"BP5"] forState:UIControlStateNormal];
            cell.deviceName2.text=NSLocalizedString(@"BP5S", @"");
            
            [cell.deviceBtn3 setBackgroundImage:[UIImage imageNamed:@"BP5"] forState:UIControlStateNormal];
            cell.deviceName3.text=NSLocalizedString(@"BP5C", @"");
            [cell.deviceBtn4 setBackgroundImage:[UIImage imageNamed:@"HS2S"] forState:UIControlStateNormal];
            cell.deviceName4.text=NSLocalizedString(@"HS2S Pro", @"");


            cell.deviceBtn1.tag=indexPath.section+17;
            [cell.deviceBtn1 addTarget:self action:@selector(deviceButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            cell.deviceBtn2.tag=indexPath.section+18;
            [cell.deviceBtn2 addTarget:self action:@selector(deviceButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            cell.deviceBtn3.tag=indexPath.section+19;
            [cell.deviceBtn3 addTarget:self action:@selector(deviceButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            cell.deviceBtn4.tag=indexPath.section+20;
            [cell.deviceBtn4 addTarget:self action:@selector(deviceButtonClicked:) forControlEvents:UIControlEventTouchUpInside];

        }
            break;
        case 8:{
            cell.deviceTitle.text=NSLocalizedString(@"More", @"");
            
            [cell.deviceBtn1 setBackgroundImage:[UIImage imageNamed:@"BG1S"] forState:UIControlStateNormal];
            cell.deviceName1.text=NSLocalizedString(@"BG1A", @"");
            [cell.deviceBtn2 setBackgroundImage:nil forState:UIControlStateNormal];
            cell.deviceName2.text=NSLocalizedString(@"", @"");
            [cell.deviceBtn3 setBackgroundImage:nil forState:UIControlStateNormal];
            cell.deviceName3.text=NSLocalizedString(@"", @"");
            [cell.deviceBtn3 setBackgroundImage:nil forState:UIControlStateNormal];
            cell.deviceName3.text=NSLocalizedString(@"", @"");
            [cell.deviceBtn4 setBackgroundImage:nil forState:UIControlStateNormal];
            cell.deviceName4.text=NSLocalizedString(@"", @"");
            
            cell.deviceBtn1.tag=indexPath.section+21;
            [cell.deviceBtn1 addTarget:self action:@selector(deviceButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            
        }
            break;
        default:
            break;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 140;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
   
}

-(void)deviceButtonClicked:(UIButton *)sender{
    
    
    if (sender.tag==11) {
        
         [self performSegueWithIdentifier:@"ConnectHS6View" sender:self];
        
        return;
    }
    
    if (sender.tag==5) {
        
        [self performSegueWithIdentifier:@"ConnectBG1View" sender:self];
        
        return;
    }
    
    if (sender.tag==24) {

        [self performSegueWithIdentifier:@"ConnectBPM1AEView" sender:self];

        return;
    }
    
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setValue:[NSNumber numberWithInteger:sender.tag] forKey:@"DeviceSDKTypeTag"];
    [userDefault synchronize];
    
    [self performSegueWithIdentifier:@"DeviceConnect" sender:self];
    
}

-(void)deviceECGButtonClicked:(UIButton *)sender{
    
    
    UIAlertController *vc = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Select ECG", @"") message:@"" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:NSLocalizedString(@"Bluetooth", @"") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        [userDefault setValue:[NSNumber numberWithInteger:22] forKey:@"DeviceSDKTypeTag"];
        [userDefault synchronize];
        
        [self performSegueWithIdentifier:@"DeviceConnect" sender:self];
        
    }];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:NSLocalizedString(@"USB", @"") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        [userDefault setValue:[NSNumber numberWithInteger:23] forKey:@"DeviceSDKTypeTag"];
        [userDefault synchronize];
        
        [self performSegueWithIdentifier:@"DeviceConnect" sender:self];
        
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", @"") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [vc addAction:action];
    [vc addAction:action1];
    [vc addAction:action2];
    [self presentViewController:vc animated:YES completion:nil];
    
    
    
   
    
}



@end
