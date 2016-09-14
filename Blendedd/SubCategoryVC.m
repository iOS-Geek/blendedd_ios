//
//  SubCategoryVC.m
//  Blendedd
//
//  Created by iOS Developer on 10/11/15.
//  Copyright © 2015 Prabh Kiran Kaur. All rights reserved.
//

#import "SubCategoryVC.h"

@interface SubCategoryVC ()
{
    NSMutableArray *searchResultsArray;
    NSArray *displayResultsArray;

    AppDelegate *appDelegate;
}
@end

@implementation SubCategoryVC
@synthesize subCategoryTable,categoryIdString,spinner,imageDownloadsInProgress;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    pageCount=0;
    
    searchResultsArray =[NSMutableArray array];
    displayResultsArray =[NSArray array];
    imageDownloadsInProgress = [NSMutableDictionary dictionary];
    
    appDelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    [appDelegate show_LoadingIndicator];
    
    [self.view bringSubviewToFront:subCategoryTable];
    
    spinner.hidden = true;
    
    [self getData];
}

#pragma mark - Getting data from server

-(void)getData
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    //check if search done or category selected
    if (self.searchString) {
        NSLog(@"%d",pageCount);
        dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:self.searchString,@"search_term",[NSString stringWithFormat:@"%d",pageCount],@"page", nil];
    }
    else
    {
        NSLog(@"%d",pageCount);
        dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:categoryIdString,@"categories_id",[NSString stringWithFormat:@"%d",pageCount],@"page", nil];
    }
    
    //hit
    [RequestManager getFromServer:@"search" parameters:dict completionHandler:^(NSDictionary *responseDict) {
        
        NSArray *dataArray=[responseDict valueForKey:@"data"];
        
        for (NSDictionary *dic in dataArray) {
            SearchResults *results=[[SearchResults alloc]init];
            
            results.post_id=[dic valueForKey:@"post_id"];
            results.post_title=[dic valueForKey:@"post_title"];
            results.post_description=[dic valueForKey:@"post_description"];
            results.post_display_price=[dic valueForKey:@"post_display_price"];
            results.city_name=[dic valueForKey:@"city_name"];
            results.state_code=[dic valueForKey:@"state_code"];
            results.post_zipcode=[dic valueForKey:@"post_zipcode"];
            results.post_image_url=[dic valueForKey:@"post_image_url"];
            
            [searchResultsArray addObject:results];
            
        }
        
        displayResultsArray = [displayResultsArray arrayByAddingObjectsFromArray:searchResultsArray];
        
        NSLog(@"search array :::: %@",searchResultsArray);
        NSLog(@"display array :::: %@",displayResultsArray);
        
        [subCategoryTable reloadData];
        
        if (displayResultsArray.count == 0) {
            [self.view bringSubviewToFront:self.noDataView];
        }
        else
        {
            [self.view bringSubviewToFront:subCategoryTable];
        }
        
        if ([spinner isAnimating]) {
            [spinner stopAnimating];
            spinner.hidden = true;
        }
        
        [appDelegate hide_LoadingIndicator];
        
    }];
    
}

#pragma mark - Navigation

- (IBAction)backToMainCategories:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

#pragma mark - Table View Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return displayResultsArray.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"Cell";
    
    
    SubCategoryTableViewCell *cell = (SubCategoryTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[SubCategoryTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
    }
    
    SearchResults *results=[displayResultsArray objectAtIndex:indexPath.row];
    
    cell.categoryHeaderLabel.text = results.post_title;
    cell.categoryDescriptionView.text = results.post_description;
    NSString *locationString = [[[[results.city_name stringByAppendingString:@" "] stringByAppendingString:results.state_code] stringByAppendingString:@" "] stringByAppendingString:results.post_zipcode];
    cell.categoryLocationLabel.text  = locationString;
    cell.categoryCostLabel.text = results.post_display_price;
    
    cell.categoryImageView.backgroundColor=[UIColor lightGrayColor];
    
    if (!results.post_image) {
        cell.categoryImageView.image=nil;
        [self startIconDownload:results forIndexPath:indexPath];
    }
    else{
        cell.categoryImageView.image=results.post_image;
    }
    
    return cell;
    
}

#pragma mark - TableView Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 130;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    SearchResults *result=[displayResultsArray objectAtIndex:indexPath.row];
    [self callSelectionWebService:result.post_id];
    
}

#pragma mark - Setting up Icon Downloader

