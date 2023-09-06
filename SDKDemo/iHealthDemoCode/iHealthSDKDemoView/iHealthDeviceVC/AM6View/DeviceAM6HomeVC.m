//
//  DeviceAM6HomeVC.m
//  iHealthDemoCode
//
//  Created by Spring on 2023/4/18.
//  Copyright © 2023 iHealth Demo Code. All rights reserved.
//

#import "DeviceAM6HomeVC.h"
#import "IHSDKDemoTableView.h"
#import "DeviceAM6BindVC.h"
#import "DeviceAM6NotificationVC.h"
#import "DeviceAM6GeneralControlVC.h"
#import "DeviceAM6DataVC.h"
#import "DeviceAM6FindDeviceVC.h"
#import "AMMacroFile.h"
#import "AMHeader.h"

#import "DeviceAM6FindPhoneUtils.h"

/* Notification */
#define kiHealthSDKAddNoti(obj,notiName,sel) [NSNotificationCenter.defaultCenter addObserver:obj selector:(sel) name:(notiName) object:nil]

@interface DeviceAM6HomeVC ()<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) NSMutableArray *items;
@property (strong, nonatomic) IHSDKDemoTableView *myTable;
@property (weak, nonatomic) AM6 *device;
@property (strong, nonatomic) UITextView *myTextView;

@property (strong, nonatomic) UITextField *deviceIdInputTextField;
@property (strong, nonatomic) UITextField *keyInputTextField;
@property (strong, nonatomic) UITextField *timeTextField;

@property (strong, nonatomic) UITextField *device_id;

@property (strong, nonatomic) UITextField *device_key;

@end

@implementation DeviceAM6HomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (void)setupInterface{
    self.title = self.deviceId;
    [self loadItems];
    [self.myTable addToView:self.view];

    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(am6StartFindPhoneNoti:) name:@"AM6StartFindPhoneNoti" object:nil];
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(am6StopFindPhoneNoti:) name:@"AM6StopFindPhoneNoti" object:nil];
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(handleAppWillTerminate) name:UIApplicationWillTerminateNotification object:nil];
    
    kiHealthSDKAddNoti(self, AM6DisConnectNoti, @selector(DeviceDisConnect:));
}
- (void)leftBarButtonDidPressed:(id)sender{
    [self.device commandAM6Disconnect:^{
        [super leftBarButtonDidPressed:sender];
    } fail:^(int error) {
        
    }];
    
}


- (void)DeviceDisConnect:(NSNotification *)noti{
    
    NSLog(@"DeviceDisConnect:%@",[noti userInfo]);
    
    [self showFailToastWithText:@"Disconnect"];
}

- (void)showTextView:(NSString*)text{
    if (!_myTextView) {
        _myTextView = [UITextView new];
        _myTextView.font = IHSDK_FONT_Regular(16);
        [self.view addSubview:_myTextView];
        [_myTextView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(self.view);
            make.left.mas_equalTo(self.view).offset(20);
            if (@available(iOS 11.0, *)) {
                make.top.mas_equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(60);
            } else {
                // Fallback on earlier versions
            }
        }];
    }
    _myTextView.text = text;
    _myTextView.hidden = NO;
}
- (void)hideTextView{
    _myTextView.hidden = YES;
}
#pragma mark -
- (AM6 *)device{
    if (!_device) {
        NSArray*deviceArray=[[AM6Controller shareAM6Controller] getAllCurrentAM6Instace];
        
        for(AM6 *am6 in deviceArray){
            
            if([self.deviceId isEqualToString:am6.serialNumber]){
                
                _device=am6;
                
            }
        }
    }
    __weak typeof(self) weakSelf = self;
    if (_device==nil) {
        
        [IHSDKDemoToast showTipWithTitle:@"Device Not Connected"];
            
        [weakSelf hideLoading];
            
        [weakSelf.navigationController popViewControllerAnimated:YES];
    
    }
    return _device;
}
- (IHSDKDemoTableView *)myTable{
    if (!_myTable) {
        _myTable = [IHSDKDemoTableView groupedTable];
        _myTable.rowHeight = 50;
        _myTable.dataSource = self;
        _myTable.delegate = self;
    }
    return _myTable;
}

