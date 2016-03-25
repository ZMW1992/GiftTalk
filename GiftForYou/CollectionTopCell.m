//
//  CollectionTopCell.m
//  GiftForYou
//
//  Created by zhumingwen on 16/3/6.
//  Copyright © 2016年 zhumingwen. All rights reserved.
//

#import "CollectionTopCell.h"
#import "CollectionModel.h"
#import <UIImageView+WebCache.h>

@interface CollectionTopCell ()

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation CollectionTopCell


- (void)setTopModelArr:(NSArray *)topModelArr {
    _topModelArr = topModelArr;
    CGFloat imageW = kWindowW / 2 - 15;
    NSInteger imgCount = topModelArr.count;
    for (int i = 0; i< imgCount; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(15 + i * (imageW + 20), 0, imageW, kWindowW / 4)];
        
        [imageView sd_setImageWithURL:[NSURL URLWithString:[topModelArr[i] banner_image_url]] placeholderImage:MLImage(@"ig_holder_image")];
        imageView.layer.cornerRadius = 10;
        imageView.clipsToBounds = YES;
        imageView.tag = 200 + i;
        imageView.userInteractionEnabled = YES;
        imageView.backgroundColor = [UIColor cyanColor];
        
        // 添加手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewClicked:)];
        [imageView addGestureRecognizer:tap];
        
        [self.scrollView addSubview:imageView];
    }
    
    _scrollView.contentSize = CGSizeMake(imgCount * (imageW + 20) + 10, kWindowW / 4);
    [self.contentView addSubview:_scrollView];
 
}


- (void)viewClicked:(UITapGestureRecognizer *)sender
{
    if ([_delegate conformsToProtocol:@protocol(CollectionTopCellDelegate)]) {
        if ([_delegate respondsToSelector:@selector(collectionTopCellViewClicked:title:)]) {
            
            // 传数据
          
            [_delegate collectionTopCellViewClicked:[_topModelArr[sender.view.tag - 200] ID] title:[_topModelArr[sender.view.tag - 200] titleName]];
            
        }
    }
    
}

// 点击查看全部按钮的点击事件
- (IBAction)AllBtnClick:(UIButton *)sender {
    if ([_delegate conformsToProtocol:@protocol(CollectionTopCellDelegate)]) {
        if ([_delegate respondsToSelector:@selector(collectionTopCellBtnClicked)]) {
            [_delegate collectionTopCellBtnClicked];
        }
    }
    
}



- (void)awakeFromNib {
    // Initialization code
}

@end
