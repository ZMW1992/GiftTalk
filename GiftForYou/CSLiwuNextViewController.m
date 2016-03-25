//
//  CSLiwuNextViewController.m
//  GiftForYou
//
//  Created by zhumingwen on 16/3/10.
//  Copyright © 2016年 zhumingwen. All rights reserved.
//

#import "CSLiwuNextViewController.h"
#import "RemenCell.h"
#import "RemenModel.h"
#import "BaseNetWorkManager.h"
#import "ShangPinDetailViewController.h"
#define UrlStr @"http://api.liwushuo.com/v1/item_subcategories/%@/items?limit=20&offset=%ld"
@interface CSLiwuNextViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataSourceArr;
@end

static NSInteger offset = 0;
static NSString * const reuseIdentifier = @"Cell";

@implementation CSLiwuNextViewController

//开辟数据源空间
- (NSMutableArray *)dataSourceArr {
    if (_dataSourceArr == nil) {
        self.dataSourceArr = [NSMutableArray array];
    }
    return _dataSourceArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = self.titleName;
   // MLLog(@"----%@", self.ID);
    [self configureCollection];
    
}


- (void)configureCollection {
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake((kWindowW - 15) / 2.0, (kWindowW - 15) / 2.0 *1.2);
    flowLayout.minimumInteritemSpacing = 5;
    flowLayout.minimumLineSpacing = 5;
    flowLayout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:flowLayout];
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    self.view = _collectionView;
    
    // 注册cell
    [self.collectionView registerNib:[UINib nibWithNibName:@"RemenCell" bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];
    
    //数据请求
 //   [self dataRequestWithUrlStr:[NSString stringWithFormat:UrlStr, self.ID, offset]];
    
    //添加刷新
    [self addMJRefresh];
    [self.collectionView.mj_header beginRefreshing];
}


//下拉刷新,上拉加载
- (void)addMJRefresh {
    
    __weak CSLiwuNextViewController *weakSelf = self;
    //下拉刷新
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        offset = 0;
        [weakSelf dataRequestWithUrlStr:[NSString stringWithFormat:UrlStr, self.ID, offset]];
        
    }];
    
    //上拉加载
    self.collectionView.mj_footer = [MJRefreshBackStateFooter footerWithRefreshingBlock:^{
        offset += 20;
        [weakSelf dataRequestWithUrlStr:[NSString stringWithFormat:UrlStr, self.ID, offset]];
    }];
    
}


//数据请求
- (void)dataRequestWithUrlStr:(NSString *)urlStr {
    
    [BaseNetWorkManager GET:urlStr parameters:nil success:^(id data) {
        if (offset == 0) {
            [self.dataSourceArr removeAllObjects];
        }
        
        for (NSDictionary *dic in data[@"data"][@"items"]) {
            RemenModel *model = [RemenModel new];
            //让字典里边的数据赋值给model
            [model setValuesForKeysWithDictionary:dic];
            [self.dataSourceArr addObject:model];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            //刷新界面
            [self.collectionView reloadData];
        });
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView.mj_footer endRefreshing];
      
    } fail:^(NSError *error) {
        
    }];
}






//分区数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
//item个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSourceArr.count;
}


//cell配置
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    RemenCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.remenModel = self.dataSourceArr[indexPath.row];
   
    return cell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    MLLog(@"%ld - %ld", indexPath.section, indexPath.row);
    
    RemenModel *model = self.dataSourceArr[indexPath.row];
    ShangPinDetailViewController *detailVC = [ShangPinDetailViewController new];
    //detailVC.urlID = model.idd;
    detailVC.remenModel = model;
    detailVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detailVC animated:YES];
}




















- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}




































/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
