//
//  IHSDKTipsView.m
//  iHealthDemoCode
//
//  Created by jing on 2023/4/11.
//  Copyright © 2023 iHealth Demo Code. All rights reserved.
//

#import "IHSDKTipsView.h"
#import "IHSDKDemoUIHeader.h"
@interface IHSDKTipsView()
{
    UIImageView* _imageView;
    UILabel* _labelInfo;
    UIImageView* _boardView;
    UIActivityIndicatorView* _activityView;
}
@end

//key for tips
#define IHSDK_keyForTipsContextInfo                                       @"info"
#define IHSDK_keyForTipsContextDuration                                   @"duration"
#define IHSDK_keyForTipsContextModelFlag                                  @"isModel"
#define IHSDK_kDefaultTipsDuration 2.0

static IHSDKTipsView* gTipsView = nil;

#define IHSDK_kBoardViewSize   (160.f) //面板的宽度和高度，高度会变
#define IHSDK_kBoardViewImageCapInset   (20.f) //面板背景图显示时的cap inset
#define IHSDK_kTBGap (20.f)    //顶端和低端的间隙
#define IHSDK_kLRGap   (10.f)  //左右间隙
#define IHSDK_kResultIconSize (70.f)   //成功或失败icon的尺寸
#define IHSDK_kResultIconTextVGap   (11.f) //成功或失败icon和其下面的文本的间隙
#define IHSDK_kTextHeight   (50.f) //默认文本高度
#define IHSDK_kTextFont    (14.f)  //文本字体大小

@interface IHSDKTipsView()
@property (nonatomic, assign) BOOL userInteraction;
@end

@implementation IHSDKTipsView
- (IHSDKTipsView*)initTips
{
    CGFloat w = [UIScreen mainScreen].bounds.size.width;
    CGFloat h = [UIScreen mainScreen].bounds.size.height;
    if (h > w) {
        self = [super initWithFrame:[UIScreen mainScreen].bounds];
    } else {
        self = [super initWithFrame:CGRectMake(0, 0, h, w)];
    }
    if (self)  {
        [self setUserInteraction:NO];
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        UIViewAutoresizing viewAutoresizing = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin |
        UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
        
        _boardView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, IHSDK_kBoardViewSize, IHSDK_kBoardViewSize)];
        UIImage* bgImage = KIHSDKImageNamed(@"IHSDK_tips_info_bkg");
        bgImage = [bgImage resizableImageWithCapInsets:UIEdgeInsetsMake(IHSDK_kBoardViewImageCapInset, IHSDK_kBoardViewImageCapInset, IHSDK_kBoardViewImageCapInset, IHSDK_kBoardViewImageCapInset)];
        _boardView.image = bgImage;
        _boardView.center = CGPointMake(self.bounds.size.width /2, self.bounds.size.height /2) ;
        _boardView.autoresizingMask = viewAutoresizing;
        [self addSubview:_boardView];
        
        _activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        _activityView.center = CGPointMake(IHSDK_kBoardViewSize/2, IHSDK_kTBGap+IHSDK_kResultIconSize/2.f);
        _activityView.hidesWhenStopped = YES;
        
        CGRect labelRect = CGRectMake(IHSDK_kLRGap, IHSDK_kTBGap+IHSDK_kResultIconSize+IHSDK_kResultIconTextVGap, IHSDK_kBoardViewSize-IHSDK_kLRGap*2, IHSDK_kTextHeight);
        _labelInfo = [[UILabel alloc] initWithFrame:labelRect];
        _labelInfo.numberOfLines = 0;
        _labelInfo.backgroundColor = [UIColor clearColor];
        _labelInfo.textAlignment = NSTextAlignmentCenter;
        _labelInfo.textColor = [UIColor whiteColor];
        _labelInfo.font = [UIFont systemFontOfSize:IHSDK_kTextFont];
        _labelInfo.shadowColor = [UIColor blackColor];
        _labelInfo.shadowOffset = CGSizeMake(0, 1.0);
        [_boardView addSubview:_labelInfo];
        
        _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, IHSDK_kResultIconSize, IHSDK_kResultIconSize)];
        _imageView.contentMode = UIViewContentModeCenter;
        _imageView.center = CGPointMake(IHSDK_kBoardViewSize/2.f, IHSDK_kTBGap+IHSDK_kResultIconSize/2.f) ;
        [_boardView addSubview:_imageView];
        _imageView.hidden = YES;
        
        switch ([[UIApplication sharedApplication] statusBarOrientation]) {
            case UIInterfaceOrientationPortrait:
                self.transform = CGAffineTransformMakeRotation(0);
                break;
            case UIInterfaceOrientationPortraitUpsideDown:
                self.transform = CGAffineTransformMakeRotation(M_PI);
                break;
            case UIInterfaceOrientationLandscapeLeft:
                self.transform = CGAffineTransformMakeRotation(-M_PI/2);
                break;
            case UIInterfaceOrientationLandscapeRight:
                self.transform = CGAffineTransformMakeRotation(M_PI/2);
                break;
            default:
                break;
        }
        
    }
    return self;
}


