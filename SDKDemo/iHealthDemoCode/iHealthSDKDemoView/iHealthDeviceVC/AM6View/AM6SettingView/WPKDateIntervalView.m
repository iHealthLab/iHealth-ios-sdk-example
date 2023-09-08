//
//  WPKDateIntervalView.m
//  WZPlatformKit
//
//  Created by abc on 2019/6/11.
//  Copyright © 2019 Wyze. All rights reserved.
//

#import "WPKDateIntervalView.h"

#import "WPKBottomButtonView.h"

#import "UIView+WPKCorner.h"

#import "NSString+WPKStringDrawing.h"

@implementation WPKDateSelectModel

@end

static int const kWPKDateIntervalViewUnitTag = 1000;
@interface WPKDateIntervalView() <UIPickerViewDelegate, UIPickerViewDataSource>
@property (nonatomic, copy) NSArray *dataArray;
@property (nonatomic, copy) NSArray *unitDataArray;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) WPKBottomButtonView *bottomView;
@property (nonatomic, copy) WPKDateIntervalActionBlock rightAction;
@property (nonatomic, copy) NSString *rightString;
@property (nonatomic, copy) NSString *leftString;
@property (nonatomic, copy) NSString *titleString;
@end

@implementation WPKDateIntervalView
- (instancetype)initWithTitle:(NSString *)title dataArray:(NSArray *)dataArray unitDataArray:(NSArray *)unitDataArray confimAction:(WPKDateIntervalActionBlock)confimAction
{
    self = [super initWithFrame:CGRectMake(0, 0, IHSDK_SCREEN_W, IHSDK_SCREEN_H)];
    if (self) {
        self.showUnitFlag = YES;
        self.dataArray = dataArray;
        self.unitDataArray = unitDataArray;
        self.titleString = title;
        self.leftString = @"Cancel";
        self.rightString = @"Confirm";
        self.rightAction = confimAction;
        [self loadMainUI];
    }
    return self;
}

- (instancetype)initWithTitle:(NSString *)title leftBtnStr:(NSString *)leftBtnStr rightBtnStr:(NSString *)rightBtnStr dataArray:(NSArray *)dataArray unitDataArray:(NSArray *)unitDataArray confimAction:(WPKDateIntervalActionBlock)confimAction
{
    self = [super initWithFrame:CGRectMake(0, 0, IHSDK_SCREEN_W, IHSDK_SCREEN_H)];
    if (self) {
        self.showUnitFlag = YES;
        self.dataArray = dataArray;
        self.unitDataArray = unitDataArray;
        self.titleString = title;
        self.leftString = leftBtnStr;
        self.rightString = rightBtnStr;
        self.rightAction = confimAction;
        [self loadMainUI];
    }
    return self;
}

- (void)loadMainUI
{
    self.backgroundColor = IHSDK_COLOR_FROM_HEX_A(0x000000, 0.27);
    self.contentView = [[UIView alloc] initWithFrame:CGRectMake(0, IHSDK_SCREEN_H-IHSDK_SAFEAREA_BOTTOM_H-347, IHSDK_SCREEN_W, 347)];
    [self.contentView addRoundedCorners:UIRectCornerTopLeft | UIRectCornerTopRight withRadii:CGSizeMake(10.0, 10.0)];
    self.contentView.backgroundColor = IHSDK_COLOR_FROM_HEX(0xffffff);
    [self addSubview:self.contentView];
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, IHSDK_SCREEN_W, 52)];
    self.titleLabel.text=self.titleString;
    self.titleLabel.backgroundColor = IHSDK_COLOR_FROM_HEX_A(0x2C2D30, 0.05);
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.titleLabel addRoundedCorners:UIRectCornerTopLeft | UIRectCornerTopRight withRadii:CGSizeMake(10.0, 10.0)];
    
    self.pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(12, CGRectGetMaxY( self.titleLabel.frame), IHSDK_SCREEN_W-2*12, 237)];
    self.pickerView.backgroundColor = IHSDK_COLOR_FROM_HEX(0xffffff);
    
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.pickerView];
    
    UIView *sperateView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY( self.pickerView.frame), IHSDK_SCREEN_W, 6)];
    sperateView.backgroundColor = IHSDK_COLOR_FROM_HEX_A(0x2C2D30, 0.05);
    [self.contentView addSubview:sperateView];
    
    self.bottomView = [[WPKBottomButtonView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY( self.pickerView.frame)+6, IHSDK_SCREEN_W, 52) leftStr:self.leftString leftAction:^(UIButton * _Nullable button) {
//        WPKInfoLog(@"Cancel");
        [self dismiss];
    } rightStr:self.rightString rightAction:^(UIButton * _Nullable button) {
        if (self.rightAction) {
            // 获取当前选中的信息
            NSMutableArray *selectArray = [[NSMutableArray alloc] init];
            for (int i = 0; i < self.dataArray.count; i++) {
                NSInteger currentIndex = [self.pickerView selectedRowInComponent:i];
                WPKDateSelectModel *selectModel =  [[WPKDateSelectModel alloc] init];
                selectModel.selectIndex = currentIndex;
                if (currentIndex < [self.dataArray[i] count]) {
                    selectModel.selectTitle = [self.dataArray[i] objectAtIndex:currentIndex];
                }
                [selectArray addObject:selectModel];
            }
            self.rightAction(selectArray);
        }
        [self dismiss];
    }];
    [self.contentView addSubview:self.bottomView];
    [self showUnit];//默认展示
}

