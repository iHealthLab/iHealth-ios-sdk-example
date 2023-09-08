//
//  IHSDKBG1AResultVC.m
//  iHealthDemoCode
//
//  Created by Spring on 2023/6/5.
//  Copyright © 2023 iHealth Demo Code. All rights reserved.
//

#import "IHSDKBG1AResultVC.h"

@interface IHSDKBG1AResultVC ()

@property (nonatomic,strong) UIImageView *timeBgImageView;

@property (nonatomic,strong) UILabel *resultLabel;

@property (nonatomic,strong) UIButton *saveButton;

@property (nonatomic,strong) UIButton *shareButton;

@property (nonatomic,strong) NSString *selectTestTime;

@end

@implementation IHSDKBG1AResultVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupInterface];
}
- (void)setupInterface{
    
    [self.view setBackgroundColor:[UIColor colorWithHexString:@"#FFFFFF"]];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = NSLocalizedString(@"BG1A", @"");
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:IHSDKScaleByWidth(20)];
    titleLabel.textColor = [UIColor colorWithHexString:@"#000000"];
    [self.view addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {

        make.centerX.mas_equalTo(self.view);
        make.top.offset(IHSDKStatusBarH+10);
    }];
    
    
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setImage:[UIImage imageNamed:@"bg1a_nav_backBtn_black"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(clickleftBarButtonItem) forControlEvents:UIControlEventTouchUpInside];
    CGFloat btnW = IHSDKNavaBarItemW;
    [self.view addSubview:leftBtn];
    [leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(btnW, btnW));
        make.left.offset(IHSDKNavaBarItemMargin);
        make.top.offset(IHSDKStatusBarH);
    }];
    
    [self.view addSubview:self.timeBgImageView];
    [self.timeBgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(IHSDKStatusBarH+10+IHSDKScaleByWidth(77));
        make.centerX.mas_equalTo(self.view);

    }];
    
    self.resultLabel.text =[NSString stringWithFormat:@"%@",self.result];
    [self.view addSubview:self.resultLabel];
    [self.resultLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(IHSDKStatusBarH+10+IHSDKScaleByWidth(202));
        make.height.mas_equalTo(IHSDKScaleByWidth(40));
        make.centerX.mas_equalTo(self.view);
    }];
//
//    self.testLabelline2.text =NSLocalizedString(@"Do not pull out the test paper", @"");
//    [self.view addSubview:self.testLabelline2];
//    [self.testLabelline2 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.offset(IHSDKStatusBarH+10+IHSDKScaleByWidth(520));
//        make.height.mas_equalTo(IHSDKScaleByWidth(22));
//        make.centerX.mas_equalTo(self.view);
//    }];
//
}

- (void)clickleftBarButtonItem{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (UIImageView *)timeBgImageView{
    if (_timeBgImageView == nil) {
        _timeBgImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bg1a_measuring_time_image"]];
    }
    return _timeBgImageView;
}

- (UILabel *)resultLabel{
    if (_resultLabel == nil) {
        _resultLabel = [[UILabel alloc]init];
        _resultLabel.textAlignment = NSTextAlignmentCenter;
        _resultLabel.numberOfLines=5;
        _resultLabel.font = [UIFont systemFontOfSize:IHSDKScaleByWidth(52)];
        _resultLabel.textColor = [UIColor colorWithHexString:@"#538BF7"];
    }
    return _resultLabel;
}

- (UIButton *)saveButton{
    if (_saveButton == nil) {
        
        _saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        _saveButton.frame = CGRectMake(0, 0, IHSDKScreen_W - IHSDKScaleByWidth(29) * 2, 60);

        [_saveButton setBackgroundColor:[UIColor colorWithHexString:@"#538BF7"]];
        
        [_saveButton setTitle:NSLocalizedString(@"OK", @"") forState:UIControlStateNormal];
        
        _saveButton.titleLabel.font = [UIFont systemFontOfSize:IHSDKScaleByWidth(18)];
        
        [_saveButton setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
        
        [_saveButton addTarget:self action:@selector(saveResult) forControlEvents:UIControlEventTouchUpInside];
        
        _saveButton.layer.cornerRadius = 35;
        _saveButton.layer.masksToBounds = YES;
        

    }
    return _saveButton;
}
-(void)saveResult{
    
    
    NSDateFormatter *df = [NSDateFormatter new];
    df.dateFormat = @"yyyyMMDD HH:mm:ss";
    NSString *dateString = [df stringFromDate:[NSDate date]];
    
    // first row time value
    NSMutableString *firstRow = [NSMutableString new];
    [firstRow appendString:@"MAC\t"];
    [firstRow appendString:@"Time\t"];
    [firstRow appendString:@"Result\t"];
    [firstRow appendString:@"EatTime\t"];
    [firstRow appendString:@"unit\t"];
    
    NSMutableString *mString = [NSMutableString new];
    [mString appendFormat:@"%@\t",self.deviceMac];
    [mString appendFormat:@"%@\t",dateString];
    [mString appendFormat:@"%@\t",self.result];
    [mString appendFormat:@"%@\t",self.selectTestTime];
    [mString appendFormat:@"%@\t",@"mmol/L"];
    
    // Find documents directory
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    ;
    NSString *fileName = @"BG1AResult";
    NSString *filePath = [docPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.xls",fileName]];
    NSLog(@"file path:%@",filePath);
    // Create new file if none exists
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        
        NSFileHandle *fileHandle = [NSFileHandle fileHandleForWritingAtPath:filePath];
        [fileHandle seekToEndOfFile];
        [fileHandle writeData:[[mString copy] dataUsingEncoding:NSUTF16StringEncoding]];
        [fileHandle closeFile];
    } else {
        
        [[NSFileManager defaultManager] createFileAtPath:filePath contents:nil attributes:nil];
        NSFileHandle *fileHandle = [NSFileHandle fileHandleForWritingAtPath:filePath];
        [fileHandle writeData:[[NSString stringWithFormat:@"%@%@",firstRow,mString] dataUsingEncoding:NSUTF16StringEncoding]];
        [fileHandle closeFile];
    }
    
    [self.navigationController popToRootViewControllerAnimated:YES];
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
