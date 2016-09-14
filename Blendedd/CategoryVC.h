//
//  CategoryVC.h
//  Blendedd
//
//  Created by iOS Developer on 04/11/15.
//  Copyright © 2015 Prabh Kiran Kaur. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonHeaderVC.h"
#import "SubCategoryVC.h"
#import "RequestManager.h"
#import "Categories.h"

@interface CategoryVC : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *categoriesTableView;

@end
