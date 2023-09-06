//
//  DeviceAm6GeneralControlVC.m
//  iHealthDemoCode
//
//  Created by Spring on 2023/4/18.
//  Copyright © 2023 iHealth Demo Code. All rights reserved.
//

#import "DeviceAM6GeneralControlVC.h"
#import "AMMacroFile.h"
#import "AMHeader.h"
#import "IHSDKDemoTableView.h"
#import <MJExtension.h>

#import "DeviceAM6AlarmVC.h"

#import "DeviceAM6Settings.h"

@interface DeviceAM6GeneralControlVC ()<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) NSMutableArray *items;
@property (strong, nonatomic) IHSDKDemoTableView *myTable;
@property (weak, nonatomic) AM6 *device;

@property (strong, nonatomic) UITextField *stepsTextField;

@property (strong, nonatomic) UITextField *caloriesTextField;

@end

@implementation DeviceAM6GeneralControlVC

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
   
    [self.items addObject:@{@"t":@"Activity Goal",@"cb":^{
        DeviceAM6Settings *vc = [[DeviceAM6Settings alloc]initWithSettingsType:AM6SettingsType_ActivityGoal deviceId:self.deviceId];
        [weakSelf.navigationController pushViewController:vc animated:YES];

    }}];
    [self.items addObject:@{@"t":@"Stretch Reminder",@"cb":^{
        DeviceAM6Settings *vc = [[DeviceAM6Settings alloc]initWithSettingsType:AM6SettingsType_Stretch deviceId:self.deviceId];
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }}];
    [self.items addObject:@{@"t":@"Raise to Wake",@"cb":^{
        DeviceAM6Settings *vc = [[DeviceAM6Settings alloc]initWithSettingsType:AM6SettingsType_RasieToWake deviceId:self.deviceId];
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }}];
    
    [self.items addObject:@{@"t":@"Do Not Disturb",@"cb":^{
        DeviceAM6Settings *vc = [[DeviceAM6Settings alloc]initWithSettingsType:AM6SettingsType_NotDisturb deviceId:self.deviceId];
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }}];
    
    [self.items addObject:@{@"t":@"Query Wrist Hand",@"cb":^{
        
        [self.device queryWearHandWithSuccess:^{
            [weakSelf hideLoading];
            [weakSelf showTopToast:[NSString stringWithFormat:@"wristHand: %ld",weakSelf.device.wristHand]];
        } fail:^(int error) {
            [weakSelf hideLoading];
        }];
        
    }}];
    
    [self.items addObject:@{@"t":@"Set Wrist Hand",@"cb":^{
        UIAlertController *vc = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Set Wrist Hand", @"") message:@"" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:NSLocalizedString(@"Left", @"") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [self.device setWearHand:0x00 success:^{
                
                [self showTopToast:@"success"];
                
            } fail:^(int error) {
                
                [weakSelf hideLoading];
            }];
            
        }];
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:NSLocalizedString(@"Right", @"") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [self.device setWearHand:0x01 success:^{
                
                [self showTopToast:@"success"];
                
            } fail:^(int error) {
                [weakSelf hideLoading];
            }];
            
        }];
        UIAlertAction *action2 = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", @"") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        [vc addAction:action];
        [vc addAction:action1];
        [vc addAction:action2];
        [self presentViewController:vc animated:YES completion:nil];
    }}];
   
    [self.items addObject:@{@"t":@"Alarm",@"cb":^{
        DeviceAM6AlarmVC *vc = [[DeviceAM6AlarmVC alloc]init];
        vc.deviceId = weakSelf.deviceId;
        [weakSelf.navigationController pushViewController:vc animated:YES];
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
