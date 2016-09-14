//
//  WebViewVC.m
//  Blendedd
//
//  Created by iOS Developer on 09/11/15.
//  Copyright © 2015 Prabh Kiran Kaur. All rights reserved.
//

#import "WebViewVC.h"

@interface WebViewVC ()
{
    AppDelegate *appDelegate;
}
@end

@implementation WebViewVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    appDelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    self.loadWebView.delegate = self;
    
    if(self.load){
        
        NSURLRequest *requestObj = [NSURLRequest requestWithURL:[NSURL URLWithString:self.urlToload]];
        [self.loadWebView loadRequest:requestObj];
    }
    else{
        [self.loadWebView loadHTMLString:self.urlToload baseURL:nil];
    }
    
    self.webHeaderLabel.text = self.webHeaderProperty;
}

#pragma mark - Webview delegate

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [appDelegate hide_LoadingIndicator];
    
    // Disable user selection
    [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitUserSelect='none';"];
    // Disable callout
    [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitTouchCallout='none';"];
}

#pragma mark - Navigation

- (IBAction)backToHomeButtonAction:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

#pragma mark - Orientation

- (UIInterfaceOrientationMask) supportedInterfaceOrientations {
    
    return UIInterfaceOrientationMaskPortrait;
    
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
