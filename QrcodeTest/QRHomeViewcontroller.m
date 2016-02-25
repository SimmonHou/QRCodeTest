//
//  FirstViewcontroller.m
//  QrcodeTest
//
//  Created by 侯伟平 on 16/2/24.
//  Copyright © 2016年 ZaZa. All rights reserved.
//

#import "QRHomeViewcontroller.h"
#import "QRScanViewController.h"
@interface QRHomeViewcontroller ()

@end

@implementation QRHomeViewcontroller

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *butn =[[UIButton alloc]initWithFrame:CGRectMake((CGRectGetWidth(self.view.frame)-200)/2, (CGRectGetHeight(self.view.frame)-200)/2, 200, 200)];
    butn.backgroundColor = [UIColor blueColor];
    [butn setTitle:@"扫一扫" forState:UIControlStateNormal];
    [butn addTarget:self action:@selector(toNextCrl) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:butn];

    
    
    // Do any additional setup after loading the view.
}

-(void)toNextCrl
{
    QRScanViewController *scanView  = [[QRScanViewController alloc]init];
    [self.navigationController pushViewController:scanView animated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
