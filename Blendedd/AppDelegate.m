//
//  AppDelegate.m
//  Blendedd
//
//  Created by iOS Developer on 03/11/15.
//  Copyright © 2015 Prabh Kiran Kaur. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

@synthesize aboutUsString,contactUsString,faqString,feedbackString,howWorkString,termsString,privacyString,storiesString,loggedIn,loggedInWithFB,showActivity;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    //launch image animation
    
    [self.window makeKeyAndVisible];
    [self.window setBackgroundColor:[UIColor whiteColor]];
    
    UIView *launchView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.window.frame.size.width, self.window.frame.size.height)];
    launchView.backgroundColor = [UIColor whiteColor];
    [self.window addSubview:launchView];
    [self.window bringSubviewToFront:launchView];
    UIImageView *logoView = [[UIImageView alloc]initWithFrame:CGRectMake(55, self.window.frame.size.height + 10, self.window.frame.size.width - 110, 45)];
    logoView.image = [UIImage imageNamed:@"logo2.png"];
    [launchView addSubview:logoView];
    [UIWindow animateWithDuration:2.5 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        logoView.frame = CGRectMake(55, self.window.frame.size.height/2 - 22.5, self.window.frame.size.width - 110, 45);
        
    } completion:^(BOOL finished){
        [launchView removeFromSuperview];
        [logoView removeFromSuperview];
    }];
    
    
    // session login
    
    if ([[NSUserDefaults standardUserDefaults]stringForKey:@"logged_user_id"] && [[NSUserDefaults standardUserDefaults]stringForKey:@"logged_user_security_hash"]) {
        
        loggedIn = YES;
        
        if ([[NSUserDefaults standardUserDefaults]stringForKey:@"logged_user_facebook_id"]) {
            loggedInWithFB = YES;
        }else{
            loggedInWithFB = NO;
        }
        
        [RequestManager getFromServer:@"session_login" parameters:[NSMutableDictionary dictionaryWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults]stringForKey:@"logged_user_id"],@"user_id",[[NSUserDefaults standardUserDefaults]stringForKey:@"logged_user_security_hash"],@"user_security_hash", nil] completionHandler:^(NSDictionary *responseDict) {
            
            if ([[responseDict valueForKey:@"code"] isEqualToString:@"0"]) {
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:[responseDict valueForKey:@"message"] preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                [alertController addAction:ok];
                
                [self.window.rootViewController presentViewController:alertController animated:YES completion:nil];
            }
            else if ([[responseDict valueForKey:@"code"] isEqualToString:@"1"]){
                
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
                if (loggedIn == YES && loggedInWithFB == YES) {
                    
                    
                    [[NSUserDefaults standardUserDefaults]setObject:[dataDict valueForKey:@"user_email"] forKey:@"logged_user_email"];
                    
                    [[NSUserDefaults standardUserDefaults]setObject:[dataDict valueForKey:@"user_facebook_id"] forKey:@"logged_user_facebook_id"];
                    NSLog(@"%@",[[NSUserDefaults standardUserDefaults]stringForKey:@"logged_user_facebook_id"]);
                    
                    
                }
                
                
            }
            
        }];
        
    }
    
    else{
        
        loggedIn = NO;
        loggedInWithFB = NO;
        
        [[FBSDKApplicationDelegate sharedInstance] application:application
                                 didFinishLaunchingWithOptions:launchOptions];
    }
    
    showActivity = NO;
    
    // http pages
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"now",@"current_timestamp", nil];
    [RequestManager getFromServer:@"strings" parameters:dic completionHandler:^(NSDictionary *responseDict) {
        
        if ([[responseDict valueForKey:@"error"] isEqualToString:@"1"]) {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"Please check your Internet Connection" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
            [alertController addAction:ok];
            
            [self.window.rootViewController presentViewController:alertController animated:YES completion:nil];
        }
        else
        {
            NSDictionary *dict=[responseDict valueForKey:@"data"];
            aboutUsString=[dict valueForKey:@"about_us"];
            howWorkString=[dict valueForKey:@"how_does_it_work"];
            faqString=[dict valueForKey:@"faq"];
            contactUsString=[dict valueForKey:@"contact_us"];
            storiesString=[dict valueForKey:@"stories"];
            feedbackString=[dict valueForKey:@"feedback"];
            privacyString=[dict valueForKey:@"privacy"];
            termsString=[dict valueForKey:@"terms"];
        }
        
    }];
    
    
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                          openURL:url
                                                sourceApplication:sourceApplication
                                                       annotation:annotation];
}

-(void)show_LoadingIndicator
{
    if(!HUD)
    {
        HUD = [[MBProgressHUD alloc] initWithView:self.window];
        [self.window addSubview:HUD];
        HUD.delegate = self;
        HUD.labelText = @"Loading . . .";
        
    }
    [HUD show:YES];
    [self.window performSelector:@selector(bringSubviewToFront:) withObject:HUD afterDelay:0.1];
    NSLog(@"Hud Shown");
}


-(void)hide_LoadingIndicator
{
    if(HUD)
    {
        [HUD hide:YES];
    }
    NSLog(@"Hud hidden");
}

@end
