//
//  ShangPinDetailModel.h
//  GiftForYou
//
//  Created by zhumingwen on 16/3/10.
//  Copyright © 2016年 zhumingwen. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface SourceModel : JSONModel

@property (nonatomic, strong) NSString *button_title;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *page_title;
@property (nonatomic, strong) NSString *type;



@end


@interface ShangPinDetailModel : JSONModel

@property (nonatomic, strong) SourceModel *source;
@property (nonatomic, strong) NSArray *image_urls;
@property (nonatomic, strong) NSNumber *category_id;
@property (nonatomic, strong) NSNumber *comments_count;
@property (nonatomic, strong) NSNumber *created_at;
@property (nonatomic, strong) NSNumber *editor_id;
@property (nonatomic, strong) NSNumber *favorites_count;
@property (nonatomic, strong) NSNumber *id;
@property (nonatomic, strong) NSNumber *likes_count;
@property (nonatomic, strong) NSNumber *purchase_status;
@property (nonatomic, strong) NSNumber *purchase_type;
@property (nonatomic, strong) NSNumber *shares_count;
@property (nonatomic, strong) NSNumber *subcategory_id;
@property (nonatomic, strong) NSNumber *updated_at;
@property (nonatomic, strong) NSString *cover_image_url;

@property (nonatomic, strong) NSString *desc;

@property (nonatomic, strong) NSString *detail_html;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *price;
@property (nonatomic, strong) NSString *purchase_id;
//@property (nonatomic, strong) NSString *purchase_shop_id;
@property (nonatomic, strong) NSString *purchase_url;
@property (nonatomic, strong) NSString *url;



@end


