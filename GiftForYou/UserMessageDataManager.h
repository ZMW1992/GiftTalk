//
//  UserMessageDataManager.h
//  GiftForYou
//
//  Created by zhumingwen on 16/3/14.
//  Copyright © 2016年 zhumingwen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FMDB.h>
@interface UserMessageDataManager : NSObject

+ (FMDatabaseQueue *)shareData;

@end
