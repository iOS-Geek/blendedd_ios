//
//  CategoryVC.m
//  Blendedd
//
//  Created by iOS Developer on 04/11/15.
//  Copyright © 2015 Prabh Kiran Kaur. All rights reserved.
//

#import "CategoryVC.h"

@interface CategoryVC ()
{
NSMutableArray *categoryArray;
    
    AppDelegate *appDelegate;
}

@end

@implementation CategoryVC
@synthesize categoriesTableView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    categoryArray=[NSMutableArray array];
    appDelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    [appDelegate show_LoadingIndicator];
    [self getData];
}

#pragma mark - Getting data from Server

-(void)getData
{
    
    [RequestManager getFromServer:@"categories" parameters:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"now",@"current_timestamp", nil] completionHandler:^(NSDictionary *responseDict) {
        
        if ([[responseDict valueForKey:@"error"] isEqualToString:@"1"]) {
            return ;
        }
        NSArray *dataArray=[responseDict valueForKey:@"data"];
        
        [categoryArray removeAllObjects];
        
        for (NSDictionary *dic in dataArray) {
            Categories *category=[[Categories alloc]init];
            category.categoryIdString=[dic valueForKey:@"category_id"];
            category.categoryNameString=[dic valueForKey:@"category_name"];
            [categoryArray addObject:category];
            NSLog(@"%@",categoryArray);
        }
        [categoriesTableView reloadData];
        
        [appDelegate hide_LoadingIndicator];
        
    }];
    
}

#pragma mark - Table View Data Source

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return categoryArray.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"Cell1";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    Categories *category=(Categories*)[categoryArray objectAtIndex:indexPath.row];
    
    UILabel *cellLabel = (UILabel*)[cell viewWithTag:998];
    cellLabel.text = category.categoryNameString;
//    UIImageView *imageView = (UIImageView *)[cell viewWithTag:999];
//    imageView.image = [UIImage imageNamed:@"forward.png"];
    return cell;
    
}

#pragma mark - Table View Delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SubCategoryVC *viewController = (SubCategoryVC *)[storyboard instantiateViewControllerWithIdentifier:@"subView"];
    Categories *category=(Categories*)[categoryArray objectAtIndex:indexPath.row];
    viewController.categoryIdString = category.categoryIdString;
    [self presentViewController:viewController animated:YES completion:nil];
    
}

#pragma mark - Segue to common view

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"CategorySegue"]) {
        CommonHeaderVC *embed = segue.destinationViewController;
        embed.headerProperty = @"Categories";
        
    }
}

#pragma mark - Orientation

- (UIInterfaceOrientationMask) supportedInterfaceOrientations {
    
    return UIInterfaceOrientationMaskPortrait;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
