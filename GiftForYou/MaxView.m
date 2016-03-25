//
//  MaxView.m
//  GiftForYou
//
//  Created by zhumingwen on 16/3/7.
//  Copyright © 2016年 zhumingwen. All rights reserved.
//

#import "MaxView.h"

@implementation MaxView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubviews];
    }
    return self;
}

- (void)addSubviews
{
    self.backgroundColor = [UIColor whiteColor];
    
    self.leftTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 80, kWindowH) style:UITableViewStylePlain];
    self.leftTableView.backgroundColor = [UIColor whiteColor];
    self.leftTableView.showsVerticalScrollIndicator = NO;
    self.leftTableView.sectionFooterHeight = 1;
    self.leftTableView.sectionHeaderHeight = 1;
    self.leftTableView.contentInset = UIEdgeInsetsMake(0, 0, 114, 0);
    self.leftTableView.showsVerticalScrollIndicator = NO;
    [self addSubview:self.leftTableView];
    
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
   // layout.itemSize = CGSizeMake(kWindowW*0.160, kWindowW*0.267);
    layout.itemSize = CGSizeMake((kWindowW - 80 - 2*3)/3, (kWindowW - 80 - 2*3)/3*1.4);
    //layout.itemSize = CGSizeMake(60, 85);
   // layout.minimumInteritemSpacing = kWindowW*0.027;
    layout.minimumInteritemSpacing = 1;
     layout.minimumLineSpacing = 1;
    layout.sectionInset = UIEdgeInsetsMake(2, 2, 20, 0);
    
    self.rightCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(80, 0, kWindowW -  80,  kWindowH) collectionViewLayout:layout];
    
    self.rightCollectionView.backgroundColor = [UIColor whiteColor];
    

    self.rightCollectionView.contentInset = UIEdgeInsetsMake(0, 0, 114, 0);
    
   
    [self addSubview:self.rightCollectionView];
    
}



@end
