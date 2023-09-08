//
//  DeviceAM6NotificationVC.m
//  iHealthDemoCode
//
//  Created by Spring on 2023/4/18.
//  Copyright © 2023 iHealth Demo Code. All rights reserved.
//
#import "IHSDKDemoTableView.h"
#import "AMMacroFile.h"
#import "AMHeader.h"
#import "DeviceAM6NotificationVC.h"

@interface DeviceAM6NotificationVC ()<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) NSMutableArray *items;
@property (strong, nonatomic) IHSDKDemoTableView *myTable;
@property (weak, nonatomic) AM6 *device;

@end

@implementation DeviceAM6NotificationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)setupInterface{
    self.title = self.deviceId;
    [self loadItems];
    [self.myTable addToView:self.view];
}
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
        _myTable.dataSource = self;
        _myTable.delegate = self;
    }
    return _myTable;
}

- (void)loadItems{
    self.items = [NSMutableArray new];
    __weak typeof(self) weakSelf = self;
    [self.items addObject:@{@"t":@"Set Platform: iOS",@"cb":^{
        [weakSelf showLoading];
        
        [self.device setPlatformWithSuccess:^{
            [weakSelf hideLoading];
            [weakSelf showTopToast:@"Success"];
        } fail:^(int error) {
            [weakSelf hideLoading];

        }];
    }}];
    [self.items addObject:@{@"t":@"Query Notification Status",@"cb":^{
        [weakSelf showLoading];
        
        [self.device queryNotificationStateWithSuccess:^{
            [weakSelf hideLoading];
            [weakSelf showTopToast:[NSString stringWithFormat:@"Status: %d",self.device.notificationEnable]];
        } fail:^(int error) {
            [weakSelf hideLoading];
        }];
        
    }}];
    
    [self.items addObject:@{@"t":@"Set Notification On",@"cb":^{
        [weakSelf showLoading];
        
        [self.device setNotificationStatus:YES success:^{
            [weakSelf hideLoading];
            [weakSelf showTopToast:@"Success"];
        } fail:^(int error) {
            [weakSelf hideLoading];
            
        }];
    }}];
    [self.items addObject:@{@"t":@"Set Notification Off",@"cb":^{
        [weakSelf showLoading];
        
        [self.device setNotificationStatus:NO success:^{
            [weakSelf hideLoading];
            [weakSelf showTopToast:@"Success"];
        } fail:^(int error) {
            [weakSelf hideLoading];
            
        }];
    }}];
    
    [self.items addObject:@{@"t":@"ANCS Status (iOS13+)",@"cb":^{
        
        if (@available(iOS 13, *)) {
            BOOL flag = [self.device queryAncsAuthorizedStatus];
            
            [weakSelf showTopToast:[NSString stringWithFormat:@"Success:%d",flag]];
           
        } else {
            [weakSelf showTopToast:@"Not Support with your iOS version"];
        }
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
