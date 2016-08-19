//
//  XMGWebViewController.m
//  20160331BuDeJie
//
//  Created by Hahn on 16/4/7.
//  Copyright © 2016年 Hahn. All rights reserved.
//

#import "XMGWebViewController.h"
#import <WebKit/WebKit.h>
@interface XMGWebViewController ()
@property (nonatomic, weak) WKWebView *webView;
@end

@implementation XMGWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
//    WKWebView *webView = [[WKWebView alloc] initWithFrame:self.view.bounds];
    WKWebView *webView = [[WKWebView alloc] init];
    
    [self.view addSubview:webView];
    self.webView = webView;
    
    NSURLRequest *request = [NSURLRequest requestWithURL:self.url];
    [webView loadRequest:request];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.webView.frame = self.view.bounds;
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
