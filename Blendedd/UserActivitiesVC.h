//
//  UserActivitiesVC.h
//  Blendedd
//
//  Created by iOS Developer on 21/11/15.
//  Copyright © 2015 Prabh Kiran Kaur. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "ActivityData.h"
#import "ActivityTableViewCell.h"

@interface UserActivitiesVC : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *activityTable;

@end