- (void)startIconDownload:(SearchResults *)appRecord forIndexPath:(NSIndexPath *)indexPath
{
    IconDownloader *iconDownloader = (imageDownloadsInProgress)[indexPath];
    if (iconDownloader == nil)
    {
        iconDownloader = [[IconDownloader alloc] init];
        iconDownloader.results = appRecord;
        [iconDownloader setCompletionHandler:^{
            
            SubCategoryTableViewCell *cell = (SubCategoryTableViewCell*)[subCategoryTable cellForRowAtIndexPath:indexPath];
            
            // Display the newly loaded image
            cell.categoryImageView.image = appRecord.post_image;
            
            // Remove the IconDownloader from the in progress list.
            // This will result in it being deallocated.
            [self.imageDownloadsInProgress removeObjectForKey:indexPath];
            
        }];
        (self.imageDownloadsInProgress)[indexPath] = iconDownloader;
        [iconDownloader startDownload];
    }
}

- (void)terminateAllDownloads
{
    // terminate all pending download connections
    NSArray *allDownloads = [imageDownloadsInProgress allValues];
    [allDownloads makeObjectsPerformSelector:@selector(cancelDownload)];
    
    [imageDownloadsInProgress removeAllObjects];
}

#pragma mark - ScrollView delegate for refreshing table with contents on next page

-(void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    
    if(subCategoryTable.contentOffset.y<0){
        //it means table view is pulled down like refresh
        return;
    }
    else if(subCategoryTable.contentOffset.y >= (subCategoryTable.contentSize.height - subCategoryTable.bounds.size.height)) {
        NSLog(@"bottom!");
        spinner.hidden = false;
        [spinner startAnimating];
        [self refreshPulled];
    }
    
}

-(void)refreshPulled
{
    [searchResultsArray removeAllObjects];
    pageCount++;
    NSLog(@"%d",pageCount);
    [self getData];
    
}


#pragma mark - Result selection

-(void)callSelectionWebService:(NSString*)post_id {
    
    [appDelegate show_LoadingIndicator];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    CategoryDescriptionVC *viewController = (CategoryDescriptionVC *)[storyboard instantiateViewControllerWithIdentifier:@"describeView"];
    
    
    NSMutableDictionary *dict=[NSMutableDictionary dictionaryWithObjectsAndKeys:post_id,@"post_id", nil];
    
    [RequestManager getFromServer:@"view" parameters:dict completionHandler:^(NSDictionary *responseDict) {
        
        NSLog(@"Got response in block %@",responseDict);
        NSDictionary *dic=[responseDict valueForKey:@"data"];
        
        SinglePostInfo *post=[[SinglePostInfo alloc]init];
        
        
        post.post_id=[dic valueForKey:@"post_id"];
        post.post_title=[dic valueForKey:@"post_title"];
        post.post_description=[dic valueForKey:@"post_description"];
        
        NSArray *buttonArray=[dic valueForKey:@"pricing_buttons"];
        
        post.buttonArray=[NSMutableArray array];
        for (NSDictionary *val in buttonArray) {
            [post.buttonArray addObject:val];
        }
        
        NSArray *imageArray=[dic valueForKey:@"post_images_array"];
        post.post_status = [dic valueForKey:@"post_status"];
        post.imageArray=[NSMutableArray array];
        
        for (NSDictionary *val in imageArray) {
            [post.imageArray addObject:[val valueForKey:@"post_image_url"]];
        }
        
        
        NSArray *postAvailArray=[dic valueForKey:@"post_time_availability_array"];
        
        post.postAvailabilityArray=[NSMutableArray array];
        for (NSDictionary *val in postAvailArray) {
            [post.postAvailabilityArray addObject:val];
        }
        
        post.country_name=[dic valueForKey:@"country_name"];
        post.post_street=[dic valueForKey:@"post_street"];
        post.post_cross_street=[dic valueForKey:@"post_cross_street"];
        
        post.city_name=[dic valueForKey:@"city_name"];
        post.state_code=[dic valueForKey:@"state_code"];
        post.post_zipcode=[dic valueForKey:@"post_zipcode"];
        post.category_name=[dic valueForKey:@"category_name"];
        post.time_zone_slug=[dic valueForKey:@"time_zone_slug"];
        NSLog(@"Got response in block 3");
        viewController.post=post;
        [self presentViewController:viewController animated:YES completion:nil];
        
    }];
    
}

#pragma mark - Orientation

- (UIInterfaceOrientationMask) supportedInterfaceOrientations {
    
    return UIInterfaceOrientationMaskPortrait;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    [self terminateAllDownloads];
}

- (void)dealloc
{
    // terminate all pending download connections
    [self terminateAllDownloads];
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
