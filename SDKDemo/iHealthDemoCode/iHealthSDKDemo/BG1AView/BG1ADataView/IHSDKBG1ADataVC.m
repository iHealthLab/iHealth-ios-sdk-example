//
//  BG1ADataVC.m
//  iHealthDemoCode
//
//  Created by Spring on 2023/6/3.
//  Copyright © 2023 iHealth Demo Code. All rights reserved.
//

#import "IHSDKBG1ADataVC.h"

#import "IHSDKDemoTableView.h"

@interface IHSDKBG1ADataVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) NSMutableSet *mArr;
@property (strong, nonatomic) IHSDKDemoTableView *myTable;

@end

@implementation IHSDKBG1ADataVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.mArr = [NSMutableSet new];
//    [self.mArr addObject:@"test device"];
    self.myTable = [IHSDKDemoTableView groupedTable];
    self.myTable.delegate = self;
    self.myTable.dataSource = self;
    [self.myTable addToView:self.view];
    // Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.vcTitle=NSLocalizedString(@"BG1A", @"");
    
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setImage:[UIImage imageNamed:@"nav_backBtn_black"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(clickleftBarButtonItem) forControlEvents:UIControlEventTouchUpInside];
    CGFloat btnW = IHSDKNavaBarItemW;
    [self.view addSubview:leftBtn];
    [leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(btnW, btnW));
        make.left.offset(IHSDKNavaBarItemMargin);
        make.top.offset(IHSDKStatusBarH);
    }];
}

- (void)clickleftBarButtonItem{
    
  
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.mArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    IHSDKBaseCell *cell = [IHSDKBaseCell settingCell];
    cell.textLabel.text = self.mArr.allObjects[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString *deviceId = self.mArr.allObjects[indexPath.row];
    
    
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
