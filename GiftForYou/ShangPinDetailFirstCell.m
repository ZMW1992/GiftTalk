//
//  ShangPinDetailFirstCell.m
//  GiftForYou
//
//  Created by zhumingwen on 16/3/10.
//  Copyright © 2016年 zhumingwen. All rights reserved.
//

#import "ShangPinDetailFirstCell.h"
#import "ShangPinDetailModel.h"
#import <SDCycleScrollView.h>
//图片高度
#define PIC_HEIGHT kWindowW * 329 / 720.0
@interface ShangPinDetailFirstCell ()
@property (strong, nonatomic)  SDCycleScrollView *cycleScrollView;


@property (strong, nonatomic) UIView *topView;

@property (strong, nonatomic) UILabel *nameLabel;

@property (strong, nonatomic) UILabel *priceLabel;

@property (strong, nonatomic) UILabel *describeLabel;



@end


@implementation ShangPinDetailFirstCell

- (void)awakeFromNib {
   
//    self.cycleScrollView = [[SDCycleScrollView alloc] initWithFrame:self.topView.frame];
//    [self.topView addSubview:_cycleScrollView];
    
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
}

//cycleScrollView
- (SDCycleScrollView *)cycleScrollView {
    if (!_cycleScrollView) {
        self.cycleScrollView = [[SDCycleScrollView alloc] initWithFrame:CGRectMake(0, 0, kWindowW, PIC_HEIGHT * 1.2)];
    }
    return _cycleScrollView;
}
//nameLabel
- (UILabel *)nameLabel {
    if (!_nameLabel) {
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.cycleScrollView.frame), kWindowW - 20, 30)];
        _nameLabel.font = [UIFont boldSystemFontOfSize:16];
    }
    
    return _nameLabel;
}
//priceLabel
- (UILabel *)priceLabel {
    if (_priceLabel == nil) {
        self.priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.nameLabel.frame), kWindowW - 20, 25)];
        _priceLabel.textColor = [UIColor redColor];
    }
    return _priceLabel;
}
//descripeLabel
- (UILabel *)describeLabel {
    
    if (!_describeLabel) {
        self.describeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.priceLabel.frame), kWindowW - 20, 30)];
        _describeLabel.numberOfLines = 0;
        _describeLabel.font = [UIFont systemFontOfSize:14];
        _describeLabel.textColor = [UIColor darkGrayColor];
    }
    return _describeLabel;
}

//重写初始化方法
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.cycleScrollView];
        [self.contentView addSubview:self.nameLabel];
        [self.contentView addSubview:self.priceLabel];
        [self.contentView addSubview:self.describeLabel];
    }
    
    return self;
}





- (void)setTempModel:(ShangPinDetailModel *)tempModel {
    
    _tempModel = tempModel;
    self.cycleScrollView.imageURLStringsGroup = tempModel.image_urls;
    self.nameLabel.text = tempModel.name;
    self.priceLabel.text = [NSString stringWithFormat:@"¥%@", tempModel.price];
    self.describeLabel.text = tempModel.desc;
    
    CGRect rect = self.describeLabel.frame;
//    rect.size.height = [tempModel.desc boundingRectWithSize:CGSizeMake(self.describeLabel.frame.size.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size.height;
    rect.size.height = [self getHeightForCellByModel:tempModel] - CGRectGetMaxY(self.priceLabel.frame);
    
    self.describeLabel.frame = rect;
  
}


- (CGFloat)getHeightForCellByModel:(ShangPinDetailModel *)model {
    
  //  return CGRectGetMaxY(self.describeLabel.frame) + 5;
    CGRect rect = [model.desc boundingRectWithSize:CGSizeMake(self.describeLabel.frame.size.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil];
    
    return rect.size.height + CGRectGetMaxY(self.priceLabel.frame);
    
}


































- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
