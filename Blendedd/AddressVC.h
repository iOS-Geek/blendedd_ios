//
//  AddressVC.h
//  Blendedd
//
//  Created by iOS Developer on 07/11/15.
//  Copyright © 2015 Prabh Kiran Kaur. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VSDropdown.h"
#import "CreditDetailsVC.h"
#import "RequestManager.h"

@interface AddressVC : UIViewController<UITextFieldDelegate,VSDropdownDelegate>

@property (weak, nonatomic) IBOutlet UITextField *streetAddress1Field;
@property (weak, nonatomic) IBOutlet UITextField *streetAddress2Field;
@property (weak, nonatomic) IBOutlet UITextField *countryField;
@property (weak, nonatomic) IBOutlet UITextField *stateField;
@property (weak, nonatomic) IBOutlet UITextField *cityField;
@property (weak, nonatomic) IBOutlet UITextField *zipField;
@property (weak, nonatomic) IBOutlet UIButton *countryBtn;
@property (weak, nonatomic) IBOutlet UIButton *stateBtn;
@property (weak, nonatomic) IBOutlet UIButton *cityBtn;

@end
