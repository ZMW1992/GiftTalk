//
//  BaseNetWorkManager.h
//  GiftForYou
//
//  Created by zhumingwen on 16/3/2.
//  Copyright © 2016年 zhumingwen. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void(^SuccessBlock)(id data);
typedef void(^FailBlock)(NSError *error);
@interface BaseNetWorkManager : NSObject

// 封装网络请求
+ (void)GET:(NSString *)path parameters:(NSDictionary *)params
  success:(SuccessBlock)successblock fail:(FailBlock)failblock;


+ (void)POST:(NSString *)path parameters:(NSDictionary *)params
  success:(SuccessBlock)successblock fail:(FailBlock)failblock;

@end
