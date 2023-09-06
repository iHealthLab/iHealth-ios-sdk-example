//
//  DeviceAM6Settings.m
//  iHealthDemoCode
//
//  Created by Spring on 2023/6/13.
//  Copyright © 2023 iHealth Demo Code. All rights reserved.
//

#import "DeviceAM6Settings.h"

#import "AMMacroFile.h"
#import "AMHeader.h"

#import "AM6TimePicker.h"
#import "WZLatteStepsPicker.h"
#import "WZLatteCaloriesPicker.h"
#import "UILabel+WPKLabel.h"

@interface DeviceAM6Settings ()<UITableViewDelegate,UITableViewDataSource>
@property (copy, nonatomic) NSDictionary *titleDic;
@property (copy, nonatomic) NSDictionary *imageNameDic;
@property (copy, nonatomic) NSDictionary *descriptionDic;
@property (strong, nonatomic) NSMutableArray *datasourceArray;
@property (strong, nonatomic) UIButton *leftBtn;
@property (strong, nonatomic) UILabel *leftLab;
@property (strong, nonatomic) UIButton *rightBtn;
@property (strong, nonatomic) UILabel *rightLab;

@property (weak, nonatomic) AM6 *device;



#pragma mark - Notification
@property (assign, nonatomic) BOOL isAllowNotification;// 总开关
#pragma mark - Stretch Reminder
@property (assign, nonatomic) BOOL isStretchReminderOn;
@property (assign, nonatomic) NSInteger stretchReminderStartTime;// 分钟值
@property (assign, nonatomic) NSInteger stretchReminderEndTime;// 分钟值

#pragma mark - Activity Goal
@property (assign, nonatomic) BOOL isActivityGoalOn;
@property (assign, nonatomic) uint32_t stepsGoal;
@property (assign, nonatomic) uint32_t caloGoal;

#pragma mark - Do Not Disturb
@property (assign, nonatomic) BOOL isDoNotDisturbOn;
@property (assign, nonatomic) NSInteger doNotDisturbStartTime;// 分钟值
@property (assign, nonatomic) NSInteger doNotDisturbEndTime;// 分钟值
#pragma mark - Raise to Wake
@property (assign, nonatomic) BOOL isRaiseToWakeOn;
@property (assign, nonatomic) NSInteger raiseToWakeStartTime;// 分钟值
@property (assign, nonatomic) NSInteger raiseToWakeEndTime;// 分钟值
#pragma mark - Wearing Wrist
@property (assign, nonatomic) NSInteger wristHand;//与设备的定义保持一致

//@property (strong, nonatomic) WZLatteSettingsPresenter *presenter;

@end

@implementation DeviceAM6Settings

#pragma mark - life style
- (instancetype)initWithSettingsType:(AM6SettingsType)type deviceId:(nonnull NSString *)deviceId{
    self = [DeviceAM6Settings new];
    if (self) {
        self.settingsType = type;
        self.deviceId = deviceId;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
}
- (void)setupInterface{
    self.titleDic = @{
                      @(AM6SettingsType_Notification):@"Notifications",
                      @(AM6SettingsType_Stretch):@"Sedentary Reminder",
                      @(AM6SettingsType_ActivityGoal):@"Goal Reminder",
                      @(AM6SettingsType_NotDisturb):@"Do Not Disturb",
                      @(AM6SettingsType_RasieToWake):@"Raise to Wake",
                      @(AM6SettingsType_WearingWrist):@"Wearing Wrist",
                      @(AM6SettingsType_RunningInTheBackground):@"Running in the Background",
                      @(AM6SettingsType_Weather):@"Weather"
    };
    self.imageNameDic = @{@(AM6SettingsType_Notification):@"",
                          @(AM6SettingsType_Stretch):@"wzbrandy_setting_sedentaryreminder_icon",
                          @(AM6SettingsType_ActivityGoal):@"latte_settings_activity_goal_bg",
                          @(AM6SettingsType_NotDisturb):@"latte_setting_rDoNotDisturb",
                          @(AM6SettingsType_RasieToWake):@"wzbrandy_setting_raisetowake_icon",
                          @(AM6SettingsType_WearingWrist):@"",
                          @(AM6SettingsType_RunningInTheBackground):@"",
                          @(AM6SettingsType_Weather):@"latte_settings_weather_bg"};
    self.descriptionDic = @{@(AM6SettingsType_Notification):@"",
                           @(AM6SettingsType_Stretch):@"Sitting still 1 hour or more is not healthy. Turn on this function so that Wyze Watch can notify you when it happens.",
                           @(AM6SettingsType_ActivityGoal):@"Make exercise a daily habit. Turn on Activity  Goal to set goal for steps and calories. Your Wyze Watch will notify you when the goal is achieved each day.",
                           @(AM6SettingsType_NotDisturb):@"Do Not Disturb will be turned on during this time. While it is on, your watch will not receive any notifications.",
                           @(AM6SettingsType_RasieToWake):@"Wake up the device by raising your arm",
                           @(AM6SettingsType_WearingWrist):@"Please choose which wrist you wear your watch on.",
                           @(AM6SettingsType_RunningInTheBackground):@"",
                           @(AM6SettingsType_Weather):@"Check weather on Watch"};
    
    self.title = self.titleDic[@(self.settingsType)];
    
    [self.view addSubview:self.myTable];
    [self.myTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_safeAreaLayoutGuideTop);
        make.bottom.mas_equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        make.left.right.mas_equalTo(self.view);
    }];
    
    self.datasourceArray = [NSMutableArray new];
    [self queryData];
    [self.myTable reloadData];
    
