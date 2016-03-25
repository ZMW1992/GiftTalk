//
//  DBManager2.h
//  礼物说
//
//  Created by zhumingwen on 14/10/21.
//  Copyright (c) 2014年 zhumingwen. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ShouyeModel;
@interface DBManager2 : NSObject

// 单例模式
+ (instancetype)shareManager;

// 删除数据
- (BOOL)deleteDataWithSelectionID:(NSString *)selectionID;

// 插入数据
- (BOOL)insertDataWithSelectionModel:(ShouyeModel *)model;

// 根据giftID查询单条数据
- (BOOL)selectOneDataWithSelectionID:(NSString *)selectionID;

// 查询所有数据
- (NSArray *)selectAllData;
@end
