//
//  EditPersonalDetailsVC.m
//  Blendedd
//
//  Created by iOS Developer on 20/11/15.
//  Copyright © 2015 Prabh Kiran Kaur. All rights reserved.
//

#import "EditPersonalDetailsVC.h"

@interface EditPersonalDetailsVC ()
{
    NSMutableArray *selectedBtnarr;
    
    VSDropdown *_dropdown;
    
    NSString *passedEditedCountryId;
    NSString *passedEditedStateId;
    NSString *passedEditedCityId;
    
    NSMutableArray *namesArray;
    NSMutableArray *idArray;
    
    NSMutableArray *countryArray;
    NSMutableArray *countryIdArray;
    
    NSMutableArray *stateArray;
    NSMutableArray *stateIdArray;
    
    NSMutableArray *cityArray;
    NSMutableArray *cityIdArray;
    
    UIAlertController *alertController;
    AppDelegate *appDelegate;
}
@end

@implementation EditPersonalDetailsVC
int counter = 0;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    appDelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    [appDelegate show_LoadingIndicator];
    
    //scrollview content size
    self.containerScrollView.contentSize=CGSizeMake(0, self.submitButton.frame.origin.y+162);
    
    selectedBtnarr = [[NSMutableArray alloc]init];
    idArray = [NSMutableArray array];
    namesArray = [NSMutableArray array];
    
    self.editFirstNameField.text = [[NSUserDefaults standardUserDefaults] stringForKey:@"logged_user_first_name"];
    self.editLastNameField.text = [[NSUserDefaults standardUserDefaults] stringForKey:@"logged_user_last_name"];
    self.fbField.text = [[NSUserDefaults standardUserDefaults] stringForKey:@"logged_user_facebook_url"];
    self.twitterField.text = [[NSUserDefaults standardUserDefaults] stringForKey:@"logged_user_twitter_url"];
    self.linkedInField.text = [[NSUserDefaults standardUserDefaults] stringForKey:@"logged_user_linkedin_url"];
    self.instaField.text = [[NSUserDefaults standardUserDefaults] stringForKey:@"logged_user_instagram_url"];
    self.editAddOneField.text = [[NSUserDefaults standardUserDefaults] stringForKey:@"logged_user_address_line_1"];
    self.editAddTwoField.text = [[NSUserDefaults standardUserDefaults] stringForKey:@"logged_user_address_line_2"];
    self.editZipField.text = [[NSUserDefaults standardUserDefaults] stringForKey:@"logged_user_zipcode"];
    self.editCountryField.text = [[NSUserDefaults standardUserDefaults] stringForKey:@"logged_country_name"];
    self.editStateField.text = [[NSUserDefaults standardUserDefaults] stringForKey:@"logged_state_name"];
    self.editCityField.text = [[NSUserDefaults standardUserDefaults] stringForKey:@"logged_city_name"];
    
    
    _dropdown = [[VSDropdown alloc]initWithDelegate:self];
    [_dropdown setAdoptParentTheme:NO];
    [_dropdown setShouldSortItems:YES];
    
    [self addImage:@"dwn.png" withPaddingToTextField:self.editCountryField];
    [self addImage:@"dwn.png" withPaddingToTextField:self.editStateField];
    [self addImage:@"dwn.png" withPaddingToTextField:self.editCityField];
    
    [self getDataForButton:self.selectCountryBtn forServer:@"countries" withKeyDictionary:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"now",@"current_timestamp", nil] withName:@"country_name" andId:@"country_id"];
    
    self.selectStateBtn.enabled = NO;
    self.selectCityBtn.enabled = NO;
}

#pragma mark - getting data for country, state, cities from server

-(void)getDataForButton:(UIButton*)button forServer:(NSString*)serverString withKeyDictionary:(NSMutableDictionary*)keyDict withName:(NSString*)nameKey andId:(NSString*)idKey{
    
    [RequestManager getFromServer:serverString parameters:keyDict completionHandler:^(NSDictionary *responseDict) {
        
        [idArray removeAllObjects];
        [namesArray removeAllObjects];
        
        NSArray *dataArray=[responseDict valueForKey:@"data"];
        
        for (NSDictionary *dic in dataArray) {
            NSString *idString = [dic valueForKey:idKey];
            NSString *nameString = [dic valueForKey:nameKey];
            [idArray addObject:idString];
            [namesArray addObject:nameString];
        }
        NSLog(@"%@",namesArray);
        
    }];
    [appDelegate hide_LoadingIndicator];
}

#pragma mark - Getting data from server

