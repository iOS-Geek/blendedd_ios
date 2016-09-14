//
//  WebViewVC.h
//  Blendedd
//
//  Created by iOS Developer on 09/11/15.
//  Copyright © 2015 Prabh Kiran Kaur. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
@interface WebViewVC : UIViewController<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *loadWebView;
@property(nonatomic,retain) NSString *urlToload;
@property (weak, nonatomic) NSString *webHeaderProperty;
@property (weak, nonatomic) IBOutlet UILabel *webHeaderLabel;
@property(nonatomic,assign) BOOL load;
@end
