//
//  LiwuHeaderView.m
//  GiftForYou
//
//  Created by zhumingwen on 16/3/7.
//  Copyright © 2016年 zhumingwen. All rights reserved.
//

#import "LiwuHeaderView.h"

@implementation LiwuHeaderView

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
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        
    }
    return _nameLabel;
}










/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
