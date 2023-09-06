//
//  DeviceBG1AVC.m
//  iHealthDemoCode
//
//  Created by Spring on 2023/8/11.
//  Copyright © 2023 iHealth Demo Code. All rights reserved.
//

#import "DeviceBG1AVC.h"

#import "IHSDKDemoTableView.h"
#import "BGHeader.h"
#import "ScanDeviceController.h"

@interface DeviceBG1AVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) NSMutableSet *mArr;
@property (strong, nonatomic) NSMutableArray *items;
@property (strong, nonatomic) IHSDKDemoTableView *myTable;
@property (copy, nonatomic) NSString *selectedDeviceId;
@property (strong, nonatomic) BG1A *device;
@property (strong, nonatomic) UITextView *logTextView;

@end

@implementation DeviceBG1AVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSArray*deviceArray=[[BG1AController shareIHBG1AController] getAllCurrentBG1AInstace];
    
    for(BG1A *device in deviceArray){
        
        if([self.deviceId isEqualToString:device.serialNumber]){
            
            self.device=device;
            
        }
    }
    
    if (self.device==nil) {
        
        [IHSDKDemoToast showTipWithTitle:@"Device Not Connected"];
        
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(DeviceDisConnectForBG1A:) name:BG1ADisConnectNoti object:nil];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(devicePO1Measure:) name:@"PO1NotificationMeasureData" object:nil];
    
    [self.logTextView setHidden:YES];
}


-(void)DeviceDisConnectForBG1A:(NSNotification*)info {
    
    
    NSLog(@"DeviceDisConnectForBG1A:%@",[info userInfo]);
    
}



- (void)setupInterface{
    self.title = self.deviceId;
    [self loadItems];
    [self.myTable addToView:self.view];
    
    [self.view addSubview:self.logTextView];
        
    [self.logTextView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.view).offset(self.navigationController.navigationBar.bounds.size.height + CTScaleByWidth(44));
            make.left.mas_equalTo(self.view);
            make.right.mas_equalTo(self.view);
            make.bottom.mas_equalTo(self.view).offset(30);
        }];
    
}
- (void)leftBarButtonDidPressed:(id)sender{
    [self.device commandDisconnectDevice];
    [super leftBarButtonDidPressed:sender];
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

- (UITextView *)logTextView{
    if (_logTextView == nil) {
        _logTextView = [[UITextView alloc]init];
        _logTextView.textColor = [UIColor blackColor];
        _logTextView.selectable = NO;
        _logTextView.editable = NO;
        _logTextView.showsVerticalScrollIndicator = YES;
    }
    return _logTextView;
}

- (void)loadItems{
    self.items = [NSMutableArray new];
    __weak typeof(self) weakSelf = self;
    [self.items addObject:@{@"t":@"GetDeviceInfo",@"cb":^{

        [self.device commandGetDeviceInfo:^{
        
            NSString *str = [NSString stringWithFormat:@"Battery:%d\nhasHistoryResult:%d\ndeviceTS:%@\nprotocol:%@\naccessoryName:%@\nfirmwareVersion:%@\nhardwareVersion:%@\nmanufaturer:%@\nmodelNumber:%@\n",weakSelf.device.battery,weakSelf.device.hasHistoryResult,weakSelf.device.deviceTS,weakSelf.device.protocol,weakSelf.device.accessoryName,weakSelf.device.firmwareVersion,weakSelf.device.hardwareVersion,weakSelf.device.manufaturer,weakSelf.device.modelNumber];
            
            [IHSDKDemoToast showTipWithTitle:[NSString stringWithFormat:@"deviveInfo:\n%@",str]];
            
        } fail:^(BG1ADeviceError error) {
            
            [IHSDKDemoToast showTipWithTitle:[NSString stringWithFormat:@"BG1ADeviceError:%d",error]];
            
        }];

    }}];

    [self.items addObject:@{@"t":@"SetMeasureType",@"cb":^{

        [self.device commandSetMeasureType:BG1AMeasureType_BloodSugar success:^{
            
        } fail:^(BG1ADeviceError error) {
            
        }];

    }}];
    
    [self.items addObject:@{@"t":@"SyncTime",@"cb":^{

        [self.device commandSyncTime:^{
            
        } fail:^(BG1ADeviceError error) {
            
        }];

    }}];

    [self.items addObject:@{@"t":@"SyncHistory",@"cb":^{

        [self.device commandSyncHistory:^(NSArray * _Nullable historyArray) {
            
            
            [IHSDKDemoToast showTipWithTitle:[NSString stringWithFormat:@"History:\n%@",historyArray]];
            
        } fail:^(BG1ADeviceError error) {
            
        }];

    }}];
    
    [self.items addObject:@{@"t":@"DeleteHistory",@"cb":^{

        [self.device commandDeleteHistory:^{
            
            [IHSDKDemoToast showTipWithTitle:[NSString stringWithFormat:@"DeleteHistory Sucess"]];
            
        } fail:^(BG1ADeviceError error) {
            
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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
