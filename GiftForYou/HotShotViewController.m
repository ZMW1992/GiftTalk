//
//  HotShotViewController.m
//  GiftForYou
//
//  Created by lanouhn on 16/3/2.
//  Copyright © 2016年 zhumingwen. All rights reserved.
//

#import "HotShotViewController.h"
#import "RemenCell.h"
#import "RemenModel.h"
#import "BaseNetWorkManager.h"
#import "ShangPinDetailViewController.h"

#define hotUrlStr @"http://api.liwushuo.com/v2/items?gender=1&generation=2&limit=20&offset=%ld"
@interface HotShotViewController () <UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) UICollectionView *collectionView;
@end

static NSInteger offset = 0;
@implementation HotShotViewController

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        self.dataSource = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataSource;
}


- (void)viewWillAppear:(BOOL)animated {
    //self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.translucent = NO;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"热门";
    
    [self configureCollectionView];
    
  
}

- (void)configureCollectionView {
    
    // 创建布局对象
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake((kWindowW - 2*3)/2, (kWindowW - 2*3)/2*1.18);
    flowLayout.sectionInset = UIEdgeInsetsMake(2, 2, 66, 2);
    flowLayout.minimumLineSpacing = 2;
    flowLayout.minimumInteritemSpacing = 1;
    
    // 创建collectionView对象
    self.collectionView = [[UICollectionView alloc] initWithFrame:[UIScreen mainScreen].bounds collectionViewLayout:flowLayout];
    
    _collectionView.backgroundColor = [UIColor whiteColor];
    // 设置数据源代理
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    
    // 添加到主视图
    [self.view addSubview:_collectionView];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"RemenCell" bundle:nil] forCellWithReuseIdentifier:@"remen"];
    
    
    //添加刷新
    [self addMJRefresh];
    [self.collectionView.mj_header beginRefreshing];
    
}


//下拉刷新,上拉加载
- (void)addMJRefresh {
    
    __weak HotShotViewController *weakSelf = self;
    //下拉刷新
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        offset = 0;
        [weakSelf dataRequestWithUrlStr:[NSString stringWithFormat:hotUrlStr, offset]];
        
    }];
    
    //上拉加载
    self.collectionView.mj_footer = [MJRefreshBackStateFooter footerWithRefreshingBlock:^{
        offset += 20;
        [weakSelf dataRequestWithUrlStr:[NSString stringWithFormat:hotUrlStr, offset]];
    }];
    
}

//数据请求
- (void)dataRequestWithUrlStr:(NSString *)urlStr {
    
    [BaseNetWorkManager GET:urlStr parameters:nil success:^(id data) {
        
        if (data != nil) {
            NSArray *arr = data[@"data"][@"items"];
            for (NSDictionary *miniDic in arr) {
                NSDictionary *dic2 = miniDic[@"data"];
                RemenModel *model = [[RemenModel alloc] init];
                //让字典里边的数据赋值给model
                [model setValuesForKeysWithDictionary:dic2];
                
                //把model扔到数组里边
                [self.dataSource addObject:model];
            }
            
            [self.collectionView reloadData];
            [self.collectionView.mj_header endRefreshing];
            [self.collectionView.mj_footer endRefreshing];
        }
        
    } fail:^(NSError *error) {
        
    }];
 
    
}




#pragma mark - 数据源代理方法

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    RemenCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"remen" forIndexPath:indexPath];
    
    
    cell.remenModel = self.dataSource[indexPath.row];
    
    
    return cell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    MLLog(@"%ld - %ld", indexPath.section, indexPath.row);
    
    RemenModel *model = self.dataSource[indexPath.row];
    ShangPinDetailViewController *detailVC = [ShangPinDetailViewController new];
    //detailVC.urlID = model.idd;
    detailVC.remenModel = model;
    detailVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detailVC animated:YES];
   
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
