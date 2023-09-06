//
//  IHSDKQRScanView.m
//  Pods


#import "IHSDKQRScanView.h"
#import <AVFoundation/AVFoundation.h>

static CGFloat scanTime = 3.0;
static CGFloat borderLineWidth = 0.5;
static CGFloat cornerLineWidth = 1.5;
static CGFloat scanLineWidth = 42;
static NSString *const scanLineAnimationName = @"scanLineAnimation";

@interface IHSDKQRScanView ()<AVCaptureMetadataOutputObjectsDelegate>
@property (nonatomic, strong) AVCaptureDevice *device;
@property (nonatomic, strong) AVCaptureDeviceInput *deviceInput;
@property (nonatomic, strong) AVCaptureMetadataOutput *dataOutput;
@property (nonatomic, strong) AVCaptureSession *session;
@property (nonatomic, strong) UIView *scanLine;
@property (nonatomic, strong) UIView *middleView;
@property (nonatomic, strong) UILabel *textLabel;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;



@end

@implementation IHSDKQRScanView
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor blackColor];
        _showScanLine = YES;
        _showCornerLine = YES;
        _showBorderLine = NO;
    }
    return self;
}

- (void)setNoteStr:(NSString *)noteStr{
    self.textLabel.text = noteStr;
}

- (void)configCameraAndStart{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        self.device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        NSError *error;
        self.deviceInput = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:&error];
        if (error) {
            NSLog(@"%@",error);
        }
        self.dataOutput = [[AVCaptureMetadataOutput alloc] init];
        [self.dataOutput setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];

        self.session = [[AVCaptureSession alloc] init];
        if ([self.device supportsAVCaptureSessionPreset:AVCaptureSessionPreset1920x1080]) {
            [self.session setSessionPreset:AVCaptureSessionPreset1920x1080];
        }
        else{
            [self.session setSessionPreset:AVCaptureSessionPresetHigh];
        }    
        if ([self.session canAddInput:self.deviceInput]){
            [self.session addInput:self.deviceInput];
        }
        if ([self.session canAddOutput:self.dataOutput]){
            [self.session addOutput:self.dataOutput];
        }
        if (![self.dataOutput.availableMetadataObjectTypes containsObject:AVMetadataObjectTypeQRCode]) {
            NSLog(@"The camera unsupport for QRCode.");
        }
        self.dataOutput.metadataObjectTypes = @[AVMetadataObjectTypeQRCode];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
            self.previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
            self.previewLayer.frame = self.frame;
            [self.layer insertSublayer:self.previewLayer atIndex:0];
            [self.session startRunning];
             self.dataOutput.rectOfInterest = [self.previewLayer metadataOutputRectOfInterestForRect:self.scanRect];
            [self showScanLine:self.isShowScanLine];
        });
    });
}

- (void)showScanLine:(BOOL)showScanLine{
    if (showScanLine) {
        [self addScanLineAnimation];
    }
    else{
        [self removeScanLineAnimation];
    }
}

- (void)startScanning{
    if (![self statusCheck]) {
        return;
    }
    if (!self.session) {
        [self setupViews];
        [self configCameraAndStart];
        return;
    }
    if (self.session.isRunning){
        return;
    }
    [self.session startRunning];
    [self showScanLine:self.isShowScanLine];
}

- (void)stopScanning{
    if (!self.session.isRunning){
        return;
    }
    [self.session stopRunning];
    [self showScanLine:NO];
}


- (BOOL)statusCheck{
    if (![self isCameraAvailable]){
//        [self showWarn:NSLocalizedString(@"The device has no camera-the device has no camera function and cannot scan", @"")];
        return NO;
    }
    if (![self isRearCameraAvailable] && ![self isFrontCameraAvailable]) {
//        [self showWarn:NSLocalizedString(@"Device camera error-unable to enable camera, please check", @"")];
        return NO;
    }
    if (![self isCameraAuthStatusCorrect]) {
//        [self showWarn:NSLocalizedString(@"Camera permission is not turned on-please allow access to your camera in the Settings-Privacy-Camera option", @"")];
        return NO;
    }
    return YES;
}

- (void)showWarn:(NSString *)message{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"OK", @"") style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:cancelAction];
    [(UIViewController *)self.delegate presentViewController:alert animated:YES completion:nil];
}


