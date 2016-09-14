//
//  LoginVC.m
//  Blendedd
//
//  Created by iOS Developer on 04/11/15.
//  Copyright © 2015 Prabh Kiran Kaur. All rights reserved.
//

#import "LoginVC.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
@class CommonHeaderVC;

@interface LoginVC ()
{
    AppDelegate *appDelegate;
    NSString *emailFromFacebook;
    NSString *firstNameFromFacebook;
    NSString *lastNameFromFacebook;
    NSString *userIdFromFacebook;
    CommonHeaderVC *embed;
    int height;
}
@property (weak, nonatomic) IBOutlet UIScrollView *scrollV;



@end

@implementation LoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    appDelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    height = [UIScreen mainScreen].bounds.size.height;
    if (height != 480){
        self.scrollV.scrollEnabled = false;
    }
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapFrom)];
    
    [self.scrollV addGestureRecognizer:tapGestureRecognizer];
}

#pragma mark - Getting data from Server

-(void)getData
{
    NSString *serverString;
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    // checking if login is from facebook or otherwise
    
    if (appDelegate.loggedIn == YES && appDelegate.loggedInWithFB == YES) {
        serverString = @"social_media_login";
        dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:emailFromFacebook,@"user_email",firstNameFromFacebook,@"user_first_name",lastNameFromFacebook,@"user_last_name",userIdFromFacebook,@"user_facebook_id", nil];
    }else{
        serverString = @"login";
        dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:self.emailTextField.text,@"user_login",self.passwordTextField.text,@"user_login_password", nil];
    }
    
    [RequestManager getFromServer:serverString parameters:dict completionHandler:^(NSDictionary *responseDict) {
        
        NSLog(@"response ::  %@",responseDict);
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:[responseDict valueForKey:@"message"] preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        
        [self presentViewController:alertController animated:YES completion:nil];
        
        
        if ([[responseDict valueForKey:@"code"] isEqualToString:@"1"]){
            
            
            NSDictionary *dataDict = [responseDict valueForKey:@"data"];
            
            
            [[NSUserDefaults standardUserDefaults]setObject:[dataDict valueForKey:@"user_id"] forKey:@"logged_user_id"];
            NSLog(@"%@",[[NSUserDefaults standardUserDefaults]stringForKey:@"logged_user_id"]);
            [[NSUserDefaults standardUserDefaults]setObject:[dataDict valueForKey:@"user_security_hash"] forKey:@"logged_user_security_hash"];
            NSLog(@"%@",[[NSUserDefaults standardUserDefaults]stringForKey:@"logged_user_security_hash"]);
            [[NSUserDefaults standardUserDefaults]setObject:[dataDict valueForKey:@"user_first_name"] forKey:@"logged_user_first_name"];
            
            [[NSUserDefaults standardUserDefaults]setObject:[dataDict valueForKey:@"user_last_name"] forKey:@"logged_user_last_name"];
            
            [[NSUserDefaults standardUserDefaults]setObject:[dataDict valueForKey:@"user_credit_card_name"] forKey:@"logged_user_credit_card_name"];
            
            [[NSUserDefaults standardUserDefaults]setObject:[dataDict valueForKey:@"user_credit_card_number"] forKey:@"logged_user_credit_card_number"];
            
            [[NSUserDefaults standardUserDefaults]setObject:[dataDict valueForKey:@"user_credit_card_expiry_month"] forKey:@"logged_user_credit_card_expiry_month"];
            
            [[NSUserDefaults standardUserDefaults]setObject:[dataDict valueForKey:@"user_credit_card_expiry_year"] forKey:@"logged_user_credit_card_expiry_year"];
            
            [[NSUserDefaults standardUserDefaults]setObject:[dataDict valueForKey:@"user_credit_card_cvv"] forKey:@"logged_user_credit_card_cvv"];
            
            [[NSUserDefaults standardUserDefaults]setObject:[dataDict valueForKey:@"user_communication_via_email"] forKey:@"logged_user_communication_via_email"];
            
            [[NSUserDefaults standardUserDefaults]setObject:[dataDict valueForKey:@"user_communication_via_phone_call"] forKey:@"logged_user_communication_via_phone_call"];
            
            [[NSUserDefaults standardUserDefaults]setObject:[dataDict valueForKey:@"user_communication_via_sms"] forKey:@"logged_user_communication_via_sms"];
            
            [[NSUserDefaults standardUserDefaults]setObject:[dataDict valueForKey:@"user_facebook_url"] forKey:@"logged_user_facebook_url"];
            
            [[NSUserDefaults standardUserDefaults]setObject:[dataDict valueForKey:@"user_twitter_url"] forKey:@"logged_user_twitter_url"];
            
            [[NSUserDefaults standardUserDefaults]setObject:[dataDict valueForKey:@"user_linkedin_url"] forKey:@"logged_user_linkedin_url"];
            
            [[NSUserDefaults standardUserDefaults]setObject:[dataDict valueForKey:@"user_instagram_url"] forKey:@"logged_user_instagram_url"];
            
            [[NSUserDefaults standardUserDefaults]setObject:[dataDict valueForKey:@"user_address_line_1"] forKey:@"logged_user_address_line_1"];
            
            [[NSUserDefaults standardUserDefaults]setObject:[dataDict valueForKey:@"user_address_line_2"] forKey:@"logged_user_address_line_2"];
            
            [[NSUserDefaults standardUserDefaults]setObject:[dataDict valueForKey:@"user_zipcode"] forKey:@"logged_user_zipcode"];
            
            NSLog(@"%@",[dataDict valueForKey:@"city_name"]);
            
            if ([dataDict valueForKey:@"city_name"] == (id)[NSNull null]) {
                // is null
            }else{
                [[NSUserDefaults standardUserDefaults]setObject:[dataDict valueForKey:@"city_name"] forKey:@"logged_city_name"];
                
                [[NSUserDefaults standardUserDefaults]setObject:[dataDict valueForKey:@"cities_id"] forKey:@"logged_cities_id"];
                
            }
            
            if ([dataDict valueForKey:@"state_name"] == (id)[NSNull null]) {
                // is null
            }else{
                [[NSUserDefaults standardUserDefaults]setObject:[dataDict valueForKey:@"state_name"] forKey:@"logged_state_name"];
                
                [[NSUserDefaults standardUserDefaults]setObject:[dataDict valueForKey:@"states_id"] forKey:@"logged_states_id"];
                
                
            }
            if ([dataDict valueForKey:@"country_name"] == (id)[NSNull null]) {
                // is null
            }else{
                [[NSUserDefaults standardUserDefaults]setObject:[dataDict valueForKey:@"country_name"] forKey:@"logged_country_name"];
                
                [[NSUserDefaults standardUserDefaults]setObject:[dataDict valueForKey:@"countries_id"] forKey:@"logged_countries_id"];
                
            }
            
            
            if (appDelegate.loggedIn == YES && appDelegate.loggedInWithFB == YES) {
                
                
                [[NSUserDefaults standardUserDefaults]setObject:[dataDict valueForKey:@"user_email"] forKey:@"logged_user_email"];
                
                [[NSUserDefaults standardUserDefaults]setObject:[dataDict valueForKey:@"user_facebook_id"] forKey:@"logged_user_facebook_id"];
                NSLog(@"%@",[[NSUserDefaults standardUserDefaults]stringForKey:@"logged_user_facebook_id"]);
                
                
            }
            
            //hide login tab on success
            
            NSMutableArray *tabbarViewControllers = [NSMutableArray arrayWithArray: [self.tabBarController viewControllers]];
            [tabbarViewControllers removeObjectAtIndex: 2];
            [self.tabBarController setViewControllers: tabbarViewControllers ];
            
        }
        [appDelegate hide_LoadingIndicator];
    }];
    
}

