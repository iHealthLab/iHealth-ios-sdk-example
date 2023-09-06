//
//  WPKDateIntervalView.h
//  WZPlatformKit
//
//  Created by abc on 2019/6/11.
//  Copyright © 2019 Wyze. All rights reserved.
//
/**
 * 时间间隔选择器
 */
#import <UIKit/UIKit.h>

@interface WPKDateSelectModel : NSObject
@property (nonatomic, assign) NSInteger selectIndex;
@property (nonatomic, copy) NSString *selectTitle;
@end

typedef void(^WPKDateIntervalActionBlock)(NSArray <WPKDateSelectModel *> *selectModel);
@interface WPKDateIntervalView : UIView
@property (nonatomic, assign) BOOL showUnitFlag;//显示单位的标记
@property (nonatomic, copy) NSArray *currentSelectValues;//当前选择的数据
@property (nonatomic, copy) NSArray <NSNumber *> *unitOffestValues;//单位偏移的数值

/**
 * init dateIntervalView default button is  cancel and  confirm
 * @param title view's title
 * @param dataArray view's show data
 * @param unitDataArray view's show unit data
 * @param confimAction view's comfimOperation
 */
- (instancetype)initWithTitle:(NSString *)title dataArray:(NSArray *)dataArray unitDataArray:(NSArray *)unitDataArray confimAction:(WPKDateIntervalActionBlock)confimAction;

/**
 * init dateIntervalView
 * @param title view's title
 * @param leftBtnStr view's left button title
 * @param rightBtnStr view's right button title
 * @param dataArray view's show data
 * @param unitDataArray view's show unit data
 * @param confimAction view's comfimOperation
 */
- (instancetype)initWithTitle:(NSString *)title leftBtnStr:(NSString *)leftBtnStr rightBtnStr:(NSString *)rightBtnStr dataArray:(NSArray *)dataArray unitDataArray:(NSArray *)unitDataArray confimAction:(WPKDateIntervalActionBlock)confimAction;

/**
 * dateIntervalView show
 */
- (void)show;

/**
 * dateIntervalView dismiss
 */
- (void)dismiss;
@end