- (void)setupViews{
    [self addSubview:self.middleView];
    [self.middleView addSubview:self.scanLine];
    [self addSubview:self.maskView];
    
    [self addSubview:self.textLabel];
    
    [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.middleView.mas_bottom).offset(IHSDKScaleByWidth(18));
        make.left.mas_equalTo(self).offset(IHSDKScaleByWidth(42));
        make.right.mas_equalTo(self).offset(IHSDKScaleByWidth(-42));
       
    }];
    
    if (self.isShowCornerLine) {
        [self addCornerLines];
    }
    if (self.isShowBorderLine){
        [self addScanBorderLine];
    }
}


- (BOOL)isCameraAvailable{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}

- (BOOL)isFrontCameraAvailable{
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront];
}

- (BOOL)isRearCameraAvailable{
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
}

- (BOOL)isCameraAuthStatusCorrect{
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusAuthorized || authStatus == AVAuthorizationStatusNotDetermined) {
        return YES;
    }
    return NO;
}

- (void)addScanLineAnimation{
    self.scanLine.hidden = NO;
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
    animation.fromValue = @(- scanLineWidth);
    animation.toValue = @(self.scanRect.size.height - scanLineWidth);
    animation.duration = scanTime;
    animation.repeatCount = OPEN_MAX;
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [self.scanLine.layer addAnimation:animation forKey:scanLineAnimationName];
}


- (void)removeScanLineAnimation{
    [self.scanLine.layer removeAnimationForKey:scanLineAnimationName];
    self.scanLine.hidden = YES;
}


#pragma mark - bezierPath

- (void)addScanBorderLine{
    CGRect borderRect = CGRectMake(self.scanRect.origin.x + borderLineWidth, self.scanRect.origin.y + borderLineWidth, self.scanRect.size.width - 2*borderLineWidth, self.scanRect.size.height - 2*borderLineWidth);
    UIBezierPath *scanBezierPath = [UIBezierPath bezierPathWithRect:borderRect];
    CAShapeLayer *lineLayer = [CAShapeLayer layer];
    lineLayer.path = scanBezierPath.CGPath;
    lineLayer.lineWidth = borderLineWidth;
    lineLayer.strokeColor = self.borderLineColor.CGColor;
    lineLayer.fillColor = [UIColor clearColor].CGColor;
    [self.layer addSublayer:lineLayer];
}

- (void)addCornerLines{
    CAShapeLayer *lineLayer = [CAShapeLayer layer];
    lineLayer.lineWidth = cornerLineWidth;
    lineLayer.strokeColor = self.cornerLineColor.CGColor;
    lineLayer.fillColor = [UIColor clearColor].CGColor;
    CGFloat halfLineLong = self.scanRect.size.width / 12;
    UIBezierPath *lineBezierPath = [UIBezierPath bezierPath];
    
    CGFloat spacing = cornerLineWidth/2;
    
    CGPoint leftUpPoint = (CGPoint){self.scanRect.origin.x + spacing ,self.scanRect.origin.y + spacing};
    [lineBezierPath moveToPoint:(CGPoint){leftUpPoint.x,leftUpPoint.y + halfLineLong}];
    [lineBezierPath addLineToPoint:leftUpPoint];
    [lineBezierPath addLineToPoint:(CGPoint){leftUpPoint.x + halfLineLong,leftUpPoint.y}];
    lineLayer.path = lineBezierPath.CGPath;
    [self.layer addSublayer:lineLayer];
    

    CGPoint leftDownPoint = (CGPoint){self.scanRect.origin.x + spacing,self.scanRect.origin.y + self.scanRect.size.height - spacing};
    [lineBezierPath moveToPoint:(CGPoint){leftDownPoint.x,leftDownPoint.y - halfLineLong}];
    [lineBezierPath addLineToPoint:leftDownPoint];
    [lineBezierPath addLineToPoint:(CGPoint){leftDownPoint.x + halfLineLong,leftDownPoint.y}];
    lineLayer.path = lineBezierPath.CGPath;
    [self.layer addSublayer:lineLayer];
    
    CGPoint rightUpPoint = (CGPoint){self.scanRect.origin.x + self.scanRect.size.width - spacing,self.scanRect.origin.y + spacing};
    [lineBezierPath moveToPoint:(CGPoint){rightUpPoint.x - halfLineLong,rightUpPoint.y}];
    [lineBezierPath addLineToPoint:rightUpPoint];
    [lineBezierPath addLineToPoint:(CGPoint){rightUpPoint.x,rightUpPoint.y + halfLineLong}];
    lineLayer.path = lineBezierPath.CGPath;
    [self.layer addSublayer:lineLayer];
    
    CGPoint rightDownPoint = (CGPoint){self.scanRect.origin.x + self.scanRect.size.width - spacing,self.scanRect.origin.y + self.scanRect.size.height - spacing};
    [lineBezierPath moveToPoint:(CGPoint){rightDownPoint.x - halfLineLong,rightDownPoint.y}];
    [lineBezierPath addLineToPoint:rightDownPoint];
    [lineBezierPath addLineToPoint:(CGPoint){rightDownPoint.x,rightDownPoint.y - halfLineLong}];
    lineLayer.path = lineBezierPath.CGPath;
    [self.layer addSublayer:lineLayer];
}



