//
//  SignUpVC.m
//  Blendedd
//
//  Created by iOS Developer on 05/11/15.
//  Copyright © 2015 Prabh Kiran Kaur. All rights reserved.
//

#import "SignUpVC.h"
#import "VSDropdown.h"
@interface SignUpVC ()<VSDropdownDelegate>
{
    VSDropdown *_dropdown;
    AppDelegate *appDelegate;
    UIAlertController *alertController;
    NSArray *dateArr;
    NSArray *monthArr;
    NSArray *yearArr;
    NSString *numericMonth;
}

@property (weak, nonatomic) IBOutlet UIView *outerView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *outerTopViewConstraint;

@end

@implementation SignUpVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    appDelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    [appDelegate hide_LoadingIndicator];
    
    // drop down content arrays
    dateArr = [NSArray arrayWithObjects:@"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23",@"24",@"25",@"26",@"27",@"28",@"29",@"30",@"31", nil];
    monthArr = [NSArray arrayWithObjects:@"Jan",@"Feb",@"Mar",@"Apr",@"May",@"Jun",@"Jul",@"Aug",@"Sep",@"Oct",@"Nov",@"Dec", nil];
    yearArr = [NSArray arrayWithObjects:@"1930",@"1931",@"1932",@"1933",@"1934",@"1935",@"1936",@"1937",@"1938",@"1939",@"1940",@"1941",@"1942",@"1943",@"1944",@"1945",@"1946",@"1947",@"1948",@"1949",@"1950",@"1951",@"1952",@"1953",@"1954",@"1955",@"1956",@"1957",@"1958",@"1959",@"1960",@"1961",@"1962",@"1963",@"1964",@"1965",@"1966",@"1967",@"1968",@"1969",@"1970",@"1971",@"1972",@"1973",@"1974",@"1975",@"1976",@"1977",@"1978",@"1979",@"1980",@"1981",@"1982",@"1983",@"1984",@"1985",@"1986",@"1987",@"1988",@"1989",@"1990",@"1991",@"1992",@"1993",@"1994",@"1995",@"1996",@"1997",@"1998",@"1999",@"2000",@"2001",@"2002",@"2003",@"2004",@"2005",@"2006",@"2007",@"2008",@"2009",@"2010", nil];
    
    
    _dropdown = [[VSDropdown alloc]initWithDelegate:self];
    [_dropdown setAdoptParentTheme:NO];
    [_dropdown setShouldSortItems:YES];
    
    
    [self addImage:@"dwn.png" withPaddingToTextField:self.dateField];
    [self addImage:@"dwn.png" withPaddingToTextField:self.monthField];
    [self addImage:@"dwn.png" withPaddingToTextField:self.yearField];
    
}

#pragma mark - Getting data from Server

-(void)getData
{
    
    [RequestManager getFromServer:@"signup_step_one" parameters:[NSMutableDictionary dictionaryWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] stringForKey:@"firstName"],@"user_first_name",[[NSUserDefaults standardUserDefaults] stringForKey:@"lastName"],@"user_last_name",[[NSUserDefaults standardUserDefaults] stringForKey:@"userId"],@"user_login",[[NSUserDefaults standardUserDefaults] stringForKey:@"password"],@"user_login_password",[[NSUserDefaults standardUserDefaults] stringForKey:@"confirmPass"],@"confirm_user_login_password",[[NSUserDefaults standardUserDefaults] stringForKey:@"email"],@"user_email",[[NSUserDefaults standardUserDefaults] stringForKey:@"contact"],@"user_primary_contact",[[NSUserDefaults standardUserDefaults] stringForKey:@"dob"],@"user_dob", nil] completionHandler:^(NSDictionary *responseDict) {
        
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

#pragma mark - Drop down Setup

- (IBAction)dateButtonAction:(id)sender {
    self.outerTopViewConstraint.constant = -100;
    [UIView animateWithDuration:0.33
                          delay:0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         
                    [self.view layoutIfNeeded];
                     } completion:^(BOOL finished){
                         NSLog(@"Completed");
                         [self showDropDownForButton:sender adContents:dateArr multipleSelection:NO];
                         
                     }];
    
    
}

