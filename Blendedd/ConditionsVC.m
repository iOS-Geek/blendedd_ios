//
//  ConditionsVC.m
//  Blendedd
//
//  Created by iOS Developer on 09/11/15.
//  Copyright © 2015 Prabh Kiran Kaur. All rights reserved.
//

#import "ConditionsVC.h"

@interface ConditionsVC ()
{
    NSMutableArray *selectedBtnarr;
    AppDelegate *appDelegate;
}
@end

@implementation ConditionsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //fitting text in label
    self.notifyLabel.numberOfLines=0;
    [self.notifyLabel sizeToFit];
    
    selectedBtnarr = [[NSMutableArray alloc]init];
    
    appDelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    
    [self.button1 setBackgroundImage:[UIImage imageNamed:@"check.png"] forState:UIControlStateNormal];
    self.button1.enabled = false;
    
    [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"phoneCheck"];
    
    [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"textCheck"];
    
    [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"policyCheck"];
    
    [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"notificationCheck"];
    
}

#pragma mark - Handling checkboxes

- (IBAction)buttonAction:(id)sender {
    
    UIButton *btn=(UIButton *)sender;
    NSString *Str=[NSString stringWithFormat:@"%ld",(long)btn.tag];
    BOOL flag=   [selectedBtnarr containsObject:Str];
    
    if (flag==YES)
    {
        [btn setBackgroundImage:[UIImage imageNamed:@"nocheck.png"]    forState:UIControlStateNormal];
        [selectedBtnarr removeObject:Str];
        if (btn.tag == 92) {
            [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"phoneCheck"];
        }
        else if (btn.tag == 93) {
            [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"textCheck"];
        }
        else if (btn.tag == 94) {
            [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"policyCheck"];
        }
        else if (btn.tag == 95) {
            [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"notificationCheck"];
        }
    }
    else
    {
        [selectedBtnarr addObject:Str];
        [btn setBackgroundImage:[UIImage imageNamed:@"check.png"] forState:UIControlStateNormal];
        if (btn.tag == 92) {
            [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"phoneCheck"];
        }
        else if (btn.tag == 93) {
            [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"textCheck"];
        }
        else if (btn.tag == 94) {
            [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"policyCheck"];
        }
        else if (btn.tag == 95) {
            [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"notificationCheck"];
        }
        
    }
    
    
}

#pragma mark - Html pages

- (IBAction)showUserTerms:(id)sender {
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    WebViewVC *webView = (WebViewVC*)[mainStoryboard instantiateViewControllerWithIdentifier: @"webView"];
    webView.load=false;
    webView.webHeaderProperty = @"User Terms";
    webView.urlToload = appDelegate.termsString;
    [appDelegate show_LoadingIndicator];
    [self presentViewController:webView animated:YES completion:nil];
}

- (IBAction)showPrivacyPolicies:(id)sender {
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    WebViewVC *webView = (WebViewVC*)[mainStoryboard instantiateViewControllerWithIdentifier: @"webView"];
    webView.load=false;
    webView.webHeaderProperty = @"Privacy Policy";
    webView.urlToload = appDelegate.privacyString;
    [appDelegate show_LoadingIndicator];
    [self presentViewController:webView animated:YES completion:nil];
    
}

#pragma mark - Getting data from server

-(void)getData
{
    
    [RequestManager getFromServer:@"signup_step_four" parameters:[NSMutableDictionary dictionaryWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] stringForKey:@"firstName"],@"user_first_name",[[NSUserDefaults standardUserDefaults] stringForKey:@"lastName"],@"user_last_name",[[NSUserDefaults standardUserDefaults] stringForKey:@"userId"],@"user_login",[[NSUserDefaults standardUserDefaults] stringForKey:@"password"],@"user_login_password",[[NSUserDefaults standardUserDefaults] stringForKey:@"confirmPass"],@"confirm_user_login_password",[[NSUserDefaults standardUserDefaults] stringForKey:@"email"],@"user_email",[[NSUserDefaults standardUserDefaults] stringForKey:@"contact"],@"user_primary_contact",[[NSUserDefaults standardUserDefaults] stringForKey:@"dob"],@"user_dob",[[NSUserDefaults standardUserDefaults] stringForKey:@"add1"],@"user_address_line_1",[[NSUserDefaults standardUserDefaults] stringForKey:@"add2"],@"user_address_line_2",[[NSUserDefaults standardUserDefaults] stringForKey:@"countryId"],@"countries_id",[[NSUserDefaults standardUserDefaults] stringForKey:@"stateId"],@"states_id",[[NSUserDefaults standardUserDefaults] stringForKey:@"cityId"],@"cities_id",[[NSUserDefaults standardUserDefaults] stringForKey:@"zip"],@"user_zipcode",[[NSUserDefaults standardUserDefaults] stringForKey:@"creditName"],@"user_credit_card_name",[[NSUserDefaults standardUserDefaults] stringForKey:@"cardNumber"],@"user_credit_card_number",[[NSUserDefaults standardUserDefaults] stringForKey:@"expirationMonth"],@"user_credit_card_expiry_month",[[NSUserDefaults standardUserDefaults] stringForKey:@"expirationYear"],@"user_credit_card_expiry_year",[[NSUserDefaults standardUserDefaults] stringForKey:@"cvv"],@"user_credit_card_cvv",[[NSUserDefaults standardUserDefaults] stringForKey:@"phoneCheck"],@"user_communication_via_phone_call",[[NSUserDefaults standardUserDefaults] stringForKey:@"textCheck"],@"user_communication_via_sms",[[NSUserDefaults standardUserDefaults] stringForKey:@"policyCheck"],@"user_agreement",[[NSUserDefaults standardUserDefaults] stringForKey:@"notificationCheck"],@"user_newsletter_subscription", nil] completionHandler:^(NSDictionary *responseDict) {
        
        
        if ([[responseDict valueForKey:@"code"] isEqualToString:@"0"]) {
            NSLog(@"sorryy!!");
        }
        else if ([[responseDict valueForKey:@"code"] isEqualToString:@"1"]) {
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:[responseDict valueForKey:@"message"] preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
                                 {
                                     [self success];
                                     [appDelegate hide_LoadingIndicator];
                                 }];
            [alertController addAction:ok];
            
            [self presentViewController:alertController animated:YES completion:nil];
            
        }
        
        
    }];
    
}

#pragma mark - Navigation

//move to next controller on success

-(void)success {
    UIViewController *vc = self.presentingViewController;
    while (vc.presentingViewController) {
        vc = vc.presentingViewController;
    }
    [vc dismissViewControllerAnimated:YES completion:NULL];
    //clearing all user defaults
    NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
    [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
    
    
}

- (IBAction)submitRegistrationAction:(id)sender {
    [appDelegate show_LoadingIndicator];
    [self getData];
    
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