#pragma mark - Button Actions

// forgot password

- (IBAction)forgotPasswordButtonAction:(id)sender {
    [appDelegate show_LoadingIndicator];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ForgotPasswordVC *viewController = (ForgotPasswordVC *)[storyboard instantiateViewControllerWithIdentifier:@"forgotView"];
    [self presentViewController:viewController animated:YES completion:^{
        [appDelegate hide_LoadingIndicator];
    }];
    
    
}

// registration

- (IBAction)registerButtonAction:(id)sender {
    [appDelegate show_LoadingIndicator];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SignUpVC *viewController = (SignUpVC *)[storyboard instantiateViewControllerWithIdentifier:@"signView"];
    [self presentViewController:viewController animated:YES completion:nil];
}

// login

- (IBAction)loginButtonPressed:(id)sender {
    if ([self.emailTextField.text isEqualToString:@""] || [self.passwordTextField.text isEqualToString:@""]) {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"Please fill both the fields." preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        
        [self presentViewController:alertController animated:YES completion:nil];
        
    }
    else {
        [appDelegate show_LoadingIndicator];
        appDelegate.loggedIn = YES;
        appDelegate.loggedInWithFB = NO;
        [self getData];
    }
}

// facebook login

- (IBAction)fbLoginButoonAction:(id)sender {
    
    
    // change info.plist for blendedd facebook login currently using fha's fb login
    // 1- FacebookAppID
    // 2-FacebookAppSecret
    // 3-FacebookDisplayName
    // 4-UrlTypes/UrlSchemes/item0
    
    
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    
    if ([FBSDKAccessToken currentAccessToken]) {
        [login logOut];
        //picView.profileID=[FBSDKAccessToken currentAccessToken].userID;
    }
    
    [login logInWithReadPermissions:@[@"email",@"public_profile"] fromViewController:self handler:^(FBSDKLoginManagerLoginResult *result, NSError *error)
     
     {
         if (error)
         {
             // Process error
             //  [appDelegate hide_LoadingIndicator];
         } else if (result.isCancelled)
         {
             // Handle cancellations
             
             
             UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Try Again" message:@"Login Failed from facebook" preferredStyle:UIAlertControllerStyleAlert];
             
             UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
             [alertController addAction:ok];
             //  [appDelegate hide_LoadingIndicator];
             [self presentViewController:alertController animated:YES completion:nil];
             
         } else
         {
             
             // If you ask for multiple permissions at once, you
             // should check if specific permissions missing
             if ([result.grantedPermissions containsObject:@"email"]) {
                 // Do work
                 
                 [appDelegate show_LoadingIndicator];
                 
                 NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
                 [parameters setValue:@"id,first_name,last_name,gender,email" forKey:@"fields"];
                 
                 [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:parameters]
                  startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
                      if (!error) {
                          
                          //// Do here what you want after login success from facebook
                          
                          NSLog(@"%@",result[@"email"]);
                          NSLog(@"%@",result[@"first_name"]);
                          NSLog(@"%@",result[@"last_name"]);
                          NSLog(@"%@",result[@"id"]);
                          
                          emailFromFacebook = [NSString stringWithFormat:@"%@",result[@"email"]];
                          firstNameFromFacebook = [NSString stringWithFormat:@"%@",result[@"first_name"]];
                          lastNameFromFacebook = [NSString stringWithFormat:@"%@",result[@"last_name"]];
                          userIdFromFacebook = [NSString stringWithFormat:@"%@",result[@"id"]];
                          
                          appDelegate.loggedIn = YES;
                          appDelegate.loggedInWithFB = YES;
                          [self getData];
                      }
                      
                      
                  }];
             }
         }
     }];
    
    
    
    
}

-(void)handleTapFrom{
    [self.emailTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
    [embed.categoriesSearchBar resignFirstResponder];
   // [self.scrollV setContentOffset:CGPointMake(0, 0) animated:YES];
}

#pragma mark - handling keyboard with textfield delegate and touches

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
    if (height==480) {
    if (textField.tag == 101){
        [self.scrollV setContentOffset:CGPointMake(0, 110) animated: YES];
    }
    else{
       // [self.scrollV setContentOffset:CGPointMake(0, 110) animated:YES];
    }
}
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    if (textField.tag == 101) {
        [self.passwordTextField becomeFirstResponder];
    }
    else
    {
        [textField resignFirstResponder];
    }
    
    return YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
    UITouch *touch = [touches anyObject];
    if(touch.phase == UITouchPhaseBegan) {
        [self.emailTextField resignFirstResponder];
        [self.passwordTextField resignFirstResponder];
    }
    
}

#pragma mark - Segue for common view

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"LoginSegue"]) {
         embed = (CommonHeaderVC*)segue.destinationViewController;
        embed.headerProperty = @"Login";
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
        [embed.view addGestureRecognizer:tapGesture];
    }
}

-(void)handleTapGesture:(UITapGestureRecognizer*)gesture{
    [self.emailTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
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
