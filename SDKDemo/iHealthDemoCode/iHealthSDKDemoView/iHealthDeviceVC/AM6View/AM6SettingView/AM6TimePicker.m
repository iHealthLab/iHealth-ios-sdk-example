//
//  AM6TimePicker.m
//  iHealthDemoCode
//
//  Created by Spring on 2023/6/13.
//  Copyright © 2023 iHealth Demo Code. All rights reserved.
//

#import "AM6TimePicker.h"

@implementation AM6TimePicker

- (instancetype)initWithTitle:(NSString*)title is12hoursFormat:(BOOL)is12hoursFormat currentValues:(nullable NSArray*)currentValues{
    if (is12hoursFormat) {
        NSMutableArray *hoursArray = [NSMutableArray array];
        NSMutableArray *minutesArray = [NSMutableArray array];
        NSMutableArray *ampmArray = @[@"AM", @"PM"].mutableCopy;
        
        for (int i = 1;  i<=12; i++) {
            [hoursArray addObject:[NSString stringWithFormat:@"%d", i]];
        }
        
        for (int i = 0;  i<60; i++) {
            [minutesArray addObject:[NSString stringWithFormat:@"%d", i]];
        }
        __weak typeof(self) weakSelf = self;
        self = [super initWithTitle:title leftBtnStr:@"Cancel" rightBtnStr:@"OK" dataArray:@[hoursArray, minutesArray, ampmArray] unitDataArray:@[] confimAction:^(NSArray<WPKDateSelectModel *> *selectModel) {
            
            WPKDateSelectModel *hourModel = [selectModel firstObject];
            WPKDateSelectModel *minuteModel = [selectModel objectAtIndex:1];
            WPKDateSelectModel *ampmModel = [selectModel lastObject];
            
            // 12:00 am对应0:00，12:00 pm对应12:00，
            NSInteger hour = [hourModel.selectTitle integerValue];
            NSInteger min  = [minuteModel.selectTitle integerValue];
            NSString *am_pm = ampmModel.selectTitle;
            if ([am_pm isEqualToString:@"AM"]) {
                if (hour == 12) {
                    hour = 0;
                }
            }else{
                if (hour != 12) {
                    hour = hour + 12;
                }
            }
            if (weakSelf.onSelctionCallback) {
                weakSelf.onSelctionCallback(hour, min);
            }
            
        }];
        self.currentSelectValues = currentValues;
        return self;
    } else {
        NSMutableArray *hoursArray = [NSMutableArray array];
        NSMutableArray *minutesArray = [NSMutableArray array];
        
        for (int i = 0;  i<24; i++) {
            [hoursArray addObject:[NSString stringWithFormat:@"%d", i]];
        }
        
        for (int i = 0;  i<60; i++) {
            [minutesArray addObject:[NSString stringWithFormat:@"%d", i]];
        }
        __weak typeof(self) weakSelf = self;
        self = [super initWithTitle:title leftBtnStr:@"Cancel" rightBtnStr:@"OK" dataArray:@[hoursArray, minutesArray] unitDataArray:@[] confimAction:^(NSArray<WPKDateSelectModel *> *selectModel) {
            
            WPKDateSelectModel *hourModel = [selectModel firstObject];
            WPKDateSelectModel *minuteModel = [selectModel objectAtIndex:1];
            
            NSInteger hour = [hourModel.selectTitle integerValue];
            NSInteger min  = [minuteModel.selectTitle integerValue];
            
            if (weakSelf.onSelctionCallback) {
                weakSelf.onSelctionCallback(hour, min);
            }
            
        }];
        self.currentSelectValues = currentValues;
        return self;
    }
}

@end