//    [self checkLocationAccessIfNeed];
}
#pragma mark - lazy load
//- (WZLatteSettingsPresenter *)presenter{
//    if (!_presenter) {
//        _presenter = [WZLatteSettingsPresenter new];
//        _presenter.deviceId = self.deviceId;
//    }
//    return _presenter;
//}
- (UITableView *)myTable{
    if (!_myTable) {
        _myTable = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _myTable.rowHeight = 64;
        _myTable.delegate = self;
        _myTable.dataSource = self;
        _myTable.backgroundColor = kIHSDK_Background_Gray;
        _myTable.tableFooterView = [UIView new];
        
        if (self.settingsType == AM6SettingsType_Notification) {
            UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, IHSDK_SCREEN_W, 360)];
            _myTable.tableHeaderView = headerView;
        } else if (self.settingsType == AM6SettingsType_WearingWrist) {
            UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, IHSDK_SCREEN_W,360)];
            _myTable.tableHeaderView = headerView;
            
            CGFloat verticalMargin = (IHSDKIS_IPHONE_5?20:75);
            UIButton *maleBtn = [UIButton new];
            maleBtn.userInteractionEnabled = NO;
            maleBtn.tag = 0;
            [maleBtn setImage:KIHSDKImageNamed(@"wyze_band_wearing_left_icon_prs") forState:UIControlStateSelected];
            [maleBtn setImage:KIHSDKImageNamed(@"wyze_band_wearing_left_icon") forState:UIControlStateNormal];
            [maleBtn setImage:KIHSDKImageNamed(@"wyze_band_wearing_left_icon_prs") forState:UIControlStateHighlighted];

            [headerView addSubview:maleBtn];
            [maleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(headerView).offset(verticalMargin);
                make.centerX.mas_equalTo(headerView);
            }];
//            UILabel *leftLab = [[UILabel alloc]initWithFrame:CGRectZero text:@"Left" font:JAK_FONT_Normal(14) textColor:kJAK_COLOR_FROM_HEX(0x7E8D92)];
            UILabel *leftLab = [[UILabel alloc]init];
            
            leftLab.text=@"Left";
            
            leftLab.textAlignment = NSTextAlignmentCenter;
            [headerView addSubview:leftLab];
            [leftLab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(maleBtn.mas_bottom).offset(10);
                make.centerX.width.mas_equalTo(maleBtn);
                make.height.mas_equalTo(18);
            }];

            UIButton *femaleBtn = [UIButton new];
            femaleBtn.userInteractionEnabled = NO;
            femaleBtn.tag = 1;
            [femaleBtn setImage:KIHSDKImageNamed(@"wyze_band_wearing_right_icon_prs") forState:UIControlStateSelected];
            [femaleBtn setImage:KIHSDKImageNamed(@"wyze_band_wearing_right_icon") forState:UIControlStateNormal];
            [femaleBtn setImage:KIHSDKImageNamed(@"wyze_band_wearing_right_icon_prs") forState:UIControlStateHighlighted];

            [headerView addSubview:femaleBtn];
            [femaleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(maleBtn);
                make.centerX.mas_equalTo(headerView);
            }];
            UILabel *rightLab = [[UILabel alloc]initWithFrame:CGRectZero text:@"Right" font:IHSDK_FONT_Normal(14) textColor:IHSDK_COLOR_FROM_HEX(0x7E8D92)];
            
