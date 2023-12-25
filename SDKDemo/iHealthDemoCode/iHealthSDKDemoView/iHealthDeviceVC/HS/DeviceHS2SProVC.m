//
//  DeviceHS2SProVC.m
//  iHealthDemoCode
//
//  Created by dai on 2023/12/11.
//  Copyright © 2023 iHealth Demo Code. All rights reserved.
//

#import "DeviceHS2SProVC.h"

#import "IHSDKDemoTableView.h"
#import "HSHeader.h"
#import "ScanDeviceController.h"

@interface DeviceHS2SProVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) NSMutableSet *mArr;
@property (strong, nonatomic) NSMutableArray *items;
@property (strong, nonatomic) IHSDKDemoTableView *myTable;
@property (copy, nonatomic) NSString *selectedDeviceId;
@property (weak, nonatomic) HS2SPRO *device;
@property (weak, nonatomic) NSData *myHS2SProUserID;

@end

@implementation DeviceHS2SProVC

- (void)dealloc
{
    NSLog(@"%@ dealloc",self);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSArray*deviceArray=[[HS2SPROController shareIHHS2SPROController] getAllCurrentHS2SPROInstace];
    
    for(HS2SPRO *device in deviceArray){
        
        if([self.deviceId isEqualToString:device.serialNumber]){
            
            self.device=device;
            
        }
    }
    
    if (self.device==nil) {
        
        [IHSDKDemoToast showTipWithTitle:@"Device Not Connected"];
        
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(DeviceDisConnectForHS2SPRO:) name:HS2SPRODisConnectNoti object:nil];
    
}


