//
//  PaymentVC.h
//  Blendedd
//
//  Created by iOS Developer on 19/11/15.
//  Copyright © 2015 Prabh Kiran Kaur. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RequestManager.h"


@interface PaymentVC : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *paymentLabel;
@property (weak, nonatomic) IBOutlet UILabel *creditLabel;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property(nonatomic,retain) NSString *passedStringValue;
@property(nonatomic,retain) NSString *amountReceived;
@property(nonatomic,retain) NSString *optionsIdReceived;
@property(nonatomic,retain) NSString *passedStringTitle;
@property(nonatomic,retain) NSString *passedStringCity;
@property(nonatomic,retain) NSString *passedStringCountry;
@property(nonatomic,retain) NSString *receivedPostId;
@end
