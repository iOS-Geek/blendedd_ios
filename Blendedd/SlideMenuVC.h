//
//  SlideMenuVC.h
//  Blendedd
//
//  Created by iOS Developer on 03/11/15.
//  Copyright © 2015 Prabh Kiran Kaur. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "WebViewVC.h"
#import "UserActivitiesVC.h"
#import "SWRevealViewController.h"

@interface SlideMenuVC : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *menuTable;

@end