//            UILabel *rightLab = [[UILabel alloc]init];
//
//            rightLab.text=@"Right";
            
            rightLab.textAlignment = NSTextAlignmentCenter;
            [headerView addSubview:rightLab];
            [rightLab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(femaleBtn.mas_bottom).offset(10);
                make.centerX.width.mas_equalTo(femaleBtn);
                make.height.mas_equalTo(18);
            }];
            self.leftBtn = maleBtn;
            self.rightBtn = femaleBtn;
            self.leftLab = leftLab;
            self.rightLab = rightLab;
            
            UIImageView *myImageView = [[UIImageView alloc]initWithImage:KIHSDKImageNamed(self.imageNameDic[@(self.settingsType)])];
            [headerView addSubview:myImageView];
            [myImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.centerX.mas_equalTo(headerView);
                make.width.mas_equalTo(375);
                make.height.mas_equalTo(250);
            }];
            UILabel *lab = [[UILabel alloc]initWithFrame:CGRectZero text:self.descriptionDic[@(self.settingsType)] font:IHSDK_FONT_Regular(17) textColor:IHSDK_COLOR_FROM_HEX(0x22262B) numberOfLines:0];
          
            
            lab.textAlignment = NSTextAlignmentCenter;
            [headerView addSubview:lab];
            [lab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(myImageView.mas_bottom).offset(10);
                make.left.mas_equalTo(headerView).offset(20);
                make.centerX.mas_equalTo(headerView);
                make.height.mas_greaterThanOrEqualTo(10);
            }];
        } else if (self.settingsType == AM6SettingsType_RunningInTheBackground) {
            
        } else {
            UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, IHSDK_SCREEN_W, (self.settingsType==AM6SettingsType_Weather)?320:360)];
            
            
            UIImageView *myImageView = [[UIImageView alloc]initWithImage:KIHSDKImageNamed(self.imageNameDic[@(self.settingsType)])];
            [headerView addSubview:myImageView];
            [myImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.centerX.mas_equalTo(headerView);
                make.width.mas_equalTo(375);
                make.height.mas_equalTo(250);
            }];
            UILabel *lab = [[UILabel alloc]initWithFrame:CGRectZero text:self.descriptionDic[@(self.settingsType)] font:IHSDK_FONT_Normal(16) textColor:IHSDK_COLOR_FROM_HEX(0x393F47) numberOfLines:0];
            
            lab.textAlignment = NSTextAlignmentCenter;
            [headerView addSubview:lab];
            [lab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(myImageView.mas_bottom).offset(10);
                make.centerX.mas_equalTo(headerView);
                make.width.mas_equalTo(IHSDK_SCREEN_W-40);
                make.height.mas_greaterThanOrEqualTo(10);
            }];
            _myTable.tableHeaderView = headerView;
        }
    }
    return _myTable;
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
#pragma mark - data
- (void)queryData{
    
    __weak typeof(self) weakSelf = self;
//    AM6DeviceSuccessBlock callback = ^{
//        [weakSelf hideLoading];
//        [weakSelf reloadItems];
//        [weakSelf.myTable reloadData];
//    };
//    AM6DeviceErrorBlock errorCallback = ^(int error){
//        WZLatteErrorLog(@"%d fail: %d",(int)self.settingsType,error);
//        [weakSelf hideLoading];
//        [weakSelf showNotConnectToast];
//        [weakSelf reloadItems];
//        [weakSelf.myTable reloadData];
//    };
    [self showLoading];
    switch (self.settingsType) {
        case AM6SettingsType_ActivityGoal:{
            
            [self.device queryGoalReminderWithSuccess:^{
                
                weakSelf.isActivityGoalOn=weakSelf.device.isActivityGoalOn;
                
                weakSelf.caloGoal=weakSelf.device.caloGoal;
                
                weakSelf.stepsGoal=weakSelf.device.stepsGoal;
                
                [weakSelf hideLoading];
                [weakSelf reloadItems];
                [weakSelf.myTable reloadData];
            } fail:^(int error) {
                
                
                        [weakSelf hideLoading];
                [IHSDKDemoToast showTipWithTitle:@"Device Not Connected"];
                        [weakSelf reloadItems];
                        [weakSelf.myTable reloadData];
            }];
            
        }
            break;
        case AM6SettingsType_Stretch:{
            
            [self.device queryStretchReminderWithSuccess:^{
                
                weakSelf.isStretchReminderOn=weakSelf.device.isStretchReminderOn;
                
                weakSelf.stretchReminderStartTime=weakSelf.device.stretchReminderStartTime;
                
                weakSelf.stretchReminderEndTime=weakSelf.device.stretchReminderEndTime;
                
                [weakSelf hideLoading];
                [weakSelf reloadItems];
                [weakSelf.myTable reloadData];
            } fail:^(int error) {
                [weakSelf hideLoading];
        [IHSDKDemoToast showTipWithTitle:@"Device Not Connected"];
                [weakSelf reloadItems];
                [weakSelf.myTable reloadData];
            }];
           
        }
            break;
        case AM6SettingsType_RasieToWake:{
            
            [self.device queryRaiseWakeWithSuccess:^{
                
                weakSelf.isRaiseToWakeOn=weakSelf.device.isRaiseToWakeOn;
                
                weakSelf.raiseToWakeStartTime=weakSelf.device.raiseToWakeStartTime;
                
                weakSelf.raiseToWakeEndTime=weakSelf.device.raiseToWakeEndTime;
                
                [weakSelf hideLoading];
                [weakSelf reloadItems];
                [weakSelf.myTable reloadData];
            } fail:^(int error) {
                [weakSelf hideLoading];
        [IHSDKDemoToast showTipWithTitle:@"Device Not Connected"];
                [weakSelf reloadItems];
                [weakSelf.myTable reloadData];
            }];
            
        }
            break;
        case AM6SettingsType_NotDisturb:{
            
            [self.device queryNotDisturbWithSuccess:^{
                
                weakSelf.isDoNotDisturbOn=weakSelf.device.isDoNotDisturbOn;
                
                weakSelf.doNotDisturbStartTime=weakSelf.device.doNotDisturbStartTime;
                
                weakSelf.doNotDisturbEndTime=weakSelf.device.doNotDisturbEndTime;
                
                [weakSelf hideLoading];
                [weakSelf reloadItems];
                [weakSelf.myTable reloadData];
            } fail:^(int error) {
                [weakSelf hideLoading];
        [IHSDKDemoToast showTipWithTitle:@"Device Not Connected"];
                [weakSelf reloadItems];
                [weakSelf.myTable reloadData];
            }];
            

        }
            break;
        default:
            break;
    }
}
- (void)reloadItems{
    [self.datasourceArray removeAllObjects];
    
    __weak typeof(self) weakSelf = self;
//    WZLatteDeviceSuccessBlock successBlock = ^{
//        [weakSelf showSyncSuccessToast];
//        [weakSelf reloadItems];
//        [weakSelf.myTable reloadData];
//    };
//    WZLatteDeviceErrorBlock errorBlock = ^(int error){
//        [weakSelf handelDeviceError:error];
//        [weakSelf reloadItems];
//        [weakSelf.myTable reloadData];
//    };
    
    AM6SettingsItemSwitchChangeBlock swBlock = ^(BOOL isOn) {
//        [weakSelf showSyncingLoadingView];
        switch (weakSelf.settingsType) {
            case AM6SettingsType_Stretch:{
                [weakSelf.device setStretchReminderEnable:isOn start:weakSelf.stretchReminderStartTime end:weakSelf.stretchReminderEndTime success:^{
                    
                    weakSelf.isStretchReminderOn=isOn;
                    
                    [weakSelf reloadItems];
                    [weakSelf.myTable reloadData];
                    
                } fail:^(int error) {
                    
//                            [weakSelf handelDeviceError:error];
                            [weakSelf reloadItems];
                            [weakSelf.myTable reloadData];
                }];
            }
                break;
            case AM6SettingsType_ActivityGoal:
            {
                [weakSelf.device setGoalReminderEnable:isOn calorie:weakSelf.caloGoal steps:weakSelf.stepsGoal success:^{
                    
                    weakSelf.isActivityGoalOn=isOn;
                    
                    [weakSelf reloadItems];
                    [weakSelf.myTable reloadData];
                    
                } fail:^(int error) {
                    [weakSelf reloadItems];
                    [weakSelf.myTable reloadData];
                }];
            }
                break;
            case AM6SettingsType_NotDisturb:{
                [weakSelf.device setNotDisturbEnable:isOn start:weakSelf.doNotDisturbStartTime end:weakSelf.doNotDisturbEndTime success:^{
                    
                    weakSelf.isDoNotDisturbOn=isOn;
                    [weakSelf reloadItems];
                    [weakSelf.myTable reloadData];
                    
                } fail:^(int error) {
                    
                    [weakSelf reloadItems];
                    [weakSelf.myTable reloadData];
                    
                }];
            }
                break;
            case AM6SettingsType_RasieToWake:{
                [weakSelf.device setRaiseWakeEnable:isOn start:weakSelf.raiseToWakeStartTime end:weakSelf.raiseToWakeEndTime success:^{
                    
                    weakSelf.isRaiseToWakeOn=isOn;
                    [weakSelf reloadItems];
                    [weakSelf.myTable reloadData];
                    
                } fail:^(int error) {
                    
                }];
            }
                break;
            default:
                break;
        }
        
    };
    
    
    switch (self.settingsType) {
        case AM6SettingsType_Notification:
        {
            
        }
            break;
            
        case AM6SettingsType_Stretch:
        {
            AM6SettingsItem *item1 = [AM6SettingsItem new];
            item1.title = @"Sedentary Reminder";
            item1.cellType = AM6SettingsCellType_Switch;
            item1.switchStatus = self.isStretchReminderOn;
            item1.onChangeSwitchBlock = swBlock;
            [self.datasourceArray addObject:@[item1]];
            
            if (item1.switchStatus) {
                AM6SettingsItem *item21 = [AM6SettingsItem new];
                item21.title = @"Start Time";
                item21.detail = [self jak_timeStringWithMins:self.stretchReminderStartTime];
                item21.cellType = AM6SettingsCellType_StartTime;
               AM6SettingsItem *item22 = [AM6SettingsItem new];
                item22.title = @"End Time";
                NSString *endString = [self jak_timeStringWithMins:self.stretchReminderEndTime];
                if (self.stretchReminderEndTime<=self.stretchReminderStartTime) {
                    endString = [NSString stringWithFormat:@"Next day %@",endString];
                }
                item22.detail = endString;
                item22.cellType = AM6SettingsCellType_StartTime;
                [self.datasourceArray addObject:@[item21,item22]];
            }
        }
            break;
        case AM6SettingsType_ActivityGoal:
        {
            AM6SettingsItem *item1 = [AM6SettingsItem new];
            item1.title = @"Activity Goal";
            item1.cellType = AM6SettingsCellType_Switch;
            item1.switchStatus = self.isActivityGoalOn;
            item1.onChangeSwitchBlock = swBlock;
            [self.datasourceArray addObject:@[item1]];
            
            if (item1.switchStatus == YES) {
                AM6SettingsItem *item21 = [AM6SettingsItem new];
                item21.title = @"Steps";
                item21.detail = [NSString stringWithFormat:@"%ld",(long)self.stepsGoal];
                item21.cellType = AM6SettingsCellType_StartTime;
                AM6SettingsItem *item22 = [AM6SettingsItem new];
                item22.title = @"Calories";
                item22.detail = [NSString stringWithFormat:@"%ld",(long)self.caloGoal];
                item22.cellType = AM6SettingsCellType_StartTime;
                [self.datasourceArray addObject:@[item21,item22]];
            }
            

        }
            break;
        case AM6SettingsType_NotDisturb:
        {
            AM6SettingsItem *item1 = [AM6SettingsItem new];
            item1.title = @"Do Not Disturb";
            item1.cellType = AM6SettingsCellType_Switch;
            item1.switchStatus = self.isDoNotDisturbOn;
            item1.onChangeSwitchBlock = swBlock;
            [self.datasourceArray addObject:@[item1]];
            
            if (item1.switchStatus == YES) {
                AM6SettingsItem *item21 = [AM6SettingsItem new];
                item21.title = @"Start Time";
                item21.detail = [self jak_timeStringWithMins:self.doNotDisturbStartTime];
                item21.cellType = AM6SettingsCellType_StartTime;
                AM6SettingsItem *item22 = [AM6SettingsItem new];
                item22.title = @"End Time";
                NSString *endString = [self jak_timeStringWithMins:self.doNotDisturbEndTime];
                if (self.doNotDisturbEndTime<=self.doNotDisturbStartTime) {
                    endString = [NSString stringWithFormat:@"Next day %@",endString];
                }
                item22.detail = endString;
                item22.cellType = AM6SettingsCellType_EndTime;
                [self.datasourceArray addObject:@[item21,item22]];
            }
            
        }
            break;
        case AM6SettingsType_RasieToWake:
        {
            AM6SettingsItem *item1 = [AM6SettingsItem new];
            item1.title = @"Raise to Wake";
            item1.cellType = AM6SettingsCellType_Switch;
            item1.switchStatus = self.isRaiseToWakeOn;
            item1.onChangeSwitchBlock = swBlock;
            [self.datasourceArray addObject:@[item1]];
            
            if (item1.switchStatus == YES) {
                AM6SettingsItem *item21 = [AM6SettingsItem new];
                item21.title = @"Start Time";
                item21.detail = [self jak_timeStringWithMins:self.raiseToWakeStartTime];
                item21.cellType = AM6SettingsCellType_StartTime;
                AM6SettingsItem *item22 = [AM6SettingsItem new];
                item22.title = @"End Time";
                NSString *endString = [self jak_timeStringWithMins:self.raiseToWakeEndTime];
                if (self.raiseToWakeEndTime<=self.raiseToWakeStartTime) {
                    endString = [NSString stringWithFormat:@"Next day %@",endString];
                }
                item22.detail = endString;
                item22.cellType = AM6SettingsCellType_EndTime;
                [self.datasourceArray addObject:@[item21,item22]];
            }
        }
            break;
        case AM6SettingsType_WearingWrist:
        {
            BOOL isLeft = (self.wristHand==0);
            AM6SettingsItem *item1 = [AM6SettingsItem new];
            item1.title = @"Wearing Wrist";
            item1.detail = isLeft?@"Left Hand":@"Right Hand";
            item1.cellType = AM6SettingsCellType_Indicator;
            [self.datasourceArray addObject:@[item1]];
            
            self.leftBtn.selected = isLeft;
            self.leftBtn.hidden = !isLeft;
            self.rightBtn.selected = !isLeft;
            self.rightBtn.hidden = isLeft;
            self.leftLab.textColor = isLeft?kIHSDK_Text_Wyze_Green:IHSDK_COLOR_FROM_HEX(0x7E8D92);
            self.leftLab.hidden = !isLeft;
            self.rightLab.textColor = (!isLeft)?kIHSDK_Text_Wyze_Green:IHSDK_COLOR_FROM_HEX(0x7E8D92);
            self.rightLab.hidden = isLeft;
            
        }
            break;
        case AM6SettingsType_RunningInTheBackground:
        {
            
        }
            break;
        
        default:
            break;
    }
}
#pragma mark - tableview delegate
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 20;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.datasourceArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.datasourceArray[section] count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AM6SettingsItem *item = self.datasourceArray[indexPath.section][indexPath.row];
    AM6SettingsCell *cell = [[AM6SettingsCell alloc]initWithType:self.settingsType item:item];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    if (self.settingsType == AM6SettingsType_Stretch || self.settingsType == AM6SettingsType_NotDisturb || self.settingsType == AM6SettingsType_RasieToWake) {
        if (section==1) {
            if (row==0) {
                [self showSelectStartTimePicker];
            } else {
                [self showSelectEndTimePicker];
            }
        }
    } else if (self.settingsType == AM6SettingsType_ActivityGoal) {
        if (section==1) {
            if (row==0) {
                [self showStepPicker];
            } else {
                [self showCaloriesPicker];
            }
        }
    } else if (self.settingsType == AM6SettingsType_WearingWrist){
//        [self showWearingWristPicker];
        
    }
}

