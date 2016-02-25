//
//  QRWebViewController.m
//  QrcodeTest
//
//  Created by 侯伟平 on 16/2/24.
//  Copyright © 2016年 ZaZa. All rights reserved.
//

#import "QRWebViewController.h"
#import <WebKit/WebKit.h>


@interface QRWebViewController ()<WKNavigationDelegate>
@property (nonatomic,copy)NSURL *url;
@property (nonatomic,copy)NSString *urlString;
@property (nonatomic,strong)UIActivityIndicatorView *indicatorView;

@end


@implementation QRWebViewController

-(id)initWithUrl:(NSString *)url
{
    self = [super init];
    
    if (self) {
        _url = [NSURL URLWithString:url];
        _urlString = url;
    }
    return self;

}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    WKWebView *webView =[[WKWebView alloc]initWithFrame:self.view.bounds];
    webView.navigationDelegate = self;
    [self.view addSubview:webView];
    
    UIBarButtonItem * leftItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    {
    _indicatorView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _indicatorView.frame = CGRectMake((CGRectGetWidth(self.view.frame) - CGRectGetWidth(_indicatorView.frame)) / 2, (CGRectGetHeight(self.view.frame) - CGRectGetHeight(_indicatorView.frame)) / 2, CGRectGetWidth(_indicatorView.frame), CGRectGetHeight(_indicatorView.frame));    [self.view addSubview:_indicatorView];
    
    }
    if (_url.scheme == nil) {
        
        _url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@",_url.absoluteString]];
    }
    
    NSURLRequest * request = [NSURLRequest requestWithURL:_url];

    [webView loadRequest:request];
}

-(void)back
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kStartScanNotification object:nil];
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    [_indicatorView startAnimating];

}
-(void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation{
    
}
-(void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error{
    [_indicatorView stopAnimating];

}

-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    [_indicatorView stopAnimating];

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