-(void)getData
{
    
    [RequestManager getFromServer:@"edit_profile" parameters:[NSMutableDictionary dictionaryWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] stringForKey:@"logged_user_id"],@"user_id",[[NSUserDefaults standardUserDefaults] stringForKey:@"logged_user_security_hash"],@"user_security_hash",[[NSUserDefaults standardUserDefaults] stringForKey:@"logged_user_first_name"],@"user_first_name",[[NSUserDefaults standardUserDefaults] stringForKey:@"logged_user_last_name"],@"user_last_name",[[NSUserDefaults standardUserDefaults] stringForKey:@"logged_user_facebook_url"],@"user_facebook_url",[[NSUserDefaults standardUserDefaults] stringForKey:@"logged_user_twitter_url"],@"user_twitter_url",[[NSUserDefaults standardUserDefaults] stringForKey:@"logged_user_linkedin_url"],@"user_linkedin_url",[[NSUserDefaults standardUserDefaults] stringForKey:@"logged_user_instagram_url"],@"user_instagram_url",[[NSUserDefaults standardUserDefaults] stringForKey:@"logged_user_address_line_1"],@"user_address_line_1",[[NSUserDefaults standardUserDefaults] stringForKey:@"logged_user_address_line_2"],@"user_address_line_2",[[NSUserDefaults standardUserDefaults] stringForKey:@"logged_countries_id"],@"countries_id",[[NSUserDefaults standardUserDefaults] stringForKey:@"logged_states_id"],@"states_id",[[NSUserDefaults standardUserDefaults] stringForKey:@"logged_cities_id"],@"cities_id",[[NSUserDefaults standardUserDefaults] stringForKey:@"logged_user_zipcode"],@"user_zipcode",[[NSUserDefaults standardUserDefaults] stringForKey:@"logged_user_communication_via_email"],@"user_communication_via_email",[[NSUserDefaults standardUserDefaults] stringForKey:@"logged_user_communication_via_phone_call"],@"user_communication_via_phone_call",[[NSUserDefaults standardUserDefaults] stringForKey:@"logged_user_communication_via_sms"],@"user_communication_via_sms", nil] completionHandler:^(NSDictionary *responseDict) {
        
        NSLog(@"response ::  %@",responseDict);
        
        alertController = [UIAlertController alertControllerWithTitle:nil message:[responseDict valueForKey:@"message"] preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        
        [self presentViewController:alertController animated:YES completion:nil];
        
        
        if ([[responseDict valueForKey:@"code"] isEqualToString:@"1"]){
            
            
            NSDictionary *dataDict = [responseDict valueForKey:@"data"];
            
            
            [[NSUserDefaults standardUserDefaults]setObject:[dataDict valueForKey:@"user_security_hash"] forKey:@"logged_user_security_hash"];
            
        }
        
    }];
    [appDelegate hide_LoadingIndicator];
}

#pragma mark - Submit button action

- (IBAction)submitInfoButtonAction:(id)sender {
    
    
    [[NSUserDefaults standardUserDefaults] setObject:self.editFirstNameField.text forKey:@"logged_user_first_name"];
    
    [[NSUserDefaults standardUserDefaults] setObject:self.editLastNameField.text forKey:@"logged_user_last_name"];
    
    [[NSUserDefaults standardUserDefaults] setObject:self.fbField.text forKey:@"logged_user_facebook_url"];
    
    [[NSUserDefaults standardUserDefaults] setObject:self.twitterField.text forKey:@"logged_user_twitter_url"];
    
    [[NSUserDefaults standardUserDefaults] setObject:self.linkedInField.text forKey:@"logged_user_linkedin_url"];
    
    [[NSUserDefaults standardUserDefaults] setObject:self.instaField.text forKey:@"logged_user_instagram_url"];
    
    [[NSUserDefaults standardUserDefaults] setObject:self.editAddOneField.text forKey:@"logged_user_address_line_1"];
    
    [[NSUserDefaults standardUserDefaults] setObject:self.editAddTwoField.text forKey:@"logged_user_address_line_2"];
    
    [[NSUserDefaults standardUserDefaults] setObject:self.editZipField.text forKey:@"logged_user_zipcode"];
    
    [[NSUserDefaults standardUserDefaults] setObject:self.editCountryField.text forKey:@"logged_country_name"];
    
    [[NSUserDefaults standardUserDefaults] setObject:self.editStateField.text forKey:@"logged_state_name"];
    
    [[NSUserDefaults standardUserDefaults] setObject:self.editCityField.text forKey:@"logged_city_name"];
    [appDelegate show_LoadingIndicator];
    [self getData];
    
}

#pragma mark - Drop down setup

