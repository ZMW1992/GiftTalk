//
//  GonglueDetailModel.m
//  GiftForYou
//
//  Created by zhumingwen on 16/3/9.
//  Copyright © 2016年 zhumingwen. All rights reserved.
//

#import "GonglueDetailModel.h"

@implementation GonglueDetailModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
    if ([key isEqualToString:@"id"]) {
        self.idd = value;
    }
}
@end