#pragma mark - edit
- (void)showSelectStartTimePicker {
    
    NSArray *currentValuesString = nil;
    switch (self.settingsType) {
        case AM6SettingsType_Stretch:
            currentValuesString = [self jak_timeStringArrayWithMins:self.stretchReminderStartTime];
            break;
        case AM6SettingsType_NotDisturb:
            currentValuesString = [self jak_timeStringArrayWithMins:self.doNotDisturbStartTime];
            break;
        case AM6SettingsType_RasieToWake:
            currentValuesString = [self jak_timeStringArrayWithMins:self.raiseToWakeStartTime];
            break;
        default:
            break;
    }
    
    __weak typeof(self) weakSelf = self;
//    WZLatteDeviceSuccessBlock successBlock = ^{
//        [weakSelf showSyncSuccessToast];
//
//        [weakSelf reloadItems];
//        [weakSelf.myTable reloadData];
//    };
//    WZLatteDeviceErrorBlock errorBlock = ^(int error){
//        [weakSelf handelDeviceError:error];
//        [weakSelf reloadItems];
//        [weakSelf.myTable reloadData];
//    };
    
    AM6TimePicker *timePicker = [[AM6TimePicker alloc]initWithTitle:@"Start Time" is12hoursFormat:[self jak_is12hoursFormat] currentValues:currentValuesString];
    timePicker.onSelctionCallback = ^(NSInteger hours, NSInteger minutes) {
        NSInteger min = hours*60+minutes;
//        WZLatteInfoLog(@"start min:%d",(int)min);
//        [weakSelf showSyncingLoadingView];
        switch (weakSelf.settingsType) {
            case AM6SettingsType_Stretch:{
                [weakSelf.device setStretchReminderEnable:weakSelf.isStretchReminderOn start:min end:weakSelf.stretchReminderEndTime success:^{
                    weakSelf.stretchReminderStartTime=min;
                    [weakSelf reloadItems];
                   [weakSelf.myTable reloadData];
                    
                } fail:^(int error) {
                    [weakSelf reloadItems];
                   [weakSelf.myTable reloadData];
                }];
            }
                break;
            case AM6SettingsType_NotDisturb:{
                [weakSelf.device setNotDisturbEnable:weakSelf.isDoNotDisturbOn start:min end:weakSelf.doNotDisturbEndTime success:^{
                    
                    weakSelf.doNotDisturbStartTime=min;
                    [weakSelf reloadItems];
                   [weakSelf.myTable reloadData];
                    
                } fail:^(int error) {
                    
                    [weakSelf reloadItems];
                   [weakSelf.myTable reloadData];
                    
                }];
            }
                break;
            case AM6SettingsType_RasieToWake:{
                [weakSelf.device setRaiseWakeEnable:weakSelf.isRaiseToWakeOn start:min end:weakSelf.raiseToWakeEndTime success:^{
                    
                    weakSelf.raiseToWakeStartTime=min;
                    [weakSelf reloadItems];
                   [weakSelf.myTable reloadData];
                    
                } fail:^(int error) {
                    
                    [weakSelf reloadItems];
                   [weakSelf.myTable reloadData];
                    
                }];
            }
                break;
            default:
                break;
        }
    };
    [timePicker show];
}
- (void)showSelectEndTimePicker {
    
    NSArray *currentValuesString = nil;
    switch (self.settingsType) {
        case AM6SettingsType_Stretch:
            currentValuesString = [self jak_timeStringArrayWithMins:self.stretchReminderEndTime];
            break;
        case AM6SettingsType_NotDisturb:
            currentValuesString = [self jak_timeStringArrayWithMins:self.doNotDisturbEndTime];
            break;
        case AM6SettingsType_RasieToWake:
            currentValuesString = [self jak_timeStringArrayWithMins:self.raiseToWakeEndTime];
            break;
        default:
            break;
    }
    
    __weak typeof(self) weakSelf = self;
//    WZLatteDeviceSuccessBlock successBlock = ^{
//        [weakSelf showSyncSuccessToast];
//        [weakSelf reloadItems];
//        [weakSelf.myTable reloadData];
//    };
//    WZLatteDeviceErrorBlock errorBlock = ^(int error){
//        [weakSelf handelDeviceError:error];
//        [weakSelf reloadItems];
//        [weakSelf.myTable reloadData];
//    };
    AM6TimePicker *timePicker = [[AM6TimePicker alloc]initWithTitle:@"End Time" is12hoursFormat:[self jak_is12hoursFormat] currentValues:currentValuesString];
    timePicker.onSelctionCallback = ^(NSInteger hours, NSInteger minutes) {
        NSInteger min = hours*60+minutes;
//        [weakSelf showSyncingLoadingView];
        switch (weakSelf.settingsType) {
            case AM6SettingsType_Stretch:{
                [weakSelf.device setStretchReminderEnable:weakSelf.isStretchReminderOn start:weakSelf.stretchReminderStartTime end:min success:^{
                    
                    weakSelf.stretchReminderEndTime=min;
                    [weakSelf reloadItems];
                   [weakSelf.myTable reloadData];
                    
                } fail:^(int error) {
                    
                    [weakSelf reloadItems];
                   [weakSelf.myTable reloadData];
                    
                }];
            }
                break;
            case AM6SettingsType_NotDisturb:{
                [weakSelf.device setNotDisturbEnable:weakSelf.isDoNotDisturbOn start:weakSelf.doNotDisturbStartTime end:min success:^{
                    
                    
                    weakSelf.doNotDisturbEndTime=min;
                    [weakSelf reloadItems];
                   [weakSelf.myTable reloadData];
                    
                } fail:^(int error) {
                    
                    [weakSelf reloadItems];
                   [weakSelf.myTable reloadData];
                    
                }];
            }
                break;
            case AM6SettingsType_RasieToWake:{
                [weakSelf.device setRaiseWakeEnable:weakSelf.isRaiseToWakeOn start:weakSelf.raiseToWakeStartTime end:min success:^{
                    
                    weakSelf.raiseToWakeEndTime=min;
                    [weakSelf reloadItems];
                   [weakSelf.myTable reloadData];
                    
                } fail:^(int error) {
                    [weakSelf reloadItems];
                   [weakSelf.myTable reloadData];
                }];
            }
                break;
            default:
                break;
        }
    };
    [timePicker show];
}
- (void)showStepPicker{
    __weak typeof(self) weakSelf = self;
    WZLatteStepsPicker *picker = [[WZLatteStepsPicker alloc]initWithTitle:@"Steps" currentValue:self.stepsGoal];
    picker.onSelctionCallback = ^(NSInteger value) {
//        [weakSelf showSyncingLoadingView];
        [weakSelf.device setGoalReminderEnable:self.isActivityGoalOn calorie:self.caloGoal steps:(uint32_t)value success:^{
//            [weakSelf showSyncSuccessToast];
            self.stepsGoal=(uint32_t)value;
            [weakSelf reloadItems];
            [weakSelf.myTable reloadData];
        } fail:^(int error) {
//            [weakSelf handelDeviceError:error];
            [weakSelf reloadItems];
            [weakSelf.myTable reloadData];
        }];
    };
    [picker show];
}
- (void)showCaloriesPicker{
    __weak typeof(self) weakSelf = self;
    WZLatteCaloriesPicker *picker = [[WZLatteCaloriesPicker alloc]initWithTitle:@"Calories" currentValue:self.caloGoal];
    picker.onSelctionCallback = ^(NSInteger value) {
//        [weakSelf showSyncingLoadingView];
        [weakSelf.device setGoalReminderEnable:self.isActivityGoalOn calorie:(uint32_t)value steps:self.stepsGoal success:^{
            self.caloGoal=(uint32_t)value;
//            [weakSelf showSyncSuccessToast];
            [weakSelf reloadItems];
            [weakSelf.myTable reloadData];
        } fail:^(int error) {

//            [weakSelf handelDeviceError:error];
            [weakSelf reloadItems];
            [weakSelf.myTable reloadData];
        }];
    };
    [picker show];
}
//- (void)showWearingWristPicker{
//    __weak typeof(self) weakSelf = self;
//    WPKActionSheet *sheet = [[WPKActionSheet alloc] initWPKActionTitle:nil];
//    WPKAction *yesAction = [WPKAction actionWithTitle:@"Left Hand" handler:^(WPKAction * _Nonnull action) {
//        [weakSelf showSyncingLoadingView];
//        [weakSelf.presenter setWearHand:0 success:^{
//
//            [weakSelf showSyncSuccessToast];
//            [weakSelf reloadItems];
//            [weakSelf.myTable reloadData];
//        } fail:^(int error) {
//
//            [weakSelf handelDeviceError:error];
//            [weakSelf reloadItems];
//            [weakSelf.myTable reloadData];
//        }];
//    }];
//    [sheet addAction:yesAction];
//    WPKAction *noAction = [WPKAction actionWithTitle:@"Right Hand" handler:^(WPKAction * _Nonnull action) {
//        [weakSelf.presenter setWearHand:1 success:^{
//            [weakSelf showSyncSuccessToast];
//            [weakSelf reloadItems];
//            [weakSelf.myTable reloadData];
//        } fail:^(int error) {
//            [weakSelf handelDeviceError:error];
//            [weakSelf reloadItems];
//            [weakSelf.myTable reloadData];
//        }];
//    }];
//    [sheet addAction:noAction];
//    WPKAction *cancelAction = [WPKAction actionWithTitle:@"Cancel" handler:^(WPKAction * _Nonnull action) {
//    }];
//    [sheet addAction:cancelAction];
//    [sheet show];
//}
//- (void)showTemperatureUnitPicker{
//    __weak typeof(self) weakSelf = self;
//    WPKActionSheet *sheet = [[WPKActionSheet alloc] initWPKActionTitle:nil];
//    WPKAction *yesAction = [WPKAction actionWithTitle:@"Fahrenheit ℉" handler:^(WPKAction * _Nonnull action) {
//        [weakSelf showSyncingLoadingView];
//        [weakSelf.presenter setTemperatureUnit:1  success:^{
//
//            [weakSelf showSyncSuccessToast];
//            [weakSelf reloadItems];
//            [weakSelf.myTable reloadData];
//        } fail:^(int error) {
//
//            [weakSelf handelDeviceError:error];
//            [weakSelf reloadItems];
//            [weakSelf.myTable reloadData];
//        }];
//    }];
//    [sheet addAction:yesAction];
//    WPKAction *noAction = [WPKAction actionWithTitle:@"Celsius ℃" handler:^(WPKAction * _Nonnull action) {
//        [weakSelf.presenter setTemperatureUnit:0  success:^{
//            [weakSelf showSyncSuccessToast];
//            [weakSelf reloadItems];
//            [weakSelf.myTable reloadData];
//        } fail:^(int error) {
//            [weakSelf handelDeviceError:error];
//            [weakSelf reloadItems];
//            [weakSelf.myTable reloadData];
//        }];
//    }];
//    [sheet addAction:noAction];
//    WPKAction *cancelAction = [WPKAction actionWithTitle:@"Cancel" handler:^(WPKAction * _Nonnull action) {
//    }];
//    [sheet addAction:cancelAction];
//    [sheet show];
//}
#pragma mark -
- (void)handelDeviceError:(int)error{
//    if (error==JAKDeviceError_DeviceDisconnect) {
//        if ([[WZLatteDeviceManager manager]getBluetoothState]!=JAKBluetoothState_PoweredOn) {
//            [self showBluetoothIsOffToast];
//        } else {
//            [self showNotConnectToast];
//        }
//    } else {
//        [self showSyncFailToast];
//    }
}


