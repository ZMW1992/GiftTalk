//
//  BannerModel.h
//  GiftTalk
//
//  Created by zhumingwen on 16/1/11.
//  Copyright © 2016年 zhumingwen. All rights reserved.
//

#import "Jastor.h"

@interface TargetModel : Jastor

@property (nonatomic, strong) NSString *banner_image_url;
@property (nonatomic, strong) NSString *cover_image_url;
@property (nonatomic, strong) NSNumber *created_at;
@property (nonatomic, strong) NSNumber *id;
@property (nonatomic, strong) NSNumber *posts_count;
@property (nonatomic, strong) NSNumber *status;
@property (nonatomic, strong) NSString *subtitle;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *updated_at;

@end



@interface BannerModel : Jastor

@property (nonatomic, strong) NSString *channel;
@property (nonatomic, strong) NSNumber *id;
@property (nonatomic, strong) NSString *image_url;
@property (nonatomic, strong) NSNumber *order;
@property (nonatomic, strong) NSNumber *status;
@property (nonatomic, strong) TargetModel *target;
@property (nonatomic, strong) NSNumber *target_id;
@property (nonatomic, strong) NSString *target_url;
@property (nonatomic, strong) NSString *type;

@end


