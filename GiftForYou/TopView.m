//
//  TopView.m
//  GiftForYou
//
//  Created by zhumingwen on 16/3/6.
//  Copyright © 2016年 zhumingwen. All rights reserved.
//

#import "TopView.h"
#import "CollectionModel.h"
#import <UIImageView+WebCache.h>

@interface TopView ()
{
    NSArray  *_dataArr;
}

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end


@implementation TopView

// 类方法创建TopView
+ (instancetype)topViewWithFrame:(CGRect)frame dataArr:(NSArray *)dataArr {
    
//    TopView *topView = [[TopView alloc] initWithFrame:frame];
    TopView *topView = [[[NSBundle mainBundle] loadNibNamed:@"TopView" owner:nil options:nil] firstObject];
    topView.frame = frame;

    [topView addSubviews:dataArr];
    
    return topView;
}

- (void)addSubviews:(NSArray *)dataArr {
    
    _dataArr = dataArr;
    CGFloat imageW = kWindowW / 2 - 15;
    NSInteger imgCount = _dataArr.count;
    MLLog(@"----------------%ld", _dataArr.count);
    for (int i = 0; i< imgCount; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(15 + i * (imageW + 20), 5, imageW, 60)];
        imageView.backgroundColor = [UIColor whiteColor];
        
        [imageView sd_setImageWithURL:[NSURL URLWithString:[_dataArr[i] banner_image_url]] placeholderImage:MLImage(@"ig_holder_image")];
        
        imageView.layer.cornerRadius = 10;
        imageView.clipsToBounds = YES;
        imageView.tag = 200+i;
        imageView.userInteractionEnabled = YES;
        imageView.backgroundColor = [UIColor whiteColor];
        
        // 添加手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewClicked:)];
        [imageView addGestureRecognizer:tap];
        
        [self.scrollView addSubview:imageView];
    }
    
    _scrollView.contentSize = CGSizeMake(imgCount * (imageW + 20) + 10, 70);
    _scrollView.backgroundColor = [UIColor yellowColor];
    [self addSubview:_scrollView];
    
}


- (IBAction)AllBtnClick:(UIButton *)sender {
    if ([_delegate conformsToProtocol:@protocol(TopViewDelegate)]) {
        if ([_delegate respondsToSelector:@selector(topViewBtnClicked)]) {
            [_delegate topViewBtnClicked];
        }
    }
    
}

// 告诉代理, 哪个imgView被点了
- (void)viewClicked:(UITapGestureRecognizer *)sender
{
    if ([_delegate conformsToProtocol:@protocol(TopViewDelegate)]) {
        if ([_delegate respondsToSelector:@selector(topViewOfImageViewClicked:title:)]) {
            
         
            [_delegate topViewOfImageViewClicked:[_dataArr[sender.view.tag-200] ID] title:[_dataArr[sender.view.tag-200] titleName]];
            
        }
    }
    
}




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