- (IBAction)editCountryButtonAction:(id)sender {
    
    if (counter == 0) {
        
        countryArray = [[NSMutableArray alloc] initWithCapacity:namesArray.count];
        for (id element in namesArray) {
            [countryArray addObject:[element mutableCopy]];
        }
        
        countryIdArray = [[NSMutableArray alloc] initWithCapacity:idArray.count];
        for (id element in idArray) {
            [countryIdArray addObject:[element mutableCopy]];
        }}
    [self showDropDownForButton:sender adContents:countryArray multipleSelection:NO];
    
    
}
- (IBAction)editStateButtonAction:(id)sender {
    
    if (counter == 1){
        
        stateArray = [[NSMutableArray alloc] initWithCapacity:namesArray.count];
        for (id element in namesArray) {
            [stateArray addObject:[element mutableCopy]];
        }
        stateIdArray = [[NSMutableArray alloc] initWithCapacity:idArray.count];
        for (id element in idArray) {
            [stateIdArray addObject:[element mutableCopy]];
        }
    }
    
    [self showDropDownForButton:sender adContents:stateArray multipleSelection:NO];
    
}
- (IBAction)editCityButtonAction:(id)sender {
    
    if (counter == 2){
        
        cityArray = [[NSMutableArray alloc] initWithCapacity:namesArray.count];
        for (id element in namesArray) {
            [cityArray addObject:[element mutableCopy]];
        }
        cityIdArray = [[NSMutableArray alloc] initWithCapacity:idArray.count];
        for (id element in idArray) {
            [cityIdArray addObject:[element mutableCopy]];
        }
        
    }
    
    [self showDropDownForButton:sender adContents:cityArray multipleSelection:NO];
    
}

-(void)showDropDownForButton:(UIButton *)sender adContents:(NSArray *)contents multipleSelection:(BOOL)multipleSelection
{
    
    [_dropdown setDrodownAnimation:rand()%2];
    
    [_dropdown setAllowMultipleSelection:multipleSelection];
    
    [_dropdown setupDropdownForView:sender];
    
    [_dropdown setSeparatorColor:sender.titleLabel.textColor];
    
    if (_dropdown.allowMultipleSelection)
    {
        [_dropdown reloadDropdownWithContents:contents andSelectedItems:[[sender titleForState:UIControlStateNormal] componentsSeparatedByString:@";"]];
        
    }
    else
    {
        [_dropdown reloadDropdownWithContents:contents];
        
    }
    
}

#pragma mark - VSDropdown Delegate methods.

- (void)dropdown:(VSDropdown *)dropDown didChangeSelectionForValue:(NSString *)str atIndex:(NSUInteger)index selected:(BOOL)selected
{
    UIButton *btn = (UIButton *)dropDown.dropDownView;
    
    NSString *allSelectedItems = nil;
    if (dropDown.selectedItems.count > 1)
    {
        allSelectedItems = [dropDown.selectedItems componentsJoinedByString:@";"];
        
    }
    else
    {
        allSelectedItems = [dropDown.selectedItems firstObject];
        
    }
    if (btn.tag == 77) {
        counter = 1;
        [appDelegate show_LoadingIndicator];
        self.editCountryField.text = allSelectedItems;
        passedEditedCountryId = [countryIdArray objectAtIndex:index];
        [[NSUserDefaults standardUserDefaults] setObject:passedEditedCountryId forKey:@"logged_countries_id"];
        [self getDataForButton:self.selectStateBtn forServer:@"states" withKeyDictionary:[NSMutableDictionary dictionaryWithObjectsAndKeys: passedEditedCountryId,@"countries_id", nil] withName:@"state_name" andId:@"state_id"];
        self.selectStateBtn.enabled = YES;
        self.selectCityBtn.enabled = NO;
        
    }else if (btn.tag == 78)
    {
        counter = 2;
        [appDelegate show_LoadingIndicator];
        self.editStateField.text = allSelectedItems;
        passedEditedStateId = [stateIdArray objectAtIndex:index];
        [[NSUserDefaults standardUserDefaults] setObject:passedEditedStateId forKey:@"logged_states_id"];
        [self getDataForButton:self.selectCityBtn forServer:@"cities" withKeyDictionary:[NSMutableDictionary dictionaryWithObjectsAndKeys: passedEditedStateId,@"states_id", nil] withName:@"city_name" andId:@"city_id"];
        self.selectCityBtn.enabled = YES;
    }else
    {
        self.editCityField.text = allSelectedItems;
        passedEditedCityId = [cityIdArray objectAtIndex:index];
        [[NSUserDefaults standardUserDefaults] setObject:passedEditedCityId forKey:@"logged_cities_id"];
    }
}

