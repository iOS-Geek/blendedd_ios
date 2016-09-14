//
//  UserActivitiesVC.m
//  Blendedd
//
//  Created by iOS Developer on 21/11/15.
//  Copyright © 2015 Prabh Kiran Kaur. All rights reserved.
//

#import "UserActivitiesVC.h"

@interface UserActivitiesVC ()
{
    NSMutableArray *activityResultsArray;
    AppDelegate *appDelegate;
}
@end

@implementation UserActivitiesVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    activityResultsArray = [NSMutableArray array];
    appDelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    [appDelegate show_LoadingIndicator];
    self.activityTable.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self getData];
}

#pragma mark - Getting data from Server

-(void)getData
{
    
    [RequestManager getFromServer:@"dashboard" parameters:[NSMutableDictionary dictionaryWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] stringForKey:@"logged_user_id"],@"user_id",[[NSUserDefaults standardUserDefaults] stringForKey:@"logged_user_security_hash"],@"user_security_hash", nil] completionHandler:^(NSDictionary *responseDict) {
        
        if ([[responseDict valueForKey:@"code"] isEqualToString:@"0"]) {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:[responseDict valueForKey:@"message"] preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
            [alertController addAction:ok];
            
            [self presentViewController:alertController animated:YES completion:nil];
        }
        else if ([[responseDict valueForKey:@"code"] isEqualToString:@"1"])
        {
            NSArray *dataArray=[responseDict valueForKey:@"data"];
            
            
            
            if (dataArray.count ==0){
                
                
                UIAlertController*  alertController = [UIAlertController alertControllerWithTitle:nil message:@"No Post" preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                }];
                [alertController addAction:ok];
                
                [appDelegate hide_LoadingIndicator];
                [self presentViewController:alertController animated:YES completion:nil];
                [appDelegate hide_LoadingIndicator];
                return;
            }
            
            for (NSDictionary *dic in dataArray) {
                ActivityData *results=[[ActivityData alloc]init];
                
                results.post_id=[dic valueForKey:@"post_id"];
                results.post_description=[dic valueForKey:@"post_description"];
                results.post_display_price=[dic valueForKey:@"post_display_price"];
                results.post_image_url=[dic valueForKey:@"post_image_url"];
                results.invoice_created=[dic valueForKey:@"invoice_created"];
                [activityResultsArray addObject:results];
                
            }
            
            [self.activityTable reloadData];
        }
        [appDelegate hide_LoadingIndicator];
        
    }];
    
}

#pragma mark - Navigation

- (IBAction)backAction:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

#pragma mark - TableView Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return activityResultsArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"activityCell";
    
    ActivityTableViewCell *cell = (ActivityTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[ActivityTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    ActivityData *results=[activityResultsArray objectAtIndex:indexPath.row];
    
    cell.invoiceDate.text = results.invoice_created;
    cell.invoicePrice.text = results.post_display_price;
    cell.orderDescription.text = results.post_description;
    cell.postIdToDisplay.text = [NSString stringWithFormat:@"POST ID : %@",results.post_id];
    NSURL *imgUrl=[NSURL URLWithString:results.post_image_url];
    NSData *imgData = [NSData dataWithContentsOfURL:imgUrl];
    UIImage *img = [UIImage imageWithData:imgData];
    cell.orderImage.image = img;
    
    
    return cell;
    
}

#pragma mark - Tableview Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 160;
}

#pragma mark - Orientation

- (UIInterfaceOrientationMask) supportedInterfaceOrientations {
    
    return UIInterfaceOrientationMaskPortrait;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
