//
//  LoginVC.h
//  Blendedd
//
//  Created by iOS Developer on 04/11/15.
//  Copyright © 2015 Prabh Kiran Kaur. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonHeaderVC.h"
#import "ForgotPasswordVC.h"
#import "SignUpVC.h"


@interface LoginVC : UIViewController<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@end