- (void)resetFrame
{
    CGFloat w = [UIScreen mainScreen].bounds.size.width;
    CGFloat h = [UIScreen mainScreen].bounds.size.height;
    if (h > w) {
        self.frame = [UIScreen mainScreen].bounds;
    } else {
        self.frame = CGRectMake(0, 0, h, w);
    }
}

- (void)setUserInteraction:(BOOL)userInteraction
{
    _userInteraction = userInteraction;
    if (userInteraction) {
        [self setUserInteractionEnabled:YES];
        self.backgroundColor = [UIColor clearColor];
    } else {
        [self setUserInteractionEnabled:NO];
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.1];
    }
}

- (void)setTipsOrientation:(UIInterfaceOrientation)ori
{
    switch (ori) {
        case UIInterfaceOrientationPortrait:
            self.transform = CGAffineTransformIdentity;
            break;
            
        case UIInterfaceOrientationPortraitUpsideDown:
            self.transform = CGAffineTransformMakeRotation(M_PI);
            break;
            
        case UIInterfaceOrientationLandscapeLeft:
            self.transform = CGAffineTransformMakeRotation(-M_PI/2);
            break;
            
        case UIInterfaceOrientationLandscapeRight:
            self.transform = CGAffineTransformMakeRotation(M_PI/2);
            break;
            
        default:
            break;
    }
}

/*
 * 设置默认position
 */
- (void)updateUIWithInfo:(NSString*)info
{
    float infoTextY;
    if (_imageView.hidden && ![_activityView superview]) {
        infoTextY = IHSDK_kTBGap;
    } else {
        infoTextY = IHSDK_kTBGap+IHSDK_kResultIconSize+IHSDK_kResultIconTextVGap;
    }
    
    _boardView.center = CGPointMake(self.bounds.size.width /2, self.bounds.size.height /2);
    
    CGRect labelRect = CGRectMake(IHSDK_kLRGap, infoTextY, IHSDK_kBoardViewSize-IHSDK_kLRGap*2, IHSDK_kTextHeight);
    [_labelInfo setFrame:labelRect];
    
    _imageView.center = CGPointMake(IHSDK_kBoardViewSize/2.f, IHSDK_kTBGap+IHSDK_kResultIconSize/2.f) ;
    
    /*根据info调整position*/
    _labelInfo.text = info;
    CGFloat  textHeight = [info boundingRectWithSize:CGSizeMake(_labelInfo.frame.size.width, 200) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:IHSDK_kTextFont]} context:nil].size.height;
    [_labelInfo setFrame:CGRectMake(_labelInfo.frame.origin.x, _labelInfo.frame.origin.y, _labelInfo.frame.size.width, textHeight)];
    
    [_boardView setFrame:CGRectMake(_boardView.frame.origin.x, _boardView.frame.origin.y, _boardView.frame.size.width, CGRectGetMaxY(_labelInfo.frame) + IHSDK_kTBGap)];
    
    //如果文字为空，菊花居中.
    if ([info length] <= 0) {
        _activityView.center = CGPointMake(CGRectGetWidth(_boardView.bounds) / 2, CGRectGetHeight(_boardView.bounds) / 2);
    } else {
        _activityView.center = CGPointMake(IHSDK_kBoardViewSize/2, IHSDK_kTBGap+IHSDK_kResultIconSize/2.f);
    }
}

- (void)showTipsOnMainTread:(NSDictionary*)diction
{
    NSString* info = [diction objectForKey:IHSDK_keyForTipsContextInfo];
    NSNumber* modelFlag = [diction objectForKey:IHSDK_keyForTipsContextModelFlag];
    BOOL useInteraction = [modelFlag boolValue];
    [self setUserInteraction:useInteraction];
    
    self.hidden = NO;
    _imageView.hidden = YES;
    
    [_boardView addSubview:_activityView];
    [_activityView startAnimating];
    
    [self updateUIWithInfo:info];
    
    self.center = CGPointMake([UIScreen mainScreen].bounds.size.width * 0.5, [UIScreen mainScreen].bounds.size.height * 0.5);
    [self loadTipsView];
}

