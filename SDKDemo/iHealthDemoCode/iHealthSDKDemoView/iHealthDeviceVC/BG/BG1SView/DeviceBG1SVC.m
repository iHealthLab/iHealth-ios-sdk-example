//
//  DeviceBG1SVC.m
//  iHealthDemoCode
//
//  Created by Spring on 2023/8/21.
//  Copyright © 2023 iHealth Demo Code. All rights reserved.
//

#import "DeviceBG1SVC.h"

#import "IHSDKDemoTableView.h"
#import "BGHeader.h"
#import "ScanDeviceController.h"

@interface DeviceBG1SVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) NSMutableSet *mArr;
@property (strong, nonatomic) NSMutableArray *items;
@property (strong, nonatomic) IHSDKDemoTableView *myTable;
@property (copy, nonatomic) NSString *selectedDeviceId;
@property (strong, nonatomic) BG1S *device;
@property (strong, nonatomic) UITextView *logTextView;

@end

@implementation DeviceBG1SVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSArray*deviceArray=[[BG1SController shareIHBG1SController] getAllCurrentBG1SInstace];
    
    for(BG1S *device in deviceArray){
        
        if([self.deviceId isEqualToString:device.serialNumber]){
            
            self.device=device;
            
        }
    }
    
    if (self.device==nil) {
        
        [IHSDKDemoToast showTipWithTitle:@"Device Not Connected"];
        
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(DeviceDisConnectForBG1S:) name:BG1SDisConnectNoti object:nil];

    
    [self.logTextView setHidden:YES];
}


-(void)DeviceDisConnectForBG1S:(NSNotification*)info {
    
    
    NSLog(@"DeviceDisConnectForBG1S:%@",[info userInfo]);
    
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

        [self.device commandFunction:^(NSDictionary *functionDict) {
            
            [IHSDKDemoToast showTipWithTitle:[NSString stringWithFormat:@"functionDict:\n%@",functionDict]];
            
        } DisposeBGErrorBlock:^(BG1SDeviceError error) {
            
        }];

    }}];

    [self.items addObject:@{@"t":@"ReadBGCodeDic",@"cb":^{

        [self.device commandReadBGCodeDic:^(NSDictionary *codeDic) {
            
            [IHSDKDemoToast showTipWithTitle:[NSString stringWithFormat:@"codeDic:\n%@",codeDic]];
            
        } DisposeBGErrorBlock:^(BG1SDeviceError error) {
            
        }];

    }}];
    
    [self.items addObject:@{@"t":@"SendBGCode",@"cb":^{
        
        NSString*testCode=[NSString stringWithFormat:@"02323C46323C01006400FA00E102016800F000F001F4025814015E3200A0005A00A0032000320046005A006E0082009600AA00B400E60104011801400168017C0190019A0584054F051C04EB04BC04900467045303E803C903AD037B035303430335032F10273D464E6F32496581AC1447689BFA03FF031306170475"];

        [self.device commandSendBGCodeWithCodeString:testCode DisposeBGSendCodeBlock:^(NSNumber *result) {
            
        } DisposeBGErrorBlock:^(BG1SDeviceError error) {
            
        }];

    }}];

    [self.items addObject:@{@"t":@"Measure",@"cb":^{

        [self.device commandCreateBG1STestModel:BGMeasureMode_Blood DisposeBGStripInBlock:^(BOOL inORout) {
            
        } DisposeBGBloodBlock:^{
            
            
        } DisposeBGResultBlock:^(NSDictionary *result) {
            
            [IHSDKDemoToast showTipWithTitle:[NSString stringWithFormat:@"result:%@",result]];
            
        } DisposeBGErrorBlock:^(BG1SDeviceError error) {
            
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
