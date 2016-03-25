//
//  UserMessageDataManager.m
//  GiftForYou
//
//  Created by zhumingwen on 16/3/14.
//  Copyright © 2016年 zhumingwen. All rights reserved.
//

#import "UserMessageDataManager.h"

@implementation UserMessageDataManager

+ (FMDatabaseQueue *)shareData {
    // 1.获取数据库路径
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *path = [documentPath stringByAppendingString:@"/user.sqlite"];
    MLLog(@"path = %@", path);
    
    // 2.创建数据库
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:path];
    
    // 3.打开数据库并创建表格
    [queue inDatabase:^(FMDatabase *db) {
        BOOL result = [db executeUpdate:@"create table if not exists userInfo(username text, password text, email text, telephone text, imgView data);"];
        if (result) {
            MLLog(@"创表成功");
        } else {
            MLLog(@"创表失败");
        }
    }];
    
    return queue;
}







@end
