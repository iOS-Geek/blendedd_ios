//
//  CommonEditHeaderVC.m
//  Blendedd
//
//  Created by iOS Developer on 20/11/15.
//  Copyright © 2015 Prabh Kiran Kaur. All rights reserved.
//

#import "CommonEditHeaderVC.h"

@interface CommonEditHeaderVC ()

@end

@implementation CommonEditHeaderVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.mainHeaderLabel.text = self.mainHeaderProperty;
}

#pragma mark - Navigation

- (IBAction)backAction:(id)sender {
    
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
