//
//  SouSuoReCiCell.m
//  GiftForYou
//
//  Created by zhumingwen on 16/3/9.
//  Copyright © 2016年 zhumingwen. All rights reserved.
//

#import "SouSuoReCiCell.h"
#import "TextCell.h"
@interface SouSuoReCiCell ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong)UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *widthsM; // 存储每个item的宽度
@end


@implementation SouSuoReCiCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.widthsM = [NSMutableArray array];
       // [self configureCollectionView];
        
    }
    return self;
}





- (void)setDataSource:(NSArray *)dataSource {
    _dataSource = dataSource;
    for (int i = 0; i < self.dataSource.count; i++) {
        UILabel *aLabel = [[UILabel alloc]init];
        aLabel.text = self.dataSource[i];
        [aLabel sizeToFit]; // 算出宽度
        CGFloat w = aLabel.bounds.size.width + 20;
        NSString *key = [NSString stringWithFormat:@"%d", i];
        
        NSNumber *value = [NSNumber numberWithFloat:w];
        NSDictionary *dic = [NSDictionary dictionaryWithObject:value forKey:key];
        [self.widthsM addObject:dic];
        
    }
    
    [self configureCollectionView];
    
}




- (void)configureCollectionView {
    
    // 创建布局对象
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(10, 0, kWindowW-20, kWindowH-64) collectionViewLayout:flowLayout];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    
    
    [self.contentView addSubview:_collectionView];
    
    [self.collectionView registerClass:[TextCell class] forCellWithReuseIdentifier:@"text"];
    
}


// 返回item数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
        return self.dataSource.count;
  
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
   
        TextCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"text" forIndexPath:indexPath];
        
        cell.tagLabel.text = self.dataSource[indexPath.row];
        
        return cell;
 
}




#pragma mark - UICollectionViewDelegateFlowLayout 方法
// 动态返回item大小的方法
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
   
        NSString *s = [NSString stringWithFormat:@"%ld", (long)indexPath.row];
        
        NSDictionary *dic = self.widthsM[indexPath.row];
        NSNumber *W = dic[s];
        return CGSizeMake([W floatValue], 30);
    
}


// 动态设置分区缩进量
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
  
        return UIEdgeInsetsMake(10, 0, 10, 0);

    
    
}


// 动态设置最小行间距
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    
   
        return 10;
  
    
}

// 动态设置最小列间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
  
        return 10;
   
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
    
}






- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
