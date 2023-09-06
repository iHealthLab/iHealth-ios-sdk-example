//
//  DeviceAm6BindVC.m
//  iHealthDemoCode
//
//  Created by Spring on 2023/4/18.
//  Copyright © 2023 iHealth Demo Code. All rights reserved.
//

#import "DeviceAM6BindVC.h"
#import "IHSDKDemoTableView.h"
#import "AMMacroFile.h"
#import "AMHeader.h"

#import <CommonCrypto/CommonHMAC.h>
#import <CommonCrypto/CommonCryptor.h>
#import <zlib.h>

#define kTestUserId [self md5:@""]

@interface DeviceAM6BindVC ()<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) NSMutableArray *items;
@property (strong, nonatomic) IHSDKDemoTableView *myTable;
@property (weak, nonatomic) AM6 *device;

@end

@implementation DeviceAM6BindVC

- (NSData *)md5:(NSString *)hashString{
    
    NSData *data = [hashString dataUsingEncoding:NSUTF8StringEncoding];
    // 计算md5
    unsigned char *digest;
    digest = (unsigned char *)malloc(CC_MD5_DIGEST_LENGTH);
    
    CC_MD5([data bytes], (CC_LONG)[data length], digest);
    NSData *md5Data = [NSData dataWithBytes:digest length:CC_MD5_DIGEST_LENGTH];
    free(digest);
    
    return md5Data;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (void)setupInterface{
    self.title = self.deviceId;
    [self loadItems];
    [self.myTable addToView:self.view];
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
        _myTable.dataSource = self;
        _myTable.delegate = self;
    }
    return _myTable;
}

- (void)loadItems{
    self.items = [NSMutableArray new];
    __weak typeof(self) weakSelf = self;
    [self.items addObject:@{@"t":@"Set User Info",@"cb":^{
        
        [weakSelf showLoading];
        [self.device setUserInfoWithUserIdMD5:kTestUserId gender:1 age:18 height:120 weight:80 success:^{
            [weakSelf hideLoading];
            [weakSelf showTopToast:@"Set User Info Success"];
        } fail:^(int error) {
            [weakSelf hideLoading];
        }];

    }}];
    [self.items addObject:@{@"t":@"Send Bind Token",@"cb":^{
        [weakSelf showLoading];
        
        [self.device sendStartBindWithSuccess:^{
            [weakSelf hideLoading];
            [weakSelf showTopToast:@"Send Bind Success"];
        } fail:^(int error) {
            [weakSelf hideLoading];
        }];
        
    
    }}];
    
    [self.items addObject:@{@"t":@"Send Bind Success",@"cb":^{
        [weakSelf showLoading];
        [self.device sendSuccessBindWithUserId:kTestUserId success:^{
            [weakSelf hideLoading];
            [weakSelf showTopToast:@"Bind Success"];
        } fail:^(int error) {
            [weakSelf hideLoading];
//            [JAKAlertController alertContoller:@"Error" message:[WZLatteConstants errorMessageWithError:error] withBottomBtntitle:@"OK" bottomAction:^{
//
//            }];
        }];
        
    }}];
    
    
    [self.items addObject:@{@"t":@"Send Bind Fail",@"cb":^{
        [weakSelf showLoading];
        [self.device sendFailBindWithSuccess:^{
            [weakSelf hideLoading];
            [weakSelf showTopToast:@"Send Success"];
        } fail:^(int error) {
            [weakSelf hideLoading];
//            [JAKAlertController alertContoller:@"Error" message:[WZLatteConstants errorMessageWithError:error] withBottomBtntitle:@"OK" bottomAction:^{
//
//            }];
        }];
    }}];
    
    [self.items addObject:@{@"t":@"Send Unbind",@"cb":^{
        [weakSelf showLoading];
        
        [self.device sendUnbindWithUserId:kTestUserId success:^{
            [weakSelf hideLoading];
            [weakSelf showTopToast:@"Unbind Success"];
        } fail:^(int error) {
            [weakSelf hideLoading];
//            [JAKAlertController alertContoller:@"Error" message:[WZLatteConstants errorMessageWithError:error] withBottomBtntitle:@"OK" bottomAction:^{
//                
//            }];
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
