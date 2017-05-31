//
//  JuBaoWebView.m
//  BFTest
//
//  Created by 伯符 on 17/3/21.
//  Copyright © 2017年 bofuco. All rights reserved.
//

#import "JuBaoWebView.h"
#import <WebKit/WebKit.h>

@interface JuBaoWebView ()<WKNavigationDelegate,WKScriptMessageHandler,WKUIDelegate>{
    WKWebView *web;
    UIProgressView *progress;

}

@end

@implementation JuBaoWebView

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}
- (void)viewDidLoad{
    
    
    
    WKWebViewConfiguration *configuretion = [[WKWebViewConfiguration alloc]init];
    
    configuretion.preferences.minimumFontSize = 10;
    configuretion.preferences.javaScriptEnabled = true;
    
    WKPreferences * prefer = [[WKPreferences alloc]init];
    prefer.javaScriptEnabled = YES;
    prefer.minimumFontSize = 20;
    prefer.javaScriptCanOpenWindowsAutomatically = YES;
    configuretion.preferences = prefer;
    web = [[WKWebView alloc]initWithFrame:self.view.bounds configuration:configuretion];
    [web loadRequest:[NSURLRequest requestWithURL:self.pathURL]];
    web.allowsBackForwardNavigationGestures = NO;
    web.scrollView.bounces = NO;
    web.UIDelegate = self;
    web.navigationDelegate = self;
    [web addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    progress = [[UIProgressView alloc]initWithFrame:CGRectMake(0, NavBar_Height, Screen_width, 0)];
    progress.tintColor = [UIColor orangeColor];
    progress.trackTintColor = [UIColor whiteColor];
    [self.view addSubview:progress];
    [self.view insertSubview:web belowSubview:progress];


}

- (void)backItemClick:(UIBarButtonItem *)back{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    if ([webView.URL.absoluteString hasPrefix:@"https://itunes.apple.com"]) {
        [[UIApplication sharedApplication] openURL:navigationAction.request.URL];
        decisionHandler(WKNavigationActionPolicyCancel);
    }else {
        decisionHandler(WKNavigationActionPolicyAllow);
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    if (object == web && [keyPath isEqualToString:@"estimatedProgress"]) {
        CGFloat newprogress = [[change objectForKey:NSKeyValueChangeNewKey] doubleValue];
        if (newprogress == 1) {
            progress.hidden = YES;
            [progress setProgress:0 animated:NO];
        }else {
            progress.hidden = NO;
            [progress setProgress:newprogress animated:YES];
        }
    }
}

// 记得取消监听
- (void)dealloc {
    [web removeObserver:self forKeyPath:@"estimatedProgress"];
}


@end
