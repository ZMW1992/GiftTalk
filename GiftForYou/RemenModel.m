//
//  RemenModel.m
//  GiftForYou
//
//  Created by zhumingwen on 16/3/5.
//  Copyright © 2016年 zhumingwen. All rights reserved.
//

#import "RemenModel.h"

@implementation RemenModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"id"]) {
        self.idd = value;
    }
}


@end
