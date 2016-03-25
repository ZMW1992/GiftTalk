//
//  BaseNetWorkManager.m
//  GiftForYou
//
//  Created by zhumingwen on 16/3/2.
//  Copyright © 2016年 zhumingwen. All rights reserved.
//

#import "BaseNetWorkManager.h"

static AFHTTPSessionManager *manager = nil;
@implementation BaseNetWorkManager


+ (AFHTTPSessionManager *)sharedAFManager{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [AFHTTPSessionManager manager];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/plain", @"application/json", @"text/json", @"text/javascript", nil];
    });
    return manager;
}


//+ (id)GET:(NSString *)path parameters:(NSDictionary *)params
//  success:(SuccessBlock)successblock fail:(FailBlock)failblock {
//    
//    return [[self sharedAFManager] GET:path parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
//        
//    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        
//        successblock(responseObject);
//        
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        failblock(error);
//    }];
//}


+ (void)GET:(NSString *)path parameters:(NSDictionary *)params
  success:(SuccessBlock)successblock fail:(FailBlock)failblock {
    
    [[self sharedAFManager] GET:path parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        successblock(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failblock(error);
    }];

    
}



//+ (id)POST:(NSString *)path parameters:(NSDictionary *)params
//   success:(SuccessBlock)successblock fail:(FailBlock)failblock {
//    
//    return [[self sharedAFManager] POST:path parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
//        
//    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        
//        successblock(responseObject);
//        
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        
//        failblock(error);
//        
//    }];
//}

+ (void)POST:(NSString *)path parameters:(NSDictionary *)params
   success:(SuccessBlock)successblock fail:(FailBlock)failblock {
    
    [[self sharedAFManager] POST:path parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        successblock(responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        failblock(error);
    }];
    
}





@end