#pragma mark - AVCaptureMetadataOutputObjectsDelegate

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray<AVMetadataMachineReadableCodeObject *> *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    if (metadataObjects.count == 0) {
        return;
    }
    NSString *result = [metadataObjects.firstObject stringValue];
    if ([self.delegate respondsToSelector:@selector(scanView:pickUpMessage:)]) {
        [self.delegate scanView:self pickUpMessage:result];
    }
}

#pragma mark - getter&setter

- (CGRect)scanRect{
    if (CGRectIsEmpty(_scanRect)) {
        CGSize scanSize = CGSizeMake(self.frame.size.width * 3/4, self.frame.size.width * 3/4);
        _scanRect = CGRectMake((self.frame.size.width - scanSize.width)/2, (self.frame.size.height - scanSize.height)/2, scanSize.width, scanSize.height);
    }
    return _scanRect;
}

- (UIView *)maskView{
    if (!_maskView) {
        _maskView = [[UIView alloc]initWithFrame:self.bounds];
        _maskView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5];
        UIBezierPath *fullBezierPath = [UIBezierPath bezierPathWithRect:self.bounds];
        UIBezierPath *scanBezierPath = [UIBezierPath bezierPathWithRect:self.scanRect];
        [fullBezierPath appendPath:[scanBezierPath  bezierPathByReversingPath]];
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        shapeLayer.path = fullBezierPath.CGPath;
        _maskView.layer.mask = shapeLayer;
    }
    return _maskView;
}

- (UIView *)middleView{
    if (!_middleView) {
        _middleView = [[UIView alloc]initWithFrame:self.scanRect];
        _middleView.clipsToBounds = YES;
    }
    return _middleView;
}

- (UILabel *)textLabel{
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] init];
        _textLabel.textAlignment = NSTextAlignmentCenter;
        _textLabel.font = [UIFont systemFontOfSize:16.0];
        _textLabel.numberOfLines=3;
        _textLabel.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
    }
    return _textLabel;
}

- (UIView *)scanLine{
    if (!_scanLine) {
        _scanLine = [[UIView alloc]initWithFrame:CGRectMake(0,0, self.scanRect.size.width, scanLineWidth)];
        _scanLine.hidden = YES;
        CAGradientLayer *gradient = [CAGradientLayer layer];
        gradient.startPoint = CGPointMake(0.5, 0);
        gradient.endPoint = CGPointMake(0.5, 1);
        gradient.frame = _scanLine.layer.bounds;
        gradient.colors = @[(__bridge id)[self.scanLineColor colorWithAlphaComponent:0].CGColor,(__bridge id)[self.scanLineColor colorWithAlphaComponent:0.4f].CGColor,(__bridge id)self.scanLineColor.CGColor];
        gradient.locations = @[@0,@0.96,@0.97];
        [_scanLine.layer addSublayer:gradient];
    }
    return _scanLine;
}


- (UIColor *)cornerLineColor{
    if (!_cornerLineColor) {
        _cornerLineColor = [UIColor colorWithHexString:@"#49A0D9"];
    }
    return _cornerLineColor;
}

- (UIColor *)borderLineColor{
    if (!_borderLineColor) {
        _borderLineColor = [UIColor clearColor];
    }
    return _borderLineColor;
}

- (UIColor *)scanLineColor{
    if (!_scanLineColor) {
        _scanLineColor = [UIColor colorWithHexString:@"#49A0D9"];
        

    }
    return _scanLineColor;
}


@end
