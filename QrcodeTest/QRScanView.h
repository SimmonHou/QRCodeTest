//
//  QRScanView.h
//  QrcodeTest
//
//  Created by 侯伟平 on 16/2/24.
//  Copyright © 2016年 ZaZa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
@class QRScanView;
@protocol QRScanViewDelegate <NSObject>
@optional
-(void)qrScanView:(QRScanView *)scanView scanResult:(NSString *)scanResult;

@end

@interface QRScanView : UIView
@property (nonatomic,strong)id<QRScanViewDelegate>delegate;
@property (nonatomic,assign,readonly) CGRect scanFrame;

-(id)initWithFrame:(CGRect)frame;
-(void)startScan;
-(void)stopScan;



@end
