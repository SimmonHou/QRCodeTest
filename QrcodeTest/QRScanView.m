//
//  QRScanView.m
//  QrcodeTest
//
//  Created by 侯伟平 on 16/2/24.
//  Copyright © 2016年 ZaZa. All rights reserved.
//

#import "QRScanView.h"

@interface QRScanView ()<AVCaptureMetadataOutputObjectsDelegate>
@property(nonatomic,strong)UIImageView *scanImageView;
@property(nonatomic,strong)UIImageView *lineView;
@property(nonatomic,strong)AVCaptureSession *avCaptureSession;

@end

@implementation QRScanView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        [self initView];
    }
    return self;
}

-(void)initView
{
   // UIImage *scanImage = [UIImage imageNamed:@"view_backImage"];//扫描框图片

    CGFloat width = CGRectGetWidth(self.frame);
    CGFloat height = CGRectGetHeight(self.frame);
    CGFloat scanW = 200;
    CGRect  scanFrame = CGRectMake(width/2.-100, height/2.-100, scanW, scanW);
    
    _scanImageView = [[UIImageView alloc]initWithFrame:scanFrame];
    _scanImageView.backgroundColor = [UIColor clearColor];
//    _scanImageView.frame = scanFrame;
    
    [self addSubview:_scanImageView];
    
    // 获取摄像设备
    
    AVCaptureDevice *denvice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    //闪光灯
    if ([denvice hasFlash] && [denvice hasTorch]) {
        [denvice lockForConfiguration:nil];
        [denvice setFlashMode:AVCaptureFlashModeAuto];
        [denvice setTorchMode:AVCaptureTorchModeAuto];
        [denvice unlockForConfiguration];
        
    }
    //创建输入流
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:denvice error:nil];
    // 创建输出流
    AVCaptureMetadataOutput *outPut = [[AVCaptureMetadataOutput alloc]init];
    //设置代理
    [outPut setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    outPut.rectOfInterest = [self rectOfInterestByScanViewRect:_scanImageView.frame];
    
    // 初始化链接对象
    
    _avCaptureSession = [[AVCaptureSession alloc]init];
    
    _avCaptureSession.sessionPreset = AVCaptureSessionPresetHigh;
    
    if (input) {
        
        [_avCaptureSession addInput:input];
        
    }
    if (outPut) {
        [_avCaptureSession addOutput:outPut];
        
        NSMutableArray *array = [NSMutableArray array];
        if ([outPut.availableMetadataObjectTypes containsObject:AVMetadataObjectTypeQRCode]) {
            [array addObject:AVMetadataObjectTypeQRCode];
        }
        if ([outPut.availableMetadataObjectTypes containsObject:AVMetadataObjectTypeEAN13Code]) {
            [array addObject:AVMetadataObjectTypeEAN13Code];

        }
        if ([outPut.availableMetadataObjectTypes containsObject:AVMetadataObjectTypeEAN8Code]) {
            [array addObject:AVMetadataObjectTypeEAN8Code];
        }
        if ([outPut.availableMetadataObjectTypes containsObject:AVMetadataObjectTypeCode128Code]) {
            [array addObject:AVMetadataObjectTypeCode128Code];
        
    }
    
        outPut.metadataObjectTypes = array;
    }
    
    AVCaptureVideoPreviewLayer *lanyer = [AVCaptureVideoPreviewLayer layerWithSession:_avCaptureSession];
    lanyer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    lanyer.frame = self.bounds;
    [self.layer insertSublayer:lanyer above:0];
    [self bringSubviewToFront:_scanImageView];
    
    [self startScan];

    [self setOverView];
    
}


// 设置扫描的区域

- (CGRect)rectOfInterestByScanViewRect:(CGRect)scanRect
{
    CGFloat width = CGRectGetWidth(self.frame);
    CGFloat height = CGRectGetHeight(self.frame);
    CGFloat x = (height - CGRectGetHeight(scanRect))/2/height;
    CGFloat y = (width - CGRectGetWidth(scanRect))/2/width;
    CGFloat w = CGRectGetHeight(scanRect)/height;
    CGFloat h = CGRectGetWidth(scanRect)/width;
    return CGRectMake(x, y, w, h);

}

-(void)setOverView
{
    CGFloat width = CGRectGetWidth(self.frame);
    CGFloat height = CGRectGetHeight(self.frame);
    
    CGFloat x = CGRectGetMinX(_scanImageView.frame);
    CGFloat y = CGRectGetMinY(_scanImageView.frame);
    CGFloat w = CGRectGetWidth(_scanImageView.frame);
    CGFloat h = CGRectGetHeight(_scanImageView.frame);
    
    [self creatView:CGRectMake(0, 0, width, y)];
    [self creatView:CGRectMake(0, y + h, width, height - y)];
    [self creatView:CGRectMake(0, y, x, h)];
    [self creatView:CGRectMake(x + w, y, x, h)];
    
    
}

- (void)creatView:(CGRect)rect{
    CGFloat alpha = 0.5;
    UIView *view = [[UIView alloc]initWithFrame:rect];
    view.backgroundColor = [UIColor grayColor];
    view.alpha = alpha;
    [self addSubview:view];
}



- (void)loopDrawLine {
    
    UIImage *lineImage = [UIImage imageNamed:@"attentioned_mypg"];
    
    CGFloat x = CGRectGetMinX(_scanImageView.frame);
    CGFloat y = CGRectGetMinY(_scanImageView.frame);
    CGFloat w = CGRectGetWidth(_scanImageView.frame);
    CGFloat h = CGRectGetHeight(_scanImageView.frame);
    
    CGRect start = CGRectMake(x, y, w, 2);
    CGRect end = CGRectMake(x, y + h - 2, w, 2);
    
    if (!_lineView) {
        _lineView = [[UIImageView alloc]initWithImage:lineImage];
        _lineView.frame = start;
        [self addSubview:_lineView];
    }else{
        _lineView.frame = start;
    }
    
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:2 animations:^{
        _lineView.frame = end;
    } completion:^(BOOL finished) {
        [weakSelf loopDrawLine];
    }];
}

-(void)startScan
{
    _lineView.hidden = NO;
    [_avCaptureSession startRunning];
}

-(void)stopScan
{
    _lineView.hidden = YES;
    [_avCaptureSession stopRunning];
}

-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    if (metadataObjects.count > 0) {
        
        AVMetadataMachineReadableCodeObject *mecodeObj = [metadataObjects firstObject];
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(qrScanView:scanResult:)]) {
            
            [self.delegate qrScanView:self scanResult:mecodeObj.stringValue];
        }
    }
    
    
}


@end
