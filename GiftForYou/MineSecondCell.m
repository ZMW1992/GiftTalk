//
//  MineSecondCell.m
//  GiftForYou
//
//  Created by zhumingwen on 16/3/11.
//  Copyright © 2016年 zhumingwen. All rights reserved.
//

#import "MineSecondCell.h"
#import "RemenCell.h"
#import "ShouCangGonglueCell.h"
#import "DBManager.h"
#import "DBManager2.h"
#import "RemenModel.h"
#import "ShouyeModel.h"


@interface MineSecondCell () <UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource, UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSArray *gonglueArr;
@property (nonatomic, strong) NSArray *liwuArr;
@end


@implementation MineSecondCell

// 重写初始化方法
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        
        self.gonglueArr = [[DBManager2 shareManager] selectAllData];
        self.liwuArr = [[DBManager shareManager] selectAllData];
        
        [self.contentView addSubview:self.scrollView];
        [self.scrollView addSubview:self.collectionView];
        [self.scrollView addSubview:self.tableView];
        
        //添加观察者,改变scrollView偏移量
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mineVCchangeScrollViewOffset:) name:@"mineVCchangeScrollViewOffset" object:nil];
    }
    
    return self;
}


- (UIScrollView *)scrollView {
    if (_scrollView == nil) {
        self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kWindowW, kWindowH- 64 - 30)];
        _scrollView.delegate = self;
        _scrollView.contentSize = CGSizeMake(kWindowW * 2, 200);
        _scrollView.backgroundColor = [UIColor yellowColor];
        _scrollView.pagingEnabled = YES;
        _scrollView.bounces = NO;
    }
    return _scrollView;
}

- (UITableView *)tableView {
    if (_tableView == nil) {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(kWindowW, 0, kWindowW, kWindowH - 64 - 30) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerNib:[UINib nibWithNibName:@"ShouCangGonglueCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"ShouCangGonglueCell"];
        _tableView.scrollEnabled = NO;
        
//        _tableView.estimatedRowHeight = 44;
//        _tableView.rowHeight = UITableViewAutomaticDimension;
        
//        UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
//        [_tableView setTableFooterView:view];
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        
    }
    return _tableView;
}

- (UICollectionView *)collectionView {
    if (_collectionView == nil) {
    
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.itemSize = CGSizeMake((kWindowW - 15) / 2.0, (kWindowW - 15) / 2.0 *1.2);
        
        flowLayout.minimumInteritemSpacing = 5;
        flowLayout.minimumLineSpacing = 5;
        flowLayout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kWindowW, kWindowH - 64 - 30) collectionViewLayout:flowLayout];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        [self.collectionView registerNib:[UINib nibWithNibName:@"RemenCell" bundle:nil] forCellWithReuseIdentifier:@"RemenCell"];
    
    }
    return _collectionView;
}



//观察者方法
- (void)mineVCchangeScrollViewOffset:(NSNotification *)notification {
    CGPoint offset = [notification.userInfo[@"offset"] CGPointValue];
    [self.scrollView setContentOffset:offset animated:YES];
}

//scrollView代理方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.scrollView) {
        CGFloat offset = scrollView.contentOffset.x;
        //注册通知中心并发送通知,改变指示条偏移量, 当手动滑动切换页面时让指示条随着动
        [[NSNotificationCenter defaultCenter] postNotificationName:@"mineVCchangeIndicateViewOffset" object:self userInfo:@{@"offset":[NSString stringWithFormat:@"%f", offset]}];
    }
}

//- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
//    scrollView = self.scrollView;
//    [self scrollViewDidEndDecelerating:scrollView];
//}

// 在此方法中决定scrollview的高度
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    if (scrollView == self.scrollView) {
        NSInteger index = scrollView.contentOffset.x / kWindowW;
        
        if (0 == index) {
            if (self.collectionView.contentSize.height < kWindowH - 64 -44) {
                self.scrollView.frame = CGRectMake(0, 0, kWindowW, kWindowH - 66 -44);
                if (self.secondCellHightBolck) {
                    self.secondCellHightBolck(kWindowH - 66 -44);
                }
            } else {
                self.scrollView.frame = CGRectMake(0, 0, kWindowW, self.collectionView.contentSize.height);
                self.collectionView.frame = CGRectMake(0, 0, kWindowW, self.collectionView.contentSize.height);
                if (self.secondCellHightBolck) {
                    self.secondCellHightBolck(self.collectionView.contentSize.height);
                }
            }
           
        } else {
            if (self.tableView.contentSize.height < kWindowH - 64 -44) {
                self.scrollView.frame = CGRectMake(0, 0, kWindowW, kWindowH - 64 - 44);
                self.tableView.frame = CGRectMake(0, 0, kWindowW, kWindowH - 64 - 44);
                if (self.secondCellHightBolck) {
                    self.secondCellHightBolck(kWindowH - 64 - 44);
                }
            } else {
                self.scrollView.frame = CGRectMake(0, 0, kWindowW, self.tableView.contentSize.height);
                self.tableView.frame = CGRectMake(0, 0, kWindowW, self.tableView.contentSize.height);
                if (self.secondCellHightBolck) {
                    self.secondCellHightBolck(self.tableView.contentSize.height);
                }
            }
            
        }
       
    }
    
}




- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.liwuArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    RemenCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"RemenCell" forIndexPath:indexPath];
    
    RemenModel *model = self.liwuArr[indexPath.row];
    cell.remenModel = model;
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    MLLog(@"点了");
    RemenModel *model = self.liwuArr[indexPath.row];
    if ([_delegate conformsToProtocol:@protocol(MineSecondCellDelegate)]) {
        if ([_delegate respondsToSelector:@selector(collectionViewItemClick:)]) {
            [_delegate collectionViewItemClick:model];
        }
    }
   
    
}


//++++++++++++++++++++++++++++++++++++++


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.gonglueArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ShouCangGonglueCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ShouCangGonglueCell" forIndexPath:indexPath];
    
    cell.shouyeModel = self.gonglueArr[indexPath.row];
    
    return cell;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MLLog(@"点了");
    
    ShouyeModel *shouyeModel = self.gonglueArr[indexPath.row];
    if ([_delegate conformsToProtocol:@protocol(MineSecondCellDelegate)]) {
        if ([_delegate respondsToSelector:@selector(tableViewCellClick:)]) {
            [_delegate tableViewCellClick:shouyeModel];
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
