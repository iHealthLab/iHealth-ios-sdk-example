//
//  DeviceAM6AddAlarmVC.m
//  iHealthDemoCode
//
//  Created by Spring on 2023/6/13.
//  Copyright © 2023 iHealth Demo Code. All rights reserved.
//

#import "DeviceAM6AddAlarmVC.h"
#import "UIButton+WPKButton.h"
@interface DeviceAM6AddAlarmVC ()
@property (strong, nonatomic) UIDatePicker *datePicker;
@end

@implementation DeviceAM6AddAlarmVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)setupInterface{
    self.title = @"Alarm";
    self.leftBarButtonTitle = @"Cancel";
    self.leftBarButtonTitleColor = IHSDK_COLOR_FROM_HEX(0x1C9E90);
    self.leftBarButtonItemStyle = IHSDKLeftBarButtonItemStyleBoldText;
    self.rightBarButtonTitle = @"Save";
    self.rightBarButtonItemStyle = IHSDKRightBarButtonItemStyleBoldText;
    self.rightBarButtonTitleColor = IHSDK_COLOR_FROM_HEX(0x1C9E90);
    [self.view addSubview:self.datePicker];
    [self.datePicker mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view);
        make.top.mas_equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(10);
        make.height.mas_equalTo(195);
    }];
    //    UILabel *myLab = [[UILabel alloc]initWithFrame:CGRectZero text:@"Repeat" font:JAK_FONT_Bold(13) textColor:kJAK_COLOR_FROM_HEX(0x515963)];
    UILabel *myLab = [[UILabel alloc]init];
    
    myLab.text=@"Repeat";
    
    [self.view addSubview:myLab];
    [myLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(16);
        make.top.mas_equalTo(self.datePicker.mas_bottom).offset(10);
    }];
    
    UIView *repeatContainer = [UIView new];
    repeatContainer.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:repeatContainer];
    [repeatContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.datePicker.mas_bottom).offset(36);
        make.left.right.mas_equalTo(self.view);
        make.height.mas_equalTo(98);
    }];
    
    
    NSArray *arr = @[@"Sun",@"Mon",@"Tue",@"Wed",@"Thu",@"Fri",@"Sat"];
    
    CGFloat space = (IHSDK_SCREEN_W-33*2-32)/6.0;
    if (IHSDKIS_IPAD) {
        space = (IHSDK_SCREEN_W*0.8-33*2-32)/6.0;
    }
    for (NSInteger i=0; i<7; i++) {
        __weak typeof(self) weakSelf = self;
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(34+space*i, 0.5*(100-32), 32, 32) titile:arr[i] font:IHSDK_FONT_Regular(12) textColor:IHSDK_COLOR_FROM_HEX(0x22262B) action:^(UIButton * _Nullable button) {
            
            button.selected = !button.selected;
            if (button.selected) {
                weakSelf.repeatMode |= (0x01 << button.tag);
            } else {
                weakSelf.repeatMode &= ~(0x01 << button.tag);
            }
            
            NSLog(@"%02x",weakSelf.repeatMode);
        }];
        btn.tag = i;
        btn.layer.cornerRadius = 16;
        btn.layer.masksToBounds = YES;
        // select
        [btn setTitleColor:IHSDK_COLOR_FROM_HEX(0xFFFFFF) forState:UIControlStateSelected];
        [btn setBackgroundImage:[self createImageWithColor:IHSDK_COLOR_FROM_HEX(0x00D0B9)] forState:UIControlStateSelected];
        [btn setTitleColor:IHSDK_COLOR_FROM_HEX(0x22262B) forState:UIControlStateNormal];
        [btn setBackgroundImage:[self createImageWithColor:IHSDK_COLOR_FROM_HEX(0xF1F3F3)] forState:UIControlStateNormal];
        
        btn.selected = ((self.repeatMode>>i) & 0x01)==0x01;
        
        [repeatContainer addSubview:btn];
    }
}

- (void)rightBarButtonDidPressed:(id)sender{
    AM6AlarmModel *model = [AM6AlarmModel new];
    if (self.isFromAdd) {
        model.isOn = YES;
    } else {
        model.isOn = self.isOn;
    }
    
    model.repeatMode = self.repeatMode;
    struct AM6DateStruct dateStruct = {0};
    NSString *string = [self jak_stringFromDateFormat:@"HH-mm" dates:self.datePicker.date];
    NSArray *arr = [string componentsSeparatedByString:@"-"];
    dateStruct.hour = [arr[0] intValue];
    dateStruct.min = [arr[1] intValue];
    model.date = dateStruct;
    if (self.callback) {
        self.callback(model);
    }
}
- (UIDatePicker *)datePicker{
    if (!_datePicker) {
        _datePicker = [UIDatePicker new];
        _datePicker.datePickerMode = UIDatePickerModeTime;
        if (@available(iOS 13.4, *)) {
            _datePicker.preferredDatePickerStyle = UIDatePickerStyleWheels;
        }
        _datePicker.backgroundColor = UIColor.whiteColor;
        if (self.isFromAdd==NO) {
            _datePicker.date = [self dateWithString:[NSString stringWithFormat:@"%02d%02d",self.date.hour,self.date.min] formatString:@"HHmm"];
        }
    }
    return _datePicker;
}
- (UIImage*)createImageWithColor:(UIColor*) color
{
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

- (NSString*)jak_stringFromDateFormat:(NSString*)format dates:(NSDate*)date{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.dateFormat = format;
    dateFormatter.locale = [NSLocale localeWithLocaleIdentifier:@"en_US"];
    return [dateFormatter stringFromDate:date];
}


- (NSDate *)dateWithString:(NSString*)string formatString:(NSString*)formatString{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.dateFormat = formatString;
    dateFormatter.locale = [NSLocale localeWithLocaleIdentifier:@"en_US"];
    return [dateFormatter dateFromString:string];
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
