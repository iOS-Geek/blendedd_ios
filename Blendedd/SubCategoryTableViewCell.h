//
//  SubCategoryTableViewCell.h
//  Blendedd
//
//  Created by iOS Developer on 10/11/15.
//  Copyright © 2015 Prabh Kiran Kaur. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SubCategoryTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *categoryImageView;
@property (weak, nonatomic) IBOutlet UILabel *categoryHeaderLabel;
@property (weak, nonatomic) IBOutlet UITextView *categoryDescriptionView;
@property (weak, nonatomic) IBOutlet UILabel *categoryCostLabel;
@property (weak, nonatomic) IBOutlet UILabel *categoryLocationLabel;

@end
