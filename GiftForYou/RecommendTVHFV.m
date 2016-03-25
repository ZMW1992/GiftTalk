//
//  RecommendTVHFV.m
//  GiftForYou
//
//  Created by zhumingwen on 16/3/8.
//  Copyright © 2016年 zhumingwen. All rights reserved.
//

#import "RecommendTVHFV.h"

@implementation RecommendTVHFV

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.dateLabel];
    }
    
    return self;
}


- (UILabel *)dateLabel {
    if (_dateLabel == nil) {
        self.dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
        _dateLabel.font = [UIFont systemFontOfSize:14];
    }
    return _dateLabel;
}

- (void)setHeaderTitle:(NSString *)headerTitle {
    
    _headerTitle = headerTitle;
    
    self.dateLabel.text = headerTitle;
    
}

@end
