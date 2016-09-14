//
//  PaymentVC.m
//  Blendedd
//
//  Created by iOS Developer on 19/11/15.
//  Copyright © 2015 Prabh Kiran Kaur. All rights reserved.
//

#import "PaymentVC.h"

@interface PaymentVC ()
{
    AppDelegate *appDelegate;
}
@end

@implementation PaymentVC
@synthesize passedStringCountry,passedStringCity,passedStringTitle,passedStringValue,amountReceived,optionsIdReceived,receivedPostId;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.titleLabel.text = [NSString stringWithFormat:@"%@ (%@, %@)",passedStringTitle,passedStringCity,passedStringCountry];
    self.paymentLabel.text = [NSString stringWithFormat:@"Total Payment : %@",passedStringValue];
    self.creditLabel.text = [NSString stringWithFormat:@"Credit Card Number : %@",[[NSUserDefaults standardUserDefaults] stringForKey:@"logged_user_credit_card_number"]];
    self.containerView.layer.cornerRadius = 5;
    self.containerView.clipsToBounds = true;
    
    appDelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    
}

#pragma mark - Getting data from server

-(void)getData
{
    
    [RequestManager getFromServer:@"purchase" parameters:[NSMutableDictionary dictionaryWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] stringForKey:@"logged_user_id"],@"user_id",[[NSUserDefaults standardUserDefaults] stringForKey:@"logged_user_security_hash"],@"user_security_hash",amountReceived,@"amount",receivedPostId,@"posts_id",optionsIdReceived,@"pricing_options_id", nil] completionHandler:^(NSDictionary *responseDict) {
        
        
        NSLog(@"response in end ::: %@",responseDict);
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:[responseDict valueForKey:@"message"] preferredStyle:UIAlertControllerStyleAlert];
        
        if ([[responseDict valueForKey:@"code"] isEqualToString:@"0"]) {
            
            
            
            UIAlertAction* okDone = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
            [alertController addAction:okDone];
            
        }
        else if ([[responseDict valueForKey:@"code"] isEqualToString:@"1"]){
            
            UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
                                 {
                                     [self success];
                                 }];
            
            [alertController addAction:ok];
        }
        
        
        [self presentViewController:alertController animated:YES completion:nil];
        [appDelegate hide_LoadingIndicator];
    }];
    
}


- (IBAction)paymentPressed:(id)sender {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Confirmation" message:@"Do you want to proceed with the transaction?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* okDone = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        [self getData];
        [appDelegate show_LoadingIndicator];
    }];
    
    UIAlertAction* cancelDone = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    
    [alertController addAction:okDone];
    [alertController addAction:cancelDone];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
}

#pragma mark - Navigation

// on successful payment

-(void)success{
    appDelegate.showActivity = YES;
    UIViewController *vc = self.presentingViewController;
    while (vc.presentingViewController) {
        vc = vc.presentingViewController;
    }
    [vc dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)backToDetailsAction:(id)sender {
    
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
