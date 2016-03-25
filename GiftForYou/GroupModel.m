//
//  GroupModel.m
//  GiftForYou
//
//  Created by zhumingwen on 16/3/5.
//  Copyright © 2016年 zhumingwen. All rights reserved.
//

#import "GroupModel.h"
#import "GroupDetailModel.h"
@implementation GroupModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {}

// 重写channels的getter方法.
//- (NSArray *)channels {
//    NSMutableArray *channelArr = [NSMutableArray arrayWithCapacity:0];
//    for (int i = 0; i < _channels.count; i ++) {
//        NSDictionary *dict = _channels[i];
//        GroupDetailModel *model = [[GroupDetailModel alloc] init];
//        [model setValuesForKeysWithDictionary:dict];
//        model.ID = dict[@"id"];
//        [channelArr addObject:model];
//    }
//    
//    return channelArr;
//}


@end
