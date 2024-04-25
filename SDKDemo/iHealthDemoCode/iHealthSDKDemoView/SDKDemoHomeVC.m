//
//  SDKDemoHomeVC.m
//  iHealthDemoCode
//
//  Created by jing on 2023/4/11.
//  Copyright © 2023 iHealth Demo Code. All rights reserved.
//

#import "SDKDemoHomeVC.h"
#import "IHSDKDemoTableView.h"
#import "IHSDKBaseCell.h"
#import "IHSDKDeviceList.h"

#import "BPHeader.h"
#import "DeviceBP5VC.h"

#define APP_VERSION [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
#define APP_BUILD [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]

@interface SDKDemoHomeVC ()<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) IHSDKDemoTableView *myTable;
@property (copy, nonatomic) NSArray *titles;

@end

@implementation SDKDemoHomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [BP5Controller shareBP5Controller];
    
    // Do any additional setup after loading the view.
}
- (void)setupInterface{
    self.title = [NSString stringWithFormat:@"iHealth SDK Demo v%@",APP_VERSION];
    self.leftBarButtonItemStyle = IHSDKLeftBarButtonItemStyleNone;
    self.myTable = [IHSDKDemoTableView groupedTable];
    self.myTable.delegate = self;
    self.myTable.dataSource = self;
    [self.myTable addToView:self.view];
    
    self.titles = @[@"KN-550BT",@"BP5S",@"HS2S",@"AM6",@"BG5S",@"BG1A",@"PT3SBT",@"BP3L",@"PO3",@"PO1",@"BG1",@"BG1S",@"BP7S",@"HS2SPro",@"BP5",@"CONTINUA_BP",@"KD723_V2"];
    
    
}
#pragma mark - Lazy
#pragma mark -
- (void)leftBarButtonDidPressed:(id)sender{
    
}
- (void)rightBarButtonDidPressed:(id)sender{

}
#pragma mark -
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.titles.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    IHSDKBaseCell *cell = [IHSDKBaseCell settingCell];
    cell.textLabel.text = self.titles[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    IHSDKDeviceList *vc = [IHSDKDeviceList new];
    if (indexPath.row==0) {
        vc.SDKDeviceType=HealthDeviceType_KN550BT;
    } else if (indexPath.row==1) {
        vc.SDKDeviceType=HealthDeviceType_BP5S;
    } else if (indexPath.row==2){

        vc.SDKDeviceType=HealthDeviceType_HS2S;

    } else if (indexPath.row==3){
        vc.SDKDeviceType=HealthDeviceType_AM6;
    } else if (indexPath.row==4){
        vc.SDKDeviceType=HealthDeviceType_BG5S;
    } else if (indexPath.row==5){
        vc.SDKDeviceType=HealthDeviceType_BG1A;
    } else if (indexPath.row==6){

        vc.SDKDeviceType=HealthDeviceType_PT3SBT;
    } else if (indexPath.row==7){
        
        vc.SDKDeviceType=HealthDeviceType_BP3L;
        
    }else if (indexPath.row==8){
        
        vc.SDKDeviceType=HealthDeviceType_PO3;
    }else if (indexPath.row==9){
        
        vc.SDKDeviceType=HealthDeviceType_PO1;
    }else if (indexPath.row==10){
        
        vc.SDKDeviceType=HealthDeviceType_BG1;
    }else if (indexPath.row==11){
        
        vc.SDKDeviceType=HealthDeviceType_BG1S;
    }else if (indexPath.row==12){
        
        vc.SDKDeviceType=HealthDeviceType_BP7S;
    }else if (indexPath.row==13){
        
        vc.SDKDeviceType=HealthDeviceType_HS2SPro;
    }else if (indexPath.row==14){
        
        DeviceBP5VC*bp5vc=[[DeviceBP5VC alloc] init];
        
        [self.navigationController pushViewController:bp5vc animated:YES];
        
        return;
    }else if (indexPath.row==15){
        
        vc.SDKDeviceType=HealthDeviceType_CONTINUA_BP;
    }else if (indexPath.row==16){
        
        vc.SDKDeviceType=HealthDeviceType_KD723_V2;
    }
    
    [self.navigationController pushViewController:vc animated:YES];
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