- (BOOL)jak_is12hoursFormat{
    //获取系统是24小时制或者12小时制
    NSString *formatStringForHours = [NSDateFormatter dateFormatFromTemplate:@"j" options:0 locale:[NSLocale currentLocale]];
    NSRange containsA = [formatStringForHours rangeOfString:@"a"];
    BOOL hasAMPM = containsA.location != NSNotFound;//hasAMPM==TURE为12小时制，否则为24小时制
    return hasAMPM;
}

- (NSString*)jak_timeStringWithMins:(NSInteger)time{
    
    if (time<0 || time>24*60-1) {
        return @"";
    }
    
    int hour = (int)time/60;
    int min = time%60;
    
    BOOL is12HourFormat = [self jak_is12hoursFormat];
    if (is12HourFormat) {
        if (hour==0){
            // am
            return [NSString stringWithFormat:@"%02d:%02d AM",12,min];
        }
        else if (hour<12) {
            // am
            return [NSString stringWithFormat:@"%02d:%02d AM",hour,min];
        } else if (hour==12){
            // pm
            return [NSString stringWithFormat:@"%02d:%02d PM",hour,min];
        } else {
            // pm
            return [NSString stringWithFormat:@"%02d:%02d PM",hour-12,min];
        }
    } else {
        return [NSString stringWithFormat:@"%02d:%02d",hour,min];
    }
}


- (nullable NSArray*)jak_timeStringArrayWithMins:(NSInteger)time{
    if (time<0 || time>24*60-1) {
        return nil;
    }
    
    int hour = (int)time/60;
    int min = time%60;
    
    BOOL is12HourFormat = [self jak_is12hoursFormat];
    if (is12HourFormat) {
        if (hour==0){
            // am
            return [NSArray arrayWithObjects:@"12",[NSString stringWithFormat:@"%d",min],@"AM", nil];
        }
        else if (hour<12) {
            // am
            return [NSArray arrayWithObjects:[NSString stringWithFormat:@"%d",hour],[NSString stringWithFormat:@"%d",min],@"AM", nil];
        } else if (hour==12){
            // pm
            return [NSArray arrayWithObjects:@"12",[NSString stringWithFormat:@"%d",min],@"PM", nil];
        } else {
            // pm
            return [NSArray arrayWithObjects:[NSString stringWithFormat:@"%d",hour-12],[NSString stringWithFormat:@"%d",min],@"PM", nil];
        }
    } else {
        return [NSArray arrayWithObjects:[NSString stringWithFormat:@"%d",hour],[NSString stringWithFormat:@"%d",min], nil];
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
