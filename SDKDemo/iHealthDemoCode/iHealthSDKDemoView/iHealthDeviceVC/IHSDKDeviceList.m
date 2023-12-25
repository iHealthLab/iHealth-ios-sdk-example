//
//  IHSDKDeviceList.m
//  iHealthDemoCode
//
//  Created by jing on 2023/4/12.
//  Copyright © 2023 iHealth Demo Code. All rights reserved.
//

#import "IHSDKDeviceList.h"
#import "IHSDKDemoTableView.h"
#import "BPHeader.h"
#import "BGHeader.h"
#import "AMMacroFile.h"
#import "AMHeader.h"
#import "POHeader.h"
#import "HSHeader.h"
#import "PT3SBTMacroFile.h"
#import "PT3SBTController.h"
#import "ScanDeviceController.h"
#import "ConnectDeviceController.h"
#import "DeviceAM6HomeVC.h"
#import "DeviceKN550BTVC.h"
#import "DeviceBG5SVC.h"
#import "DevicePO3VC.h"
#import "DevicePO1VC.h"
#import "DeviceBG1AVC.h"
#import "DeviceBG1VC.h"
#import "DeviceBG1SVC.h"
#import "DeviceBP5SVC.h"
#import "DeviceBP3LVC.h"
#import "DeviceHS2SVC.h"
#import "DevicePT3SBTVC.h"
#import "DeviceBP7SVC.h"
#import "DeviceHS2SProVC.h"
/* Notification */
#define kiHealthSDKAddNoti(obj,notiName,sel) [NSNotificationCenter.defaultCenter addObserver:obj selector:(sel) name:(notiName) object:nil]
#define kiHealthSDKRemNoti(obj,notiName) [NSNotificationCenter.defaultCenter removeObserver:obj name:(notiName) object:nil]
#define kiHealthSDKRemAllNoti(obj) [NSNotificationCenter.defaultCenter removeObserver:obj]
@interface IHSDKDeviceList ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) NSMutableSet *mArr;
@property (strong, nonatomic) IHSDKDemoTableView *myTable;
@property (copy, nonatomic) NSString *selectedDeviceId;

@end

