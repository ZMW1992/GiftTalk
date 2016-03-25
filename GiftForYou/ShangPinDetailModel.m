//
//  ShangPinDetailModel.m
//  GiftForYou
//
//  Created by zhumingwen on 16/3/10.
//  Copyright © 2016年 zhumingwen. All rights reserved.
//

#import "ShangPinDetailModel.h"

@implementation ShangPinDetailModel

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"description": @"desc",
                                                       
                                                       }];
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

@end


@implementation SourceModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}


@end