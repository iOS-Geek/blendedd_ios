//
//  CategoryDescriptionVC.m
//  Blendedd
//
//  Created by iOS Developer on 18/11/15.
//  Copyright © 2015 Prabh Kiran Kaur. All rights reserved.
//

#import "CategoryDescriptionVC.h"

@interface CategoryDescriptionVC (){

    AppDelegate *appDelegate;

}

@end

@implementation CategoryDescriptionVC
@synthesize post,bgView,enlargedImage;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setUpView];
    
    appDelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    [appDelegate hide_LoadingIndicator];
    
}

#pragma mark - Setting up UI

-(void)setUpView
{
    // 1 : check availability
    
    if ([post.post_status isEqualToString:@"0"]) {
        self.availabilityLabel.text=@"Being Rented Now";
        self.availabilityLabel.textColor = [UIColor redColor];
    }
    else{
        self.availabilityLabel.text=@"Available";
        self.availabilityLabel.textColor = [UIColor greenColor];
    }
    
    // 2 : set header
    
    self.titleLabel.text=post.post_title;
    
    // 3 : horizontal scrolling with image
    
    int value=(int)post.imageArray.count;
    self.subHorizontalScroll.contentSize = CGSizeMake((self.view.frame.size.width-20) * value, self.subHorizontalScroll.frame.size.height);
    self.subHorizontalScroll.delegate = self;
    [self.subHorizontalScroll setPagingEnabled:YES];
    for (int i=0; i<value; i++) {
        UIImageView *imgView=[[UIImageView alloc]initWithFrame:CGRectMake(i*(self.view.frame.size.width-20), 0, self.view.frame.size.width-20, self.subHorizontalScroll.frame.size.height)];
        imgView.userInteractionEnabled=YES;
        imgView.tag=i+5;
        imgView.backgroundColor=[UIColor whiteColor];
        [self.subHorizontalScroll addSubview:imgView];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTapped:)];
        tap.numberOfTapsRequired=1;
        [imgView addGestureRecognizer:tap];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^ {
            
            NSData* dataim = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:[post.imageArray objectAtIndex:i]]];
            UIImage* image = [UIImage imageWithData:dataim];
            
            dispatch_async(dispatch_get_main_queue(), ^ {
                imgView.image=image;
                
            });
        });
        imgView.contentMode=UIViewContentModeScaleAspectFit;
        imgView.clipsToBounds=YES;
        
    }
    
    // 4 : controlling page dots
    
    self.pageControl.numberOfPages = self.subHorizontalScroll.contentSize.width/(self.view.frame.size.width-20);
    [self.pageControl addTarget:self action:@selector(changePage:) forControlEvents:UIControlEventValueChanged];
    
    // 5 : adding buttons
    
    value=(int)post.buttonArray.count;
    NSLog(@"%d buttons",value);
    for (int i=0; i<value; i++) {
        
        int x;
        int y;
        if (i==0) {
            x=20;
            y=self.pageControl.frame.origin.y+self.pageControl.frame.size.height;
            
        }else if(i==1){
            x=self.view.bounds.size.width/2+10;
            y=self.pageControl.frame.origin.y+self.pageControl.frame.size.height;
        }else if(i==2){
            x=20;
            y=self.pageControl.frame.origin.y+85;
        }else if(i==3){
            x=self.view.bounds.size.width/2+10;
            y=self.pageControl.frame.origin.y+85;
        }
        
        UIButton *btn=[[UIButton alloc]initWithFrame:CGRectMake(x, y, (self.view.bounds.size.width/2)-20, 35)];
        btn.tag=i;
        btn.backgroundColor=[UIColor colorWithRed:25.0/255.0 green:188.0/255.0 blue:248.0/255.0 alpha:1.0];
        btn.titleLabel.textColor=[UIColor whiteColor];
        btn.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:12.0f];
        btn.titleLabel.textAlignment=NSTextAlignmentCenter;
        btn.layer.cornerRadius=8;
        btn.clipsToBounds=YES;
        [btn setTitle:[[[[post.buttonArray objectAtIndex:i] valueForKey:@"price_button_text"] stringByAppendingString:@" "] stringByAppendingString:[[post.buttonArray objectAtIndex:i] valueForKey:@"price_button_display_value"]] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(dealButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        btn.titleLabel.numberOfLines = 1;
        btn.titleLabel.adjustsFontSizeToFitWidth = YES;
        btn.titleLabel.lineBreakMode = NSLineBreakByClipping;
        [self.mainVerticalScroll addSubview:btn];
    }
    
    // 6 : changing description frame if buttons added
    
    if (post.buttonArray.count>=2) {
        self.descriptionTitle.frame = CGRectMake(10, 350, self.view.bounds.size.width-20, 21);
        [self.descriptionHeightConstraint setConstant:90];
    }
    else{
        self.descriptionTitle.frame = CGRectMake(10, self.pageControl.frame.origin.y+91, self.view.bounds.size.width-20, 21);
        [self.descriptionHeightConstraint setConstant:42];
    }
    [self.descriptionTitle layoutIfNeeded];
    
    //7 : setting descrition height according to content
    
    self.descriptionLabel.text = post.post_description;
    self.descriptionLabel.numberOfLines = 0;
    CGSize maximumLabelSize = CGSizeMake(self.view.bounds.size.width-20, 9999); // this width will be as per your requirement
    CGSize expectedSize = [self.descriptionLabel sizeThatFits:maximumLabelSize];
    CGRect labelFrame=self.descriptionLabel.frame;
    labelFrame.size.height=expectedSize.height;
    self.descriptionLabel.frame=labelFrame;
    
    // 8 : timing header
    
    self.availTitle.text=[NSString stringWithFormat:@"Available Hours (%@)",post.time_zone_slug];
    
    // 9 : setting main scroll size
    
    self.mainVerticalScroll.contentSize=CGSizeMake(0, self.weekTableView.frame.origin.y+162);
    
    // 10 : hiding-unhiding enlarged image
    
    bgView.hidden=true;
    [bgView setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.5]];
    [enlargedImage setBackgroundColor:[[UIColor clearColor] colorWithAlphaComponent:1.0]];
    UITapGestureRecognizer *tapOnBgView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    tapOnBgView.numberOfTapsRequired=1;
    [bgView addGestureRecognizer:tapOnBgView];
}

