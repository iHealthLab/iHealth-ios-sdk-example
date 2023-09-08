//
//  DeviceHS2SVC.m
//  iHealthDemoCode
//
//  Created by Spring on 2023/9/7.
//  Copyright © 2023 iHealth Demo Code. All rights reserved.
//

#import "DeviceHS2SVC.h"
#import "IHSDKDemoTableView.h"
#import "HSHeader.h"
#import "ScanDeviceController.h"

@interface DeviceHS2SVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) NSMutableSet *mArr;
@property (strong, nonatomic) NSMutableArray *items;
@property (strong, nonatomic) IHSDKDemoTableView *myTable;
@property (copy, nonatomic) NSString *selectedDeviceId;
@property (strong, nonatomic) HS2S *device;
@property (strong, nonatomic) NSData *myHS2SUserID;

@end
@implementation DeviceHS2SVC
- (void)dealloc
{
    NSLog(@"%@ dealloc",self);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSArray*deviceArray=[[HS2SController shareIHHS2SController] getAllCurrentHS2SInstace];
    
    for(HS2S *device in deviceArray){
        
        if([self.deviceId isEqualToString:device.serialNumber]){
            
            self.device=device;
            
        }
    }
    
    if (self.device==nil) {
        
        [IHSDKDemoToast showTipWithTitle:@"Device Not Connected"];
        
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(DeviceDisConnectForHS2S:) name:HS2SDisConnectNoti object:nil];
    
}


