//
//  DeviceBG5SVC.m
//  iHealthDemoCode
//
//  Created by Spring on 2023/6/30.
//  Copyright © 2023 iHealth Demo Code. All rights reserved.
//

#import "DeviceBG5SVC.h"

#import "IHSDKDemoTableView.h"
#import "BGHeader.h"
#import "ScanDeviceController.h"

@interface DeviceBG5SVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) NSMutableSet *mArr;
@property (strong, nonatomic) NSMutableArray *items;
@property (strong, nonatomic) IHSDKDemoTableView *myTable;
@property (copy, nonatomic) NSString *selectedDeviceId;
@property (strong, nonatomic) BG5S *device;
@property (strong, nonatomic) UITextView *logTextView;
@property (nonatomic) BOOL isShowLog;

@end

@implementation DeviceBG5SVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSArray*deviceArray=[[BG5SController sharedController] getAllCurrentInstace];
    
    for(BG5S *device in deviceArray){
        
        if([self.deviceId isEqualToString:device.serialNumber]){
            
            self.device=device;
            
        }
    }
    
    if (self.device==nil) {
        
        [IHSDKDemoToast showTipWithTitle:@"Device Not Connected"];
        
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(DeviceDisConnectForBG5S:) name:kNotificationNameBG5SDidDisConnect object:nil];
    
    self.rightBarButtonItemStyle = IHSDKRightBarButtonItemStyleText;
    self.rightBarButtonTitle = @"Log";
    
    [self.logTextView setHidden:YES];
    
    _isShowLog=NO;
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

-(void)DeviceDisConnectForBG5S:(NSNotification*)info {
    
    
    NSLog(@"DeviceDisConnectForBG5S:%@",[info userInfo]);
    
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
    [self.device disconnectDevice];
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
    [self.items addObject:@{@"t":@"Query Device Info",@"cb":^{
        [weakSelf showLoading];
        
        [self.device queryStateInfoWithSuccess:^(BG5SStateInfo *stateInfo) {
            NSLog(@"综合查询成功：电量：%d",(int)stateInfo.batteryValue);
            NSLog(@"综合查询成功：时间：%@",stateInfo.deviceDate);
            NSLog(@"综合查询成功：时区：%f",stateInfo.deviceTimeZone);
            NSLog(@"综合查询成功：试条使用条数：%d",(int)stateInfo.stripUsedValue);
            NSLog(@"综合查询成功：离线数据条数：%d",(int)stateInfo.offlineDataQuantity);
            NSLog(@"综合查询成功：血液Code版本号：%d",(int)stateInfo.bloodCodeVersion);
            NSLog(@"综合查询成功：质控液Code版本号：%d",(int)stateInfo.ctlCodeVersion);
            NSLog(@"综合查询成功：单位：%@",(stateInfo.unit == BGUnit_mmolPL)?@"mmol":((stateInfo.unit == BGUnit_mgPmL)?@"mg":@"未设置"));
            [weakSelf hideLoading];
        } errorBlock:^(BG5SError error, NSString *detailInfo) {
            NSLog(@"error：%d",(int)error);
        }];
        
    }}];
    [self.items addObject:@{@"t":@"Get Memory",@"cb":^{
        [weakSelf showLoading];
        
        [self.device queryRecordWithSuccessBlock:^(NSArray *array) {
            
            [weakSelf hideLoading];
          
            for (BG5SRecordModel *obj in array) {
                NSLog(@"dataID：%@ timeZone：%f,measureDate：%@ result：%ld canCorrect：%d",obj.dataID,obj.timeZone,obj.measureDate,(long)obj.value,(int)obj.canCorrect);
                
                [self printLog:[NSString stringWithFormat:@"dataID：%@ timeZone：%f,measureDate：%@ result：%ld canCorrect：%d",obj.dataID,obj.timeZone,obj.measureDate,(long)obj.value,(int)obj.canCorrect] title:@"Get Memory"];
            }
        } errorBlock:^(BG5SError error, NSString *detailInfo) {
            [weakSelf hideLoading];
            NSLog(@"error：%d",(int)error);
        }];
        
    }}];
    
    [self.items addObject:@{@"t":@"Start Test",@"cb":^{
        [weakSelf showLoading];
        
        [self.device startMeasure:BGMeasureMode_Blood withSuccessBlock:^{
            
            [weakSelf hideLoading];
            
        } errorBlock:^(BG5SError error, NSString *detailInfo) {
            [weakSelf hideLoading];
            NSLog(@"error：%d",(int)error);
            
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
