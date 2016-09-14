//
//  CommonHeaderVC.h
//  Blendedd
//
//  Created by iOS Developer on 04/11/15.
//  Copyright © 2015 Prabh Kiran Kaur. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWRevealViewController.h"
#import "SubCategoryVC.h"
#import "UserActivitiesVC.h"
@interface CommonHeaderVC : UIViewController<UISearchBarDelegate>


@property (weak, nonatomic) NSString *headerProperty;
@property (weak, nonatomic) IBOutlet UIButton *slideMenuButton;
@property (weak, nonatomic) IBOutlet UILabel *headingLabel;
@property (weak, nonatomic) IBOutlet UISearchBar *categoriesSearchBar;
@property (weak, nonatomic) NSString *searchString;

@end
