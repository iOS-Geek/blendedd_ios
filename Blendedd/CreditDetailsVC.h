//
//  CreditDetailsVC.h
//  Blendedd
//
//  Created by iOS Developer on 07/11/15.
//  Copyright © 2015 Prabh Kiran Kaur. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VSDropdown.h"
#import "ConditionsVC.h"
#import "RequestManager.h"

@interface CreditDetailsVC : UIViewController<VSDropdownDelegate>

@property (weak, nonatomic) IBOutlet UITextField *creditNameField;
@property (weak, nonatomic) IBOutlet UITextField *cardNumberField;
@property (weak, nonatomic) IBOutlet UITextField *expirationMonthField;
@property (weak, nonatomic) IBOutlet UITextField *expirationYearField;
@property (weak, nonatomic) IBOutlet UITextField *cvvField;

@end
