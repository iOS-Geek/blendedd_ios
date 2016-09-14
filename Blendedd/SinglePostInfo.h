//
//  SinglePostInfo.h
//  Blendedd
//
//  Created by iOS Developer on 18/11/15.
//  Copyright © 2015 Prabh Kiran Kaur. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SinglePostInfo : NSObject
@property(nonatomic,retain) NSString * post_id;
@property(nonatomic,retain) NSString * post_title;
@property(nonatomic,retain) NSString * post_description;
@property(nonatomic,retain) NSString * post_display_price;
@property(nonatomic,retain) NSString * post_street;
@property(nonatomic,retain) NSString * post_cross_street;
@property(nonatomic,retain) NSString * country_name;
@property(nonatomic,retain) NSString * city_name;
@property(nonatomic,retain) NSString * state_code;
@property(nonatomic,retain) NSString * post_zipcode;
@property(nonatomic,retain) NSString * category_name;
@property(nonatomic,retain) NSString *time_zone_slug;

@property(nonatomic,retain) NSString * post_status;
@property(nonatomic,retain) NSMutableArray *buttonArray;
@property(nonatomic,retain) NSMutableArray *imageArray;
@property(nonatomic,retain) NSMutableArray *postAvailabilityArray;
@end
