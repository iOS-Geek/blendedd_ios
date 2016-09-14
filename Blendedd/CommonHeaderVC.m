//
//  CommonHeaderVC.m
//  Blendedd
//
//  Created by iOS Developer on 04/11/15.
//  Copyright © 2015 Prabh Kiran Kaur. All rights reserved.
//

#import "CommonHeaderVC.h"

@interface CommonHeaderVC ()
{
    AppDelegate *appDelegate;
}
@end

@implementation CommonHeaderVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    appDelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    self.categoriesSearchBar.delegate = self;
}

-(void)viewDidAppear:(BOOL)animated
{
    
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        [self.slideMenuButton addTarget:self.revealViewController action:@selector( revealToggle: ) forControlEvents:UIControlEventTouchUpInside];
        [self.slideMenuButton addTarget:self action:@selector( hideKeyboardWhenTapped ) forControlEvents:UIControlEventTouchDown];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    
    self.headingLabel.text = self.headerProperty;
    
    if (appDelegate.showActivity == YES) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UserActivitiesVC *viewController = (UserActivitiesVC *)[storyboard instantiateViewControllerWithIdentifier:@"activityView"];
        [self presentViewController:viewController animated:YES completion:^{
            appDelegate.showActivity = NO;
            
        }];
    }
}

#pragma mark - Search bar delegates and keyboard handling

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    self.searchString = searchBar.text;
    
    [searchBar setShowsCancelButton:NO animated:YES];
    [searchBar resignFirstResponder];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SubCategoryVC *viewController = (SubCategoryVC *)[storyboard instantiateViewControllerWithIdentifier:@"subView"];
    viewController.searchString = self.searchString;
    [self presentViewController:viewController animated:YES completion:nil];
    searchBar.text = @"";
    
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    
    [searchBar resignFirstResponder];
    
}


- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if ([searchText length] == 0)
    {
        [searchBar performSelector:@selector(resignFirstResponder)
                        withObject:nil
                        afterDelay:0];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
    UITouch *touch = [touches anyObject];
    if(touch.phase == UITouchPhaseBegan) {
        [self.categoriesSearchBar resignFirstResponder];
    }
    
}

// gesture method

-(void)hideKeyboardWhenTapped{
    
    [self.categoriesSearchBar resignFirstResponder];
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
