//
//  IHSDKGeneralVC.m
//  iHealthDemoCode
//
//  Created by Spring on 2023/5/30.
//  Copyright © 2023 iHealth Demo Code. All rights reserved.
//

#import "IHSDKGeneralVC.h"

#import "IHSDKDemoTableView.h"

#define APP_VERSION [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
#define APP_BUILD [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]

@interface IHSDKGeneralVC ()<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) IHSDKDemoTableView *myTable;
@property (copy, nonatomic) NSArray *titles;

@end

@implementation IHSDKGeneralVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupInterface];
}
- (void)setupInterface{
//    self.leftBarButtonItemStyle = IHSDKLeftBarButtonItemStyleNone;
    self.myTable = [IHSDKDemoTableView groupedTable];
    self.myTable.delegate = self;
    self.myTable.dataSource = self;
    [self.myTable addToView:self.view];
    
    self.titles = @[NSLocalizedString(@"Open-source Code", @""),NSLocalizedString(@"Document and FAQ", @""),NSLocalizedString(@"Share Log", @""),NSLocalizedString(@"Contact Us", @""),NSLocalizedString(@"App version", @"")];
    
}
#pragma mark - Lazy
#pragma mark -
- (void)leftBarButtonDidPressed:(id)sender{
    
}
- (void)rightBarButtonDidPressed:(id)sender{
//    [[WZLatteDeviceManager manager]stopScan];
//    [[WZLatteDeviceManager manager]startScan];
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
    
    if (indexPath.row==4) {
        
        [cell isShowAccessoryView:NO];
        
        cell.detailTextLabel.text=APP_VERSION;
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row==0) {
       
    } else if (indexPath.row==1) {
        
    } else if (indexPath.row==2){
        
    

    } else if (indexPath.row==3){
        
    } else if (indexPath.row==4){
    
    }
    
//    [self.navigationController pushViewController:vc animated:YES];
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
