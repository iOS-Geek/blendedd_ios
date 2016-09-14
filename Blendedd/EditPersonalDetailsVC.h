//
//  EditPersonalDetailsVC.h
//  Blendedd
//
//  Created by iOS Developer on 20/11/15.
//  Copyright © 2015 Prabh Kiran Kaur. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonEditHeaderVC.h"
#import "VSDropdown.h"
#import "RequestManager.h"

@interface EditPersonalDetailsVC : UIViewController<VSDropdownDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *containerScrollView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;
@property (weak, nonatomic) IBOutlet UITextField *editFirstNameField;
@property (weak, nonatomic) IBOutlet UITextField *editLastNameField;
@property (weak, nonatomic) IBOutlet UITextField *fbField;
@property (weak, nonatomic) IBOutlet UITextField *twitterField;
@property (weak, nonatomic) IBOutlet UITextField *linkedInField;
@property (weak, nonatomic) IBOutlet UITextField *instaField;
@property (weak, nonatomic) IBOutlet UITextField *editAddOneField;
@property (weak, nonatomic) IBOutlet UITextField *editZipField;
@property (weak, nonatomic) IBOutlet UITextField *editAddTwoField;
@property (weak, nonatomic) IBOutlet UITextField *editCountryField;
@property (weak, nonatomic) IBOutlet UITextField *editStateField;
@property (weak, nonatomic) IBOutlet UITextField *editCityField;
@property (weak, nonatomic) IBOutlet UIButton *selectCountryBtn;
@property (weak, nonatomic) IBOutlet UIButton *selectStateBtn;
@property (weak, nonatomic) IBOutlet UIButton *selectCityBtn;
@property (weak, nonatomic) IBOutlet UIImageView *emailCheckImageView;
@property (weak, nonatomic) IBOutlet UIImageView *textCheckImageView;
@property (weak, nonatomic) IBOutlet UIImageView *phoneCheckImageView;

@end
