//
//  ActivityTableViewCell.h
//  Blendedd
//
//  Created by iOS Developer on 04/12/15.
//  Copyright © 2015 Prabh Kiran Kaur. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ActivityTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *invoiceDate;
@property (weak, nonatomic) IBOutlet UILabel *invoicePrice;
@property (weak, nonatomic) IBOutlet UIImageView *orderImage;
@property (weak, nonatomic) IBOutlet UILabel *postIdToDisplay;
@property (weak, nonatomic) IBOutlet UITextView *orderDescription;


@end
