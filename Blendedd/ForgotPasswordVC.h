//
//  ForgotPasswordVC.h
//  Blendedd
//
//  Created by iOS Developer on 05/11/15.
//  Copyright © 2015 Prabh Kiran Kaur. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RequestManager.h"

@interface ForgotPasswordVC : UIViewController<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *userEmailField;

@end