#pragma mark - page control action method

-(void)changePage:(id)sender
{
    CGFloat x = self.pageControl.currentPage * self.subHorizontalScroll.frame.size.width;
    [self.subHorizontalScroll setContentOffset:CGPointMake(x, 0) animated:YES];
}

#pragma mark - scrollview delegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView==self.subHorizontalScroll) {
        CGFloat pageWidth = scrollView.frame.size.width;
        int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
        self.pageControl.currentPage = page;
    }
    else{
        //do anything
    }
    
}

#pragma mark - gesture actions

-(void)imageTapped:(id) sender
{
    UITapGestureRecognizer *gesture = (UITapGestureRecognizer *) sender;
    UIImageView *img = (UIImageView*)[self.subHorizontalScroll viewWithTag:gesture.view.tag];
    enlargedImage.image = img.image;
    bgView.hidden=false;
    [self.view bringSubviewToFront:bgView];
}

-(void)viewTapped:(id) sender
{
    bgView.hidden=true;
}

#pragma mark - table view data source methods

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return post.postAvailabilityArray.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"weekCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSDictionary *dict=[post.postAvailabilityArray objectAtIndex:indexPath.row];
    
    UILabel *dayLabel = (UILabel*)[cell viewWithTag:55];
    dayLabel.text = [dict valueForKey:@"post_availability_day"];
    UILabel *timeLabel = (UILabel*)[cell viewWithTag:56];
    timeLabel.text = [[[dict valueForKey:@"post_availability_from"] stringByAppendingString:@" TO "] stringByAppendingString:[dict valueForKey:@"post_availability_to"]];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"EEEE"];
    NSString *day = [dateFormatter stringFromDate:[NSDate date]];
    
    if ([dayLabel.text isEqualToString:day]) {
        dayLabel.textColor = [UIColor redColor];
        timeLabel.textColor = [UIColor redColor];
    }
    
    return cell;
}

#pragma mark - navigation

-(void)dealButtonPressed:(UIButton*)sender {
    NSLog(@"action presed =%d",(int)sender.tag);
    NSString *valueString = [[post.buttonArray objectAtIndex:sender.tag]valueForKey:@"price_button_display_value"];
    NSString *amountPassed = [[post.buttonArray objectAtIndex:sender.tag]valueForKey:@"price_button_value"];
    NSString *optionsIdPassed = [[post.buttonArray objectAtIndex:sender.tag]valueForKey:@"pricing_options_id"];
    NSString *title = post.post_title;
    NSString *city = post.city_name;
    NSString *country = post.country_name;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    if (appDelegate.loggedIn == NO)
    {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"Please make sure you sign up before making any purchase." preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
                             {
                                 [self moveBackToLogin];
                             }];
        [alertController addAction:ok];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
    else if (appDelegate.loggedIn == YES && appDelegate.loggedInWithFB == YES)
    {
        if ([[[NSUserDefaults standardUserDefaults] stringForKey:@"logged_user_credit_card_number"] isEqualToString:@""])
        {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"Please make sure you have entered credit card details before making any purchase." preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
                                 {
                                     UITabBarController *tabView = (UITabBarController*)[storyboard instantiateViewControllerWithIdentifier: @"editingTabBar"];
                                     [self presentViewController:tabView animated:YES completion:nil];
                                 }];
            [alertController addAction:ok];
            
            [self presentViewController:alertController animated:YES completion:nil];
            
            
        }
        else
        {
            PaymentVC *viewController = (PaymentVC *)[storyboard instantiateViewControllerWithIdentifier:@"payView"];
            viewController.passedStringValue = valueString;
            viewController.amountReceived = amountPassed;
            viewController.optionsIdReceived = optionsIdPassed;
            viewController.passedStringTitle = title;
            viewController.passedStringCity = city;
            viewController.passedStringCountry = country;
            viewController.receivedPostId = post.post_id;
            [self presentViewController:viewController animated:YES completion:nil];
        }
        
    }
    else
    {
        
        PaymentVC *viewController = (PaymentVC *)[storyboard instantiateViewControllerWithIdentifier:@"payView"];
        viewController.passedStringValue = valueString;
        viewController.amountReceived = amountPassed;
        viewController.optionsIdReceived = optionsIdPassed;
        viewController.passedStringTitle = title;
        viewController.passedStringCity = city;
        viewController.passedStringCountry = country;
        viewController.receivedPostId = post.post_id;
        [self presentViewController:viewController animated:YES completion:nil];
    }
}

-(void)moveBackToLogin {
    UIViewController *vc = self.presentingViewController;
    while (vc.presentingViewController) {
        vc = vc.presentingViewController;
    }
    [vc dismissViewControllerAnimated:YES completion:NULL];
    //clearing all user defaults
    NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
    [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
    
    
}

- (IBAction)backToSubCategoryList:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    
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
