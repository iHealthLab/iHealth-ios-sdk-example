//
//  IHSDKUITipsView.m
//  iHealthDemoCode
//
//  Created by jing on 2023/4/11.
//  Copyright © 2023 iHealth Demo Code. All rights reserved.
//

#import "IHSDKUITipsView.h"

#define KWZSTipsViewContainerWidth 140
#define KWZSTipsViewContainerHeight 140

static IHSDKUITipsView* sdkTipView = nil;

@interface IHSDKUITipsView ()
@property (strong, nonatomic) UIView *containerView;
@property (strong, nonatomic) UILabel *textLabel;
@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) CAShapeLayer *loadingLayer;
@property (assign, nonatomic) BOOL isLoading;

@end

@implementation IHSDKUITipsView
+ (instancetype)sharedInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sdkTipView = [[IHSDKUITipsView alloc] init];

    });
    return sdkTipView;
}

- (instancetype)init{
    CGFloat w = [UIScreen mainScreen].bounds.size.width;
    CGFloat h = [UIScreen mainScreen].bounds.size.height;
    if (h > w) {
        self = [super initWithFrame:[UIScreen mainScreen].bounds];
    } else {
        self = [super initWithFrame:CGRectMake(0, 0, h, w)];
    }
    if (self) {
//        self.backgroundColor = UIColor.yellowColor;
        self.userInteractionEnabled = YES;
        self.radius = 19.0;
        self.lineWidth = 2.0;
        self.lineColor = UIColor.whiteColor;
        self.duration = 2.0;
        _font = [UIFont systemFontOfSize:14];
        _textColor = UIColor.whiteColor;
        
        [self addSubview:self.containerView];
        [self.containerView addSubview:self.textLabel];
        
        
    }
    return self;
}

- (void)show{
    self.center = CGPointMake([UIScreen mainScreen].bounds.size.width * 0.5, [UIScreen mainScreen].bounds.size.height * 0.5);
    if (![[UIApplication sharedApplication].keyWindow.subviews containsObject:self]) {
        [[UIApplication sharedApplication].keyWindow addSubview:self];
    }
}

- (void)hide{
    
    [self.loadingLayer removeAllAnimations];
    [self.loadingLayer removeFromSuperlayer];
    [self removeFromSuperview];
}
- (void)hideResultTip{
    if (self.isLoading==NO) {
        [self hide];
    }
}

- (void)showToast:(NSString*)text{
    
}

- (void)showLoadingTips:(NSString*)text{
    self.userInteractionEnabled = YES;
    self.isLoading = YES;
    
    [self.imageView removeFromSuperview];
    
    _textLabel.text = text;
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    self.loadingLayer = shapeLayer;
    shapeLayer.frame = CGRectMake(0.5*KWZSTipsViewContainerWidth-self.radius, 50-self.radius, self.radius*2, self.radius*2);
    
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.radius,self.radius) radius:(self.radius-0.5*self.lineWidth) startAngle:0 endAngle:2*M_PI clockwise:YES];
    
    shapeLayer.path = path.CGPath;
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    shapeLayer.strokeColor = self.lineColor.CGColor;
    shapeLayer.lineWidth = self.lineWidth;
    [self.containerView.layer addSublayer:shapeLayer];
    
    CABasicAnimation * anima = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    anima.fromValue = [NSNumber numberWithFloat:0.f];
    anima.toValue = [NSNumber numberWithFloat:0.5f];
    anima.duration = 1.5f;
    anima.repeatCount = MAXFLOAT;
    anima.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    anima.autoreverses = YES;
    anima.removedOnCompletion = NO;
    [shapeLayer addAnimation:anima forKey:@"strokeEndAniamtion"];
    
    CABasicAnimation *anima3 = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    anima3.toValue = [NSNumber numberWithFloat:-M_PI*2];
    anima3.duration = 0.75f;
    anima3.repeatCount = MAXFLOAT;
    anima3.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    [shapeLayer addAnimation:anima3 forKey:@"rotaionAniamtion"];
    
    [self show];
    
}

- (void)showSuccessTips:(NSString*)text{
    self.userInteractionEnabled = NO;
    self.isLoading = NO;
    [self.loadingLayer removeAllAnimations];
    [self.loadingLayer removeFromSuperlayer];
    
    _textLabel.text = text;
    self.imageView.image = self.successImage;
    [self.containerView addSubview:self.imageView];
    [self show];
    
    [self performSelector:@selector(hideResultTip) withObject:nil afterDelay:self.duration];
}

- (void)showFailTips:(NSString*)text{
    self.userInteractionEnabled = NO;
    self.isLoading = NO;
    [self.loadingLayer removeAllAnimations];
    [self.loadingLayer removeFromSuperlayer];
    
    _textLabel.text = text;
    self.imageView.image = self.failImage;
    [self.containerView addSubview:self.imageView];
    [self show];
    [self performSelector:@selector(hideResultTip) withObject:nil afterDelay:self.duration];
}

- (void)setFont:(UIFont*)font{
    _font = font?font:_font;
    if (_textLabel) {
        _textLabel.font = _font;
    }
}

- (void)setTextColor:(UIColor *)textColor{
    _textColor = textColor?textColor:_textColor;
    if (_textLabel) {
        _textLabel.textColor = textColor;
    }
}
#pragma mark - Lazy Load
- (UIView *)containerView{
    if (!_containerView) {
        _containerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KWZSTipsViewContainerWidth, KWZSTipsViewContainerWidth)];
        _containerView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        _containerView.center = CGPointMake(self.bounds.size.width /2, self.bounds.size.height /2);
        _containerView.layer.cornerRadius = 10;
    }
    return _containerView;
}
- (UILabel *)textLabel{
    if (!_textLabel) {
        _textLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, KWZSTipsViewContainerWidth-36-20, KWZSTipsViewContainerWidth, 20)];
        _textLabel.textAlignment = NSTextAlignmentCenter;
        _textLabel.font = _font;
        _textLabel.textColor = _textColor;
    }
    return _textLabel;
}

- (UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 38, 38)];
        _imageView.center = CGPointMake(KWZSTipsViewContainerWidth*0.5, 50);
    }
    return _imageView;
}

@end
