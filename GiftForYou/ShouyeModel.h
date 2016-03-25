//
//  ShouyeModel.h
//  GiftForYou
//
//  Created by zhumingwen on 16/3/5.
//  Copyright © 2016年 zhumingwen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShouyeModel : NSObject

@property (nonatomic, strong) NSString *content_url;
@property (nonatomic, strong) NSString *cover_image_url;
@property (nonatomic, strong) NSNumber *created_at;
@property (nonatomic, strong) NSNumber *idd;
@property (nonatomic, strong) NSNumber *published_at;
@property (nonatomic, strong) NSNumber *likes_count;
@property (nonatomic, strong) NSString *share_msg;
@property (nonatomic, strong) NSString *short_title;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSNumber *updated_at;
@property (nonatomic, strong) NSString *url;



@end
