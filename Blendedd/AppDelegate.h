//
//  AppDelegate.h
//  Blendedd
//
//  Created by iOS Developer on 03/11/15.
//  Copyright © 2015 Prabh Kiran Kaur. All rights reserved.
//

#define BaseUrl @"https://blendedd.com/api/"
//#define BaseUrl @"https://erginus.net/blendedd_web/api/"


#import <UIKit/UIKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import "RequestManager.h"
#import "MBProgressHUD.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate,MBProgressHUDDelegate>{
MBProgressHUD *HUD;
}

@property (strong, nonatomic) UIWindow *window;

@property (assign, nonatomic) BOOL loggedIn;
@property (assign, nonatomic) BOOL loggedInWithFB;
@property (assign, nonatomic) BOOL showActivity;

@property(retain,nonatomic) NSString *aboutUsString;
@property(retain,nonatomic) NSString *howWorkString;
@property(retain,nonatomic) NSString *faqString;
@property(retain,nonatomic) NSString *contactUsString;
@property(retain,nonatomic) NSString *storiesString;
@property(retain,nonatomic) NSString *feedbackString;
@property(retain,nonatomic) NSString *privacyString;
@property(retain,nonatomic) NSString *termsString;

-(void)show_LoadingIndicator;
-(void)hide_LoadingIndicator;

@end

