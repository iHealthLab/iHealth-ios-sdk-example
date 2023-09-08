//
//  DevicePT3SBTVC.m
//  iHealthDemoCode
//
//  Created by Spring on 2023/9/8.
//  Copyright © 2023 iHealth Demo Code. All rights reserved.
//

#import "DevicePT3SBTVC.h"

#import "IHSDKDemoTableView.h"
#import "PT3SBTMacroFile.h"
#import "PT3SBT.h"
#import "PT3SBTController.h"
#import "ScanDeviceController.h"

@interface DevicePT3SBTVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) NSMutableSet *mArr;
@property (strong, nonatomic) NSMutableArray *items;
@property (strong, nonatomic) IHSDKDemoTableView *myTable;
@property (copy, nonatomic) NSString *selectedDeviceId;
@property (weak, nonatomic) PT3SBT *device;


@end
@implementation DevicePT3SBTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSArray*deviceArray=[[PT3SBTController shareIHPT3SBTController] getAllCurrentPT3SBTInstace];
    
    for(PT3SBT *device in deviceArray){
        
        if([self.deviceId isEqualToString:device.serialNumber]){
            
            self.device=device;
            
        }
    }
    
    if (self.device==nil) {
        
        [IHSDKDemoToast showTipWithTitle:@"Device Not Connected"];
        
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(DeviceDisConnectForPT3SBT:) name:PT3SBTDisConnectNoti object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(devicePT3SBTResult:) name:@"PT3SBTNotificationGetResult" object:nil];
    
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(devicePT3SBTUnitChange:) name:@"PT3SBTNotificationDeviceUnitChange" object:nil];
    
    
}

-(void)devicePT3SBTResult:(NSNotification *)tempNoti{
 
    NSDictionary*deviceDic= [tempNoti userInfo];
    
    NSString *str = [NSString stringWithFormat:@"Result:%@",deviceDic];

    [IHSDKDemoToast showTipWithTitle:str];
    
}


-(void)devicePT3SBTUnitChange:(NSNotification *)tempNoti{
 
    NSDictionary*deviceDic= [tempNoti userInfo];

    
    NSString *str = [NSString stringWithFormat:@"UnitChange:%@",deviceDic];

    [IHSDKDemoToast showTipWithTitle:str];
    
}


-(void)DeviceDisConnectForPT3SBT:(NSNotification*)info {
    
    
    NSLog(@"DeviceDisConnectForPT3SBT:%@",[info userInfo]);
    
}



