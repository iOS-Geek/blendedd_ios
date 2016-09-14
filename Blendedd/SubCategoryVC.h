//
//  SubCategoryVC.h
//  Blendedd
//
//  Created by iOS Developer on 10/11/15.
//  Copyright © 2015 Prabh Kiran Kaur. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SubCategoryTableViewCell.h"
#import "SearchResults.h"
#import "RequestManager.h"
#import "CategoryDescriptionVC.h"
#import "SinglePostInfo.h"
#import "IconDownloader.h"

@interface SubCategoryVC : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    int pageCount;
}
@property (weak, nonatomic) IBOutlet UIView *noDataView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property (weak, nonatomic) IBOutlet UITableView *subCategoryTable;
@property(retain,nonatomic) NSString *categoryIdString;
@property(retain,nonatomic) NSString *searchString;
@property (nonatomic, strong) NSMutableDictionary *imageDownloadsInProgress;
@end
