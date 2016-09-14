//
//  AddressVC.m
//  Blendedd
//
//  Created by iOS Developer on 07/11/15.
//  Copyright © 2015 Prabh Kiran Kaur. All rights reserved.
//

#import "AddressVC.h"

@interface AddressVC ()
{
    VSDropdown *_dropdown;
    
    AppDelegate *appDelegate;
    
    NSString *passedCountryId;
    NSString *passedStateId;
    NSString *passedCityId;
    
    NSMutableArray *namesArray;
    NSMutableArray *idArray;
    
    NSMutableArray *countryArray;
    NSMutableArray *countryIdArray;
    
    NSMutableArray *stateArray;
    NSMutableArray *stateIdArray;
    
    NSMutableArray *cityArray;
    NSMutableArray *cityIdArray;
    
    UIAlertController *alertController;
}
@end

@implementation AddressVC
int count = 0;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    appDelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    idArray = [NSMutableArray array];
    namesArray = [NSMutableArray array];
    
    _dropdown = [[VSDropdown alloc]initWithDelegate:self];
    [_dropdown setAdoptParentTheme:NO];
    [_dropdown setShouldSortItems:YES];
    
    [self addImage:@"dwn.png" withPaddingToTextField:self.countryField];
    [self addImage:@"dwn.png" withPaddingToTextField:self.stateField];
    [self addImage:@"dwn.png" withPaddingToTextField:self.cityField];
    
    [self getDataForButton:self.countryBtn forServer:@"countries" withKeyDictionary:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"now",@"current_timestamp", nil] withName:@"country_name" andId:@"country_id"];
    
    self.stateBtn.enabled = NO;
    self.cityBtn.enabled = NO;
    
}

#pragma mark - Getting data from server for city, counrty, state.

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
        [appDelegate hide_LoadingIndicator];
    }];
    
}

#pragma mark - Getting data from Server

-(void)passData
{
    
    [RequestManager getFromServer:@"signup_step_two" parameters:[NSMutableDictionary dictionaryWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] stringForKey:@"add1"],@"user_address_line_1",[[NSUserDefaults standardUserDefaults] stringForKey:@"add2"],@"user_address_line_2",[[NSUserDefaults standardUserDefaults] stringForKey:@"countryId"],@"countries_id",[[NSUserDefaults standardUserDefaults] stringForKey:@"stateId"],@"states_id",[[NSUserDefaults standardUserDefaults] stringForKey:@"cityId"],@"cities_id",[[NSUserDefaults standardUserDefaults] stringForKey:@"zip"],@"user_zipcode", nil] completionHandler:^(NSDictionary *responseDict) {
        
        NSArray *dataArray=[responseDict valueForKey:@"data"];
        
        if ([[responseDict valueForKey:@"code"] isEqualToString:@"0"]) {
            
            alertController = [UIAlertController alertControllerWithTitle:nil message:[dataArray componentsJoinedByString:@"\n"] preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
            [alertController addAction:ok];
            [appDelegate hide_LoadingIndicator];
            [self presentViewController:alertController animated:YES completion:nil];
        }
        else{
            
            [self success];
            
        }
    }];
    
}

#pragma mark - Dropdown setup

