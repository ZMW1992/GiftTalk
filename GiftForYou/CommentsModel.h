//
//  CommentsModel.h
//  GiftTalk
//
//  Created by zhumingwen on 16/1/14.
//  Copyright © 2016年 Lee. All rights reserved.
//

#import <jastor/jastor.h>

@interface UserModel : Jastor

@property (nonatomic, strong) NSString *avatar_url;
@property (nonatomic, strong) NSString *can_mobile_login;
@property (nonatomic, strong) NSString *nickname;
@property (nonatomic, strong) NSNumber *id;

@end


@interface CommentsModel : Jastor

@property (nonatomic, strong) UserModel *user;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSNumber *created_at;
@property (nonatomic, strong) NSNumber *id;
@property (nonatomic, strong) NSNumber *item_id;
@property (nonatomic, strong) NSNumber *status;




@end