- (IBAction)monthButtonAction:(id)sender {
    
    _dropdown.shouldSortItems = NO; //default sorts alphabetically
    self.outerTopViewConstraint.constant = -100;
    [UIView animateWithDuration:0.33
                          delay:0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         
                         [self.view layoutIfNeeded];
                     } completion:^(BOOL finished){
                         NSLog(@"Completed");
                         [self showDropDownForButton:sender adContents:monthArr multipleSelection:NO];
                         
                     }];
    
}
- (IBAction)yearButtonAction:(id)sender {
    self.outerTopViewConstraint.constant = -100;
    [UIView animateWithDuration:0.33
                          delay:0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         
                         [self.view layoutIfNeeded];
                     } completion:^(BOOL finished){
                         NSLog(@"Completed");
                         [self showDropDownForButton:sender adContents:yearArr multipleSelection:NO];
                         
                     }];

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
    if (btn.tag == 1) {
        
        self.dateField.text = allSelectedItems;
        
    }else if (btn.tag == 2)
    {
        self.monthField.text = allSelectedItems;
        
        switch (index) {
            case 0:
                numericMonth = @"01";
                break;
                
            case 1:
                numericMonth = @"02";
                break;
                
            case 2:
                numericMonth = @"03";
                break;
                
            case 3:
                numericMonth = @"04";
                break;
                
            case 4:
                numericMonth = @"05";
                break;
                
            case 5:
                numericMonth = @"06";
                break;
                
            case 6:
                numericMonth = @"07";
                break;
                
            case 7:
                numericMonth = @"08";
                break;
                
            case 8:
                numericMonth = @"09";
                break;
                
            case 9:
                numericMonth = @"10";
                break;
                
            case 10:
                numericMonth = @"11";
                break;
                
            case 11:
                numericMonth = @"12";
                break;
                
            default:
                break;
        }
        
    }
    else if (btn.tag == 3)
    {
        self.yearField.text = allSelectedItems;
    }
    
    
    self.outerTopViewConstraint.constant=0;
    [UIView animateWithDuration:0.4
                          delay:0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         [self.firstNameField resignFirstResponder];
                         [self.lastNameField resignFirstResponder];
                         [self.emailField resignFirstResponder];
                         [self.userIdField resignFirstResponder];
                         [self.passwordField resignFirstResponder];
                         [self.confirmPassField resignFirstResponder];
                         [self.contactField resignFirstResponder];
                         [self.view setFrame:CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height)];
                         [self.view layoutIfNeeded];
                         
                     } completion:^(BOOL finished){
                         NSLog(@"Completed");
                       
                     }];
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


- (IBAction)backButtonPressed:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)continueButtonAction:(id)sender {
    
    [UIView animateWithDuration:0.2
                          delay:0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         
                         [self.view setFrame:CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height)];
                         
                     } completion:^(BOOL finished){
                         NSLog(@"Completed");
                         
                         
                     }];
    
    
    if ([self.firstNameField.text isEqualToString: @""] || [self.lastNameField.text isEqualToString: @""] || [self.userIdField.text isEqualToString: @""] || [self.passwordField.text isEqualToString: @""] || [self.confirmPassField.text isEqualToString: @""] || [self.emailField.text isEqualToString: @""] || [self.contactField.text isEqualToString: @""] || [self.dateField.text isEqualToString: @""] || [self.monthField.text isEqualToString: @""] || [self.yearField.text isEqualToString: @""])
    {
        alertController = [UIAlertController alertControllerWithTitle:nil message:@"Please fill in all the fields!!" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        
        [self presentViewController:alertController animated:YES completion:nil];
        
    }else
    {
        [appDelegate show_LoadingIndicator];
        NSString *dobString = [NSString stringWithFormat:@"%@-%@-%@",self.yearField.text,numericMonth,self.dateField.text];
        
        [[NSUserDefaults standardUserDefaults] setObject:self.firstNameField.text forKey:@"firstName"];
        [[NSUserDefaults standardUserDefaults] setObject:self.lastNameField.text forKey:@"lastName"];
        [[NSUserDefaults standardUserDefaults] setObject:self.userIdField.text forKey:@"userId"];
        [[NSUserDefaults standardUserDefaults] setObject:self.passwordField.text forKey:@"password"];
        [[NSUserDefaults standardUserDefaults] setObject:self.confirmPassField.text forKey:@"confirmPass"];
        [[NSUserDefaults standardUserDefaults] setObject:self.emailField.text forKey:@"email"];
        [[NSUserDefaults standardUserDefaults] setObject:self.contactField.text forKey:@"contact"];
        [[NSUserDefaults standardUserDefaults] setObject:dobString forKey:@"dob"];
        
        [self getData];
    }
}

