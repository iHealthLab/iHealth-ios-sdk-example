//
//  WZLatteCaloriesPicker.m
//  WyzeLatte
//
//  Created by Lei Bao on 2021/3/26.
//

#import "WZLatteCaloriesPicker.h"

@implementation WZLatteCaloriesPicker

- (instancetype)initWithTitle:(NSString*)title currentValue:(NSInteger)currentValue{
    NSMutableArray *datasourceArr = [NSMutableArray array];
    
    for (int i = 1;  i<=1000; i++) {
        NSInteger value = i*10;
        if (value<1000) {
            [datasourceArr addObject:[NSString stringWithFormat:@"%ld", (long)value]];
        } else {
            [datasourceArr addObject:[NSString stringWithFormat:@"%ld,%03ld", (long)value/1000,(long)value%1000]];
        }
    }
    __weak typeof(self) weakSelf = self;
    self = [super initWithTitle:title leftBtnStr:@"Cancel" rightBtnStr:@"OK" dataArray:@[datasourceArr] unitDataArray:@[] confimAction:^(NSArray<WPKDateSelectModel *> *selectModel) {
        
        WPKDateSelectModel *model = [selectModel firstObject];
        NSInteger index = model.selectIndex;
        if (weakSelf.onSelctionCallback) {
            weakSelf.onSelctionCallback((index+1)*10);
        }
        
    }];
    if (currentValue<1000) {
        self.currentSelectValues = @[[NSString stringWithFormat:@"%ld", (long)currentValue]];
    } else {
        self.currentSelectValues = @[[NSString stringWithFormat:@"%ld,%03ld", (long)currentValue/1000,(long)currentValue%1000]];
    }
    return self;
}

@end