- (UIColor *)outlineColorForDropdown:(VSDropdown *)dropdown
{
    
    return [UIColor lightGrayColor];
    
}

- (CGFloat)outlineWidthForDropdown:(VSDropdown *)dropdown
{
    return 2.0;
}

- (CGFloat)cornerRadiusForDropdown:(VSDropdown *)dropdown
{
    return 3.0;
}

- (CGFloat)offsetForDropdown:(VSDropdown *)dropdown
{
    return -2.0;
}

#pragma mark - Handling checkboxes

- (IBAction)preferenceButtonAction:(id)sender {
    
    UIButton *btn=(UIButton *)sender;
    NSString *Str=[NSString stringWithFormat:@"%ld",(long)btn.tag];
    BOOL flag=   [selectedBtnarr containsObject:Str];
    
    if (flag==YES)
    {
        
        [selectedBtnarr removeObject:Str];
        if (btn.tag == 88) {
            self.emailCheckImageView.image = [UIImage imageNamed:@"nocheck.png"];
            [[NSUserDefaults standardUserDefaults]setObject:@"0" forKey:@"logged_user_communication_via_email"];
        }else if (btn.tag == 89)
        {
            self.phoneCheckImageView.image = [UIImage imageNamed:@"nocheck.png"];
            [[NSUserDefaults standardUserDefaults]setObject:@"0" forKey:@"logged_user_communication_via_phone_call"];
        }else if (btn.tag == 90)
        {
            self.textCheckImageView.image = [UIImage imageNamed:@"nocheck.png"];
            [[NSUserDefaults standardUserDefaults]setObject:@"0" forKey:@"logged_user_communication_via_sms"];
        }
    }
    else
    {
        [selectedBtnarr addObject:Str];
        
        if (btn.tag == 88) {
            self.emailCheckImageView.image = [UIImage imageNamed:@"check.png"];
            [[NSUserDefaults standardUserDefaults]setObject:@"1" forKey:@"logged_user_communication_via_email"];
        }else if (btn.tag == 89)
        {
            self.phoneCheckImageView.image = [UIImage imageNamed:@"check.png"];
            [[NSUserDefaults standardUserDefaults]setObject:@"1" forKey:@"logged_user_communication_via_phone_call"];
        }else if (btn.tag == 90)
        {
            self.textCheckImageView.image = [UIImage imageNamed:@"check.png"];
            [[NSUserDefaults standardUserDefaults]setObject:@"1" forKey:@"logged_user_communication_via_sms"];
        }
        
    }
    
    
}

#pragma mark - custom method to add image to textfield

-(void)addImage:(NSString*)img withPaddingToTextField:(UITextField*)textField
{
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 15, 10)];
    imgView.image = [UIImage imageNamed:img];
    
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 10)];
    [paddingView addSubview:imgView];
    [textField setRightViewMode:UITextFieldViewModeAlways];
    [textField setRightView:paddingView];
    
}

#pragma mark - keyboard handling with textfield delegate and touches

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    if (textField.tag == 601) {
        [self.editLastNameField becomeFirstResponder];
    }
    else if (textField.tag == 602)
    {
        [self.fbField becomeFirstResponder];
        
    }else if (textField.tag == 603)
    {
        [self.twitterField becomeFirstResponder];
        
    }else if (textField.tag == 604)
    {
        [self.linkedInField becomeFirstResponder];
        
    }else if (textField.tag == 605)
    {
        [self.instaField becomeFirstResponder];
        
    }else if (textField.tag == 606)
    {
        [self.editAddOneField becomeFirstResponder];
        
    }else if (textField.tag == 607)
    {
        [self.editAddTwoField becomeFirstResponder];
        
    }else
    {
        [textField resignFirstResponder];
    }
    return YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
    UITouch *touch = [touches anyObject];
    if(touch.phase == UITouchPhaseBegan) {
        [self.editFirstNameField resignFirstResponder];
        [self.editLastNameField resignFirstResponder];
        [self.fbField resignFirstResponder];
        [self.twitterField resignFirstResponder];
        [self.linkedInField resignFirstResponder];
        [self.instaField resignFirstResponder];
        [self.editAddOneField resignFirstResponder];
        [self.editAddTwoField resignFirstResponder];
        [self.editZipField resignFirstResponder];
    }
    
}

#pragma mark - Segue for common view

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"infoSegue"]) {
        CommonEditHeaderVC *embed = segue.destinationViewController;
        embed.mainHeaderProperty = @"Personal Info";
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
