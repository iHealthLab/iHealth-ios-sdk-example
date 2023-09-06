//
//  IHSDKDeviceListVC.m
//  iHealthDemoCode
//
//  Created by Spring on 2023/5/31.
//  Copyright © 2023 iHealth Demo Code. All rights reserved.
//

#import "IHSDKDeviceListVC.h"
#import "IHSDKDemoTableView.h"

#import "BPHeader.h"
#import "AMMacroFile.h"
#import "AMHeader.h"

#import "IHSDKBG1AHomeTabBarController.h"

/* Notification */
#define kiHealthSDKAddNoti(obj,notiName,sel) [NSNotificationCenter.defaultCenter addObserver:obj selector:(sel) name:(notiName) object:nil]
#define kiHealthSDKRemNoti(obj,notiName) [NSNotificationCenter.defaultCenter removeObserver:obj name:(notiName) object:nil]
#define kiHealthSDKRemAllNoti(obj) [NSNotificationCenter.defaultCenter removeObserver:obj]



@interface IHSDKDeviceListVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) NSMutableSet *mArr;
@property (strong, nonatomic) IHSDKDemoTableView *myTable;
@property (copy, nonatomic) NSString *selectedDeviceId;


@end

@implementation IHSDKDeviceListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupInterface];
    // Do any additional setup after loading the view.
}
- (void)setupInterface{
    
    self.mArr = [NSMutableSet new];
//    [self.mArr addObject:@"test device"];
    self.myTable = [IHSDKDemoTableView groupedTable];
    self.myTable.delegate = self;
    self.myTable.dataSource = self;
    [self.myTable addToView:self.view];
    
    self.vcTitle=NSLocalizedString(@"Devices list", @"");
    
    [self.view setBackgroundColor:[UIColor colorWithHexString:@"#F0F4F7"]];
    
//    kiHealthSDKAddNoti(self, KN550BTDiscover, @selector(DeviceDiscover:));
//    kiHealthSDKAddNoti(self, KN550BTConnectNoti, @selector(DeviceConnect:));
//    kiHealthSDKAddNoti(self, KN550BTConnectFailed, @selector(DeviceConnectFail:));
//    kiHealthSDKAddNoti(self, KN550BTDisConnectNoti, @selector(DeviceDisConnect:));
//
//    [KN550BTController shareKN550BTController];


    kiHealthSDKAddNoti(self, BG1ADiscover, @selector(DeviceDiscover:));
    kiHealthSDKAddNoti(self, BG1AConnectNoti, @selector(DeviceConnect:));
    kiHealthSDKAddNoti(self, BG1AConnectFailed, @selector(DeviceConnectFail:));
    kiHealthSDKAddNoti(self, BG1ADisConnectNoti, @selector(DeviceDisConnect:));
    [BG1AController shareIHBG1AController];
  
    
   
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [[ScanDeviceController commandGetInstance] commandScanDeviceType:HealthDeviceType_BG1A];
}
- (void)viewWillDisappear:(BOOL)animated{
    [[ScanDeviceController commandGetInstance] commandStopScanDeviceType:HealthDeviceType_BG1A];
}
- (void)DeviceDiscover:(NSNotification*)tempNoti{

    NSDictionary *dic = [tempNoti userInfo];
    
     NSString*deviceMacStr=[NSString stringWithFormat:@"%@",[dic objectForKey:@"SerialNumber"]];
    
    if (![self.mArr containsObject:deviceMacStr] && deviceMacStr!=nil) {
       
        
        [self.mArr addObject:deviceMacStr];
        
    }
    
    [self.myTable reloadData];
}


- (void)handleDeviceConnectFail:(NSNotification *)noti{
    [IHSDKDemoToast showTipWithTitle:@"Connect Fail"];
}

- (void)DeviceConnect:(NSNotification *)noti{
    
    if ([self.navigationController.topViewController isEqual:self]) {
        NSString *deviceId = noti.userInfo[@"SerialNumber"];
        NSString *deviceName = noti.userInfo[@"DeviceName"];
        if (self.selectedDeviceId && [self.selectedDeviceId isEqualToString:deviceId]) {
            [IHSDKDemoToast showTipWithTitle:@"Connect Success"];
            
            
            if ([deviceName isEqualToString:@"AM6"]) {
//                DeviceAM6HomeVC *vc = [DeviceAM6HomeVC new];
//                vc.deviceId = deviceId;
//                [self.navigationController pushViewController:vc animated:YES];
            }else if ([deviceName containsString:@"550BT"]) {
//                DeviceKN550BTVC *vc = [DeviceKN550BTVC new];
//                vc.deviceId = deviceId;
//                [self.navigationController pushViewController:vc animated:YES];
            }else if ([deviceName containsString:@"AM5"]) {
//                DeviceAM5VC *vc = [DeviceAM5VC new];
//                vc.deviceId = deviceId;
//                [self.navigationController pushViewController:vc animated:YES];
            }else if ([deviceName containsString:@"BG1A"]) {
                
//                IHSDKBG1AHomeTabBarController*vc=[[IHSDKBG1AHomeTabBarController alloc] init];
//                vc.deviceMac=[deviceId copy];
//                [self.navigationController pushViewController:vc animated:YES];

            }
            
//            DeviceHomeVC *vc = [DeviceHomeVC new];
//            vc.deviceId = deviceId;
//            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

- (void)DeviceConnectFail:(NSNotification *)noti{
    [IHSDKDemoToast showTipWithTitle:@"Connect Fail"];
}

- (void)DeviceDisConnect:(NSNotification *)noti{
    [IHSDKDemoToast showTipWithTitle:[NSString stringWithFormat:@"Device (%@) disconnect",noti.userInfo[IDPS_SerialNumber]]];
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
    
//    [[ScanDeviceController commandGetInstance] commandStopScanDeviceType:HealthDeviceType_BG1A];
//
//    [[ConnectDeviceController commandGetInstance] commandContectDeviceWithDeviceType:HealthDeviceType_BG1A andSerialNub:self.selectedDeviceId];
//    [IHSDKDemoToast showTipWithTitle:@"Connecting..."];
    
    IHSDKBG1AHomeTabBarController*vc=[[IHSDKBG1AHomeTabBarController alloc] init];
    vc.deviceMac=[deviceId copy];

    [self.navigationController pushViewController:vc animated:YES];
    
}


@end
