//
//  CollectionCell.m
//  GiftForYou
//
//  Created by zhumingwen on 16/3/5.
//  Copyright © 2016年 zhumingwen. All rights reserved.
//

#import "CollectionCell.h"
#import "CollectionModel.h"
#import <UIImageView+WebCache.h>
@interface CollectionCell ()

{
    NSArray  *_dataArr;
}


@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end


@implementation CollectionCell



+ (instancetype)cellWithTableView:(UITableView *)tableView modelArr:(NSArray *)modelArr
{
    static NSString *ID = @"cellid";
    CollectionCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[CollectionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        [cell addSubviews:modelArr];
    }
    return cell;
}

- (void)addSubviews:(NSArray *)modelArr {
    
    _dataArr = modelArr;
    CGFloat imageW = kWindowW / 2 - 15;
    NSInteger imgCount = modelArr.count;
    for (int i = 0; i< imgCount; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(15 + i * (imageW + 20), 0, imageW, kWindowW / 4)];
        
        [imageView sd_setImageWithURL:[NSURL URLWithString:[modelArr[i] banner_image_url]] placeholderImage:MLImage(@"ig_holder_image")];
        imageView.layer.cornerRadius = 10;
        imageView.clipsToBounds = YES;
        imageView.tag = i;
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



#pragma mark 全部专题按钮
- (IBAction)AllBtnClick:(UIButton *)sender {
    
    if ([_delegate conformsToProtocol:@protocol(CollectionCellDelegate)]) {
        if ([_delegate respondsToSelector:@selector(collectionCellBtnClicked)]) {
            [_delegate collectionCellBtnClicked];
        }
    }
    
}


- (void)viewClicked:(UITapGestureRecognizer *)sender
{
    if ([_delegate conformsToProtocol:@protocol(CollectionCellDelegate)]) {
        if ([_delegate respondsToSelector:@selector(collectionCellViewClicked:title:)]) {
            
            [_delegate collectionCellViewClicked:[_dataArr[sender.view.tag] ID] title:[_dataArr[sender.view.tag] titleName]];
            
        }
    }
   
}




















- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
