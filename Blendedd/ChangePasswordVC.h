//
//  ChangePasswordVC.h
//  Blendedd
//
//  Created by iOS Developer on 09/11/15.
//  Copyright © 2015 Prabh Kiran Kaur. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonEditHeaderVC.h"
#import "AppDelegate.h"
#import "RequestManager.h"

@interface ChangePasswordVC : UIViewController<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *userNewPasswordField;
@property (weak, nonatomic) IBOutlet UITextField *confirmNewPasswordField;


@end
