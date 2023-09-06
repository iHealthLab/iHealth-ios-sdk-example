//
//  DeviceAM6AlarmVC.m
//  iHealthDemoCode
//
//  Created by Spring on 2023/6/13.
//  Copyright © 2023 iHealth Demo Code. All rights reserved.
//

#import "DeviceAM6AlarmVC.h"
#import "IHSDKDemoRoundCornerButton.h"
#import "AMMacroFile.h"
#import "AMHeader.h"

#import "IHSDKDemoTableView.h"

#import "DeviceAM6AddAlarmVC.h"

@interface AM6AlarmCell : UITableViewCell

@end
@implementation AM6AlarmCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
    if (self) {
        self.backgroundColor = UIColor.whiteColor;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.textLabel setValue:IHSDK_FONT_Medium(30) forKey:NSStringFromSelector(@selector(font))];
        [self.detailTextLabel setValue:IHSDK_FONT_Medium(12) forKey:NSStringFromSelector(@selector(font))];
        [self.textLabel setValue:IHSDK_COLOR_FROM_HEX(0x002632) forKey:NSStringFromSelector(@selector(textColor))];
        [self.detailTextLabel setValue:IHSDK_COLOR_FROM_HEX(0x7E8D92) forKey:NSStringFromSelector(@selector(textColor))];
    }
    return self;
}
- (void)layoutSubviews{
    [super layoutSubviews];
    
    // 修改删除确认按钮的字体
    for (UIView *subview in self.subviews) {
        if ([NSStringFromClass([subview class]) isEqualToString:@"UITableViewCellDeleteConfirmationView"]) {
            UIView *bgView = (UIView*)[subview.subviews firstObject];
            for (UIView *obj in bgView.subviews) {
                if ([NSStringFromClass([obj class]) isEqualToString:@"UIButtonLabel"]) {
                    UILabel *lab = (UILabel*)obj;
                    lab.font = IHSDK_FONT_Regular(14);
                    break;
                }
            }
            break;
        }
    }
}


@end

@interface DeviceAM6AlarmVC ()<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) IHSDKDemoTableView *myTable;
@property (weak, nonatomic) AM6 *device;
@property (strong, nonatomic) UIView *noItemView;
@property (strong, nonatomic) IHSDKDemoRoundCornerButton *bottomBtn;
@property (strong, nonatomic) NSArray<AM6AlarmModel*> *alarmArray;

@end

@implementation DeviceAM6AlarmVC

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.myTable reloadData];
    [self reloadeUI];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)setupInterface{
    self.title = @"Alarm";
    [self.bottomBtn addToViewBottom:self.view];
    [self.view addSubview:self.myTable];
    [self.myTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).offset(IHSDK_StatusBarHeight+ (IHSDK_isIPad()?50:44));
        make.left.right.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.bottomBtn.mas_top).offset(-20);
    }];
    [self.view addSubview:self.noItemView];
    [self.noItemView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).offset(IHSDK_StatusBarHeight+ (IHSDK_isIPad()?50:44));
        make.left.right.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.bottomBtn.mas_top).offset(-20);
    }];
    
    [self reloadDataSource];
}

- (void)reloadDataSource{
    __weak typeof(self) weakSelf = self;
    
    [self.device queryAlarmListWithSuccess:^{
        
        weakSelf.alarmArray=[weakSelf.device.alarmList copy];
        
        if (weakSelf.device.alarmList.count<10) {
            [weakSelf.bottomBtn setImage:KIHSDKImageNamed(@"alarm_add_icon") forState:UIControlStateNormal];
            [weakSelf.bottomBtn setImage:KIHSDKImageNamed(@"alarm_add_icon") forState:UIControlStateHighlighted];
            [weakSelf.bottomBtn updateToDefaultStyle];
        } else {
            [weakSelf.bottomBtn setImage:KIHSDKImageNamed(@"alarm_add_icon_gray") forState:UIControlStateNormal];
            [weakSelf.bottomBtn setImage:KIHSDKImageNamed(@"alarm_add_icon_gray") forState:UIControlStateHighlighted];
            [weakSelf.bottomBtn updateToDisableStyleButRespondTouch];
        }
        [weakSelf.myTable reloadData];
        [weakSelf reloadeUI];
        
    } fail:^(int error) {
        [self showTopToast:@"Connection failed. Please keep the watch connect before setting."];
    }];
    
}

