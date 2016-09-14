//
//  SlideMenuVC.m
//  Blendedd
//
//  Created by iOS Developer on 03/11/15.
//  Copyright © 2015 Prabh Kiran Kaur. All rights reserved.
//

#import "SlideMenuVC.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>


@interface SlideMenuVC ()

@end

@implementation SlideMenuVC{
    NSArray *menuItems;
    AppDelegate *appDelegate;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    appDelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    int height = [UIScreen mainScreen].bounds.size.height;
    if (height != 480){
        self.menuTable.scrollEnabled = false;
    }
}

// setting up table contents

-(void)viewWillAppear:(BOOL)animated
{
    if (appDelegate.loggedIn == YES) {
         menuItems = @[@"About Blendedd App",@"User Settings",@"About Us",@"How Does It Work",@"FAQ",@"Contact Us",/*@"Stories",*/@"Feedback",@"Privacy",@"Terms",@"Logout"];
    }else{
          menuItems = @[@"About Blendedd App",@"About Us",@"How Does It Work",@"FAQ",@"Contact Us",/*@"Stories",*/@"Feedback",@"Privacy",@"Terms"];
    }
    [self.menuTable reloadData];
}

#pragma mark - Table View Data Source

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
     int height = [UIScreen mainScreen].bounds.size.height;
    if (height != 480){
        return 44;
    }
    else{
        return 35;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return menuItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"CellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.text = [menuItems objectAtIndex:indexPath.row];
    return cell;
    
}

#pragma mark - Table View Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    WebViewVC *webView = (WebViewVC*)[mainStoryboard instantiateViewControllerWithIdentifier: @"webView"];
    UITabBarController *tabView = (UITabBarController*)[mainStoryboard instantiateViewControllerWithIdentifier: @"editingTabBar"];
//    UserActivitiesVC *activityViewController = (UserActivitiesVC*)[mainStoryboard instantiateViewControllerWithIdentifier:@"activityView"];
    
    webView.load=false;
    
    [self.revealViewController revealToggleAnimated:YES];
    
    
    webView.webHeaderProperty = [menuItems objectAtIndex:indexPath.row];
    
    [appDelegate show_LoadingIndicator];
    
    // when user is logged in
    
    if (appDelegate.loggedIn == YES) {
        
        if (indexPath.row == 0) {
            
            
            UIAlertController*  alertController = [UIAlertController alertControllerWithTitle:nil message:@"Thank you for using Blendedd's App. This app is only for renting items and paying for services. For full features please visit our website - www.blendedd.com" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            }];
            [alertController addAction:ok];
            
            [appDelegate hide_LoadingIndicator];
            [self presentViewController:alertController animated:YES completion:nil];
            
        }
        else if (indexPath.row == 1){
            
            [self presentViewController:tabView animated:YES completion:^{
                [appDelegate hide_LoadingIndicator];
            }];
            
        }
        else if (indexPath.row == 2){
            
            webView.urlToload = appDelegate.aboutUsString;
            
            
            [self presentViewController:webView animated:YES completion:nil];
            
        }
        else if (indexPath.row == 3){
            
            webView.urlToload = appDelegate.howWorkString;
            [self presentViewController:webView animated:YES completion:nil];
            
        }
        else if (indexPath.row == 4){
            
            webView.urlToload = appDelegate.faqString;
            [self presentViewController:webView animated:YES completion:nil];
            
        }
        else if (indexPath.row == 5){
            
            webView.urlToload = appDelegate.contactUsString;
            [self presentViewController:webView animated:YES completion:nil];
            
        }
//        else if (indexPath.row == 6){
//            
//            webView.urlToload = appDelegate.storiesString;
//            [self presentViewController:webView animated:YES completion:nil];
//            
//        }
        else if (indexPath.row == 6){
            
            webView.urlToload = appDelegate.feedbackString;
            [self presentViewController:webView animated:YES completion:nil];
            
        }else if (indexPath.row == 7){
            
            webView.urlToload = appDelegate.privacyString;
            [self presentViewController:webView animated:YES completion:nil];
            
        }else if (indexPath.row == 8){
            
            webView.urlToload = appDelegate.termsString;
            [self presentViewController:webView animated:YES completion:nil];
            
        }else if (indexPath.row == 9)
        {
            if (appDelegate.loggedIn == YES && appDelegate.loggedInWithFB == YES) {
                [[[FBSDKLoginManager alloc] init] logOut];
            }
            appDelegate.loggedIn = NO;
            appDelegate.loggedInWithFB = NO;
            
            //dismiss all presented view controllers if any
            UIViewController *vc = self.presentingViewController;
            while (vc.presentingViewController) {
                vc = vc.presentingViewController;
            }
            [vc dismissViewControllerAnimated:YES completion:NULL];
            
            //clearing all user defaults
            NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
            [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
            
            [appDelegate hide_LoadingIndicator];
        }
        
    }else                   // when user is logged out
    {
        
        if (indexPath.row == 0){
            
            UIAlertController*  alertController = [UIAlertController alertControllerWithTitle:nil message:@"Thank you for using Blendedd's App. This app is only for renting items and paying for services. For full features please visit our website - www.blendedd.com" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            }];
            [alertController addAction:ok];
            
            [appDelegate hide_LoadingIndicator];
            [self presentViewController:alertController animated:YES completion:nil];
            
            
            
            
        }
        else if (indexPath.row == 1){
            
            webView.urlToload = appDelegate.aboutUsString;
            [self presentViewController:webView animated:YES completion:nil];
            
        }
        else if (indexPath.row == 2){
            webView.urlToload = appDelegate.howWorkString;
            [self presentViewController:webView animated:YES completion:nil];
            
            
        }
        else if (indexPath.row == 3){
            webView.urlToload = appDelegate.faqString;
            [self presentViewController:webView animated:YES completion:nil];
            
            
        }
//        else if (indexPath.row == 4){
//            
//            webView.urlToload = appDelegate.storiesString;
//            [self presentViewController:webView animated:YES completion:nil];
//            
//        }
        else if (indexPath.row == 4){
            webView.urlToload = appDelegate.contactUsString;
            [self presentViewController:webView animated:YES completion:nil];
            
            
        }else if (indexPath.row == 5){
            webView.urlToload = appDelegate.feedbackString;
            [self presentViewController:webView animated:YES completion:nil];
            
            
        }else if (indexPath.row == 6){
            
            webView.urlToload = appDelegate.privacyString;
            [self presentViewController:webView animated:YES completion:nil];
            
        }else if (indexPath.row == 7){
            
            webView.urlToload = appDelegate.termsString;
            [self presentViewController:webView animated:YES completion:nil];
            
        }
        
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

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