-(void)DeviceDisConnectForHS2SPRO:(NSNotification*)info {
    
    
    NSLog(@"DeviceDisConnectForHS2SPRO:%@",[info userInfo]);
    
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
        
        [weakSelf.device commandGetHS2SPRODeviceInfo:^(NSDictionary * _Nonnull deviceInfo) {
            [weakSelf hideLoading];
            
            NSString *str = [NSString stringWithFormat:@"deviceInfo:%@\n",deviceInfo];

            [IHSDKDemoToast showTipWithTitle:str];
        } disposeErrorBlock:^(HS2SPRODeviceError errorID) {
            
            [weakSelf hideLoading];
            
            [IHSDKDemoToast showTipWithTitle:[self HS2SPROError:errorID]];
            
        }];
        
    }}];
    [self.items addObject:@{@"t":@"Battery",@"cb":^{
        [weakSelf showLoading];
        
        [weakSelf.device commandGetHS2SPROBattery:^(NSNumber * _Nonnull battary) {
            [weakSelf hideLoading];
            
            NSString *str = [NSString stringWithFormat:@"battary:%@\n",battary];

            [IHSDKDemoToast showTipWithTitle:str];
        } disposeErrorBlock:^(HS2SPRODeviceError errorID) {
            [weakSelf hideLoading];
            
            [IHSDKDemoToast showTipWithTitle:[self HS2SPROError:errorID]];
        }];
        
    }}];
    [self.items addObject:@{@"t":@"Set Unit",@"cb":^{
        
        [weakSelf showLoading];
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Set Unit" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *kgAction = [UIAlertAction actionWithTitle:@"Kg" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [weakSelf.device commandSetHS2SPROUnit:HSUnit_Kg successBlock:^{
                [weakSelf hideLoading];

                [IHSDKDemoToast showTipWithTitle:@"Sucess"];
            } disposeErrorBlock:^(HS2SPRODeviceError errorID) {
                [weakSelf hideLoading];
                
                [IHSDKDemoToast showTipWithTitle:[self HS2SPROError:errorID]];
            }];
            
            
        }];
        UIAlertAction *lbAction = [UIAlertAction actionWithTitle:@"LB" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [weakSelf.device commandSetHS2SPROUnit:HSUnit_LB successBlock:^{
                [weakSelf hideLoading];

                [IHSDKDemoToast showTipWithTitle:@"Sucess"];
            } disposeErrorBlock:^(HS2SPRODeviceError errorID) {
                
                [weakSelf hideLoading];
                
                [IHSDKDemoToast showTipWithTitle:[self HS2SPROError:errorID]];
                
            }];
           
            
        }];
        UIAlertAction *stAction = [UIAlertAction actionWithTitle:@"ST" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
           
            [weakSelf.device commandSetHS2SPROUnit:HSUnit_ST successBlock:^{
                [weakSelf hideLoading];

                [IHSDKDemoToast showTipWithTitle:@"Sucess"];
            } disposeErrorBlock:^(HS2SPRODeviceError errorID) {
                
                [weakSelf hideLoading];
                
                [IHSDKDemoToast showTipWithTitle:[self HS2SPROError:errorID]];
                
            }];
            
        }];
        [alertController addAction:kgAction];
        [alertController addAction:lbAction];
        [alertController addAction:stAction];
        [self presentViewController:alertController animated:YES completion:nil];
        
        
        
    }}];
    
    [self.items addObject:@{@"t":@"UserInfo",@"cb":^{
        
        [weakSelf showLoading];
        
        [weakSelf.device commandGetHS2SPROUserInfo:^(NSArray<HS2SProUser *> * _Nonnull array) {
            [weakSelf hideLoading];
            
            NSString *str = [NSString stringWithFormat:@"UserInfo:%@\n",array];
            
            if (array.count) {
                self.myHS2SProUserID=[array objectAtIndex:0].userId;
            }

            [IHSDKDemoToast showTipWithTitle:str];
        } disposeErrorBlock:^(HS2SPRODeviceError errorID) {
            
            [weakSelf hideLoading];
            
            [IHSDKDemoToast showTipWithTitle:[self HS2SPROError:errorID]];
        }];
        
        
    }}];
    
    
    [self.items addObject:@{@"t":@"UpdateUserInfo",@"cb":^{

        [weakSelf showLoading];
        
        HS2SProUser *user = [HS2SProUser new];
        
        if (self.myHS2SProUserID==nil) {
            
            self.myHS2SProUserID =[@"iHealth123456786" dataUsingEncoding:NSUTF8StringEncoding];
            
            user.userId=self.myHS2SProUserID;
            
        }else{
            
           user.userId=self.myHS2SProUserID;
        }
        
        
        user.createTS=[[NSDate date] timeIntervalSince1970];
        
        user.weight=90;
        
        user.age=18;
        
        user.height=180;
        
        user.gender=HS2SProGender_Male;
        
        user.enableMeasureImpedance=YES;
        
        user.enableFitness=YES;
        
        [weakSelf.device commandUpdateHS2SPROUserInfoWithUser:user successBlock:^{
            [weakSelf hideLoading];


            [IHSDKDemoToast showTipWithTitle:@"UpdateUserInfo sucess"];
        } disposeErrorBlock:^(HS2SPRODeviceError errorID) {
            [weakSelf hideLoading];
            
            [IHSDKDemoToast showTipWithTitle:[self HS2SPROError:errorID]];
        }];
        
        
    }}];
    
    [self.items addObject:@{@"t":@"DeleteUser",@"cb":^{
        
        [weakSelf showLoading];
        
        if (self.myHS2SProUserID==nil) {
            
            self.myHS2SProUserID =[@"iHealth123456786" dataUsingEncoding:NSUTF8StringEncoding];
            
            
        }
        
        [weakSelf.device commandDeleteHS2SPROUserWithUserId:self.myHS2SProUserID successBlock:^{
            [weakSelf hideLoading];

            [IHSDKDemoToast showTipWithTitle:@"DeleteUser sucess"];
        } disposeErrorBlock:^(HS2SPRODeviceError errorID) {
            [weakSelf hideLoading];
            
            [IHSDKDemoToast showTipWithTitle:[self HS2SPROError:errorID]];
        }];
        
    }}];
    
    [self.items addObject:@{@"t":@"Get MemoryData Count",@"cb":^{
        
        [weakSelf showLoading];
        
        if (self.myHS2SProUserID==nil) {
            
            self.myHS2SProUserID =[@"iHealth123456786" dataUsingEncoding:NSUTF8StringEncoding];
            
        }
        
        [weakSelf.device commandGetHS2SPROMemoryDataCountWithUserId:self.myHS2SProUserID successBlock:^(NSNumber * _Nonnull count) {
            [weakSelf hideLoading];
            
            NSString *str = [NSString stringWithFormat:@"memoryCount:%@\n",count];

            [IHSDKDemoToast showTipWithTitle:str];
        } disposeErrorBlock:^(HS2SPRODeviceError errorID) {
            [weakSelf hideLoading];
            
            [IHSDKDemoToast showTipWithTitle:[self HS2SPROError:errorID]];
        }];
        
    }}];
    
    [self.items addObject:@{@"t":@"Get Memory Data",@"cb":^{
        
        [weakSelf showLoading];
        
        if (self.myHS2SProUserID==nil) {
            
            self.myHS2SProUserID =[@"iHealth123456786" dataUsingEncoding:NSUTF8StringEncoding];
            
        }
        
        [weakSelf.device commandGetHS2SPROMemoryDataWithUserId:self.myHS2SProUserID successBlock:^(NSArray<HS2SProMeasurementModel *> * _Nonnull data) {
            
            [weakSelf hideLoading];
            
            NSString *str = [NSString stringWithFormat:@"memoryData:%@\n",[data debugDescription]];

            [IHSDKDemoToast showTipWithTitle:str];
            
        } disposeErrorBlock:^(HS2SPRODeviceError errorID) {
          
            [weakSelf hideLoading];
            
            [IHSDKDemoToast showTipWithTitle:[self HS2SPROError:errorID]];
        }];
        
       
        
    }}];
    
    [self.items addObject:@{@"t":@"DeleteMemoryData",@"cb":^{
        
        [weakSelf showLoading];
        
        [weakSelf.device commandDeleteHS2SPROMemoryDataWithUserId:self.myHS2SProUserID successBlock:^{
            [weakSelf hideLoading];
            [IHSDKDemoToast showTipWithTitle:@"DeleteMemoryData Sucess"];
        } disposeErrorBlock:^(HS2SPRODeviceError errorID) {
            [weakSelf hideLoading];
            
            [IHSDKDemoToast showTipWithTitle:[self HS2SPROError:errorID]];
        }];
        
        
    }}];
    
    [self.items addObject:@{@"t":@"GetAnonymousMemoryDataCount",@"cb":^{
        
        [weakSelf showLoading];
        
        [weakSelf.device commandGetHS2SPROAnonymousMemoryDataCount:^(NSNumber * _Nonnull count) {
            
            [weakSelf hideLoading];
            
            NSString *str = [NSString stringWithFormat:@"Anonymous memoryCount:%@\n",count];

            [IHSDKDemoToast showTipWithTitle:str];
            
        } disposeErrorBlock:^(HS2SPRODeviceError errorID) {
            
            [weakSelf hideLoading];
            
            [IHSDKDemoToast showTipWithTitle:[self HS2SPROError:errorID]];
        }];
        
        
    }}];
    
    [self.items addObject:@{@"t":@"GetAnonymousMemoryData",@"cb":^{
        
        [weakSelf showLoading];
        
        [weakSelf.device commandGetHS2SPROAnonymousMemoryData:^(NSArray<HS2SProAnonymousModel *> * _Nonnull data) {
            [weakSelf hideLoading];
            
            NSString *str = [NSString stringWithFormat:@"Anonymous memory Data:%@\n",[data debugDescription]];

            [IHSDKDemoToast showTipWithTitle:str];
        } disposeErrorBlock:^(HS2SPRODeviceError errorID) {
            [weakSelf hideLoading];
            
            [IHSDKDemoToast showTipWithTitle:[self HS2SPROError:errorID]];
        }];
        
        
    }}];
    
    [self.items addObject:@{@"t":@"DeleteAnonymousMemoryData",@"cb":^{
        
        [weakSelf showLoading];
        
        [weakSelf.device commandDeleteHS2SPROAnonymousMemoryData:^{
            
            [weakSelf hideLoading];
            
            [IHSDKDemoToast showTipWithTitle:@"DeleteAnonymousMemoryData Sucess"];
            
        } disposeErrorBlock:^(HS2SPRODeviceError errorID) {
            [weakSelf hideLoading];
            
            [IHSDKDemoToast showTipWithTitle:[self HS2SPROError:errorID]];
        }];
        

        
    }}];
    
    [self.items addObject:@{@"t":@"Measure",@"cb":^{
        
        [weakSelf showLoading];
        
        HS2SProUser *user = [HS2SProUser new];
        
        if (self.myHS2SProUserID==nil) {
            
            self.myHS2SProUserID =[@"iHealth123456786" dataUsingEncoding:NSUTF8StringEncoding];
            
            user.userId=self.myHS2SProUserID;
            
        }else{
            
           user.userId=self.myHS2SProUserID;
        }
        
        
        user.createTS=[[NSDate date] timeIntervalSince1970];
        
        user.weight=85;
        
        user.age=18;
        
        user.height=180;
        
        user.gender=HS2SProGender_Male;
        
        user.enableMeasureImpedance=YES;
        
        user.enableFitness=YES;
        
        [weakSelf.device commandStartHS2SPROMeasureWithUser:user realtimeWeightBlock:^(NSNumber * _Nonnull unStableWeight) {
            [weakSelf hideLoading];
            
            NSString *str = [NSString stringWithFormat:@"unStableWeight:%@",unStableWeight];

            [IHSDKDemoToast showTipWithTitle:str];
            
        } stableWeightBlock:^(NSNumber * _Nonnull stableWeight) {
            [weakSelf hideLoading];
            
            NSString *str = [NSString stringWithFormat:@"stableWeight:%@",stableWeight];

            [IHSDKDemoToast showTipWithTitle:str];
        } weightAndBodyInfoBlock:^(NSDictionary * _Nonnull weightAndBodyInfoDic) {
            [weakSelf hideLoading];
            
            NSString *str = [NSString stringWithFormat:@"weightAndBodyInfoDic:%@",weightAndBodyInfoDic];

            [IHSDKDemoToast showTipWithTitle:str];
        } disposeErrorBlock:^(HS2SPRODeviceError errorID) {
            
             [weakSelf hideLoading];
             
             [IHSDKDemoToast showTipWithTitle:[self HS2SPROError:errorID]];
        }];
        
        
    }}];
    
    [self.items addObject:@{@"t":@"ResetDevice",@"cb":^{
        
        [weakSelf showLoading];
        
        [weakSelf.device commandResetHS2SPRODevice:^{
            [weakSelf hideLoading];
            
            [IHSDKDemoToast showTipWithTitle:@"ResetDevice Sucess"];
        } disposeErrorBlock:^(HS2SPRODeviceError errorID) {
            [weakSelf hideLoading];
            
            [IHSDKDemoToast showTipWithTitle:[self HS2SPROError:errorID]];
        }];
        
        
    }}];
    
    [self.items addObject:@{@"t":@"DisconnectDevice",@"cb":^{
        
        [weakSelf.device commandDisconnectDevice];
        
    }}];
    
    [self.items addObject:@{@"t":@"EnterHeartRateMeasurementMode",@"cb":^{
        
//        [weakSelf showLoading];
        
        [weakSelf.device commandEnterHS2SPROHeartRateMeasurementMode:^(NSDictionary * _Nonnull heartResultDic) {
            
            [weakSelf hideLoading];
            
            NSString *str = [NSString stringWithFormat:@"heartResultDic:%@",heartResultDic];

            [IHSDKDemoToast showTipWithTitle:str];
            
        } measurementStatus:^(NSNumber * _Nonnull measurementStatus) {
            
            [weakSelf hideLoading];
            
            NSString *str = [NSString stringWithFormat:@"measurementStatus:%@",measurementStatus];

            [IHSDKDemoToast showTipWithTitle:str];
            
        } disposeErrorBlock:^(HS2SPRODeviceError errorID) {
            
            [weakSelf hideLoading];
            
            [IHSDKDemoToast showTipWithTitle:[self HS2SPROError:errorID]];
            
        }];
        

        
    }}];
    
    [self.items addObject:@{@"t":@"ExitHeartRateMeasurementMode",@"cb":^{
        
        [weakSelf showLoading];
        
        [weakSelf.device commandExitHS2SPROHeartRateMeasurementMode:^{
            [weakSelf hideLoading];
            
            [IHSDKDemoToast showTipWithTitle:@"ExitHeartRateMeasurementMode"];
        } disposeErrorBlock:^(HS2SPRODeviceError errorID) {
            
            [weakSelf hideLoading];
            
            [IHSDKDemoToast showTipWithTitle:[self HS2SPROError:errorID]];
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

-(NSString*)HS2SPROError:(HS2SPRODeviceError)errorID{
    
    switch (errorID) {
        case HS2SPRODeviceError_Unknown:
            return NSLocalizedString(@"device send wrong error code.", @"");
            break;
        case HS2SPRODeviceError_CommunicationTimeout:
            return NSLocalizedString(@"CommunicationTimeout", @"");
            break;
        case HS2SPRODeviceError_ReceivedCommandError:
            return NSLocalizedString(@"ReceivedCommandError", @"");
            break;
        case HS2SPRODeviceError_InputParameterError:
            return NSLocalizedString(@"InputParameterError", @"");
            break;
        case HS2SPRODeviceError_MoreThanMaxNumbersOfUser:
            return NSLocalizedString(@"MoreThanMaxNumbersOfUser", @"");
            break;
        case HS2SPRODeviceError_WriteFlashError:
            return NSLocalizedString(@"WriteFlashError", @"");
            break;
        case HS2SPRODeviceError_UserNotExist:
            return NSLocalizedString(@"UserNotExist", @"");
            break;
        case HS2SPRODeviceError_StartMeasureError:
            return NSLocalizedString(@"StartMeasureError", @"");
            break;
        case HS2SPRODeviceError_MeasureTimeout:
            return NSLocalizedString(@"MeasureTimeout", @"");
            break;
        case HS2SPRODeviceError_MeasureOverweight:
            return NSLocalizedString(@"MeasureOverweight", @"");
            break;
        case HS2SPRODeviceError_Disconnect:
            return NSLocalizedString(@"Disconnect", @"");
            break;
        case HS2SPRODeviceError_Unsupported:
            return NSLocalizedString(@"Unsupported", @"");
            break;
       
        default:
            return NSLocalizedString(@"device send wrong error code.", @"");
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
