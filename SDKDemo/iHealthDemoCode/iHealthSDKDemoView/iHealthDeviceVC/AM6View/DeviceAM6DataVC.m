//
//  DeviceAM6DataVC.m
//  iHealthDemoCode
//
//  Created by Spring on 2023/4/18.
//  Copyright © 2023 iHealth Demo Code. All rights reserved.
//

#import "DeviceAM6DataVC.h"
#import "IHSDKDemoTableView.h"
#import "AMMacroFile.h"
#import "AMHeader.h"
#import "AM6Constants.h"
#import <MJExtension.h>

@interface DeviceAM6DataVC ()<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) NSMutableArray *items;
@property (strong, nonatomic) IHSDKDemoTableView *myTable;
@property (weak, nonatomic) AM6 *device;

@property (strong, nonatomic) UITextField *nameTextField;

@property (strong, nonatomic) UITextView *myTextView;

@property (nonatomic) BOOL isShowLog;

@end

@implementation DeviceAM6DataVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.rightBarButtonItemStyle = IHSDKRightBarButtonItemStyleText;
    self.rightBarButtonTitle = @"Log";
    
    [self.myTextView setHidden:YES];
    
    _isShowLog=NO;
}

- (void)rightBarButtonDidPressed:(id)sender{
    
    if (_isShowLog) {
        _isShowLog=NO;
        [self.myTextView setHidden:YES];
    }else{
        
        _isShowLog=YES;
        
        [self.myTextView setHidden:NO];
    }
    
}

- (void)printLog:(NSString *)log title:(NSString *)title{
    
//    self.myTextView.text = [NSString stringWithFormat:@"%@\n%@\n%@",self.myTextView.text,title,log];
    
    self.myTextView.text = [NSString stringWithFormat:@"%@\n%@",title,log];

    
}

- (void)setupInterface{
    self.title = self.deviceId;
    [self loadItems];
    [self.myTable addToView:self.view];
    
    [self.view addSubview:self.myTextView];
        
    [self.myTextView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.view).offset(self.navigationController.navigationBar.bounds.size.height + CTScaleByWidth(44));
            make.left.mas_equalTo(self.view);
            make.right.mas_equalTo(self.view);
            make.bottom.mas_equalTo(self.view).offset(30);
        }];
}

