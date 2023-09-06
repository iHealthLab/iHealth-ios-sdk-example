//
//  IHSDKNavigationBar.m
//  iHealthDemoCode
//
//  Created by Spring on 2023/5/30.
//  Copyright © 2023 iHealth Demo Code. All rights reserved.
//

#import "IHSDKNavigationBar.h"

@implementation IHSDKNavigationBar

- (instancetype)init {
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, IHSDKScreen_W,IHSDKNavigationBarH);
        
        _gradientLayer = [CAGradientLayer layer];
//        _gradientLayer.colors = @[(__bridge id)[UIColor colorWithHexString:@"#419EF1"].CGColor,
//                                 (__bridge id)[UIColor colorWithHexString:@"#4184F2"].CGColor];
        _gradientLayer.startPoint = CGPointMake(0.5, 0);
        _gradientLayer.endPoint = CGPointMake(0.5, 1.0);
        _gradientLayer.locations = @[@0, @1.0];
        _gradientLayer.frame = self.frame;
        [self.layer addSublayer:_gradientLayer];
        
        CGFloat btnW = IHSDKNavaBarItemW;
        [self addSubview:self.leftItem];
        [self.leftItem mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(btnW, btnW));
            make.left.offset(IHSDKNavaBarItemMargin);
            make.bottom.offset(0);
        }];
        
        [self addSubview:self.rightItem];
        [self.rightItem mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(btnW, btnW));
            make.right.offset(-IHSDKNavaBarItemMargin);
            make.bottom.offset(0);
        }];
        
        [self addSubview:self.titleLab];
        [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(btnW);
            make.left.mas_equalTo(self.leftItem.mas_right).offset(IHSDKScaleByWidth(2));
            make.centerX.mas_equalTo(self);
            make.bottom.offset(0);
        }];
    }
    return self;
}

- (UIButton *)leftItem {
    if (!_leftItem) {
        _leftItem = [UIButton buttonWithType:UIButtonTypeCustom];
        [_leftItem setImage:[UIImage imageNamed:@"nav_backBtn_black"] forState:UIControlStateNormal];
        [_leftItem setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
        [_leftItem setTitleColor:[UIColor colorWithHexString:@"#dddddd"] forState:UIControlStateHighlighted];
        _leftItem.titleLabel.font =[UIFont systemFontOfSize:IHSDKScaleByWidth(18) weight:UIFontWeightBold];
        [_leftItem addTarget:self action:@selector(leftItemAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftItem;
}

- (void)leftItemAction {
    
    if (self.leftItemBlock)self.leftItemBlock();
    
}

- (UILabel *)titleLab {
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] init];
        _titleLab.font = [UIFont systemFontOfSize:IHSDKScaleByWidth(18)];
        _titleLab.textColor = [UIColor colorWithHexString:@"#000000"];
        _titleLab.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLab;
}

- (UIButton *)rightItem {
    if (!_rightItem) {
        _rightItem = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rightItem setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
        [_rightItem setTitleColor:[UIColor colorWithHexString:@"#dddddd"] forState:UIControlStateHighlighted];
        _rightItem.titleLabel.font = [UIFont systemFontOfSize:IHSDKScaleByWidth(18) weight:UIFontWeightBold];
        [_rightItem addTarget:self action:@selector(rightItemAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightItem;
}

- (void)rightItemAction {
    
    if (self.leftItemBlock)self.leftItemBlock();
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
