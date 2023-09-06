//
//  DeviceBG1VC.m
//  iHealthDemoCode
//
//  Created by Spring on 2023/8/21.
//  Copyright © 2023 iHealth Demo Code. All rights reserved.
//

#import "DeviceBG1VC.h"

#import "IHSDKDemoTableView.h"
#import "BGHeader.h"
#import "ScanDeviceController.h"

#define CodeStr @"024C565F4C5614322D1200A02F3485B6F314378BACD61901C67200361C1C"

@interface DeviceBG1VC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) NSMutableSet *mArr;
@property (strong, nonatomic) NSMutableArray *items;
@property (strong, nonatomic) IHSDKDemoTableView *myTable;
@property (copy, nonatomic) NSString *selectedDeviceId;
@property (nonatomic, strong) BG1 *bgInstanc;
@property (nonatomic, strong) BG1Controller *bgController;
@property (strong, nonatomic) UITextView *textView;

@end

@implementation DeviceBG1VC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(needAudioPermission:) name:kNotificationNameNeedAudioPermission object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(BG1DidDisConnect:) name:kNotificationNameBG1DidDisConnect object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(audioDeviceInsert:) name:kNotificationNameAudioDeviceInsert object:nil];
    
    //增加此处理为了解决退后台插BG1回前台后始终不能使用的问题 
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startAudioModule:)                                             name:UIApplicationWillEnterForegroundNotification
                                               object: NULL];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopAudioModule:)                                             name:UIApplicationDidEnterBackgroundNotification
                                               object: NULL];
    
    self.bgController = [BG1Controller shareBG1Controller];
    [self.bgController initBGAudioModule];
}


-(void)startAudioModule:(NSNotification*)notification
{
    [[BG1Controller shareBG1Controller]initBGAudioModule];
    
}

-(void)stopAudioModule:(NSNotification*)notification
{
    [[BG1Controller shareBG1Controller]stopBGAudioModule];
}



-(void)needAudioPermission:(NSNotification *)info{
    
}

-(void)BG1DidDisConnect:(NSNotification *)info{

    self.bgInstanc = [[BG1Controller shareBG1Controller] getCurrentBG1Instance];

}

-(void)audioDeviceInsert:(NSNotification *)info{
    
    NSLog(@"插入耳机");
    
    self.bgInstanc = [[BG1Controller shareBG1Controller]getCurrentBG1Instance];
    
    if (self.bgInstanc != nil) {
        
        [self.bgInstanc commandBG1DeviceModel:@0 withDiscoverBlock:^{
            NSLog(@"Discover");
            
            self.textView.text = [self.textView.text stringByAppendingString:[NSString stringWithFormat:@"\n%@",@"Discover"]];
            
        } withDiscoverBlock:^(NSDictionary *idpsDic) {
            
            self.textView.text = [self.textView.text stringByAppendingString:[NSString stringWithFormat:@"\n%@",idpsDic]];
            
            
            NSLog(@"%@",idpsDic);
            
        } withConnectBlock:^{
            NSLog(@"Connect");
            self.textView.text = [self.textView.text stringByAppendingString:[NSString stringWithFormat:@"\n%@",@"Connect"]];
            
            
            
        } withErrorBlock:^(BG1Error errorID) {
            NSLog(@"%ld",(long)errorID);
            
            self.textView.text = [self.textView.text stringByAppendingString:[NSString stringWithFormat:@"\n%ld",(long)errorID]];
            
        }];
    }
}




- (void)setupInterface{
    self.title = self.deviceId;
    [self loadItems];
    [self.myTable addToView:self.view];
    
    [self.view addSubview:self.textView];
        
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.mas_equalTo(self.view).offset(self.navigationController.navigationBar.bounds.size.height + CTScaleByWidth(44));
            make.left.mas_equalTo(self.view);
            make.right.mas_equalTo(self.view);
            make.bottom.mas_equalTo(self.view.mas_bottom);
            make.height.mas_offset(200);
        }];
    
}
- (void)leftBarButtonDidPressed:(id)sender{
//    [self.device commandDisconnectDevice];
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

- (UITextView *)textView{
    if (_textView == nil) {
        _textView = [[UITextView alloc]init];
        _textView.textColor = [UIColor blackColor];
        _textView.selectable = NO;
        _textView.editable = NO;
        _textView.showsVerticalScrollIndicator = YES;
    }
    return _textView;
}

- (void)loadItems{
    self.items = [NSMutableArray new];
    __weak typeof(self) weakSelf = self;
    [self.items addObject:@{@"t":@"Measure",@"cb":^{

        if (weakSelf.bgInstanc != nil) {
            
            [weakSelf.bgInstanc commandBG1MeasureMode:BGMeasureMode_Blood withCodeMode:BGCodeMode_GDH withCodeString:CodeStr withSendCodeResultBlock:^{
                NSLog(@"SendCodeResult");
                
                weakSelf.textView.text = [self.textView.text stringByAppendingString:[NSString stringWithFormat:@"\n%@",@"SendCodeResult"]];
                
            } withStripInBlock:^{
                NSLog(@"StripIn");
                
                weakSelf.textView.text = [self.textView.text stringByAppendingString:[NSString stringWithFormat:@"\n%@",@"StripIn"]];
                
                
            } withBloodBlock:^{
                NSLog(@"Blood");
                
                weakSelf.textView.text = [self.textView.text stringByAppendingString:[NSString stringWithFormat:@"\n%@",@"Blood"]];
                
                
            } withResultBlock:^(NSDictionary *result) {
                NSLog(@"%@",result);
                
                weakSelf.textView.text = [self.textView.text stringByAppendingString:[NSString stringWithFormat:@"\n%@",result]];
                
                
            } withStripOutBlock:^{
                NSLog(@"StripOut");
                
                weakSelf.textView.text = [self.textView.text stringByAppendingString:[NSString stringWithFormat:@"\n%@",@"StripOut"]];
                
                
            } withErrorBlock:^(BG1Error errorID) {
                NSLog(@"--%ld",(long)errorID);
                
                if (errorID==0) {
                    int a = 0;
                }
                
                weakSelf.textView.text = [self.textView.text stringByAppendingString:[NSString stringWithFormat:@"\n%ld",(long)errorID]];
                
                
            }];

        }

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
