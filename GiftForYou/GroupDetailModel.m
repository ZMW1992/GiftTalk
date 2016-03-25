//
//  GroupDetailModel.m
//  GiftForYou
//
//  Created by zhumingwen on 16/3/5.
//  Copyright © 2016年 zhumingwen. All rights reserved.
//

#import "GroupDetailModel.h"

@implementation GroupDetailModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key {

    if ([key isEqualToString:@"id"]) {
        self.ID = value;
    }
}
@end
