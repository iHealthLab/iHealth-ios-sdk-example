//
//  DeviceKD723_V2.m
//  iHealthDemoCode
//
//  Created by dai on 2024/2/27.
//  Copyright © 2024 iHealth Demo Code. All rights reserved.
//

#import "DeviceKD723_V2VC.h"
#import "IHSDKDemoTableView.h"
#import "BPHeader.h"
#import "ScanDeviceController.h"
@interface DeviceKD723_V2VC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) NSMutableSet *mArr;
@property (strong, nonatomic) NSMutableArray *items;
@property (strong, nonatomic) IHSDKDemoTableView *myTable;
@property (copy, nonatomic) NSString *selectedDeviceId;
@property (strong, nonatomic) UITextView *myTextView;
@property (weak, nonatomic) KD723_V2 *device;

@end

@implementation DeviceKD723_V2VC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSArray*deviceArray=[[KD723_V2Controller shareIHKD723Controller] getAllCurrentKD723Instace];
    
    for(KD723_V2 *device in deviceArray){
        
        if([self.deviceId isEqualToString:device.serialNumber]){
            
            self.device=device;
            
        }
    }
    
    if (self.device==nil) {
        
        [IHSDKDemoToast showTipWithTitle:@"Device Not Connected"];
        
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(DeviceDisConnectForKD723:) name:KD723_V2DisConnectNoti object:nil];
}
-(void)DeviceDisConnectForKD723:(NSNotification*)info {
    
    
    NSLog(@"KD723DisConnectNoti:%@",[info userInfo]);
    
    [self leftBarButtonDidPressed:nil];
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

    
    [self.items addObject:@{@"t":@"Set Time",@"cb":^{

        [self.device commandSynchronizeTime:^{

            [IHSDKDemoToast showTipWithTitle:@"SynchronizeTime"];

        } errorBlock:^(BPDeviceError error) {

            [weakSelf hideLoading];

        }];

    }}];

    [self.items addObject:@{@"t":@"Get Function",@"cb":^{

        [self.device commandFunction:^(NSDictionary *functionDict) {

            [IHSDKDemoToast showTipWithTitle:[NSString stringWithFormat:@"%@",functionDict]];

            NSLog(@"Get Function:%@",functionDict);

        } errorBlock:^(BPDeviceError error) {

            [weakSelf hideLoading];
        }];

    }}];

    [self.items addObject:@{@"t":@"Get Count",@"cb":^{

        [self.device commandTransferMemoryCount:^(NSNumber *count) {
            [IHSDKDemoToast showTipWithTitle:[NSString stringWithFormat:@"count:%@",count]];

            NSLog(@"count:%@",count);

        } errorBlock:^(BPDeviceError error) {

            [weakSelf hideLoading];

        }];

    }}];
    
    
    [self.items addObject:@{@"t":@"History Data",@"cb":^{
        [weakSelf showLoading];

        [self.device commandTransferMemoryData:^(NSArray *bachArray) {
            [weakSelf hideLoading];

            [IHSDKDemoToast showTipWithTitle:[NSString stringWithFormat:@"%@",bachArray]];

            NSLog(@"bachArray:%@",bachArray);
        } errorBlock:^(BPDeviceError error) {

            [weakSelf hideLoading];

        }];
    }}];

    [self.items addObject:@{@"t":@"Delete History Data",@"cb":^{
        [weakSelf showLoading];
        
        [self.device commandDeleteMemoryDataResult:^{
            [weakSelf hideLoading];

            [IHSDKDemoToast showTipWithTitle:@"Delete History Data"];
        } errorBlock:^(BPDeviceError error) {
            [weakSelf hideLoading];
        }];

    }}];
    
    [self.items addObject:@{@"t":@"Disconnect",@"cb":^{
        
        [weakSelf hideLoading];
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

-(NSString*)BP550Error:(BPDeviceError)errorID{
    
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
