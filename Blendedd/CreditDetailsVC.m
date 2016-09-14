//
//  CreditDetailsVC.m
//  Blendedd
//
//  Created by iOS Developer on 07/11/15.
//  Copyright © 2015 Prabh Kiran Kaur. All rights reserved.
//

#import "CreditDetailsVC.h"

@interface CreditDetailsVC ()
{
    VSDropdown *_dropdown;
    
    AppDelegate *appDelegate;
    
    UIAlertController *alertController;
    
    NSArray *creditMonthArr;
    NSMutableArray *creditYearArr;
}
@property (weak, nonatomic) IBOutlet UILabel *creditLabel;
@property (weak, nonatomic) IBOutlet UILabel *expirationLabel;

@end

@implementation CreditDetailsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    appDelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    // Do any additional setup after loading the view.
    
    creditMonthArr = [NSArray arrayWithObjects:@"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09",@"10",@"11",@"12", nil];
    
    creditYearArr = [NSMutableArray array];
//    creditYearArr = [NSArray arrayWithObjects:@"2015",@"2016",@"2017",@"2018",@"2019",@"2020",@"2021",@"2022",@"2023",@"2024",@"2025",@"2026",@"2027",@"2028",@"2029",@"2030", nil];
    
    NSDateComponents *currentDateComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];

    NSString *yearString = [NSString stringWithFormat:@"%d",[currentDateComponents year]];
    
    for (int i=1; i<15; i++)
    {
        [creditYearArr addObject:[NSString stringWithFormat:@"%d",[yearString intValue]-i]];
    }
    
//    NSLog(@"%@",creditYearArr);
    
    _dropdown = [[VSDropdown alloc]initWithDelegate:self];
    [_dropdown setAdoptParentTheme:NO];
    [_dropdown setShouldSortItems:YES];
    
    
    [self changeColorOfLabel:self.creditLabel fromCharacter:16 forNumberOfCharacters:1];
    [self changeColorOfLabel:self.expirationLabel fromCharacter:10 forNumberOfCharacters:1];
    
    [self addImage:@"dwn.png" withPaddingToTextField:self.expirationMonthField];
    [self addImage:@"dwn.png" withPaddingToTextField:self.expirationYearField];
}

#pragma mark - Getting data from server

-(void)getData
{
    
    [RequestManager getFromServer:@"signup_step_three" parameters:[NSMutableDictionary dictionaryWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] stringForKey:@"creditName"],@"user_credit_card_name",[[NSUserDefaults standardUserDefaults] stringForKey:@"cardNumber"],@"user_credit_card_number",[[NSUserDefaults standardUserDefaults] stringForKey:@"expirationMonth"],@"user_credit_card_expiry_month",[[NSUserDefaults standardUserDefaults] stringForKey:@"expirationYear"],@"user_credit_card_expiry_year",[[NSUserDefaults standardUserDefaults] stringForKey:@"cvv"],@"user_credit_card_cvv", nil] completionHandler:^(NSDictionary *responseDict) {
        
        NSLog(@"response ::::::%@",responseDict);
        
        NSArray *dataArray=[responseDict valueForKey:@"data"];
        
        
        if ([[responseDict valueForKey:@"code"] isEqualToString:@"0"]) {
            if ([[responseDict valueForKey:@"message"] isEqualToString:@""]) {
                alertController = [UIAlertController alertControllerWithTitle:nil message:[dataArray componentsJoinedByString:@"\n"] preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                [alertController addAction:ok];
                [appDelegate hide_LoadingIndicator];
                [self presentViewController:alertController animated:YES completion:nil];
                
            }else{
                alertController = [UIAlertController alertControllerWithTitle:nil message:[responseDict valueForKey:@"message"] preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                [alertController addAction:ok];
                [appDelegate hide_LoadingIndicator];
                [self presentViewController:alertController animated:YES completion:nil];
            }
        }
        else if ([[responseDict valueForKey:@"code"] isEqualToString:@"1"]) {
            
            alertController = [UIAlertController alertControllerWithTitle:nil message:[responseDict valueForKey:@"message"] preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
                                 {
                                     [self success];
                                 }];
            [alertController addAction:ok];
            
            [self presentViewController:alertController animated:YES completion:nil];
            
            
            
        }
        [appDelegate hide_LoadingIndicator];
        
    }];
    
}

#pragma mark - Dropdown Setup

