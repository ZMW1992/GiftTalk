//
//  ShouyeCell.m
//  GiftForYou
//
//  Created by lanouhn on 16/3/3.
//  Copyright © 2016年 zhumingwen. All rights reserved.
//

#import "ShouyeCell.h"
#import <UIImageView+WebCache.h>
#import "ShouyeModel.h"



@interface ShouyeCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imgView;

@property (weak, nonatomic) IBOutlet UILabel *TitleLabel;

@property (weak, nonatomic) IBOutlet UIButton *DZBtn;

@property (nonatomic, assign) BOOL isClicked;

- (IBAction)DZBtnClick:(UIButton *)sender;




@end

@implementation ShouyeCell

- (void)awakeFromNib {
    
    self.imgView.layer.cornerRadius = 7;
    self.imgView.layer.masksToBounds = YES;
   
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    if (_isClicked) {
        [_DZBtn setImage:[UIImage imageNamed:@"iconfont-xin_active"] forState:(UIControlStateNormal)];
       // _isClicked = NO;
    }
    else {
        
        [_DZBtn setImage:[UIImage imageNamed:@"iconfont-xin"] forState:(UIControlStateNormal)];
       // _isClicked = !_isClicked;
    }
    //[_DZBtn setImage:[UIImage imageNamed:@"iconfont-xin"] forState:(UIControlStateNormal)];
    _DZBtn.alpha = 0.5;
    [_DZBtn setBackgroundColor:[UIColor lightGrayColor]];
    self.DZBtn.imageEdgeInsets = UIEdgeInsetsMake(2, 2, 20, 2);
    // self.DZBtn.titleLabel.bounds.size.height
    [_DZBtn setTitle:@"222" forState:(UIControlStateNormal)];
    _DZBtn.titleLabel.font = [UIFont systemFontOfSize:8];//title字体大小
    _DZBtn.titleLabel.textAlignment = NSTextAlignmentCenter;//设置title的字体居中
    [_DZBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];//设置title在一般情况下为白色字体
    _DZBtn.titleEdgeInsets = UIEdgeInsetsMake(30, -25, 1, 1);
   // _DZBtn setContentEdgeInsets:UIEdgeInsetsMake(<#CGFloat top#>, <#CGFloat left#>, <#CGFloat bottom#>, <#CGFloat right#>)
    _DZBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;//button内容竖向居中
    //[_DZBtn addTarget:self action:@selector(<#selector#>) forControlEvents:<#(UIControlEvents)#>]
    
}

- (IBAction)DZBtnClick:(UIButton *)sender {
//    if (_isClicked) {
//        [_DZBtn setImage:[UIImage imageNamed:@"iconfont-xin"] forState:(UIControlStateNormal)];
//        // _isClicked = NO;
//    }else {
//        
//        [_DZBtn setImage:[UIImage imageNamed:@"iconfont-xin_active"] forState:(UIControlStateNormal)];
//        _isClicked = !_isClicked;
//    }
    
    _isClicked = !_isClicked;
    
    if ([_delegate respondsToSelector:@selector(dianZan:)]) {
        sender.tag = self.tag;
        [_delegate dianZan:sender];
    }
   
}



- (void)setShouyeModel:(ShouyeModel *)shouyeModel {
    _shouyeModel = shouyeModel;
    
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:shouyeModel.cover_image_url] placeholderImage:[UIImage imageNamed:@""]];
    
    self.TitleLabel.text = shouyeModel.title;
    
    NSString *str = [NSString stringWithFormat:@"%@", shouyeModel.likes_count];
    //[self.DZBtn setTitle:str forState:(UIControlStateNormal)];
    self.DZBtn.titleLabel.text = str;
   // MLLog(@"%@", str);
   
}







- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end
