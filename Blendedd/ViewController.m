//
//  ViewController.m
//  Blendedd
//
//  Created by iOS Developer on 03/11/15.
//  Copyright © 2015 Prabh Kiran Kaur. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
{
    AppDelegate *appDelegate;
}
@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.revealViewController.delegate = self;
    appDelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    
}

-(void)viewDidAppear:(BOOL)animated
{
    if (appDelegate.loggedIn == YES || appDelegate.loggedInWithFB == YES) {
        NSMutableArray *tabbarViewControllers = [NSMutableArray arrayWithArray: [self.tabBarController viewControllers]];
        
        if (tabbarViewControllers.count > 2) {
            [tabbarViewControllers removeObjectAtIndex: 2];
        }
        
        [self.tabBarController setViewControllers: tabbarViewControllers ];
    }
}

#pragma mark - Page links

// facebook link

- (IBAction)facebookButtonPressed:(id)sender {
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main"
                                                             bundle: nil];
    WebViewVC *webView = (WebViewVC*)[mainStoryboard
                                      instantiateViewControllerWithIdentifier: @"webView"];
    webView.urlToload=@"https://www.facebook.com/pages/Blendedd/799170836836921";
    [appDelegate show_LoadingIndicator];
    webView.load=true;
    [self presentViewController:webView animated:YES completion:nil];
    
}

// twitter link

- (IBAction)twitterButtonPressed:(id)sender {
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main"
                                                             bundle: nil];
    WebViewVC *webView = (WebViewVC*)[mainStoryboard
                                      instantiateViewControllerWithIdentifier: @"webView"];
    webView.urlToload=@"https://twitter.com/blendedd";
    [appDelegate show_LoadingIndicator];
    webView.load=true;
    [self presentViewController:webView animated:YES completion:nil];
}

// google link

- (IBAction)googleButtonPressed:(id)sender {
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main"
                                                             bundle: nil];
    WebViewVC *webView = (WebViewVC*)[mainStoryboard
                                      instantiateViewControllerWithIdentifier: @"webView"];
    webView.urlToload=@"https://plus.google.com/+Blendedd";
    [appDelegate show_LoadingIndicator];
    webView.load=true;
    [self presentViewController:webView animated:YES completion:nil];
}


#pragma mark - SWRevealviewController Delegate

- (void)revealController:(SWRevealViewController *)revealController didMoveToPosition:(FrontViewPosition)position
{
    if (appDelegate.loggedIn == NO) {
        
        if(position == FrontViewPositionLeft)
        {
            NSMutableArray *tabbarViewControllers = [NSMutableArray arrayWithArray: [self.tabBarController viewControllers]];
            
            if (tabbarViewControllers.count < 3) {
                UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main"
                                                                         bundle: nil];
                LoginVC *logView = (LoginVC*)[mainStoryboard
                                              instantiateViewControllerWithIdentifier: @"loginView"];
                
                [tabbarViewControllers insertObject:logView atIndex:2];
                
            }
            [self.tabBarController setViewControllers: tabbarViewControllers ];
        } else
        {
            
        }
    }
}

#pragma mark - Segue to common view

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"HomeSegue"]) {
        CommonHeaderVC *embed = segue.destinationViewController;
        embed.headerProperty = @"Home";
    }
}

#pragma mark - Orientation

- (UIInterfaceOrientationMask) supportedInterfaceOrientations {
    
    return UIInterfaceOrientationMaskPortrait;
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
