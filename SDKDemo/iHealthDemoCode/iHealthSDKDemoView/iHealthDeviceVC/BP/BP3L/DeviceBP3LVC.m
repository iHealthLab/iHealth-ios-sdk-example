//
//  DeviceBP3LVC.m
//  iHealthDemoCode
//
//  Created by Spring on 2023/9/6.
//  Copyright © 2023 iHealth Demo Code. All rights reserved.
//

#import "DeviceBP3LVC.h"
#import "IHSDKDemoTableView.h"
#import "BPHeader.h"
#import "ScanDeviceController.h"
@interface DeviceBP3LVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) NSMutableSet *mArr;
@property (strong, nonatomic) NSMutableArray *items;
@property (strong, nonatomic) IHSDKDemoTableView *myTable;
@property (copy, nonatomic) NSString *selectedDeviceId;
@property (strong, nonatomic) UITextView *myTextView;
@property (strong, nonatomic) BP3L *device;

@end
@implementation DeviceBP3LVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSArray*deviceArray=[[BP3LController shareBP3LController] getAllCurrentBP3LInstace];
    
    for(BP3L *device in deviceArray){
        
        if([self.deviceId isEqualToString:device.serialNumber]){
            
            self.device=device;
            
        }
    }
    
    if (self.device==nil) {
        
        [IHSDKDemoToast showTipWithTitle:@"Device Not Connected"];
        
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(DeviceDisConnectForBP3L:) name:BP3LDisConnectNoti object:nil];
}
-(void)DeviceDisConnectForBP3L:(NSNotification*)info {
    
    
    NSLog(@"BP3LDisConnectNoti:%@",[info userInfo]);
    
}

- (void)setupInterface{
    self.title = self.deviceId;
    [self loadItems];
    [self.myTable addToView:self.view];
    
    [self.view addSubview:self.myTextView];
    
    [self.myTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.myTable.mas_bottom).offset(10);
        make.centerX.width.mas_equalTo(self.view);
        make.height.mas_equalTo(280);
    }];
    
}
- (void)leftBarButtonDidPressed:(id)sender{
    [self.device commandDisconnectDevice];
    [super leftBarButtonDidPressed:sender];
}

- (void)printLog:(NSString *)log{
    
    self.myTextView.text = [NSString stringWithFormat:@"%@\n%@",self.myTextView.text, log];
    NSRange range;
    range.location = [self.myTextView.text length] - 1;
    range.length = 0;
    [self.myTextView scrollRangeToVisible:range];
}
#pragma mark -

