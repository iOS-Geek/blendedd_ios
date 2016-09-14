//
//  EditCreditDetailsVC.m
//  Blendedd
//
//  Created by iOS Developer on 20/11/15.
//  Copyright © 2015 Prabh Kiran Kaur. All rights reserved.
//

#import "EditCreditDetailsVC.h"

@interface EditCreditDetailsVC ()
{
    VSDropdown *_dropdown;
    
    NSArray *creditMonthArr;
    NSArray *creditYearArr;
    
    UIAlertController *alertController;
    int height;
}
@property (weak, nonatomic) IBOutlet UIScrollView *scrollV;
@end

@implementation EditCreditDetailsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    creditMonthArr = [NSArray arrayWithObjects:@"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09",@"10",@"11",@"12", nil];
    creditYearArr = [NSArray arrayWithObjects:@"2015",@"2016",@"2017",@"2018",@"2019",@"2020",@"2021",@"2022",@"2023",@"2024",@"2025",@"2026",@"2027",@"2028",@"2029",@"2030", nil];
    
    _dropdown = [[VSDropdown alloc]initWithDelegate:self];
    [_dropdown setAdoptParentTheme:NO];
    [_dropdown setShouldSortItems:YES];
    
    
    if ([[NSUserDefaults standardUserDefaults] stringForKey:@"logged_user_credit_card_number"]) {
        
        self.existingCreditLabel.text = [NSString stringWithFormat:@"Existing Credit Card : %@",[[NSUserDefaults standardUserDefaults] stringForKey:@"logged_user_credit_card_number"]];
    }
    else{
        
        self.existingCreditLabel.text = [NSString stringWithFormat:@"Existing Credit Card : No existing card"];
    }
    
    [self addImage:@"dwn.png" withPaddingToTextField:self.editMonthField];
    [self addImage:@"dwn.png" withPaddingToTextField:self.editYearField];
    
    [self changeColorOfLabel:self.infoLabel fromCharacter:16 forNumberOfCharacters:1];
    [self changeColorOfLabel:self.expireLabel fromCharacter:10 forNumberOfCharacters:1];
    
    height = [UIScreen mainScreen].bounds.size.height;
    if (height != 480){
        self.scrollV.scrollEnabled = false;
    }

    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapFrom)];
    
    [self.scrollV addGestureRecognizer:tapGestureRecognizer];
}

#pragma mark - Getting data from server

-(void)getData
{
    
    [RequestManager getFromServer:@"update_credit_card" parameters:[NSMutableDictionary dictionaryWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] stringForKey:@"logged_user_id"],@"user_id",[[NSUserDefaults standardUserDefaults] stringForKey:@"logged_user_security_hash"],@"user_security_hash",self.nameField.text,@"user_credit_card_name",self.numberField.text,@"user_credit_card_number",self.editMonthField.text,@"user_credit_card_expiry_month",self.editYearField.text,@"user_credit_card_expiry_year",self.cvvCardField.text,@"user_credit_card_cvv", nil] completionHandler:^(NSDictionary *responseDict) {
        
        
        
        
        if ([[responseDict valueForKey:@"code"] isEqualToString:@"1"]){
            
            alertController = [UIAlertController alertControllerWithTitle:nil message:[responseDict valueForKey:@"message"] preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
            [alertController addAction:ok];
            
            
            
            NSDictionary *dataDict = [responseDict valueForKey:@"data"];
            
            [[NSUserDefaults standardUserDefaults]setObject:[dataDict valueForKey:@"user_security_hash"] forKey:@"logged_user_security_hash"];
            
            [[NSUserDefaults standardUserDefaults]setObject:[dataDict valueForKey:@"user_credit_card_name"] forKey:@"logged_user_credit_card_name"];
            
            [[NSUserDefaults standardUserDefaults]setObject:[dataDict valueForKey:@"user_credit_card_number"] forKey:@"logged_user_credit_card_number"];
            
            [[NSUserDefaults standardUserDefaults]setObject:[dataDict valueForKey:@"user_credit_card_expiry_month"] forKey:@"logged_user_credit_card_expiry_month"];
            
            [[NSUserDefaults standardUserDefaults]setObject:[dataDict valueForKey:@"user_credit_card_expiry_year"] forKey:@"logged_user_credit_card_expiry_year"];
            
            [[NSUserDefaults standardUserDefaults]setObject:[dataDict valueForKey:@"user_credit_card_cvv"] forKey:@"logged_user_credit_card_cvv"];
            
            
        }
        else if ([[responseDict valueForKey:@"code"] isEqualToString:@"0"]) {
            
            NSArray *dataArray=[responseDict valueForKey:@"data"];
            
            if (dataArray) {
                
                alertController = [UIAlertController alertControllerWithTitle:[responseDict valueForKey:@"message"] message:[dataArray componentsJoinedByString:@"\n"] preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                [alertController addAction:ok];
                
                
            }
            else {
                
                alertController = [UIAlertController alertControllerWithTitle:nil message:[responseDict valueForKey:@"message"] preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                [alertController addAction:ok];
                
                
            }
            
        }
        [self presentViewController:alertController animated:YES completion:nil];
        
    }];
    
}

#pragma mark - Dropdown setup

- (IBAction)selectEditMonthButtonAction:(id)sender {
    
    if (height == 480 ){
    [self.scrollV setContentOffset:CGPointMake(0, 100) animated: YES];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.3 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self showDropDownForButton:sender adContents:creditMonthArr multipleSelection:NO];
            
        });
    }
    else{
[self showDropDownForButton:sender adContents:creditMonthArr multipleSelection:NO];

    }
    
    
    
    
}

