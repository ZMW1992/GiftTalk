//
//  MineFirstCell.m
//  GiftForYou
//
//  Created by zhumingwen on 16/3/11.
//  Copyright © 2016年 zhumingwen. All rights reserved.
//

#import "MineFirstCell.h"

@implementation MineFirstCell


//- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
//    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
//        
//        [self addSubViews];
//    }
//    return self;
//}
//
//
//
//
//- (void)addSubViews {
//    
//    for (int i = 0; i < 4; i++) {
//        CGFloat imageW = 30;
//        CGFloat imageH = 30;
//        CGFloat paging = (kWindowW - 120)/5;
//        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(paging + i*(imageW+paging), 5, imageW, imageH)];
//        imgView.backgroundColor = [UIColor yellowColor];
//        imgView.image = [UIImage imageNamed:@""];
//        imgView.tag = i + 200;
//        imgView.userInteractionEnabled = YES;
//        // 添加手势
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewClicked:)];
//        [imgView addGestureRecognizer:tap];
//        
//    }
//}
//
//- (void)viewClicked:(UITapGestureRecognizer *)sender
//{
////    if ([_delegate conformsToProtocol:@protocol(CollectionCellDelegate)]) {
////        if ([_delegate respondsToSelector:@selector(collectionCellViewClicked:title:)]) {
////            
////            [_delegate collectionCellViewClicked:[_dataArr[sender.view.tag] ID] title:[_dataArr[sender.view.tag] titleName]];
////            
////        }
////    }
//    
//}


- (void)awakeFromNib {
    // Initialization code
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