- (void)loadItems{
    self.items = [NSMutableArray new];
    __weak typeof(self) weakSelf = self;
    [self.items addObject:@{@"t":@"Query Device Info",@"cb":^{
        [weakSelf showLoading];
        [self.device queryDeviceInfoAndSyncTimeWithSuccess:^{
            
            [weakSelf hideLoading];
            
            NSString *str = [NSString stringWithFormat:@"Battery:%d(%@)\nHardware:%@\nSDK:%@\nFirmware:%@\nBind:%@\n",self.device.battery,self.device.isCharging?@"Charging":@"not in charging",self.device.hardwareVersion,self.device.sdkFirmwareVersion,self.device.firmwareVersion,self.device.bindStatus?@"YES":@"NO"];
            
            [IHSDKDemoToast showTipWithTitle:[NSString stringWithFormat:@"deviveInfo:\n%@",str]];
            
        } fail:^(int error) {
            [weakSelf hideLoading];
        }];
        
    }}];
    [self.items addObject:@{@"t":@"Query Device Time",@"cb":^{
        [weakSelf showLoading];
        
        [self.device queryDeviceTimeWithSuccess:^{
            [weakSelf hideLoading];
            
            NSString *timestr = [NSString stringWithFormat:@"%@\n12-hour format:%@",self.device.deviceTime,self.device.is12HoursFormat?@"Yes":@"No"];
            
            NSString *str = [NSString stringWithFormat:@"deviveTime:\n%@",timestr];

            [IHSDKDemoToast showTipWithTitle:str];
        } fail:^(int error) {
            [weakSelf hideLoading];
        }];
        
        
    }}];
    
    [self.items addObject:@{@"t":@"Bind Control",@"cb":^{
        DeviceAM6BindVC *vc = [DeviceAM6BindVC new];
        vc.deviceId = weakSelf.deviceId;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }}];
    
    [self.items addObject:@{@"t":@"Notification Control",@"cb":^{
        DeviceAM6NotificationVC *vc = [DeviceAM6NotificationVC new];
        vc.deviceId = weakSelf.deviceId;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }}];
    
    [self.items addObject:@{@"t":@"Data Sync",@"cb":^{
        DeviceAM6DataVC *vc = [DeviceAM6DataVC new];
        vc.deviceId = weakSelf.deviceId;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }}];
    [self.items addObject:@{@"t":@"General Control",@"cb":^{
        DeviceAM6GeneralControlVC *vc = [DeviceAM6GeneralControlVC new];
        vc.deviceId = weakSelf.deviceId;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }}];
    
    [self.items addObject:@{@"t":@"Find Watch",@"cb":^{
        DeviceAM6FindDeviceVC *vc = [DeviceAM6FindDeviceVC new];
        vc.deviceId = weakSelf.deviceId;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }}];
    [self.items addObject:@{@"t":@"Reboot Device",@"cb":^{
        [weakSelf showLoading];
        [weakSelf.device rebootDeviceWithSuccess:^{
            [weakSelf hideLoading];
            [weakSelf showTopToast:@"Success"];
        } fail:^(int error) {
            [weakSelf hideLoading];
        }];
    }}];
    
    
}
#pragma mark -
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.items.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    IHSDKBaseCell *cell = [IHSDKBaseCell settingCell];
    NSDictionary *dic = self.items[indexPath.row];
    cell.textLabel.text = dic[@"t"];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *dic = self.items[indexPath.row];
    dispatch_block_t cb = dic[@"cb"];
    if (cb) {
        cb();
    }
}
#pragma mark -
- (void)handleAppWillTerminate{
    NSLog(@"app will terminated");
//    [self.device sendAppIsTerminateMessage];
}

- (void)am6StartFindPhoneNoti:(NSNotification *)noti{
  
    [[DeviceAM6FindPhoneUtils shareInstance]play];
}

- (void)am6StopFindPhoneNoti:(NSNotification *)noti{
    [[DeviceAM6FindPhoneUtils shareInstance]stop];
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
