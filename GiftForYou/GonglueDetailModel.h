//
//  GonglueDetailModel.h
//  GiftForYou
//
//  Created by zhumingwen on 16/3/9.
//  Copyright © 2016年 zhumingwen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GonglueDetailModel : NSObject

@property (nonatomic, strong) NSNumber *comments_count;
@property (nonatomic, strong) NSString *content_html;
@property (nonatomic, strong) NSString *content_url;
@property (nonatomic, strong) NSString *cover_image_url;
@property (nonatomic, strong) NSNumber *created_at;
@property (nonatomic, strong) NSNumber *editor_id;
@property (nonatomic, strong) NSNumber *idd;
@property (nonatomic, strong) NSNumber *likes_count;
@property (nonatomic, strong) NSNumber *published_at;
@property (nonatomic, strong) NSString *share_msg;
@property (nonatomic, strong) NSNumber *shares_count;
@property (nonatomic, strong) NSString *short_title;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSNumber *updated_at;
@property (nonatomic, strong) NSString *url;

@end