- (UITextView *)myTextView{
    if (_myTextView == nil) {
        _myTextView = [[UITextView alloc]init];
        _myTextView.textColor = [UIColor blackColor];
    }
    return _myTextView;
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
        
        [self.device commandFunction:^(NSDictionary *functionDict) {
            
            [weakSelf hideLoading];
            NSString *str = [NSString stringWithFormat:@"armMeasureFlg:%@\n haveOffline:%@\n",functionDict[@"armMeasureFlg"],functionDict[@"haveOffline"]];
            
            [weakSelf printLog:str];

            [IHSDKDemoToast showTipWithTitle:str];
            
        } errorBlock:^(BPDeviceError error) {
            
            [weakSelf hideLoading];
            
            [IHSDKDemoToast showTipWithTitle:[self BPError:error]];
            
        }];

    }}];
    [self.items addObject:@{@"t":@"Get Energy",@"cb":^{
        [weakSelf showLoading];
        
        [self.device commandEnergy:^(NSNumber *energyValue) {
            
            [weakSelf hideLoading];
            
            NSString *str = [NSString stringWithFormat:@"Energy:%@",energyValue];
            
            [IHSDKDemoToast showTipWithTitle:str];
            
        } errorBlock:^(BPDeviceError error) {
            
            [weakSelf hideLoading];
            
            [IHSDKDemoToast showTipWithTitle:[self BPError:error]];
            
        }];
        
    }}];
    
    [self.items addObject:@{@"t":@"Measure",@"cb":^{
        [weakSelf showLoading];
        
        [self.device commandStartMeasureWithZeroingState:^(BOOL isComplete) {
            
        } pressure:^(NSArray *pressureArr) {
            
        } waveletWithHeartbeat:^(NSArray *waveletArr) {
            
        } waveletWithoutHeartbeat:^(NSArray *waveletArr) {
            
        } result:^(NSDictionary *resultDict) {
            
            [weakSelf hideLoading];
            
            NSString *str = [NSString stringWithFormat:@"Result:%@",resultDict];
            
            [weakSelf printLog:str];
            
            [IHSDKDemoToast showTipWithTitle:str];
            
        } errorBlock:^(BPDeviceError error) {
            
            [weakSelf hideLoading];
            
            NSLog(@"timeout:%lu",(unsigned long)error);
            
            [IHSDKDemoToast showTipWithTitle:[self BPError:error]];
        }];
        
    }}];
    
    [self.items addObject:@{@"t":@"Stop Measure",@"cb":^{
        [weakSelf showLoading];
        
        [self.device stopBPMeassureSuccessBlock:^{
            
            [weakSelf hideLoading];
            
            [IHSDKDemoToast showTipWithTitle:@"Stop Measure"];
            
        } errorBlock:^(BPDeviceError error) {
            
            [weakSelf hideLoading];
            
            [IHSDKDemoToast showTipWithTitle:[self BPError:error]];
        }];
        
    }}];
    
    [self.items addObject:@{@"t":@"Disconnect",@"cb":^{
        
        
        [self.device commandDisconnectDevice];
        
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

-(NSString*)BPError:(BPDeviceError)errorID{
    
    switch (errorID) {
        case BPError0:
            return NSLocalizedString(@"Unable to take measurements due to arm/wrist movements.", @"");
            break;
        case BPError1:
            return NSLocalizedString(@"Failed to detect systolic pressure", @"");
            break;
        case BPError2:
            return NSLocalizedString(@"Failed to detect diastolic pressure", @"");
            break;
        case BPError3:
            return NSLocalizedString(@"Pneumatic system blocked or cuff is too tight during inflation", @"");
            break;
        case BPError4:
            return NSLocalizedString(@"Pneumatic system leakage or cuff is too loose during inflation", @"");
            break;
        case BPError5:
            return NSLocalizedString(@"Cuff pressure reached over 300mmHg", @"");
            break;
        case BPError6:
            return NSLocalizedString(@"Cuff pressure reached over 15 mmHg for more than 160 seconds", @"");
            break;
        case BPError7:
        case BPError8:
        case BPError9:
        case BPError10:
            return NSLocalizedString(@"Data retrieving error", @"");
            break;
        case BPError11:
        case BPError12:
            return NSLocalizedString(@"Communication Error", @"");
            break;
        case BPError13:
            return NSLocalizedString(@"Low battery", @"");
            break;
        case BPError14:
            return NSLocalizedString(@"Device bluetooth set failed", @"");
            break;
        case BPError15:
            return NSLocalizedString(@" Systolic exceeds 260mmHg or diastolic exceeds 199mmHg", @"");
            break;
        case BPError16:
            return NSLocalizedString(@"Systolic below 60mmHg or diastolic below 40mmHg", @"");
            break;
        case BPError17:
            return NSLocalizedString(@"Arm/wrist movement beyond range", @"");
            break;
        case BPError18:
        case BPError19:
            return NSLocalizedString(@"Heart rate in measure result exceeds max limit", @"");
            break;
        case BPError20:
            return NSLocalizedString(@"PP(Average BP) exceeds limit", @"");
            break;
        case BPErrorUserStopMeasure:
            return NSLocalizedString(@"User stop measure(for ABPM history measurement only)", @"");
            break;
        case BPNormalError:
            return NSLocalizedString(@"device error, error message displayed automatically", @"");
            break;
        case BPOverTimeError:
        case BPNoRespondError:
            return NSLocalizedString(@"Abnormal communication", @"");
            break;
        case BPBeyondRangeError:
            return NSLocalizedString(@"device is out of communication range.", @"");
            break;
        case BPDidDisconnect:
            return NSLocalizedString(@"Device Disconnect", @"");
            break;
        case BPAskToStopMeasure:
            return NSLocalizedString(@"measurement has been stopped.", @"");
            break;
        case BPDeviceBusy:
            return NSLocalizedString(@"device is busy doing other things", @"");
            break;
        case BPInputParameterError:
        case BPInvalidOperation:
            return NSLocalizedString(@"Parameter input error.", @"");
            break;
        default:
            break;
    }
    
    return @"Unknow error";
}

@end