// if no issues, navigate to next

-(void)success{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    AddressVC *viewController = (AddressVC *)[storyboard instantiateViewControllerWithIdentifier:@"addressView"];
    [self presentViewController:viewController animated:YES completion:^{
        [appDelegate hide_LoadingIndicator];
    }];
    
}

#pragma mark - Custom method to add image to textfield

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
    
    if (textField.tag == 204 || textField.tag == 205 || textField.tag == 206 || textField.tag == 207) {
        [UIView animateWithDuration:0.33
                              delay:0
                            options:UIViewAnimationOptionCurveLinear
                         animations:^{
                             
                             [self.view setFrame:CGRectMake(0,-200,self.view.frame.size.width,self.view.frame.size.height)];
                             
                         } completion:^(BOOL finished){
                             NSLog(@"Completed");
                             
                             
                         }];
    }
    
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    if (textField.tag == 201) {
        [self.lastNameField becomeFirstResponder];
    }
    if (textField.tag == 202) {
        [self.emailField becomeFirstResponder];
    }
    if (textField.tag == 203) {
        [self.userIdField becomeFirstResponder];
    }
    if (textField.tag == 204) {
        [self.passwordField becomeFirstResponder];
    }
    if (textField.tag == 205) {
        [self.confirmPassField becomeFirstResponder];
    }
    if (textField.tag == 206) {
        [self.contactField becomeFirstResponder];
    }
    else
    {
        [textField resignFirstResponder];
        if (textField.tag == 207) {
            
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
    
    return YES;
}

// for entering only numbers

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField.tag == 207) {
        
        if (textField.text.length > 9 && range.length == 0)
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
        [self.firstNameField resignFirstResponder];
        [self.lastNameField resignFirstResponder];
        [self.emailField resignFirstResponder];
        [self.userIdField resignFirstResponder];
        [self.passwordField resignFirstResponder];
        [self.confirmPassField resignFirstResponder];
        [self.contactField resignFirstResponder];
        
        if (self.view.frame.origin.y != 0 || self.outerTopViewConstraint.constant != 0) {
            [UIView animateWithDuration:0.3
                                  delay:0
                                options:UIViewAnimationOptionCurveLinear
                             animations:^{
                                 
                                 [self.view setFrame:CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height)];
                                 ///[self.view layoutIfNeeded];
                                 
                             } completion:^(BOOL finished){
                                 NSLog(@"Completed");
                                 self.outerTopViewConstraint.constant = 0;
                                 [UIView animateWithDuration:0.3
                                                       delay:0
                                                     options:UIViewAnimationOptionCurveLinear
                                                  animations:^{
                                                      [self.view layoutIfNeeded];
                                                      
                                                  } completion:^(BOOL finished){
                                                      NSLog(@"Completed");
                                                      
                                                      
                                                  }];
                                 
                             }];
            
        }
        
    }
    
}

#pragma mark - Orientataion

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