- (AM6 *)device{
    if (!_device) {
        NSArray*deviceArray=[[AM6Controller shareAM6Controller] getAllCurrentAM6Instace];
        
        for(AM6 *am6 in deviceArray){
            
            if([self.deviceId isEqualToString:am6.serialNumber]){
                
                _device=am6;
                
            }
        }
    }
    __weak typeof(self) weakSelf = self;
    if (_device==nil) {
        
        [IHSDKDemoToast showTipWithTitle:@"Device Not Connected"];
            
        [weakSelf hideLoading];
            
        [weakSelf.navigationController popViewControllerAnimated:YES];
    
    }
    return _device;
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

- (UITextView *)myTextView{
    if (_myTextView == nil) {
        _myTextView = [[UITextView alloc]init];
        _myTextView.textColor = [UIColor blackColor];
        _myTextView.selectable = NO;
        _myTextView.editable = NO;
        _myTextView.showsVerticalScrollIndicator = YES;
    }
    return _myTextView;
}

- (void)loadItems{
    self.items = [NSMutableArray new];
    __weak typeof(self) weakSelf = self;
    [self.items addObject:@{@"t":@"Prepare to Sync",@"cb":^{
        [weakSelf showLoading];
        [self.device prepareSyncWithSuccess:^{
            [weakSelf hideLoading];
            [weakSelf showTopToast:@"Success"];
        } fail:^(int error) {
            [weakSelf hideLoading];
            
            [IHSDKDemoToast showTipWithTitle:[NSString stringWithFormat:@"prepare to sync error: %@",[weakSelf errorMessageWithError:error]]];
            
        }];
    }}];
    [self.items addObject:@{@"t":@"Sync Daily Report",@"cb":^{
        [weakSelf showLoading];
        
        [self.device syncDailyActivityReportWithSuccess:^{
            [weakSelf hideLoading];
            
            [weakSelf showAllDataWithTitle:@"Sync Daily Report" data:weakSelf.device.reportArray];
            
        } fail:^(int error) {
            [weakSelf hideLoading];
            [IHSDKDemoToast showTipWithTitle:[NSString stringWithFormat:@"prepare to sync error: %@",[weakSelf errorMessageWithError:error]]];
        }];
        
    }}];
    [self.items addObject:@{@"t":@"Delete Daily Report",@"cb":^{
        [weakSelf showLoading];
        [self.device deleteDataWithType:0x0010 success:^{
            [weakSelf hideLoading];
            [weakSelf showTopToast:@"Success"];
        } fail:^(int error) {
            [weakSelf hideLoading];
            [IHSDKDemoToast showTipWithTitle:[NSString stringWithFormat:@"prepare to sync error: %@",[weakSelf errorMessageWithError:error]]];
        }];
    }}];
    [self.items addObject:@{@"t":@"Sync Steps/Calorie/Distance",@"cb":^{
        [weakSelf showLoading];
        
        [self.device syncDailyStepsCalorieDistanceWithSuccess:^{
            [weakSelf hideLoading];
            [weakSelf showAllDataWithTitle:@"Sync Steps/Calorie/Distance" data:weakSelf.device.dailyStepsArray];
        } fail:^(int error) {
            [weakSelf hideLoading];
            [IHSDKDemoToast showTipWithTitle:[NSString stringWithFormat:@"prepare to sync error: %@",[weakSelf errorMessageWithError:error]]];
        }];
        
    }}];
    [self.items addObject:@{@"t":@"Delete Steps/Calorie/Distance",@"cb":^{
        [weakSelf showLoading];
        [self.device deleteDataWithType:0x0001 success:^{
            [weakSelf hideLoading];
            [weakSelf showTopToast:@"Success"];
        } fail:^(int error) {
            [self hideLoading];
            [IHSDKDemoToast showTipWithTitle:[NSString stringWithFormat:@"prepare to sync error: %@",[weakSelf errorMessageWithError:error]]];
        }];
    }}];
    [self.items addObject:@{@"t":@"Sync Sleep",@"cb":^{
        [weakSelf showLoading];
        
        [self.device syncSleepWithSuccess:^{
            [weakSelf hideLoading];
            [weakSelf showAllDataWithTitle:@"Sync Sleep" data:weakSelf.device.sleepArray];
        } fail:^(int error) {
            [weakSelf hideLoading];
            [IHSDKDemoToast showTipWithTitle:[NSString stringWithFormat:@"prepare to sync error: %@",[weakSelf errorMessageWithError:error]]];
        }];
    }}];
    [self.items addObject:@{@"t":@"Delete Sleep",@"cb":^{
        [weakSelf showLoading];
        [self.device deleteDataWithType:0x0002 success:^{
            [weakSelf hideLoading];
            [weakSelf showTopToast:@"Success"];
        } fail:^(int error) {
            [IHSDKDemoToast showTipWithTitle:[NSString stringWithFormat:@"prepare to sync error: %@",[weakSelf errorMessageWithError:error]]];
        }];
    }}];
    [self.items addObject:@{@"t":@"Sync Blood Oxygen",@"cb":^{
        [weakSelf showLoading];
        [self.device syncOfflineBloodOxygenWithSuccess:^{
            [weakSelf hideLoading];
            [weakSelf showAllDataWithTitle:@"Sync Blood Oxygen" data:weakSelf.device.bloodOxygenArray];
        } fail:^(int error) {
            [weakSelf hideLoading];
            [IHSDKDemoToast showTipWithTitle:[NSString stringWithFormat:@"prepare to sync error: %@",[weakSelf errorMessageWithError:error]]];
        }];
    
    }}];
    [self.items addObject:@{@"t":@"Delete Blood Oxygen",@"cb":^{
        [weakSelf showLoading];
        [self.device deleteDataWithType:0x0008 success:^{
            [weakSelf hideLoading];
            [weakSelf showTopToast:@"Success"];
        } fail:^(int error) {
            [weakSelf hideLoading];
            [IHSDKDemoToast showTipWithTitle:[NSString stringWithFormat:@"prepare to sync error: %@",[weakSelf errorMessageWithError:error]]];
        }];
    }}];
    [self.items addObject:@{@"t":@"Sync Daily Heart Rate",@"cb":^{
        [weakSelf showLoading];
        
        [weakSelf.device syncDailyHeartRateWithSuccess:^{
            [weakSelf hideLoading];
            [weakSelf showAllDataWithTitle:@"Sync Daily Heart Rate" data:weakSelf.device.dailyHeartRateArray];
        } fail:^(int error) {
            [weakSelf hideLoading];
            [IHSDKDemoToast showTipWithTitle:[NSString stringWithFormat:@"prepare to sync error: %@",[weakSelf errorMessageWithError:error]]];
        }];
    }}];
    [self.items addObject:@{@"t":@"Delete Daily Heart Rate",@"cb":^{
        [weakSelf showLoading];
        [self.device deleteDataWithType:0x0004 success:^{
            [weakSelf hideLoading];
            [weakSelf showTopToast:@"Success"];
        } fail:^(int error) {
            [IHSDKDemoToast showTipWithTitle:[NSString stringWithFormat:@"prepare to sync error: %@",[weakSelf errorMessageWithError:error]]];
        }];
    }}];
    [self.items addObject:@{@"t":@"Sync Sport",@"cb":^{
        [weakSelf showLoading];
        [weakSelf.device syncSportWithSuccess:^{
            
            [weakSelf hideLoading];
            
            if (weakSelf.device.indoorRunArray) {
                [weakSelf showAllDataWithTitle:@"Sync Sport" data:weakSelf.device.indoorRunArray];
            }
            if (weakSelf.device.indoorRunReportArray) {
                [weakSelf showAllDataWithTitle:@"Sync Sport Report" data:weakSelf.device.indoorRunReportArray];
            }
            
        } fail:^(int error) {
            [weakSelf hideLoading];
            [IHSDKDemoToast showTipWithTitle:[NSString stringWithFormat:@"prepare to sync error: %@",[weakSelf errorMessageWithError:error]]];
        }];
       
    }}];
    [self.items addObject:@{@"t":@"Delete Sport",@"cb":^{
        [weakSelf showLoading];
        [self.device deleteDataWithType:0x0020 success:^{
            [weakSelf hideLoading];
            [weakSelf showTopToast:@"Success"];
        } fail:^(int error) {
            [self hideLoading];
            [IHSDKDemoToast showTipWithTitle:[NSString stringWithFormat:@"prepare to sync error: %@",[weakSelf errorMessageWithError:error]]];
        }];
    }}];
    [self.items addObject:@{@"t":@"Delete All Data",@"cb":^{
        [weakSelf showLoading];
        [self.device deleteDataWithType:0x8000 success:^{
            [weakSelf hideLoading];
            [weakSelf showTopToast:@"Success"];
        } fail:^(int error) {
            [weakSelf hideLoading];
            [IHSDKDemoToast showTipWithTitle:[NSString stringWithFormat:@"prepare to sync error: %@",[weakSelf errorMessageWithError:error]]];
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

-(void)saveAllDataWithArray:(NSArray*)dataArray{
    
    if (dataArray.count==0) {
        [self showTopToast:@"No Data"];
        return;
    }
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Input File Name" message:@"No need to input extension name, the default one is json." preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"xxx";
        textField.font = IHSDK_FONT_Normal(14);
        textField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        self.nameTextField = textField;

    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSString *timeString = [self.nameTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        if (timeString && timeString.length>0) {
            [self saveToFile:timeString :dataArray];
        }
        else {
            [self showTopToast:@"Invalid input"];
        }
        
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
}


#pragma mark -

-(NSString *)convertToJsonData:(NSDictionary *)dict withJson:(BOOL)jsonFlag
{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString;
    
    if (!jsonData) {
        NSLog(@"%@",error);
    }else{
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    
    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
    if (jsonFlag==NO) {
        NSRange range = {0,jsonString.length};
        //去掉字符串中的空格
        [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
        NSRange range2 = {0,mutStr.length};
    //    去掉字符串中的换行符
        [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];
    }
    return [mutStr copy];
}
- (void)saveToFile:(NSString *)fileName :(NSArray*)dataArray{
    
    NSMutableArray *mArr = [NSMutableArray new];
    for (id object in dataArray) {
        if ([object isKindOfClass:[NSString class]]) {
            NSString *detail = (NSString*)object;
            [mArr addObject:detail];
        }
        else {
            NSDictionary *dic = [object mj_keyValues];
            NSString *detail = [self convertToJsonData:dic withJson:YES];
            [mArr addObject:detail];
        }
    }
    NSMutableString *mString = [NSMutableString new];
    [mString appendString:@"[\n"];
    [mString appendString:[mArr componentsJoinedByString:@",\n"]];
    [mString appendString:@"\n]"];
    
    NSData *data = [[mString copy] dataUsingEncoding:NSUTF8StringEncoding];
//    NSString *pathName = [NSString stringWithFormat:@"保存的数据文件-%@",[[NSDate date]jak_stringFromDateFormat:@"yyyyMMdd-HH:mm:ss"]];
    NSString *pathName = @"保存的数据文件";
    // Find documents directory
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    ;
    NSString *filePath = [[docPath stringByAppendingPathComponent:pathName] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.json",fileName]];
    NSLog(@"file path:%@",filePath);
    // Create new file if none exists
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        [[NSFileManager defaultManager]removeItemAtPath:filePath error:nil];
    }
    
    [[NSFileManager defaultManager] createDirectoryAtPath:[docPath stringByAppendingPathComponent:pathName] withIntermediateDirectories:YES attributes:nil error:nil];
    [[NSFileManager defaultManager] createFileAtPath:filePath contents:nil attributes:nil];
    NSFileHandle *fileHandle = [NSFileHandle fileHandleForWritingAtPath:filePath];
    [fileHandle writeData:data];
    [fileHandle closeFile];
//    [JAKAlertController alertContoller:nil message:@"Save Successfully" withBottomBtntitle:@"Ok" bottomAction:^{
//
//    }];
    
    [self showTopToast:@"Save Successfully"];
}

-(void)showAllDataWithTitle:(NSString*)title data:(NSArray*)dataArray{
    
    
    NSMutableArray *mArr = [NSMutableArray new];
    for (id object in dataArray) {
        if ([object isKindOfClass:[NSString class]]) {
            NSString *detail = (NSString*)object;
            [mArr addObject:detail];
        }
        else {
            NSDictionary *dic = [object mj_keyValues];
//                    NSString *detail = [self convertToJsonData:dic withJson:YES];
            [mArr addObject:dic];
        }
    }
    
    NSLog(@"title:%@ dataArray:%@",title,mArr);
    
    [self printLog:[NSString stringWithFormat:@"%@",mArr] title:title];
    
//    UIAlertController *vc = [UIAlertController alertControllerWithTitle:title message:[NSString stringWithFormat:@"%@",mArr] preferredStyle:UIAlertControllerStyleAlert];
//
//    UIAlertAction *action = [UIAlertAction actionWithTitle:NSLocalizedString(@"OK", @"") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//
//    }];
//
//    [vc addAction:action];
//
//    [self presentViewController:vc animated:YES completion:nil];
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(NSString*)errorMessageWithError:(int)errorID{
    
    
    return @"Communicaton timeout";
}

@end
