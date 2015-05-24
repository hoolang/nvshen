//
//  ILHtmlViewController.m
//  ItheimaLottery
//
//  Created by apple on 14-9-12.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import "HLHtmlViewController.h"

#import "HLHtml.h"

@interface HLHtmlViewController ()<UIWebViewDelegate>

@end

@implementation HLHtmlViewController



- (void)loadView
{
    self.view = [[UIWebView alloc] init];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIBarButtonItem *cancle = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleBordered target:self action:@selector(cancle)];
    self.navigationItem.leftBarButtonItem = cancle;
    
    
    UIWebView *webView = (UIWebView *)self.view;
    
    // 加载资源包里面的Html
    NSURL *url = [[NSBundle mainBundle] URLForResource:_html.html withExtension:nil];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    webView.delegate = self;
    
    [webView loadRequest:request];
    
}

// 加载完网页调用
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSString *js = [NSString stringWithFormat:@"window.location.href = '#%@';",_html.ID];
    [webView stringByEvaluatingJavaScriptFromString:js];
}

- (void)cancle
{
    // 回到上一个控制器
    [self dismissViewControllerAnimated:YES completion:nil];

}





@end
