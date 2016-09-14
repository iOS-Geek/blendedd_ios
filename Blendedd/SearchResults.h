//
//  SearchResults.h
//  Blendedd
//
//  Created by iOS Developer on 16/11/15.
//  Copyright © 2015 Prabh Kiran Kaur. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"

@interface SearchResults : NSObject
@property(nonatomic,retain) NSString * post_id;
@property(nonatomic,retain) NSString * post_title;
@property(nonatomic,retain) NSString * post_description;
@property(nonatomic,retain) NSString * post_display_price;
@property(nonatomic,retain) NSString * city_name;
@property(nonatomic,retain) NSString * state_code;
@property(nonatomic,retain) NSString * post_zipcode;
@property(nonatomic,retain) NSString * post_image_url;
@property(nonatomic, strong) UIImage *post_image;
@end