- (void)showTips:(NSString *)info useInteraction:(BOOL)useInteraction
{
    NSMutableDictionary* context = [[NSMutableDictionary alloc] initWithCapacity:3];
    if (info) {
        [context setObject:info forKey:IHSDK_keyForTipsContextInfo];
    }
    
    NSNumber* modelFlag = [[NSNumber alloc] initWithBool:useInteraction];
    [context setObject:modelFlag forKey:IHSDK_keyForTipsContextModelFlag];
    
    [self performSelectorOnMainThread:@selector(showTipsOnMainTread:)
                           withObject:context
                        waitUntilDone:NO];
    
    context = nil;
    modelFlag = nil;
}

- (void)showFailedTipsOnMainTread:(NSDictionary*)diction
{
    NSString* info = [diction objectForKey:IHSDK_keyForTipsContextInfo];
    NSNumber* durationNumber = [diction objectForKey:IHSDK_keyForTipsContextDuration];
    NSNumber* modelFlag = [diction objectForKey:IHSDK_keyForTipsContextModelFlag];
    NSTimeInterval duration = [durationNumber doubleValue];
    BOOL useInteraction = [modelFlag boolValue];
    
    [self setUserInteraction:useInteraction];
    self.hidden = NO;
    [_activityView removeFromSuperview];
    _imageView.image =  KIHSDKImageNamed(@"IHSDK_tips_failedIcon");
    _imageView.hidden = NO;
    
    [self updateUIWithInfo:info];
    
    if (duration > 0) {
        [self performSelector:@selector(hide) withObject:nil afterDelay:duration];
    } else {
        [self performSelector:@selector(hide) withObject:nil afterDelay:IHSDK_kDefaultTipsDuration];
    }
    [self resetFrame];

    [self loadTipsView];
}

- (void)showFailedTips:(NSString *)info duration:(NSTimeInterval)duration useInteraction:(BOOL)useInteraction
{
    NSMutableDictionary* context = [[NSMutableDictionary alloc] initWithCapacity:3];
    if (info) {
        [context setObject:info forKey:IHSDK_keyForTipsContextInfo];
    }
    double d = (double)duration;
    NSNumber* durationNumber = [[NSNumber alloc] initWithDouble:d];
    [context setObject:durationNumber forKey:IHSDK_keyForTipsContextDuration];
    
    NSNumber* modelFlag = [[NSNumber alloc] initWithBool:useInteraction];
    [context setObject:modelFlag forKey:IHSDK_keyForTipsContextModelFlag];
    
    [self performSelectorOnMainThread:@selector(showFailedTipsOnMainTread:)
                           withObject:context
                        waitUntilDone:NO];
    
    context = nil;
    durationNumber = nil;
    modelFlag = nil;
}

- (void)showFinishTipsOnMainThread:(NSDictionary*)diction
{
    NSString* info = [diction objectForKey:IHSDK_keyForTipsContextInfo];
    NSNumber* durationNumber = [diction objectForKey:IHSDK_keyForTipsContextDuration];
    NSNumber* modelFlag = [diction objectForKey:IHSDK_keyForTipsContextModelFlag];
    NSTimeInterval duration = [durationNumber doubleValue];
    BOOL useInteraction = [modelFlag boolValue];
    [self setUserInteraction:useInteraction];
    
    self.hidden = NO;
    [_activityView removeFromSuperview];
    
    _imageView.image = KIHSDKImageNamed(@"IHSDK_tips_sucessIcon");
    _imageView.hidden = NO;
    [self updateUIWithInfo:info];
    
    if (duration > 0) {
        [self performSelector:@selector(hide) withObject:nil afterDelay:duration];
    } else {
        [self performSelector:@selector(hide) withObject:nil afterDelay:IHSDK_kDefaultTipsDuration];
    }
    [self resetFrame];
    [self loadTipsView];
}

- (void)showFinishTipsWithoutImageOnMainThread:(NSDictionary*)diction
{
    NSString* info = [diction objectForKey:IHSDK_keyForTipsContextInfo];
    NSNumber* durationNumber = [diction objectForKey:IHSDK_keyForTipsContextDuration];
    NSNumber* modelFlag = [diction objectForKey:IHSDK_keyForTipsContextModelFlag];
    NSTimeInterval duration = [durationNumber doubleValue];
    BOOL useInteraction = [modelFlag boolValue];
    [self setUserInteraction:useInteraction];
    
    self.hidden = NO;
    [_activityView removeFromSuperview];
    
    _imageView.image = nil;
    _imageView.hidden = YES;
    [self updateUIWithInfo:info];
    
    if (duration > 0) {
        [self performSelector:@selector(hide) withObject:nil afterDelay:duration];
    } else {
        [self performSelector:@selector(hide) withObject:nil afterDelay:IHSDK_kDefaultTipsDuration];
    }
    [self loadTipsView];
}