@implementation IHSDKDeviceList

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (void)setupInterface{
    self.title = @"Select Device";
    
    self.mArr = [NSMutableSet new];
//    [self.mArr addObject:@"test device"];
    self.myTable = [IHSDKDemoTableView groupedTable];
    self.myTable.delegate = self;
    self.myTable.dataSource = self;
    [self.myTable addToView:self.view];
    
    switch (self.SDKDeviceType) {
        case HealthDeviceType_KN550BT:

            kiHealthSDKAddNoti(self, KN550BTDiscover, @selector(DeviceDiscover:));
            kiHealthSDKAddNoti(self, KN550BTConnectNoti, @selector(DeviceConnect:));
            kiHealthSDKAddNoti(self, KN550BTConnectFailed, @selector(DeviceConnectFail:));
            kiHealthSDKAddNoti(self, KN550BTDisConnectNoti, @selector(DeviceDisConnect:));
            
            [KN550BTController shareKN550BTController];
            break;
        case HealthDeviceType_BP5S:

            kiHealthSDKAddNoti(self, BP5SDiscover, @selector(DeviceDiscover:));
            kiHealthSDKAddNoti(self, BP5SConnectNoti, @selector(DeviceConnect:));
            kiHealthSDKAddNoti(self, BP5SConnectFailed, @selector(DeviceConnectFail:));
            kiHealthSDKAddNoti(self, BP5SDisConnectNoti, @selector(DeviceDisConnect:));
            
            [BP5SController sharedController];
            break;
        case HealthDeviceType_BG5S:

            kiHealthSDKAddNoti(self, kNotificationNameBG5SDidDiscover, @selector(DeviceDiscover:));
            kiHealthSDKAddNoti(self, kNotificationNameBG5SConnectSuccess, @selector(DeviceConnect:));
            kiHealthSDKAddNoti(self, kNotificationNameBG5SConnectFail, @selector(DeviceConnectFail:));
            kiHealthSDKAddNoti(self, kNotificationNameBG5SDidDisConnect, @selector(DeviceDisConnect:));
            
            [AM5Controller shareAM5Controller];
            break;
        case HealthDeviceType_BG1A:

            kiHealthSDKAddNoti(self, BG1ADiscover, @selector(DeviceDiscover:));
            kiHealthSDKAddNoti(self, BG1AConnectNoti, @selector(DeviceConnect:));
            kiHealthSDKAddNoti(self, BG1AConnectFailed, @selector(DeviceConnectFail:));
            kiHealthSDKAddNoti(self, BG1ADisConnectNoti, @selector(DeviceDisConnect:));
            
            [BG1AController shareIHBG1AController];
            break;
        case HealthDeviceType_PO3:

            kiHealthSDKAddNoti(self, PO3Discover, @selector(DeviceDiscover:));
            kiHealthSDKAddNoti(self, PO3ConnectNoti, @selector(DeviceConnect:));
            kiHealthSDKAddNoti(self, PO3ConnectFailed, @selector(DeviceConnectFail:));
            kiHealthSDKAddNoti(self, PO3DisConnectNoti, @selector(DeviceDisConnect:));
            
            [PO3Controller shareIHPO3Controller];
            break;
        case HealthDeviceType_PO1:

            kiHealthSDKAddNoti(self, PO1Discover, @selector(DeviceDiscover:));
            kiHealthSDKAddNoti(self, PO1ConnectNoti, @selector(DeviceConnect:));
            kiHealthSDKAddNoti(self, PO1ConnectFailed, @selector(DeviceConnectFail:));
            kiHealthSDKAddNoti(self, PO1DisConnectNoti, @selector(DeviceDisConnect:));
            
            [PO1Controller shareIHPO1Controller];
            break;
        
        case HealthDeviceType_AM6:
            
            [[AM6Controller shareAM6Controller] configAM6DeviceBleParameters];
            
            kiHealthSDKAddNoti(self, AM6Discover, @selector(DeviceDiscover:));
            kiHealthSDKAddNoti(self, AM6ConnectNoti, @selector(DeviceConnect:));
            kiHealthSDKAddNoti(self, AM6ConnectFailed, @selector(DeviceConnectFail:));
            kiHealthSDKAddNoti(self, AM6DisConnectNoti, @selector(DeviceDisConnect:));
            
            [self.mArr addObjectsFromArray:[[AM6Controller shareAM6Controller] getAllCurrentConnectedAM6Mac]];
            break;
        case HealthDeviceType_BG1:{
            DeviceBG1VC *vc = [DeviceBG1VC new];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case HealthDeviceType_BG1S:

            kiHealthSDKAddNoti(self, BG1SDiscover, @selector(DeviceDiscover:));
            kiHealthSDKAddNoti(self, BG1SConnectNoti, @selector(DeviceConnect:));
            kiHealthSDKAddNoti(self, BG1SConnectFailed, @selector(DeviceConnectFail:));
            kiHealthSDKAddNoti(self, BG1SDisConnectNoti, @selector(DeviceDisConnect:));
            
            [BG1SController shareIHBG1SController];
            break;
        case HealthDeviceType_BP3L:

            kiHealthSDKAddNoti(self, BP3LDiscover, @selector(DeviceDiscover:));
            kiHealthSDKAddNoti(self, BP3LConnectNoti, @selector(DeviceConnect:));
            kiHealthSDKAddNoti(self, BP3LConnectFailed, @selector(DeviceConnectFail:));
            kiHealthSDKAddNoti(self, BP3LDisConnectNoti, @selector(DeviceDisConnect:));
            
            [BP3LController shareBP3LController];
            break;
        case HealthDeviceType_HS2S:

            kiHealthSDKAddNoti(self, HS2SDiscover, @selector(DeviceDiscover:));
            kiHealthSDKAddNoti(self, HS2SConnectNoti, @selector(DeviceConnect:));
            kiHealthSDKAddNoti(self, HS2SConnectFailed, @selector(DeviceConnectFail:));
            kiHealthSDKAddNoti(self, HS2SDisConnectNoti, @selector(DeviceDisConnect:));
            
            [HS2SController shareIHHS2SController];
            break;
        case HealthDeviceType_PT3SBT:

            kiHealthSDKAddNoti(self, PT3SBTDiscover, @selector(DeviceDiscover:));
            kiHealthSDKAddNoti(self, PT3SBTConnectNoti, @selector(DeviceConnect:));
            kiHealthSDKAddNoti(self, PT3SBTConnectFailed, @selector(DeviceConnectFail:));
            kiHealthSDKAddNoti(self, PT3SBTDisConnectNoti, @selector(DeviceDisConnect:));
            
            [PT3SBTController shareIHPT3SBTController];
            break;
        case HealthDeviceType_BP7S:

            kiHealthSDKAddNoti(self, BP7SDiscover, @selector(DeviceDiscover:));
            kiHealthSDKAddNoti(self, BP7SConnectNoti, @selector(DeviceConnect:));
            kiHealthSDKAddNoti(self, BP7SConnectFailed, @selector(DeviceConnectFail:));
            kiHealthSDKAddNoti(self, BP7SDisConnectNoti, @selector(DeviceDisConnect:));
            
            [BP7SController shareBP7SController];
            break;
        case HealthDeviceType_HS2SPro:

            kiHealthSDKAddNoti(self, HS2SPRODiscover, @selector(DeviceDiscover:));
            kiHealthSDKAddNoti(self, HS2SPROConnectNoti, @selector(DeviceConnect:));
            kiHealthSDKAddNoti(self, HS2SPROConnectFailed, @selector(DeviceConnectFail:));
            kiHealthSDKAddNoti(self, HS2SPRODisConnectNoti, @selector(DeviceDisConnect:));
            
            [HS2SPROController shareIHHS2SPROController];
            break;
        default:
            break;
    }
    
   
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [[ScanDeviceController commandGetInstance] commandScanDeviceType:self.SDKDeviceType];
}
- (void)viewWillDisappear:(BOOL)animated{
    [[ScanDeviceController commandGetInstance] commandStopScanDeviceType:self.SDKDeviceType];
}
- (void)DeviceDiscover:(NSNotification*)tempNoti{

    NSDictionary *dic = [tempNoti userInfo];
    
    NSLog(@"scan dic:%@",dic);
    
    
    if (dic[@"ID"]!=nil &&(_SDKDeviceType!=HealthDeviceType_NT13B)) {
        
        [[ConnectDeviceController commandGetInstance] commandContectDeviceWithDeviceType:_SDKDeviceType andSerialNub:dic[@"ID"]];
        
        return;
    }
    
     NSString*deviceMacStr=[NSString stringWithFormat:@"%@",[dic objectForKey:@"SerialNumber"]];
    
    if (![self.mArr containsObject:deviceMacStr] && deviceMacStr!=nil &&(_SDKDeviceType!=HealthDeviceType_NT13B)) {
       
        
        [self.mArr addObject:deviceMacStr];
        
    }
    
    if (_SDKDeviceType==HealthDeviceType_NT13B) {
        
        [self.mArr addObject:dic[@"ID"]];
        
    }
    
    [self.myTable reloadData];
}

- (void)DeviceConnect:(NSNotification *)noti{
    
    if ([self.navigationController.topViewController isEqual:self]) {
        NSString *deviceId = noti.userInfo[@"SerialNumber"];
        NSString *deviceName = noti.userInfo[@"DeviceName"];
        if (self.selectedDeviceId && [self.selectedDeviceId isEqualToString:deviceId]) {
            [self showSuccessToastWithText:@"Connect Success"];
            
            if ([deviceName isEqualToString:@"AM6"]) {
                DeviceAM6HomeVC *vc = [DeviceAM6HomeVC new];
                vc.deviceId = deviceId;
                [self.navigationController pushViewController:vc animated:YES];
            }else if ([deviceName containsString:@"550BT"]) {
                DeviceKN550BTVC *vc = [DeviceKN550BTVC new];
                vc.deviceId = deviceId;
                [self.navigationController pushViewController:vc animated:YES];
            }else if ([deviceName containsString:@"BP5S"] ||[deviceName containsString:@"BP5C"]) {
                DeviceBP5SVC *vc = [DeviceBP5SVC new];
                vc.deviceId = deviceId;
                [self.navigationController pushViewController:vc animated:YES];
            }else if ([deviceName containsString:@"BG5S"]) {
                DeviceBG5SVC *vc = [DeviceBG5SVC new];
                vc.deviceId = deviceId;
                [self.navigationController pushViewController:vc animated:YES];
            }else if ([deviceName containsString:@"PO3"]) {
                DevicePO3VC *vc = [DevicePO3VC new];
                vc.deviceId = deviceId;
                [self.navigationController pushViewController:vc animated:YES];
            }else if ([deviceName containsString:@"PO1"]) {
                DevicePO1VC *vc = [DevicePO1VC new];
                vc.deviceId = deviceId;
                [self.navigationController pushViewController:vc animated:YES];
            }else if ([deviceName containsString:@"BG1A"]) {
                DeviceBG1AVC *vc = [DeviceBG1AVC new];
                vc.deviceId = deviceId;
                [self.navigationController pushViewController:vc animated:YES];
            }else if ([deviceName containsString:@"BG1S"]) {
                DeviceBG1SVC *vc = [DeviceBG1SVC new];
                vc.deviceId = deviceId;
                [self.navigationController pushViewController:vc animated:YES];
            }else if ([deviceName containsString:@"BP3L"]) {
                DeviceBP3LVC *vc = [DeviceBP3LVC new];
                vc.deviceId = deviceId;
                [self.navigationController pushViewController:vc animated:YES];
            }else if ([deviceName isEqualToString:@"HS2S"]) {
                DeviceHS2SVC *vc = [DeviceHS2SVC new];
                vc.deviceId = deviceId;
                [self.navigationController pushViewController:vc animated:YES];
            }else if ([deviceName containsString:@"PT3SBT"]) {
                DevicePT3SBTVC *vc = [DevicePT3SBTVC new];
                vc.deviceId = deviceId;
                [self.navigationController pushViewController:vc animated:YES];
            }else if ([deviceName containsString:@"BP7S"]) {
                DeviceBP7SVC *vc = [DeviceBP7SVC new];
                vc.deviceId = deviceId;
                [self.navigationController pushViewController:vc animated:YES];
            }else if ([deviceName isEqualToString:@"HS2S Pro"]) {
                DeviceHS2SProVC *vc = [DeviceHS2SProVC new];
                vc.deviceId = deviceId;
                [self.navigationController pushViewController:vc animated:YES];
            }

        }
    }
}

- (void)DeviceConnectFail:(NSNotification *)noti{
    
    [self hideLoadingTips];
    
    NSLog(@"DeviceConnectFail:%@",[noti userInfo]);
    
    [self showFailToastWithText:@"Connect Fail"];
}

- (void)DeviceDisConnect:(NSNotification *)noti{
    [self showFailToastWithText:@"Disconnect"];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.mArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    IHSDKBaseCell *cell = [IHSDKBaseCell settingCell];
    cell.textLabel.text = self.mArr.allObjects[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString *deviceId = self.mArr.allObjects[indexPath.row];
    
    self.selectedDeviceId = deviceId;
    
    [[ScanDeviceController commandGetInstance] commandStopScanDeviceType:self.SDKDeviceType];
    
    [[ConnectDeviceController commandGetInstance] commandContectDeviceWithDeviceType:self.SDKDeviceType andSerialNub:self.selectedDeviceId];
    [self showLoadingTipsWithText:@"Connecting..."];
    
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
