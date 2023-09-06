//
//  DevicePO1VC.m
//  iHealthDemoCode
//
//  Created by Spring on 2023/8/9.
//  Copyright © 2023 iHealth Demo Code. All rights reserved.
//

#import "DevicePO1VC.h"

#import "IHSDKDemoTableView.h"
#import "POHeader.h"
#import "ScanDeviceController.h"

@interface DevicePO1VC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) NSMutableSet *mArr;
@property (strong, nonatomic) NSMutableArray *items;
@property (strong, nonatomic) IHSDKDemoTableView *myTable;
@property (copy, nonatomic) NSString *selectedDeviceId;
@property (strong, nonatomic) PO1 *device;
@property (strong, nonatomic) UITextView *logTextView;

@end

@implementation DevicePO1VC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSArray*deviceArray=[[PO1Controller shareIHPO1Controller] getAllCurrentPO1Instace];
    
    for(PO1 *device in deviceArray){
        
        if([self.deviceId isEqualToString:device.serialNumber]){
            
            self.device=device;
            
        }
    }
    
    if (self.device==nil) {
        
        [IHSDKDemoToast showTipWithTitle:@"Device Not Connected"];
        
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(DeviceDisConnectForPO1:) name:PO1DisConnectNoti object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(devicePO1Measure:) name:@"PO1NotificationMeasureData" object:nil];
    
    [self.logTextView setHidden:YES];
}


-(void)DeviceDisConnectForPO1:(NSNotification*)info {
    
    
    NSLog(@"DeviceDisConnectForPO1:%@",[info userInfo]);
    
}

-(void)devicePO1Measure:(NSNotification *)tempNoti{
 
    NSDictionary*deviceDic= [tempNoti userInfo];
    
    NSLog(@"devicePO1Measure:%@",deviceDic);
    
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
    [self.items addObject:@{@"t":@"GetDeviceBattery",@"cb":^{
        
        [self.device commandPO1GetDeviceBattery:^(NSNumber *battery) {
            
            [IHSDKDemoToast showTipWithTitle:[NSString stringWithFormat:@"battery:%@",battery]];
            
        } withErrorBlock:^(PO1ErrorID errorID) {
            
            [IHSDKDemoToast showTipWithTitle:[NSString stringWithFormat:@"PO1ErrorID:%d",errorID]];
            
        }];
        
    }}];
    
    [self.items addObject:@{@"t":@"Function",@"cb":^{
        
        [self.device commandFunction:^(NSDictionary *functionDict) {
            
        } DisposeErrorBlock:^(PO1ErrorID errorID) {
            
            [IHSDKDemoToast showTipWithTitle:[NSString stringWithFormat:@"PO1ErrorID:%d",errorID]];
            
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