-(void)DeviceDisConnectForHS2S:(NSNotification*)info {
    
    
    NSLog(@"DeviceDisConnectForHS2S:%@",[info userInfo]);
    
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
    [self.items addObject:@{@"t":@"DeviceInfo",@"cb":^{
        
        [weakSelf showLoading];
        
        [weakSelf.device commandGetHS2SDeviceInfo:^(NSDictionary *deviceInfo) {
            
            [weakSelf hideLoading];
            
            NSString *str = [NSString stringWithFormat:@"deviceInfo:%@\n",deviceInfo];

            [IHSDKDemoToast showTipWithTitle:str];
            
        } DiaposeErrorBlock:^(HS2SDeviceError errorID) {
            
            [weakSelf hideLoading];
            
            [IHSDKDemoToast showTipWithTitle:[self HS2SError:errorID]];
        }];
        
    }}];
    [self.items addObject:@{@"t":@"Battery",@"cb":^{
        [weakSelf showLoading];
        
        [weakSelf.device commandGetHS2SBattery:^(NSNumber *battary) {
            
            [weakSelf hideLoading];
            
            NSString *str = [NSString stringWithFormat:@"battary:%@\n",battary];

            [IHSDKDemoToast showTipWithTitle:str];
        } DiaposeErrorBlock:^(HS2SDeviceError errorID) {
            [weakSelf hideLoading];
            
            [IHSDKDemoToast showTipWithTitle:[self HS2SError:errorID]];
        }];
        
    }}];
    [self.items addObject:@{@"t":@"Set Unit",@"cb":^{
        
        [weakSelf showLoading];
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Set Unit" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *kgAction = [UIAlertAction actionWithTitle:@"Kg" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [weakSelf.device commandSetHS2SUnit:HSUnit_Kg result:^(BOOL result) {
                
                [weakSelf hideLoading];

                [IHSDKDemoToast showTipWithTitle:@"Sucess"];
                
            } DisposeErrorBlock:^(HS2SDeviceError errorID) {
                [weakSelf hideLoading];
                
                [IHSDKDemoToast showTipWithTitle:[self HS2SError:errorID]];
            }];
            
        }];
        UIAlertAction *lbAction = [UIAlertAction actionWithTitle:@"LB" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
           
            [weakSelf.device commandSetHS2SUnit:HSUnit_LB result:^(BOOL result) {
                [weakSelf hideLoading];

                [IHSDKDemoToast showTipWithTitle:@"Sucess"];
                
            } DisposeErrorBlock:^(HS2SDeviceError errorID) {
                [weakSelf hideLoading];
                
                [IHSDKDemoToast showTipWithTitle:[self HS2SError:errorID]];
            }];
            
        }];
        UIAlertAction *stAction = [UIAlertAction actionWithTitle:@"ST" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
           
            [weakSelf.device commandSetHS2SUnit:HSUnit_ST result:^(BOOL result) {
                [weakSelf hideLoading];

                [IHSDKDemoToast showTipWithTitle:@"Sucess"];
                
            } DisposeErrorBlock:^(HS2SDeviceError errorID) {
                [weakSelf hideLoading];
                
                [IHSDKDemoToast showTipWithTitle:[self HS2SError:errorID]];
            }];
            
        }];
        [alertController addAction:kgAction];
        [alertController addAction:lbAction];
        [alertController addAction:stAction];
        [self presentViewController:alertController animated:YES completion:nil];
        
        
        
    }}];
    
    [self.items addObject:@{@"t":@"UserInfo",@"cb":^{
        
        [weakSelf showLoading];
        
        [weakSelf.device commandGetHS2SUserInfo:^(NSDictionary *userInfo) {
            [weakSelf hideLoading];
            
            NSString *str = [NSString stringWithFormat:@"UserInfo:%@\n",userInfo];

            [IHSDKDemoToast showTipWithTitle:str];
        } DiaposeErrorBlock:^(HS2SDeviceError errorID) {
            [weakSelf hideLoading];
            
            [IHSDKDemoToast showTipWithTitle:[self HS2SError:errorID]];
        }];
        
    }}];
    
    
    [self.items addObject:@{@"t":@"UpdateHS2SUserInfo",@"cb":^{

        [weakSelf showLoading];
        
        HealthUser*user=[HealthUser new];
        
        if (self.myHS2SUserID==nil) {
            
            self.myHS2SUserID =[@"iHealth123456786" dataUsingEncoding:NSUTF8StringEncoding];
            
            user.hs2SUserID=self.myHS2SUserID;
            
        }else{
            
           user.hs2SUserID=self.myHS2SUserID;
        }
        
        
        user.createTS=[[NSDate date] timeIntervalSince1970];
        
        user.weight=@85;
        
        user.age=@18;
        
        user.height=@180;
        
        user.sex=UserSex_Male;
        
        user.impedanceMark=HS2SImpedanceMark_YES;
        
        user.fitnessMark=HS2SFitnessMark_YES;
        
        [weakSelf.device commandUpdateHS2SUserInfoWithUser:user result:^(BOOL result) {
            
            [weakSelf hideLoading];
            
            NSString *str = [NSString stringWithFormat:@"UpdateHS2SUserInfo Result:%d\n",result];

            [IHSDKDemoToast showTipWithTitle:str];
            
        } DiaposeErrorBlock:^(HS2SDeviceError errorID) {
            
            [weakSelf hideLoading];
            
            [IHSDKDemoToast showTipWithTitle:[self HS2SError:errorID]];
        }];
        
    }}];
    
    [self.items addObject:@{@"t":@"DeleteHS2SUser",@"cb":^{
        
        [weakSelf showLoading];
        
        if (self.myHS2SUserID==nil) {
            
            self.myHS2SUserID =[@"iHealth123456786" dataUsingEncoding:NSUTF8StringEncoding];
            
            
        }
        
        [weakSelf.device commandDeleteHS2SUserWithUserID:self.myHS2SUserID result:^(BOOL result) {
            
            [weakSelf hideLoading];
            
            NSString *str = [NSString stringWithFormat:@"DeleteHS2SUser Result:%d\n",result];

            [IHSDKDemoToast showTipWithTitle:str];
            
            
        } DiaposeErrorBlock:^(HS2SDeviceError errorID) {
            
            [weakSelf hideLoading];
            
            [IHSDKDemoToast showTipWithTitle:[self HS2SError:errorID]];
            
        }];
        
    }}];
    
    [self.items addObject:@{@"t":@"Get MemoryData Count",@"cb":^{
        
        [weakSelf showLoading];
        
        if (self.myHS2SUserID==nil) {
            
            self.myHS2SUserID =[@"iHealth123456786" dataUsingEncoding:NSUTF8StringEncoding];
            
        }
        
        [weakSelf.device commandGetHS2SMemoryDataCountWithUserID:self.myHS2SUserID memoryCount:^(NSNumber *count) {
            
            [weakSelf hideLoading];
            
            NSString *str = [NSString stringWithFormat:@"memoryCount:%@\n",count];

            [IHSDKDemoToast showTipWithTitle:str];
            
        } DiaposeErrorBlock:^(HS2SDeviceError errorID) {
            
            [weakSelf hideLoading];
            
            [IHSDKDemoToast showTipWithTitle:[self HS2SError:errorID]];
        }];
        
    }}];
    
    [self.items addObject:@{@"t":@"Get HS2SMemory Data",@"cb":^{
        
        [weakSelf showLoading];
        
        if (self.myHS2SUserID==nil) {
            
            self.myHS2SUserID =[@"iHealth123456786" dataUsingEncoding:NSUTF8StringEncoding];
            
        }
        
        [weakSelf.device commandGetHS2SMemoryDataWithUserID:self.myHS2SUserID memoryData:^(NSArray *data) {
            [weakSelf hideLoading];
            
            NSString *str = [NSString stringWithFormat:@"memoryData:%@\n",data];

            [IHSDKDemoToast showTipWithTitle:str];
        } DiaposeErrorBlock:^(HS2SDeviceError errorID) {
            [weakSelf hideLoading];
            
            [IHSDKDemoToast showTipWithTitle:[self HS2SError:errorID]];
        }];
        
    }}];
    
    [self.items addObject:@{@"t":@"DeleteHS2SMemoryData",@"cb":^{
        
        [weakSelf showLoading];
        
        [weakSelf.device commandDeleteHS2SMemoryDataWithUserID:self.myHS2SUserID result:^(BOOL result) {
            [weakSelf hideLoading];
            
            NSString *str = [NSString stringWithFormat:@"delete memory data result:%d",result];

            [IHSDKDemoToast showTipWithTitle:str];
        } DiaposeErrorBlock:^(HS2SDeviceError errorID) {
            [weakSelf hideLoading];
            
            [IHSDKDemoToast showTipWithTitle:[self HS2SError:errorID]];
        }];
        
    }}];
    
    [self.items addObject:@{@"t":@"GetHS2SAnonymousMemoryDataCount",@"cb":^{
        
        [weakSelf showLoading];
        
        [weakSelf.device commandGetHS2SAnonymousMemoryDataCount:^(NSNumber *count) {
            
            [weakSelf hideLoading];
            
            NSString *str = [NSString stringWithFormat:@"Anonymous memoryCount:%@\n",count];

            [IHSDKDemoToast showTipWithTitle:str];
            
        } DiaposeErrorBlock:^(HS2SDeviceError errorID) {
            [weakSelf hideLoading];
            
            [IHSDKDemoToast showTipWithTitle:[self HS2SError:errorID]];
        }];
        
    }}];
    
    [self.items addObject:@{@"t":@"GetHS2SAnonymousMemoryData",@"cb":^{
        
        [weakSelf showLoading];
        
        [weakSelf.device commandGetHS2SAnonymousMemoryData:^(NSArray *data) {
            
            [weakSelf hideLoading];
            
            NSString *str = [NSString stringWithFormat:@"Anonymous memory Data:%@\n",data];

            [IHSDKDemoToast showTipWithTitle:str];
        } DiaposeErrorBlock:^(HS2SDeviceError errorID) {
            [weakSelf hideLoading];
            
            [IHSDKDemoToast showTipWithTitle:[self HS2SError:errorID]];
        }];
        
    }}];
    
    [self.items addObject:@{@"t":@"DeleteHS2SAnonymousMemoryData",@"cb":^{
        
        [weakSelf showLoading];
        
        [weakSelf.device commandDeleteHS2SAnonymousMemoryData:^(BOOL result) {
            [weakSelf hideLoading];
            
            NSString *str = [NSString stringWithFormat:@"delete Anonymous memory data result:%d",result];

            [IHSDKDemoToast showTipWithTitle:str];
        } DiaposeErrorBlock:^(HS2SDeviceError errorID) {
            [weakSelf hideLoading];
            
            [IHSDKDemoToast showTipWithTitle:[self HS2SError:errorID]];
        }];
        
    }}];
    
    [self.items addObject:@{@"t":@"Measure",@"cb":^{
        
        [weakSelf showLoading];
        
        HealthUser*user=[HealthUser new];
        
        user.hs2SUserID=self.myHS2SUserID;
        
        user.createTS=[[NSDate date] timeIntervalSince1970];
        
        user.weight=@85;
        
        user.age=@18;
        
        user.height=@180;
        
        user.sex=UserSex_Male;
        
        user.impedanceMark=HS2SImpedanceMark_YES;
        
        user.userType=UserType_Normal;
        
        user.fitnessMark=HS2SFitnessMark_YES;
        
        [weakSelf.device commandStartHS2SMeasureWithUser:user weight:^(NSNumber *unStableWeight) {
            
        } stableWeight:^(NSNumber *stableWeight) {
            
            [weakSelf hideLoading];
            
            NSString *str = [NSString stringWithFormat:@"stableWeight:%@",stableWeight];

            [IHSDKDemoToast showTipWithTitle:str];
            
        } weightAndBodyInfo:^(NSDictionary *weightAndBodyInfoDic) {
            
            [weakSelf hideLoading];
            
            NSString *str = [NSString stringWithFormat:@"weightAndBodyInfoDic:%@",weightAndBodyInfoDic];

            [IHSDKDemoToast showTipWithTitle:str];
            
        } disposeHS2SMeasureFinish:^{
            
        } DiaposeErrorBlock:^(HS2SDeviceError errorID) {
           
            [weakSelf hideLoading];
            
            [IHSDKDemoToast showTipWithTitle:[self HS2SError:errorID]];
        }];
        
    }}];
    
    [self.items addObject:@{@"t":@"ResetHS2SDevice",@"cb":^{
        
        [weakSelf showLoading];
        
        [weakSelf.device commandResetHS2SDevice:^(BOOL result) {
            [weakSelf hideLoading];
            
            NSString *str = [NSString stringWithFormat:@"ResetHS2SDevice result:%d",result];

            [IHSDKDemoToast showTipWithTitle:str];
            
        } DiaposeErrorBlock:^(HS2SDeviceError errorID) {
            [weakSelf hideLoading];
            
            [IHSDKDemoToast showTipWithTitle:[self HS2SError:errorID]];
        }];
        
    }}];
    
    [self.items addObject:@{@"t":@"DisconnectDevice",@"cb":^{
        
        [weakSelf.device commandDisconnectDevice];
        
    }}];
    
    [self.items addObject:@{@"t":@"EnterHS2SHeartRateMeasurementMode",@"cb":^{
        
        [weakSelf showLoading];
        
        [weakSelf.device commandEnterHS2SHeartRateMeasurementMode:^(NSDictionary *heartResultDic) {
            
            [weakSelf hideLoading];
            
            NSString *str = [NSString stringWithFormat:@"heartResultDic:%@",heartResultDic];

            [IHSDKDemoToast showTipWithTitle:str];
            
            
        } measurementStatus:^(NSNumber *measurementStatus) {
            
            [weakSelf hideLoading];
            
            NSString *str = [NSString stringWithFormat:@"measurementStatus:%@",measurementStatus];

            [IHSDKDemoToast showTipWithTitle:str];
            
        } DiaposeErrorBlock:^(HS2SDeviceError errorID) {
            [weakSelf hideLoading];
            
            [IHSDKDemoToast showTipWithTitle:[self HS2SError:errorID]];
        }];
        
    }}];
    
    [self.items addObject:@{@"t":@"ExitHS2SHeartRateMeasurementMode",@"cb":^{
        
        [weakSelf showLoading];
        
        [weakSelf.device commandExitHS2SHeartRateMeasurementMode:^(BOOL result) {
            [weakSelf hideLoading];
            
            NSString *str = [NSString stringWithFormat:@"ExitHS2SHeartRateMeasurementMode result:%d",result];

            [IHSDKDemoToast showTipWithTitle:str];
            
        } DiaposeErrorBlock:^(HS2SDeviceError errorID) {
            [weakSelf hideLoading];
            
            [IHSDKDemoToast showTipWithTitle:[self HS2SError:errorID]];
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

-(NSString*)HS2SError:(HS2SDeviceError)errorID{
    
    switch (errorID) {
        case HS2SDeviceError_Unknown:
            return NSLocalizedString(@"device send wrong error code.", @"");
            break;
        case HS2SDeviceError_CommunicationTimeout:
            return NSLocalizedString(@"CommunicationTimeout", @"");
            break;
        case HS2SDeviceError_ReceivedCommandError:
            return NSLocalizedString(@"ReceivedCommandError", @"");
            break;
        case HS2SDeviceError_InputParameterError:
            return NSLocalizedString(@"InputParameterError", @"");
            break;
        case HS2SDeviceError_MoreThanMaxNumbersOfUser:
            return NSLocalizedString(@"MoreThanMaxNumbersOfUser", @"");
            break;
        case HS2SDeviceError_WriteFlashError:
            return NSLocalizedString(@"WriteFlashError", @"");
            break;
        case HS2SDeviceError_UserNotExist:
            return NSLocalizedString(@"UserNotExist", @"");
            break;
        case HS2SDeviceError_StartMeasureError:
            return NSLocalizedString(@"StartMeasureError", @"");
            break;
        case HS2SDeviceError_MeasureTimeout:
            return NSLocalizedString(@"MeasureTimeout", @"");
            break;
        case HS2SDeviceError_MeasureOverweight:
            return NSLocalizedString(@"MeasureOverweight", @"");
            break;
        case HS2SDeviceError_Disconnect:
            return NSLocalizedString(@"Disconnect", @"");
            break;
        case HS2SDeviceError_Unsupported:
            return NSLocalizedString(@"Unsupported", @"");
            break;
       
        default:
            return NSLocalizedString(@"device send wrong error code.", @"");
            break;
    }
    
    return @"Unknow error";
}
@end
