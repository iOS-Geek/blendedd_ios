//
//  ChangePasswordVC.m
//  Blendedd
//
//  Created by iOS Developer on 09/11/15.
//  Copyright © 2015 Prabh Kiran Kaur. All rights reserved.
//

#import "ChangePasswordVC.h"

@interface ChangePasswordVC ()
{
    AppDelegate *appDelegate;
}
@end

@implementation ChangePasswordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    appDelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    //hide password tab if facebook login is done
    if (appDelegate.loggedInWithFB == YES) {
        NSMutableArray *tabbarViewControllers = [NSMutableArray arrayWithArray: [self.tabBarController viewControllers]];
        [tabbarViewControllers removeObjectAtIndex: 0];
        [self.tabBarController setViewControllers: tabbarViewControllers ];
    }
}

#pragma mark - Getting data from Server

-(void)getData
{
    
    [RequestManager getFromServer:@"change_password" parameters:[NSMutableDictionary dictionaryWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] stringForKey:@"logged_user_id"],@"user_id",[[NSUserDefaults standardUserDefaults] stringForKey:@"logged_user_security_hash"],@"user_security_hash",self.userNewPasswordField.text,@"user_login_password",self.confirmNewPasswordField.text,@"user_confirm_password", nil] completionHandler:^(NSDictionary *responseDict) {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:[responseDict valueForKey:@"message"] preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        
        [self presentViewController:alertController animated:YES completion:nil];
        
        
        if ([[responseDict valueForKey:@"code"] isEqualToString:@"1"]){
            
            NSDictionary *dataDict = [responseDict valueForKey:@"data"];
            
            [[NSUserDefaults standardUserDefaults]setObject:[dataDict valueForKey:@"user_security_hash"] forKey:@"logged_user_security_hash"];
            
        }
        
    }];
    
}

#pragma mark - Submitted new password

- (IBAction)submitNewPassword:(id)sender {
    
    if ([self.userNewPasswordField.text isEqualToString:@""] || [self.confirmNewPasswordField.text isEqualToString:@""]) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"Please fill both the fields." preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        
        [self presentViewController:alertController animated:YES completion:nil];
        
    }
    else {
        
        [self getData];
        
    }
    
}

#pragma mark - handling keyboard with textfield delegate and touches

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.tag == 401) {
        [self.confirmNewPasswordField becomeFirstResponder];
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
        [self.userNewPasswordField resignFirstResponder];
        [self.confirmNewPasswordField resignFirstResponder];
    }
    
}

#pragma mark - Segue for common view

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"passwordSegue"]) {
        CommonEditHeaderVC *embed = segue.destinationViewController;
        embed.mainHeaderProperty = @"Change Password";
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