- (IBAction)countryButtonAction:(id)sender {
    
    if (count == 0) {
        
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
- (IBAction)stateButtonAction:(id)sender {
    
    if (count == 1){
        
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
- (IBAction)cityButtonAction:(id)sender {
    
    if (count == 2){
        
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
    if (btn.tag == 11) {
        count = 1;
        self.countryField.text = allSelectedItems;
        passedCountryId = [countryIdArray objectAtIndex:index];
        [[NSUserDefaults standardUserDefaults] setObject:passedCountryId forKey:@"countryId"];
        [appDelegate show_LoadingIndicator];
        [self getDataForButton:self.stateBtn forServer:@"states" withKeyDictionary:[NSMutableDictionary dictionaryWithObjectsAndKeys: passedCountryId,@"countries_id", nil] withName:@"state_name" andId:@"state_id"];
        self.stateBtn.enabled = YES;
        self.cityBtn.enabled = NO;
        
    }else if (btn.tag == 12)
    {
        count = 2;
        self.stateField.text = allSelectedItems;
        passedStateId = [stateIdArray objectAtIndex:index];
        [[NSUserDefaults standardUserDefaults] setObject:passedStateId forKey:@"stateId"];
        [appDelegate show_LoadingIndicator];
        [self getDataForButton:self.cityBtn forServer:@"cities" withKeyDictionary:[NSMutableDictionary dictionaryWithObjectsAndKeys: passedStateId,@"states_id", nil] withName:@"city_name" andId:@"city_id"];
        self.cityBtn.enabled = YES;
        
    }else
    {
        self.cityField.text = allSelectedItems;
        passedCityId = [cityIdArray objectAtIndex:index];
        [[NSUserDefaults standardUserDefaults] setObject:passedCityId forKey:@"cityId"];
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

#pragma mark - Navigation

- (IBAction)continueToCreditButtonAction:(id)sender {
    
    [UIView animateWithDuration:0.2
                          delay:0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         
                         [self.view setFrame:CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height)];
                         
                     } completion:^(BOOL finished){
                         NSLog(@"Completed");
                         
                         
                     }];
    
    
    if ([self.streetAddress1Field.text isEqualToString:@""] || /*[self.streetAddress2Field.text isEqualToString:@""] ||*/ [self.countryField.text isEqualToString:@""] || [self.stateField.text isEqualToString:@""] || [self.cityField.text isEqualToString:@""] || [self.zipField.text isEqualToString:@""]) {
        
        alertController = [UIAlertController alertControllerWithTitle:nil message:@"Please fill in all the fields!!" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        
        [self presentViewController:alertController animated:YES completion:nil];
        
    }
    else{
        
        [appDelegate show_LoadingIndicator];
        
        [[NSUserDefaults standardUserDefaults] setObject:self.streetAddress1Field.text forKey:@"add1"];
        [[NSUserDefaults standardUserDefaults] setObject:self.streetAddress2Field.text forKey:@"add2"];
        [[NSUserDefaults standardUserDefaults] setObject:self.zipField.text forKey:@"zip"];
        
        [self passData];
    }
}

// navigate to next on success

-(void)success
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    CreditDetailsVC *viewController = (CreditDetailsVC *)[storyboard instantiateViewControllerWithIdentifier:@"creditView"];
    [self presentViewController:viewController animated:YES completion:^{
        [appDelegate hide_LoadingIndicator];
    }];
    
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

#pragma mark - handling keyboard with textfield delegate and touches

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
    if (textField.tag == 303) {
        [UIView animateWithDuration:0.33
                              delay:0
                            options:UIViewAnimationOptionCurveLinear
                         animations:^{
                             
                             [self.view setFrame:CGRectMake(0,-100,self.view.frame.size.width,self.view.frame.size.height)];
                             
                         } completion:^(BOOL finished){
                             NSLog(@"Completed");
                         }];
    }
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    if (textField.tag == 301) {
        [self.streetAddress2Field becomeFirstResponder];
    }
    else if(textField.tag == 302)
    {
        [textField resignFirstResponder];
        
    }
    else if (textField.tag == 303)
    {
        [textField resignFirstResponder];
        [UIView animateWithDuration:0.2
                              delay:0
                            options:UIViewAnimationOptionCurveLinear
                         animations:^{
                             
                             [self.view setFrame:CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height)];
                             
                         } completion:^(BOOL finished){
                             NSLog(@"Completed");
                             
                             
                         }];
        
        
    }
    
    return YES;
}

// for entering only numbers

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField.tag == 303) {
        if (textField.text.length > 4 && range.length == 0)
            return NO;
        // Only characters in the NSCharacterSet you choose will insertable.
        NSCharacterSet *invalidCharSet = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:invalidCharSet] componentsJoinedByString:@""];
        return [string isEqualToString:filtered];
    }
    return YES;
}




- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
    UITouch *touch = [touches anyObject];
    if(touch.phase == UITouchPhaseBegan) {
        [self.streetAddress1Field resignFirstResponder];
        [self.streetAddress2Field resignFirstResponder];
        [self.zipField resignFirstResponder];
        
        if (self.view.frame.origin.y != 0) {
            [UIView animateWithDuration:0.2
                                  delay:0
                                options:UIViewAnimationOptionCurveLinear
                             animations:^{
                                 
                                 [self.view setFrame:CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height)];
                                 
                             } completion:^(BOOL finished){
                                 NSLog(@"Completed");
                                 
                                 
                             }];
            
        }
        
        
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

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
