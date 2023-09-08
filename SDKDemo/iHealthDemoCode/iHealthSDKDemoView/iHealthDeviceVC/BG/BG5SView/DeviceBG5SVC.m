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
            NSLog(@"batteryValue：%d",(int)stateInfo.batteryValue);
            NSLog(@"deviceDate：%@",stateInfo.deviceDate);
            NSLog(@"deviceTimeZone：%f",stateInfo.deviceTimeZone);
            NSLog(@"stripUsedValue：%d",(int)stateInfo.stripUsedValue);
            NSLog(@"offlineDataQuantity：%d",(int)stateInfo.offlineDataQuantity);
            NSLog(@"bloodCodeVersion：%d",(int)stateInfo.bloodCodeVersion);
            NSLog(@"ctlCodeVersion：%d",(int)stateInfo.ctlCodeVersion);
            NSLog(@"unit：%@",(stateInfo.unit == BGUnit_mmolPL)?@"mmol":((stateInfo.unit == BGUnit_mgPmL)?@"mg":@"No Set"));
            [weakSelf hideLoading];

            [IHSDKDemoToast showTipWithTitle:@"Sucess"];
        } errorBlock:^(BG5SError error, NSString *detailInfo) {
            [weakSelf hideLoading];
            NSLog(@"error：%d",(int)error);
        }];
        
    }}];
    [self.items addObject:@{@"t":@"setTime",@"cb":^{
        [weakSelf showLoading];
        
        [self.device setTimeWithDate:[NSDate date] timezone:8 successBlock:^{
            
            [weakSelf hideLoading];

            [IHSDKDemoToast showTipWithTitle:@"Sucess"];
            
        } errorBlock:^(BG5SError error, NSString *detailInfo) {
            [weakSelf hideLoading];
            NSLog(@"error：%d",(int)error);
        }];
        
    }}];
    [self.items addObject:@{@"t":@"setUnit",@"cb":^{
        [weakSelf showLoading];
        
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Set Unit" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *kgAction = [UIAlertAction actionWithTitle:@"mmolPL" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [weakSelf.device setUnit:BGUnit_mmolPL successBlock:^{
                [weakSelf hideLoading];

                [IHSDKDemoToast showTipWithTitle:@"Sucess"];
            } errorBlock:^(BG5SError error, NSString *detailInfo) {
                [weakSelf hideLoading];
                NSLog(@"error：%d",(int)error);
            }];
            
        }];
        UIAlertAction *lbAction = [UIAlertAction actionWithTitle:@"BGUnit_mgPmL" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
           
            [weakSelf.device setUnit:BGUnit_mgPmL successBlock:^{
                [weakSelf hideLoading];

                [IHSDKDemoToast showTipWithTitle:@"Sucess"];
            } errorBlock:^(BG5SError error, NSString *detailInfo) {
                [weakSelf hideLoading];
                NSLog(@"error：%d",(int)error);
            }];
            
        }];
       
        [alertController addAction:kgAction];
        [alertController addAction:lbAction];
       
        [self presentViewController:alertController animated:YES completion:nil];
        

        
    }}];
    
    [self.items addObject:@{@"t":@"deleteStripUsedInfo",@"cb":^{
        [weakSelf showLoading];
        
        [self.device deleteStripUsedInfoWithSuccessBlock:^{
            
            [weakSelf hideLoading];

            [IHSDKDemoToast showTipWithTitle:@"Sucess"];
            
        } errorBlock:^(BG5SError error, NSString *detailInfo) {
            [weakSelf hideLoading];
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
    
    [self.items addObject:@{@"t":@"deleteRecord",@"cb":^{
        [weakSelf showLoading];
        
        [self.device deleteRecordWithSuccessBlock:^{
            
            [weakSelf hideLoading];

            [IHSDKDemoToast showTipWithTitle:@"Sucess"];
            
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
    
    [self.items addObject:@{@"t":@"DisconnectDevice",@"cb":^{
        
        [weakSelf.device disconnectDevice];
        
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
