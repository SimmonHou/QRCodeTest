//
//  ScanViewController.m
//  QrcodeTest
//
//  Created by 侯伟平 on 16/2/24.
//  Copyright © 2016年 ZaZa. All rights reserved.
//

#import "QRScanViewController.h"
#import "QRWebViewController.h"


@interface QRScanViewController ()<QRScanViewDelegate>
@property (nonatomic,strong)QRScanView * scanView;
@end

@implementation QRScanViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"扫一扫";
    _scanView = [[QRScanView alloc]initWithFrame:self.view.frame];
    _scanView.delegate = self;
    [self.view addSubview:_scanView];
   [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startScanQrcode:) name:kStartScanNotification object:nil];
}

-(void)qrScanView:(QRScanView *)scanView scanResult:(NSString *)scanResult
{

    QRWebViewController * webCrl = [[QRWebViewController alloc]initWithUrl:scanResult];
    [scanView stopScan];
    [self.navigationController pushViewController:webCrl animated:YES];

}

-(void)startScanQrcode:(id)noti
{
    [_scanView startScan];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)dealloc
{
    [[NSNotificationCenter alloc] removeObserver:self];
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