- (void)showFinishTips:(NSString *)info duration:(NSTimeInterval)duration useInteraction:(BOOL)useInteraction
{
    NSMutableDictionary* context = [[NSMutableDictionary alloc] initWithCapacity:3];
    if (info) {
        [context setObject:info forKey:IHSDK_keyForTipsContextInfo];
    }
    double d = (double)duration;
    NSNumber *durationNumber = [[NSNumber alloc] initWithDouble:d];
    [context setObject:durationNumber forKey:IHSDK_keyForTipsContextDuration];
    
    NSNumber* modelFlag = [[NSNumber alloc] initWithBool:useInteraction];
    [context setObject:modelFlag forKey:IHSDK_keyForTipsContextModelFlag];
    
    [self performSelectorOnMainThread:@selector(showFinishTipsOnMainThread:) withObject:context waitUntilDone:NO];
}

- (void)hideInternal
{
    [self removeFromSuperview];
    self.hidden = YES;
}

- (void)hide
{
    [self performSelectorOnMainThread:@selector(hideInternal) withObject:nil waitUntilDone:NO];
}

- (void)showTipsInfo:(NSString *)info duration:(NSTimeInterval)duration useInteraction:(BOOL)useInteraction
{
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        NSMutableDictionary* context = [[NSMutableDictionary alloc] initWithCapacity:3];
        if (info) {
            [context setObject:info forKey:IHSDK_keyForTipsContextInfo];
        }
        double d  = (double)duration;
        NSNumber* durationNumber = [[NSNumber alloc] initWithDouble:d];
        [context setObject:durationNumber forKey:IHSDK_keyForTipsContextDuration];
        
        NSNumber* modelFlag = [[NSNumber alloc] initWithBool:useInteraction];
        [context setObject:modelFlag forKey:IHSDK_keyForTipsContextModelFlag];
        [self showFinishTipsWithoutImageOnMainThread:context];
    }];
}

- (void)showTipsWithImage:(UIImage*)image info:(NSString *)info duration:(NSTimeInterval)duration useInteraction:(BOOL)useInteraction;
{
    __weak typeof(self) weakself = self;
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        __strong typeof(weakself) strongself = weakself;
        NSMutableDictionary* context = [[NSMutableDictionary alloc] initWithCapacity:3];
        if (info) {
            [context setObject:info forKey:IHSDK_keyForTipsContextInfo];
        }
        double d = (double)duration;
        NSNumber* durationNumber = [[NSNumber alloc] initWithDouble:d];
        [context setObject:durationNumber forKey:IHSDK_keyForTipsContextDuration];
        
        NSNumber* modelFlag = [[NSNumber alloc] initWithBool:useInteraction];
        [context setObject:modelFlag forKey:IHSDK_keyForTipsContextModelFlag];
        
        [self showFinishTipsOnMainThread:context];
        
        strongself->_imageView.image = image;
    }];
}

- (void)showTipsNoneImage:(CGPoint)centerPoint info:(NSString *)info duration:(NSTimeInterval)duration useInteraction:(BOOL)useInteraction
{
    __weak typeof(self) weakself = self;
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        __strong typeof(weakself) strongself = weakself;
        NSMutableDictionary* context = [[NSMutableDictionary alloc] initWithCapacity:3];
        
        if (info) {
            [context setObject:info forKey:IHSDK_keyForTipsContextInfo];
        }
        double d = (double)duration;
        NSNumber* durationNumber = [[NSNumber alloc] initWithDouble:d];
        [context setObject:durationNumber forKey:IHSDK_keyForTipsContextDuration];
        
        NSNumber* modelFlag = [[NSNumber alloc] initWithBool:useInteraction];
        [context setObject:modelFlag forKey:IHSDK_keyForTipsContextModelFlag];
        
        [self showFinishTipsOnMainThread:context];
        
        strongself->_imageView.image = nil;
        strongself->_boardView.frame = CGRectMake(0, 0, IHSDK_kBoardViewSize, IHSDK_kTextHeight);
        strongself->_boardView.center = centerPoint;
        strongself->_labelInfo.center = CGPointMake(CGRectGetWidth(strongself->_boardView.frame) / 2, CGRectGetHeight(self->_boardView.frame) / 2);
    }];
}



- (void)loadTipsView
{
    if (![[UIApplication sharedApplication].keyWindow.subviews containsObject:self]) {
        [[UIApplication sharedApplication].keyWindow addSubview:self];
    }
}

+ (IHSDKTipsView*)shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        gTipsView = [[IHSDKTipsView alloc] initTips];

    });
    return gTipsView;
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    if (self.userInteraction) {
        return NO;
    }
    return YES;
}
@end

