//
//  FLSmallModel.m
//  GiftForYou
//
//  Created by zhumingwen on 16/3/7.
//  Copyright © 2016年 zhumingwen. All rights reserved.
//

#import "FLSmallModel.h"

@implementation FLSmallModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"id"]) {
        self.ID = value;
    }
}


@end