- (void)setupInterface{
    self.title = self.deviceId;
    [self loadItems];
    [self.myTable addToView:self.view];
    
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


- (void)loadItems{
    self.items = [NSMutableArray new];
    __weak typeof(self) weakSelf = self;
    [self.items addObject:@{@"t":@"Function",@"cb":^{
        
        [weakSelf showLoading];
        
        [weakSelf.device commandFunction:^(NSDictionary *functionDict) {
            
            [weakSelf hideLoading];
            
            NSString *str = [NSString stringWithFormat:@"Function:%@",functionDict];

            [IHSDKDemoToast showTipWithTitle:str];
            
        } DisposeErrorBlock:^(PT3SBTDeviceError error) {
            
            [weakSelf hideLoading];
            
            [IHSDKDemoToast showTipWithTitle:[weakSelf PT3SBTError:error]];
            
        }];
        
    }}];
    [self.items addObject:@{@"t":@"Set Unit",@"cb":^{
        
        [weakSelf showLoading];
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Set Unit" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *kgAction = [UIAlertAction actionWithTitle:@"C" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [weakSelf.device commandPT3SBTSetUnit:PT3SBTTemperatureUnit_C DisposeSetUnitResult:^(BOOL setResult) {
                
                [weakSelf hideLoading];
                
                [IHSDKDemoToast showTipWithTitle:@"Sucess"];
                
            } DisposeErrorBlock:^(PT3SBTDeviceError error) {
                
                [weakSelf hideLoading];
                
                [IHSDKDemoToast showTipWithTitle:[weakSelf PT3SBTError:error]];
            }];
            
        }];
        UIAlertAction *lbAction = [UIAlertAction actionWithTitle:@"F" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
           
            [weakSelf.device commandPT3SBTSetUnit:PT3SBTTemperatureUnit_F DisposeSetUnitResult:^(BOOL setResult) {
                
                [weakSelf hideLoading];
                
                [IHSDKDemoToast showTipWithTitle:@"Sucess"];
                
            } DisposeErrorBlock:^(PT3SBTDeviceError error) {
                
                [weakSelf hideLoading];
                
                [IHSDKDemoToast showTipWithTitle:[weakSelf PT3SBTError:error]];
            }];
            
        }];
       
        [alertController addAction:kgAction];
        [alertController addAction:lbAction];
       
        [self presentViewController:alertController animated:YES completion:nil];
        
    }}];
    [self.items addObject:@{@"t":@"Battary",@"cb":^{
        
        [weakSelf showLoading];
        
        [weakSelf.device commandGetPT3SBTBattery:^(NSNumber *battary) {
            [weakSelf hideLoading];
            
            NSString *str = [NSString stringWithFormat:@"battary:%@",battary];

            [IHSDKDemoToast showTipWithTitle:str];
        } DiaposeErrorBlock:^(PT3SBTDeviceError error) {
            [weakSelf hideLoading];
            
            [IHSDKDemoToast showTipWithTitle:[weakSelf PT3SBTError:error]];
        }];
        
    }}];
    
    [self.items addObject:@{@"t":@"GetUnit",@"cb":^{
        
        [weakSelf showLoading];
        
        [weakSelf.device commandPT3SBTGetUnit:^(PT3SBTTemperatureUnit unit) {
            [weakSelf hideLoading];
            
            NSString *str = [NSString stringWithFormat:@"battary:%@",(unit == PT3SBTTemperatureUnit_C)?@"Unit_C":@"Unit_F"];

            [IHSDKDemoToast showTipWithTitle:str];
        } DisposeErrorBlock:^(PT3SBTDeviceError error) {
            [weakSelf hideLoading];
            
            [IHSDKDemoToast showTipWithTitle:[weakSelf PT3SBTError:error]];
        }];
        
    }}];
    
    
    [self.items addObject:@{@"t":@"MemoryCount",@"cb":^{
        
        [weakSelf showLoading];
        
        [weakSelf.device commandPT3SBTGetMemoryCount:^(NSNumber *count) {
            [weakSelf hideLoading];
            
            NSString *str = [NSString stringWithFormat:@"count:%@",count];

            [IHSDKDemoToast showTipWithTitle:str];
        } DisposeErrorBlock:^(PT3SBTDeviceError error) {
            [weakSelf hideLoading];
            
            [IHSDKDemoToast showTipWithTitle:[weakSelf PT3SBTError:error]];
        }];
        
    }}];
    
    [self.items addObject:@{@"t":@"Memory Data",@"cb":^{
        
        [weakSelf showLoading];
        
        [weakSelf.device commandGetMemorryData:^(NSMutableArray *memoryDataArray) {
            [weakSelf hideLoading];
            
            NSString *str = [NSString stringWithFormat:@"memoryDataArray:%@",memoryDataArray];

            [IHSDKDemoToast showTipWithTitle:str];
        } DisposeErrorBlock:^(PT3SBTDeviceError error) {
            [weakSelf hideLoading];
            
            [IHSDKDemoToast showTipWithTitle:[weakSelf PT3SBTError:error]];
        }];
        
    }}];
    
    [self.items addObject:@{@"t":@"Delete Memory",@"cb":^{
        
        [weakSelf showLoading];
        
        [weakSelf.device commandDeleteMemorryData:^(BOOL deleteResult) {
            [weakSelf hideLoading];
            
            [IHSDKDemoToast showTipWithTitle:@"Sucess"];
        } DisposeErrorBlock:^(PT3SBTDeviceError error) {
            [weakSelf hideLoading];
            
            [IHSDKDemoToast showTipWithTitle:[weakSelf PT3SBTError:error]];
        }];
        
    }}];
    
    
    [self.items addObject:@{@"t":@"Get DeviceInfo",@"cb":^{
        
        [weakSelf showLoading];
        
        [weakSelf.device commandGetDeviceInfo:^(NSDictionary *deviceInfoDic) {
            [weakSelf hideLoading];
            
            NSString *str = [NSString stringWithFormat:@"deviceInfoDic:%@",deviceInfoDic];

            [IHSDKDemoToast showTipWithTitle:str];
        } DisposeErrorBlock:^(PT3SBTDeviceError error) {
            [weakSelf hideLoading];
            
            [IHSDKDemoToast showTipWithTitle:[weakSelf PT3SBTError:error]];
        }];
        
    }}];
    
    [self.items addObject:@{@"t":@"Disconnect",@"cb":^{
    
        
        [weakSelf.device commandDisconnectDevice];
        
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

-(NSString*)PT3SBTError:(PT3SBTDeviceError)errorID{
    
    switch (errorID) {
        case PT3SBTDeviceError_Unknown:
            return NSLocalizedString(@"device send wrong error code.", @"");
            break;
        case PT3SBTDeviceError_CommunicationTimeout:
            return NSLocalizedString(@"CommunicationTimeout", @"");
            break;
        case PT3SBTDeviceError_ReceivedCommandError:
            return NSLocalizedString(@"ReceivedCommandError", @"");
            break;
        case PT3SBTDeviceError_InputParameterError:
            return NSLocalizedString(@"InputParameterError", @"");
            break;
        case PT3SBTDeviceError_MoreThanMaxNumbersOfUser:
            return NSLocalizedString(@"MoreThanMaxNumbersOfUser", @"");
            break;
        case PT3SBTDeviceError_WriteFlashError:
            return NSLocalizedString(@"WriteFlashError", @"");
            break;
        case PT3SBTDeviceError_Disconnect:
            return NSLocalizedString(@"Disconnect", @"");
            break;

        default:
            return NSLocalizedString(@"device send wrong error code.", @"");
            break;
    }
    
    return @"Unknow error";
}

@end
