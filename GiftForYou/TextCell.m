//
//  TextCell.m
//  ScrollView包含左右视图滑动
//
//  Created by zhumingwen on 16/2/28.
//  Copyright © 2016年 zhumingwen. All rights reserved.
//

#import "TextCell.h"

@implementation TextCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor cyanColor];
        // 添加子控件
        [self.contentView addSubview:self.tagLabel];
    }
    return self;
}

- (UILabel *)tagLabel {
    if (!_tagLabel) {
        self.tagLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, self.bounds.size.width - 20, 30)];
        self.tagLabel.textAlignment = NSTextAlignmentCenter;
       // self.tagLabel = label;
        
    }
    return _tagLabel;
}

- (void)setTitle:(NSString *)title {
    _title = title;
    self.tagLabel.text = title;
}



@end
