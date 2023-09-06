//
//  DevicePO3VC.m
//  iHealthDemoCode
//
//  Created by Spring on 2023/7/28.
//  Copyright © 2023 iHealth Demo Code. All rights reserved.
//

#import "DevicePO3VC.h"

#import "IHSDKDemoTableView.h"
#import "POHeader.h"
#import "ScanDeviceController.h"

@interface DevicePO3VC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) NSMutableSet *mArr;
@property (strong, nonatomic) NSMutableArray *items;
@property (strong, nonatomic) IHSDKDemoTableView *myTable;
@property (copy, nonatomic) NSString *selectedDeviceId;
@property (weak, nonatomic) PO3 *device;
@property (strong, nonatomic) UITextView *logTextView;
@property (nonatomic) BOOL isShowLog;

@end

@implementation DevicePO3VC
- (void)dealloc
{
    NSLog(@"%@ dealloc",self);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSArray*deviceArray=[[PO3Controller shareIHPO3Controller] getAllCurrentPO3Instace];
    
    for(PO3 *device in deviceArray){
        
        if([self.deviceId isEqualToString:device.serialNumber]){
            
            self.device=device;
            
        }
    }
    
    if (self.device==nil) {
        
        [IHSDKDemoToast showTipWithTitle:@"Device Not Connected"];
        
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(DeviceDisConnectForPO3:) name:PO3DisConnectNoti object:nil];
    
    self.rightBarButtonItemStyle = IHSDKRightBarButtonItemStyleText;
    self.rightBarButtonTitle = @"Log";
    
    [self.logTextView setHidden:YES];
    
    _isShowLog=NO;
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(ChargeState:) name:@"PO3NotificationChargeState" object:nil];
}

- (void)rightBarButtonDidPressed:(id)sender{
    
    if (_isShowLog) {
        _isShowLog=NO;
        [self.logTextView setHidden:YES];
    }else{
        
        _isShowLog=YES;
        
        [self.logTextView setHidden:NO];
    }
    
}

-(void)ChargeState:(NSNotification*)info {
    
    
    NSLog(@"ChargeState:%@",[info userInfo]);
    
    [IHSDKDemoToast showTipWithTitle:[NSString stringWithFormat:@"ChargeState:%@",[info userInfo]]];
    
}

-(void)DeviceDisConnectForPO3:(NSNotification*)info {
    
    
    NSLog(@"DeviceDisConnectForPO3:%@",[info userInfo]);
    
}

- (void)printLog:(NSString *)log title:(NSString *)title{
    
//    self.myTextView.text = [NSString stringWithFormat:@"%@\n%@\n%@",self.myTextView.text,title,log];
    
    self.logTextView.text = [NSString stringWithFormat:@"%@\n%@",title,log];

    
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
    [self.device commandPO3Disconnect:^(BOOL resetSuc) {
        
    } withErrorBlock:^(PO3ErrorID errorID) {
        
    }];
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
    [self.items addObject:@{@"t":@"SyncTime",@"cb":^{
//        [weakSelf showLoading];
        
        [weakSelf.device commandPO3SyncTime:^(BOOL resetSuc) {
            
            [weakSelf hideLoading];
            
        } withErrorBlock:^(PO3ErrorID errorID) {
            
            NSLog(@"PO3ErrorID:%lu",(unsigned long)errorID);
            
            [weakSelf hideLoading];
            
        }];
        
    }}];
    [self.items addObject:@{@"t":@"Measure",@"cb":^{
//        [weakSelf showLoading];
        
        [weakSelf.device commandPO3StartMeasure:^(BOOL resetSuc) {
            
            [weakSelf hideLoading];
            
            NSLog(@"resetSuc:%d",resetSuc);
            
        } withMeasureData:^(NSDictionary *measureDataDic) {
            [weakSelf hideLoading];
            
            NSLog(@"measureDataDic:%@",measureDataDic);
            
        } withFinishMeasure:^(BOOL finishData) {
            
            NSLog(@"finishData:%d",finishData);
            
        } withErrorBlock:^(PO3ErrorID errorID) {
            
            [weakSelf hideLoading];
            
            NSLog(@"PO3ErrorID:%lu",(unsigned long)errorID);
            
        }];
        
    }}];
    [self.items addObject:@{@"t":@"OfflineData",@"cb":^{
//        [weakSelf showLoading];
        
        [weakSelf.device commandPO3OfflineDataCount:^(NSNumber *dataCount) {
            
            [weakSelf hideLoading];
            
            NSLog(@"dataCount:%@",dataCount);
            
        } withOfflineData:^(NSDictionary *OfflineData) {
            
        } withOfflineWaveData:^(NSDictionary *offlineWaveDataDic) {
            
            NSLog(@"offlineWaveDataDic:%@",offlineWaveDataDic);
            
        } withFinishMeasure:^(BOOL resetSuc) {
            
            NSLog(@"resetSuc:%d",resetSuc);
            
        } withErrorBlock:^(PO3ErrorID errorID) {
            
            [weakSelf hideLoading];
            
            NSLog(@"PO3ErrorID:%lu",(unsigned long)errorID);
            
        }];
        
    }}];
    
    [self.items addObject:@{@"t":@"Battery",@"cb":^{
//        [weakSelf showLoading];
        
        [weakSelf.device commandPO3GetDeviceBattery:^(NSNumber *battery) {
            
            [weakSelf hideLoading];
            
        } withErrorBlock:^(PO3ErrorID errorID) {
            
            [weakSelf hideLoading];
            
            NSLog(@"BatteryPO3ErrorID:%lu",(unsigned long)errorID);
            
        }];
        
    }}];
    
    
    [self.items addObject:@{@"t":@"ChargeState",@"cb":^{
//        [weakSelf showLoading];
        
        [weakSelf.device commandPO3GetChargeState:^(PO3ChargeState state) {
            
            [weakSelf hideLoading];
            
            NSLog(@"PO3ChargeState：%@",(state == PO3ChargeState_Charging)?@"charging":@"ExitCharging");
            
            [IHSDKDemoToast showTipWithTitle:[NSString stringWithFormat:@"PO3ChargeState：%@",(state == PO3ChargeState_Charging)?@"charging":@"ExitCharging"]];
            
        } withErrorBlock:^(PO3ErrorID errorID) {
            
            [weakSelf hideLoading];
            
            NSLog(@"ChargeStatePO3ErrorID:%lu",(unsigned long)errorID);
            
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

@end