- (IBAction)selectEditYearButtonAction:(id)sender {
    
    if (height == 480 ){
        [self.scrollV setContentOffset:CGPointMake(0, 100) animated: YES];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.3 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [self showDropDownForButton:sender adContents:creditYearArr multipleSelection:NO];
            
        });
    }
    else{
        [self showDropDownForButton:sender adContents:creditYearArr multipleSelection:NO];
        
    }
    
    
    
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

#pragma mark - Submit button action

- (IBAction)submitNewCreditDetails:(id)sender {
    
    if ([self.nameField.text isEqualToString:@""] || [self.numberField.text isEqualToString:@""] || [self.cvvCardField.text isEqualToString:@""] || [self.editMonthField.text isEqualToString:@""] || [self.editYearField.text isEqualToString:@""]) {
        
        alertController = [UIAlertController alertControllerWithTitle:nil message:@"Please fill all the fields." preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        
        [self presentViewController:alertController animated:YES completion:nil];
        
        
    }
    else {
        
        [self getData];
        
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
        
        self.editMonthField.text = allSelectedItems;
        
    }else
    {
        self.editYearField.text = allSelectedItems;
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

#pragma mark - keyboard handlingwith texfield delegates and touches

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
    if (height==480) {
        
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                [self.scrollV setContentOffset:CGPointMake(0, 100) animated: YES];
            });
        
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    if (textField.tag == 501) {
        [self.numberField becomeFirstResponder];
    }
    else if (textField.tag == 502)
    {
        [self.cvvCardField becomeFirstResponder];
        
    }else
    {
        [textField resignFirstResponder];
        if (height == 480 ){
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [self.scrollV setContentOffset:CGPointMake(0, 100) animated: YES];        });
        }
    }
    return YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
    UITouch *touch = [touches anyObject];
    if(touch.phase == UITouchPhaseBegan) {
        [self.nameField resignFirstResponder];
        [self.numberField resignFirstResponder];
        [self.cvvCardField resignFirstResponder];
    }
    
}

#pragma mark - Segue for common view

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"cardSegue"]) {
        CommonEditHeaderVC *embed = segue.destinationViewController;
        embed.mainHeaderProperty = @"Credit Card";
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

-(void)handleTapFrom{
    [self.nameField resignFirstResponder];
    [self.numberField resignFirstResponder];
    [self.cvvCardField resignFirstResponder];
    if (height ==480) {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self.scrollV setContentOffset:CGPointMake(0, 100) animated: YES];
    });
    }
    // [self.scrollV setContentOffset:CGPointMake(0, 0) animated:YES];
}


@end
