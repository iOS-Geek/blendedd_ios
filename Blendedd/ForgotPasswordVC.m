//
//  ForgotPasswordVC.m
//  Blendedd
//
//  Created by iOS Developer on 05/11/15.
//  Copyright © 2015 Prabh Kiran Kaur. All rights reserved.
//

#import "ForgotPasswordVC.h"

@interface ForgotPasswordVC ()

@end

@implementation ForgotPasswordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - Getting data from Server

-(void)getData
{
    
    [RequestManager getFromServer:@"recover" parameters:[NSMutableDictionary dictionaryWithObjectsAndKeys:self.userEmailField.text,@"email_address", nil] completionHandler:^(NSDictionary *responseDict) {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:[responseDict valueForKey:@"message"] preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        
        [self presentViewController:alertController animated:YES completion:nil];
        
        
    }];
    
}
- (IBAction)submitButtonPressed:(id)sender {
    
    [self.userEmailField resignFirstResponder];
    if ([self.userEmailField.text isEqualToString:@""]) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"Please enter your Email." preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        
        [self presentViewController:alertController animated:YES completion:nil];
        
    }
    else {
        
        [self getData];
        
    }
    
}

#pragma mark - Navigation

- (IBAction)backToLoginButtonAction:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - handling keyboard with textfield delegate and touches

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    [textField resignFirstResponder];
    
    return YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
    UITouch *touch = [touches anyObject];
    if(touch.phase == UITouchPhaseBegan) {
        [self.userEmailField resignFirstResponder];
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