- (void)show
{
    [self hideKeyBoard];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    if ([window.subviews containsObject:self]) {
        return;
    }
    
    CGFloat starY = IHSDK_SCREEN_H-IHSDK_SAFEAREA_BOTTOM_H-347;
    self.contentView.layer.transform = CATransform3DTranslate(self.layer.transform, 0, starY, 0);
    self.alpha = 0;
    [window addSubview:self];
    [UIView animateWithDuration:0.3 animations:^{
        self.contentView.layer.transform = CATransform3DIdentity;
        self.alpha = 1;
    }completion:^(BOOL finished) {
    }];
}

- (void)dismiss
{
    [UIView animateWithDuration:0.3 animations:^{
        CGFloat starY = IHSDK_SCREEN_H;
        self.contentView.layer.transform = CATransform3DTranslate(self.layer.transform, 0, starY, 0);
        self.alpha = 0.3;
    }completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma makr - UIPickerViewDelegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView*)pickerView
{
    return _dataArray.count; // 返回1表明该控件只包含1列
}

- (NSInteger)pickerView:(nonnull UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [[_dataArray objectAtIndex: component] count];
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    for (UIView *speartorView in self.pickerView.subviews) {
        if (speartorView.frame.size.height < 1) { //取出分割线view
            speartorView.backgroundColor = IHSDK_COLOR_FROM_HEX_A(0x2C2D30, 0.05);//隐藏分割线
        }
    }
    //设置文字的属性 

    NSString *tipsStr =  [[_dataArray objectAtIndex: component] objectAtIndex:row];
    UILabel *genderLabel = [UILabel new];
    genderLabel.textAlignment = NSTextAlignmentCenter;
    genderLabel.text = tipsStr;
    genderLabel.textColor = IHSDK_COLOR_BLACK;
    genderLabel.font = IHSDKFontDefault(16);
    return genderLabel;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    CGFloat width = (IHSDK_SCREEN_W-2*12)/self.dataArray.count;
    if (width > 117) {
        return 117;
    }
    return width;
}

- (void)showUnit
{
    if (self.showUnitFlag) {
        if (self.unitDataArray.count > 0) {
            [self removeShowUnit];
            CGFloat contentWidth = self.pickerView.frame.size.width/self.unitDataArray.count;
            for (int i = 0; i < self.unitDataArray.count; i++) {
                NSString *itemStr = self.unitDataArray[i];
                CGSize contentSize = [itemStr wpk_sizeWithFont:IHSDKFontDefault(16) constrainedToWidth:MAXFLOAT];
                CGFloat padding = 0;
                CGFloat unitOffest = 0;
                if (self.unitOffestValues.count > i) {
                    unitOffest = [self.unitOffestValues[i] floatValue];
                }
                if (contentSize.width < (contentWidth/2-15)) {
                    padding = (contentWidth/2) - contentSize.width-15;
                }
                UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake((i+1)*contentWidth-contentSize.width-padding+unitOffest, (CGRectGetHeight(self.pickerView.frame)-30)/2, contentSize.width, 30)];
                tipLabel.text=self.unitDataArray[i];
                tipLabel.tag = kWPKDateIntervalViewUnitTag+i;
                [self.pickerView addSubview:tipLabel];
            }
        }
    }
}

- (void)removeShowUnit
{
    if (self.showUnitFlag) {
       for (int i = 0; i < self.unitDataArray.count; i++) {
           UILabel *tipLabel = [self.pickerView viewWithTag:kWPKDateIntervalViewUnitTag+i];
           [tipLabel removeFromSuperview];
       }
    }
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    CGPoint touchPoint = [[touches anyObject] locationInView:self];
    if (![self.contentView pointInside:[self.contentView convertPoint:touchPoint fromView:self.contentView.window] withEvent:nil]) {
       [self dismiss];
    }
}

- (void)setShowUnitFlag:(BOOL)showUnitFlag
{
    _showUnitFlag = showUnitFlag;
    [self showUnit];
}

- (void)setCurrentSelectValues:(NSArray *)currentSelectValues
{
    _currentSelectValues = currentSelectValues;
    if (currentSelectValues.count != self.dataArray.count) {
        return;
    }
    for (int index = 0; index < currentSelectValues.count; index++) {
        if ([currentSelectValues objectAtIndex:index]) {
            if ([[self.dataArray objectAtIndex:index] containsObject:[currentSelectValues objectAtIndex:index]]) {
                NSInteger currentIndex =  [[self.dataArray objectAtIndex:index] indexOfObject:[currentSelectValues objectAtIndex:index]];
                [self.pickerView selectRow:currentIndex inComponent:index animated:NO];
            }
        }
    }
}

- (void)setUnitOffestValues:(NSArray<NSNumber *> *)unitOffestValues
{
    _unitOffestValues = unitOffestValues;
    [self showUnit];
}

#pragma mark 隐藏系统键盘与弹框
- (void)hideKeyBoard
{
    for (UIWindow* window in [UIApplication sharedApplication].windows) {
        for (UIView* view in window.subviews) {
            [self dismissAllKeyBoardInView:view];
        }
    }
}

- (BOOL)dismissAllKeyBoardInView:(UIView *)view
{
    if ([view isFirstResponder]) {
        [view resignFirstResponder];
        return YES;
    }
    for (UIView *subView in view.subviews) {
        if ([self dismissAllKeyBoardInView:subView]) {
            return YES;
        }
    }
    return NO;
}

@end
