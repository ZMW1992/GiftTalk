//
//  CollectionHeaderView.m
//  GiftForYou
//
//  Created by zhumingwen on 16/3/6.
//  Copyright © 2016年 zhumingwen. All rights reserved.
//

#import "CollectionHeaderView.h"



@implementation CollectionHeaderView

//- (void)awakeFromNib {
//    
//    [self addSubview:self.nameLabel];
//}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.nameLabel];
    }
    return self;
}

- (UILabel *)nameLabel
{
    if (_nameLabel == nil) {
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(kWindowW*0.053, kWindowW*0.027, self.frame.size.width, kWindowW*0.106)];
        
    }
    return _nameLabel;
}

@end