- (IBAction)selectMonthButtonAction:(id)sender {
    
    [self.creditNameField resignFirstResponder];
    [self.cardNumberField resignFirstResponder];
    [self.cvvField resignFirstResponder];
    [self showDropDownForButton:sender adContents:creditMonthArr multipleSelection:NO];
    
}

- (IBAction)selectYearButtonAction:(id)sender {
    
    [self.creditNameField resignFirstResponder];
    [self.cardNumberField resignFirstResponder];
    [self.cvvField resignFirstResponder];
    [self showDropDownForButton:sender adContents:creditYearArr multipleSelection:NO];
    
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
    if (btn.tag == 21) {
        
        self.expirationMonthField.text = allSelectedItems;
        
    }else
    {
        self.expirationYearField.text = allSelectedItems;
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

- (IBAction)submitButtonPressed:(id)sender {
    
    [UIView animateWithDuration:0.2
                          delay:0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         
                         [self.view setFrame:CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height)];
                         
                     } completion:^(BOOL finished){
                         NSLog(@"Completed");
                         
                         
                     }];
    
    
    if ([self.creditNameField.text isEqualToString:@""] || [self.cardNumberField.text isEqualToString:@""] || [self.expirationMonthField.text isEqualToString:@""] || [self.expirationYearField.text isEqualToString:@""] || [self.cvvField.text isEqualToString:@""]) {
        
        alertController = [UIAlertController alertControllerWithTitle:nil message:@"Please fill in all the fields!!" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        
        [self presentViewController:alertController animated:YES completion:nil];
        
    }else{
        
        [appDelegate show_LoadingIndicator];
        
        [[NSUserDefaults standardUserDefaults] setObject:self.creditNameField.text forKey:@"creditName"];
        [[NSUserDefaults standardUserDefaults] setObject:self.cardNumberField.text forKey:@"cardNumber"];
        [[NSUserDefaults standardUserDefaults] setObject:self.expirationMonthField.text forKey:@"expirationMonth"];
        [[NSUserDefaults standardUserDefaults] setObject:self.expirationYearField.text forKey:@"expirationYear"];
        [[NSUserDefaults standardUserDefaults] setObject:self.cvvField.text forKey:@"cvv"];
        
        [self getData];
    }
    
}

// move to next on success

-(void)success
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ConditionsVC *viewController = (ConditionsVC *)[storyboard instantiateViewControllerWithIdentifier:@"conditionsView"];
    [self presentViewController:viewController animated:YES completion:^{
        [appDelegate hide_LoadingIndicator];
    }];
}

#pragma mark - custom method to change label text color

-(void)changeColorOfLabel:(UILabel*)label fromCharacter:(int)position forNumberOfCharacters:(int)length
{
    NSMutableAttributedString *text =
    [[NSMutableAttributedString alloc]
     initWithAttributedString: label.attributedText];
    
    [text addAttribute:NSForegroundColorAttributeName
                 value:[UIColor redColor]
                 range:NSMakeRange(position, length)];
    [label setAttributedText: text];
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

#pragma mark - keyboard handling with textfield delegates and touches

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
    if (textField.tag == 403) {
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
    
    if (textField.tag == 401) {
        [self.cardNumberField becomeFirstResponder];
    }
    else if (textField.tag == 402)
    {
        [textField resignFirstResponder];
        
    }
    else if (textField.tag == 403)
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
    
    NSCharacterSet *invalidCharSet1 = [[NSCharacterSet characterSetWithCharactersInString:@"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz "] invertedSet];
    NSCharacterSet *invalidCharSet2 = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet];
    
    if (textField.tag == 401) {
        // Only characters in the NSCharacterSet you choose will insertable.
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:invalidCharSet1] componentsJoinedByString:@""];
        return [string isEqualToString:filtered];
    }
    else if (textField.tag == 402) {
        if (textField.text.length > 15 && range.length == 0)
            return NO;
        // Only characters in the NSCharacterSet you choose will insertable.
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:invalidCharSet2] componentsJoinedByString:@""];
        return [string isEqualToString:filtered];
    }
    else if (textField.tag == 403) {
        if (textField.text.length > 3 && range.length == 0)
            return NO;
        // Only characters in the NSCharacterSet you choose will insertable.
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:invalidCharSet2] componentsJoinedByString:@""];
        return [string isEqualToString:filtered];
    }
    return YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
    UITouch *touch = [touches anyObject];
    if(touch.phase == UITouchPhaseBegan) {
        [self.creditNameField resignFirstResponder];
        [self.cardNumberField resignFirstResponder];
        [self.cvvField resignFirstResponder];
        
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
