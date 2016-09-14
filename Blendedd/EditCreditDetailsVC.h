//
//  EditCreditDetailsVC.h
//  Blendedd
//
//  Created by iOS Developer on 20/11/15.
//  Copyright © 2015 Prabh Kiran Kaur. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonEditHeaderVC.h"
#import "VSDropdown.h"
#import "RequestManager.h"

@interface EditCreditDetailsVC : UIViewController<VSDropdownDelegate>
@property (weak, nonatomic) IBOutlet UILabel *existingCreditLabel;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet UILabel *expireLabel;
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *numberField;
@property (weak, nonatomic) IBOutlet UITextField *cvvCardField;
@property (weak, nonatomic) IBOutlet UITextField *editYearField;
@property (weak, nonatomic) IBOutlet UITextField *editMonthField;

@end