- (void)reloadeUI{
    BOOL hasData = (self.alarmArray && self.alarmArray.count>0);
    self.rightBarButtonItemStyle = hasData?IHSDKRightBarButtonItemStyleBoldText:IHSDKRightBarButtonItemStyleNone;
    self.rightBarButtonTitle = hasData?(self.myTable.isEditing?@"Done":@"Edit"):@"";
    self.rightBarButtonTitleColor = IHSDK_COLOR_FROM_HEX(0x1C9E90);
    self.noItemView.hidden = hasData;
    self.myTable.hidden = !hasData;
    if (hasData==NO) {
        self.bottomBtn.hidden = NO;
        self.myTable.editing = NO;
    }
}

#pragma mark -
- (IHSDKDemoRoundCornerButton *)bottomBtn{
    if (!_bottomBtn) {
        _bottomBtn = [IHSDKDemoRoundCornerButton buttonWithTitle:@"Add Alarm" style:IHSDKRoundCornerButtonStyle_Default];
        [_bottomBtn setImage:KIHSDKImageNamed(@"alarm_add_icon") forState:UIControlStateNormal];
        [_bottomBtn setImage:KIHSDKImageNamed(@"alarm_add_icon") forState:UIControlStateHighlighted];
        [_bottomBtn setImage:KIHSDKImageNamed(@"alarm_add_icon") forState:UIControlStateDisabled];
        _bottomBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 40);
        [_bottomBtn addTarget:self action:@selector(onClickAddBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bottomBtn;
}
- (IHSDKDemoTableView *)myTable{
    if (!_myTable) {
        _myTable = [IHSDKDemoTableView plainTable];
        _myTable.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
        _myTable.delegate = self;
        _myTable.dataSource = self;
        _myTable.rowHeight = 64;
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
- (UIView *)noItemView{
    if (!_noItemView) {
        _noItemView = ({
            UIView *view = [UIView new];
            UIImageView *imageView = [[UIImageView alloc]initWithImage:KIHSDKImageNamed(@"alarm_no_data")];
            [view addSubview:imageView];
            [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.center.mas_equalTo(view);
                make.width.mas_equalTo(117);
                make.height.mas_equalTo(72);
            }];
//            UILabel *lab = [[UILabel alloc]initWithFrame:CGRectZero text:@"No alarm has been set yet" font:IHSDK_FONT_Regular(17) textColor:IHSDK_COLOR_FROM_HEX(0xCED6DE)];
            
            UILabel *lab = [[UILabel alloc]init];
            lab.text=@"No alarm has been set yet";
            lab.textAlignment = NSTextAlignmentCenter;
            [view addSubview:lab];
            [lab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(imageView.mas_bottom).offset(20);
                make.centerX.mas_equalTo(view);
                make.height.mas_equalTo(20);
                make.width.mas_equalTo(300);
            }];
            view;
        });
    }
    return _noItemView;
}
#pragma mark -
- (NSString*)repeatStringWithMode:(uint8_t)mode{
    if (mode==0) {
        return @"Once";
    }
    if (mode==0x7F) {
        return @"Everyday";
    }
    if (mode==0x41) {
        return @"Weekends";
    }
    if (mode==0x3E) {
        return @"Weekdays";
    }
    NSArray *subs = @[@"Sun",@"Mon",@"Tue",@"Wed",@"Thu",@"Fri",@"Sat"];
    NSArray *subs2 = @[@"Sunday",@"Monday",@"Tuesday",@"Wednesday",@"Thursday",@"Friday",@"Saturday"];
    NSMutableArray *mArr = [NSMutableArray new];
    NSMutableArray *mArr2 = [NSMutableArray new];
    for (uint8_t i=0; i<7; i++) {
        if ((mode>>i & 0x01) == 0x01) {
            [mArr addObject:subs[i]];
            [mArr2 addObject:subs2[i]];
        }
    }
    
    if (mArr.count==1) {
        return mArr2[0];
    }
    
    NSString *first = mArr.firstObject;
    NSString *last = mArr.lastObject;
    if([subs indexOfObject:last]-[subs indexOfObject:first]+1 == mArr.count){
        return [NSString stringWithFormat:@"%@ to %@",first,last];
    }
    
    return [mArr componentsJoinedByString:@", "];
}
- (void)onClickSwitch:(UISwitch*)sender{
    
    NSMutableArray *mArr = [NSMutableArray new];
    [mArr addObjectsFromArray:self.alarmArray];
    
    AM6AlarmModel *model = self.alarmArray[sender.tag];
    AM6AlarmModel *model2 = [AM6AlarmModel new];
    model2.isOn = !model.isOn;
    model2.repeatMode = model.repeatMode;
    model2.date = model.date;
    [mArr replaceObjectAtIndex:sender.tag withObject:model2];
    __weak typeof(self) weakSelf = self;
    
    [self.device setAlartList:[mArr copy] success:^{
        [weakSelf reloadDataSource];
    } fail:^(int error) {
        [weakSelf.myTable reloadData];
    }];
    
}
- (void)onClickAddBtn:(id)sender{
    
    // 灰色时提示Add up to 10 alarms
    if (self.alarmArray.count>=10) {
        [self showTopToast:@"Add up to 10 alarms"];
        return;
    }
    
    DeviceAM6AddAlarmVC *vc = [DeviceAM6AddAlarmVC new];
    vc.isFromAdd = YES;
    vc.repeatMode = 0;
    
    __weak typeof(self) weakSelf = self;
    vc.callback = ^(AM6AlarmModel * _Nonnull model) {
        NSMutableArray *mArr = [NSMutableArray new];
        if (weakSelf.alarmArray) {
            [mArr addObjectsFromArray:weakSelf.alarmArray];
        }
        [mArr addObject:model];
//        [weakSelf showSyncingLoadingView];
        
        [weakSelf.device setAlartList:[mArr copy] success:^{
//            [weakSelf showSyncSuccessToast];
            [weakSelf showTopToast:@"SyncSuccess"];
            [weakSelf reloadDataSource];
            [weakSelf.myTable reloadData];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        } fail:^(int error) {
            [weakSelf showTopToast:[NSString stringWithFormat:@"error:%d",error]];
        }];
    };
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)rightBarButtonDidPressed:(id)sender{
    self.myTable.editing = !self.myTable.editing;
    self.rightBarButtonTitle = self.myTable.isEditing?@"Done":@"Edit";
    self.bottomBtn.hidden = self.myTable.isEditing;
}
#pragma mark -
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return (self.alarmArray.count==0)?0:1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.alarmArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AM6AlarmModel *model = self.alarmArray[indexPath.row];
    
    AM6AlarmCell *cell = [[AM6AlarmCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
    
    UISwitch *sw = [UISwitch new];
    sw.tag = indexPath.row;
    sw.onTintColor = IHSDK_COLOR_FROM_HEX(0x00D0B9);
    cell.accessoryView = sw;
    [sw setOn:model.isOn];
    [sw addTarget:self action:@selector(onClickSwitch:) forControlEvents:UIControlEventValueChanged];
    
    NSString *repeatDes = [self repeatStringWithMode:model.repeatMode];
    cell.detailTextLabel.text = repeatDes;
    NSString *text = [[self jak_timeStringWithMins:(model.date.hour*60+model.date.min)]uppercaseString];
    

    if ([text containsString:@"AM"] || [text containsString:@"PM"]) {

        NSArray *arr = [text componentsSeparatedByString:@" "];
        if (arr.count<2) {
            cell.textLabel.text = text;
        } else {
            NSString *value = arr[0];
            NSString *unit = [NSString stringWithFormat:@" %@",arr[1]];
            NSMutableAttributedString *mAttString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@",value,unit]];
            [mAttString addAttribute:NSForegroundColorAttributeName value:UIColor.blackColor range:NSMakeRange(0, value.length)];
            [mAttString addAttribute:NSFontAttributeName value:IHSDK_FONT_Medium(30) range:NSMakeRange(0, value.length)];
            [mAttString addAttribute:NSForegroundColorAttributeName value:UIColor.blackColor range:NSMakeRange(value.length, unit.length)];
            [mAttString addAttribute:NSFontAttributeName value:IHSDK_FONT_Medium(16) range:NSMakeRange(value.length, unit.length)];
            cell.textLabel.attributedText = mAttString;
        }

    } else {
        cell.textLabel.text = text;
    }
    
    return cell;
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSMutableArray *mArr = [NSMutableArray new];
    [mArr addObjectsFromArray:self.alarmArray];
    [mArr removeObjectAtIndex:indexPath.row];
    __weak typeof(self) weakSelf = self;
//    [self showSyncingLoadingView];
    [self.device setAlartList:[mArr copy] success:^{
//        [weakSelf showSyncSuccessToast]
        [weakSelf showTopToast:@"SyncSuccess"];
        [weakSelf reloadDataSource];
        [weakSelf.myTable reloadData];
        [weakSelf reloadeUI];
    } fail:^(int error) {
        [weakSelf showTopToast:[NSString stringWithFormat:@"error:%d",error]];
        [weakSelf.myTable reloadData];
    }];
    
}
- (nullable NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"Delete";
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    AM6AlarmModel *curModel = self.alarmArray[indexPath.row];
    
    DeviceAM6AddAlarmVC *vc = [DeviceAM6AddAlarmVC new];
    vc.isFromAdd = NO;
    vc.date = curModel.date;
    vc.isOn = curModel.isOn;
    vc.repeatMode = curModel.repeatMode;
    __weak typeof(self) weakSelf = self;
    vc.callback = ^(AM6AlarmModel * _Nonnull model) {
        NSMutableArray *mArr = [NSMutableArray new];
        [mArr addObjectsFromArray:self.alarmArray];
        
        AM6AlarmModel *model2 = [AM6AlarmModel new];
        model2.isOn = curModel.isOn;
        model2.repeatMode = model.repeatMode;
        model2.date = model.date;
        [mArr replaceObjectAtIndex:indexPath.row withObject:model2];
//        [weakSelf showSyncingLoadingView];
        [weakSelf.device setAlartList:[mArr copy] success:^{
//            [weakSelf showSyncSuccessToast];
            [weakSelf showTopToast:@"SyncSuccess"];
            [weakSelf reloadDataSource];
            [weakSelf.myTable reloadData];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        } fail:^(int error) {
//            [weakSelf showNotConnectToast];
            [weakSelf showTopToast:[NSString stringWithFormat:@"error:%d",error]];
            [weakSelf.myTable reloadData];
        }];
    };
    [self.navigationController pushViewController:vc animated:YES];
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
- (BOOL)jak_is12hoursFormat{
    //获取系统是24小时制或者12小时制
    NSString *formatStringForHours = [NSDateFormatter dateFormatFromTemplate:@"j" options:0 locale:[NSLocale currentLocale]];
    NSRange containsA = [formatStringForHours rangeOfString:@"a"];
    BOOL hasAMPM = containsA.location != NSNotFound;//hasAMPM==TURE为12小时制，否则为24小时制
    return hasAMPM;
}

@end
