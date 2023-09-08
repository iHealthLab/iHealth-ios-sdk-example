//
//  WZLatteStepsPicker.m
//  WyzeLatte
//
//  Created by Lei Bao on 2021/3/26.
//

#import "WZLatteStepsPicker.h"

@implementation WZLatteStepsPicker

- (instancetype)initWithTitle:(NSString*)title currentValue:(NSInteger)currentValue{
    NSMutableArray *datasourceArr = [NSMutableArray array];
    
    for (int i = 1;  i<=20; i++) {
        [datasourceArr addObject:[NSString stringWithFormat:@"%d,000", i]];
    }
    __weak typeof(self) weakSelf = self;
    self = [super initWithTitle:title leftBtnStr:@"Cancel" rightBtnStr:@"OK" dataArray:@[datasourceArr] unitDataArray:@[] confimAction:^(NSArray<WPKDateSelectModel *> *selectModel) {
        
        WPKDateSelectModel *model = [selectModel firstObject];
        NSInteger index = model.selectIndex;
        if (weakSelf.onSelctionCallback) {
            weakSelf.onSelctionCallback((index+1)*1000);
        }
        
    }];
    self.currentSelectValues = @[[NSString stringWithFormat:@"%ld,000",(long)currentValue/1000]];
    return self;
}

@end
