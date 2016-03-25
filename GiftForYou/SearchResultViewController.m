//
//  SearchResultViewController.m
//  GiftForYou
//
//  Created by zhumingwen on 16/3/12.
//  Copyright © 2016年 zhumingwen. All rights reserved.
//

#import "SearchResultViewController.h"
#import "BaseNetWorkManager.h"
#import "RemenCell.h"
#import "SelectionCell.h"
#import "ShouyeModel.h"
#import "RemenModel.h"
#import "ShouyeDetailViewController.h"
#import "ShangPinDetailViewController.h"

#define kViewCount 2
#define HotSearchWordUrlStr @"http://api.liwushuo.com/v2/search/hot_words"
#define SearchLiWuUrlStr @"http://api.liwushuo.com/v2/search/item?sort=&limit=20&offset=%ld&keyword=%@"
#define SearchGongLueUrlStr @"http://api.liwushuo.com/v2/search/post?sort=&limit=20&offset=%ld&keyword=%@"
@interface SearchResultViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UITableView *gonglueTableView;
@property (nonatomic, strong) UICollectionView *liwuCollectionView;
@property (nonatomic, strong) UISegmentedControl *segmentedControl;

@property (nonatomic, strong) NSMutableArray *searchedGongLueArr;
@property (nonatomic, strong) NSMutableArray *searchedLiWuArr;
@end

static NSInteger gongLueOffset = 0;
static NSInteger liWuOffset = 0;
@implementation SearchResultViewController

- (NSMutableArray *)searchedGongLueArr {
    if (!_searchedGongLueArr) {
        self.searchedGongLueArr = [NSMutableArray array];
    }
    return _searchedGongLueArr;
}

- (NSMutableArray *)searchedLiWuArr {
    if (!_searchedLiWuArr) {
        self.searchedLiWuArr = [NSMutableArray array];
    }
    return _searchedLiWuArr;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
    [self.liwuCollectionView.mj_header beginRefreshing];
    [self.gonglueTableView.mj_header beginRefreshing];
   // [self searchLiWuDataRequest:[NSString stringWithFormat:SearchLiWuUrlStr, liWuOffset, self.searchKeyWord]];
   // [self searchGongLueDataRequest:[NSString stringWithFormat:SearchGongLueUrlStr, gongLueOffset, self.searchKeyWord]];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 35, 35);
    [button setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(backLastViewController:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = barButtonItem;
    
    self.navigationController.navigationBar.barTintColor = kRGBColor(239, 48, 50);
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[NSForegroundColorAttributeName] = kRGBColor(244, 244, 244);
    dic[NSFontAttributeName] = [UIFont boldSystemFontOfSize:20];
    self.navigationController.navigationBar.titleTextAttributes = dic;
    self.navigationController.navigationBar.translucent = NO;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self configureScrollView];
    [self configureSegmentControl];
    [self.scrollView addSubview:self.liwuCollectionView];
    [self.scrollView addSubview:self.gonglueTableView];
    
    [self addGongLueRefresh];
    [self addLiWuRefresh];
}

- (void)backLastViewController:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


//下拉刷新,上拉加载
- (void)addGongLueRefresh {
    
    __weak SearchResultViewController *weakSelf = self;
    //下拉刷新
    self.gonglueTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        gongLueOffset = 0;
        
        
        [weakSelf searchGongLueDataRequest:[[NSString stringWithFormat:SearchGongLueUrlStr, gongLueOffset, self.searchKeyWord] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        
     
    }];
    
    //上拉加载
    self.gonglueTableView.mj_footer = [MJRefreshBackStateFooter footerWithRefreshingBlock:^{
        gongLueOffset += 20;
        [weakSelf searchGongLueDataRequest:[[NSString stringWithFormat:SearchGongLueUrlStr, gongLueOffset, self.searchKeyWord] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    }];
    
}

//下拉刷新,上拉加载
- (void)addLiWuRefresh {
    
    __weak SearchResultViewController *weakSelf = self;
    //下拉刷新
    self.liwuCollectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        liWuOffset = 0;
        [weakSelf searchLiWuDataRequest:[[NSString stringWithFormat:SearchLiWuUrlStr, liWuOffset, self.searchKeyWord] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        
    }];
    //上拉加载
    self.liwuCollectionView.mj_footer = [MJRefreshBackStateFooter footerWithRefreshingBlock:^{
        liWuOffset += 20;
        [weakSelf searchLiWuDataRequest:[[NSString stringWithFormat:SearchLiWuUrlStr, liWuOffset, self.searchKeyWord] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    }];
    
}

//搜索攻略数据请求
- (void)searchGongLueDataRequest:(NSString *)urlStr {
    [BaseNetWorkManager GET:urlStr parameters:nil success:^(id data) {
        if (gongLueOffset == 0) {
            [self.searchedGongLueArr removeAllObjects];
        }
        for (NSDictionary *dic in data[@"data"][@"posts"]) {
            ShouyeModel *model = [[ShouyeModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            [self.searchedGongLueArr addObject:model];
        }
        
        [self.gonglueTableView reloadData];
        [self.gonglueTableView .mj_header endRefreshing];
        [self.gonglueTableView .mj_footer endRefreshing];
        
        
    } fail:^(NSError *error) {
        
    }];
    
}

//搜索礼物数据请求
- (void)searchLiWuDataRequest:(NSString *)urlStr {
    
    [BaseNetWorkManager GET:urlStr parameters:nil success:^(id data) {
        if (liWuOffset == 0) {
            [self.searchedLiWuArr removeAllObjects];
        }
        for (NSDictionary *dic in data[@"data"][@"items"]) {
            RemenModel *model = [RemenModel new];
            [model setValuesForKeysWithDictionary:dic];
            [self.searchedLiWuArr addObject:model];
        }
        
        [self.liwuCollectionView reloadData];
        [self.liwuCollectionView.mj_header endRefreshing];
        [self.liwuCollectionView.mj_footer endRefreshing];
        
    } fail:^(NSError *error) {
        
    }];
   
}



//配置scrollView
- (void)configureScrollView {
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 30, kWindowW, kWindowH-30)];
    self.scrollView.contentSize = CGSizeMake(kViewCount * kWindowW, _scrollView.height);
   // self.scrollView.contentInset = UIEdgeInsetsMake(0, 0, 100, 0);
    self.scrollView.backgroundColor = [UIColor whiteColor];
    self.liwuCollectionView.frame = CGRectMake(0 * kWindowW, 0, kWindowW, kWindowH-30);
    self.gonglueTableView.frame = CGRectMake(1 * kWindowW, 0, kWindowW, kWindowH-30);
    
    self.scrollView.pagingEnabled = YES;
    
    self.scrollView.delegate = self;
    
    [self.view addSubview:self.scrollView];
    
    [self.scrollView addSubview:_liwuCollectionView];
    
    [self.scrollView addSubview:_gonglueTableView];
    
}

- (void)configureSegmentControl {
  
    self.segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"礼物", @"攻略"]];
    _segmentedControl.frame = CGRectMake(0, 0, kWindowW, 30);
    _segmentedControl.tintColor = [UIColor orangeColor];
    _segmentedControl.backgroundColor = [UIColor whiteColor];
    
    
    [self.segmentedControl addTarget:self action:@selector(handleControlAction:) forControlEvents:(UIControlEventValueChanged)];
    self.segmentedControl.selectedSegmentIndex = 0;
    [self.view addSubview:self.segmentedControl];
    
}


//segmentControl事件
- (void)handleControlAction:(UISegmentedControl *)sender{
    
    [self.scrollView setContentOffset:CGPointMake(self.scrollView.bounds.size.width*sender.selectedSegmentIndex, 0)];
}

//scrollView代理方法
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    self.segmentedControl.selectedSegmentIndex = scrollView.contentOffset.x/scrollView.frame.size.width;
    
}


- (UICollectionView *)liwuCollectionView {
    if (!_liwuCollectionView) {
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        self.liwuCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0 * kWindowW, 0, kWindowW, kWindowH - 30) collectionViewLayout:flowLayout];
        flowLayout.itemSize = CGSizeMake((kWindowW - 15) / 2.0, (kWindowW - 15) / 2.0 *1.2);
        flowLayout.minimumInteritemSpacing = 5;
        flowLayout.minimumLineSpacing = 5;
        flowLayout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _liwuCollectionView.dataSource = self;
        _liwuCollectionView.delegate = self;
       // _liwuCollectionView.scrollEnabled = NO;
        _liwuCollectionView.contentInset = UIEdgeInsetsMake(0, 0, 66, 0);
        
        _liwuCollectionView.backgroundColor = [UIColor whiteColor];
        [self.liwuCollectionView registerNib:[UINib nibWithNibName:@"RemenCell" bundle:nil] forCellWithReuseIdentifier:@"RemenCell"];
        
    }
    
    return _liwuCollectionView;
}


- (UITableView *)gonglueTableView {
    if (!_gonglueTableView) {
        
        self.gonglueTableView = [[UITableView alloc] initWithFrame:CGRectMake(0 * kWindowW, 0, kWindowW, kWindowH-30) style:(UITableViewStylePlain)];
        _gonglueTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.gonglueTableView.delegate = self;
        self.gonglueTableView.dataSource = self;
      //  _gonglueTableView.scrollEnabled = NO;
        _gonglueTableView.contentInset = UIEdgeInsetsMake(0, 0, 66, 0);
  
    }
    return _gonglueTableView;
}


//tableView代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return  self.searchedGongLueArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    SelectionCell *cell = [SelectionCell cellWithTableView:tableView];
    
    cell.model = self.searchedGongLueArr[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return [SelectionCell cellHeight];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ShouyeDetailViewController *vc = [ShouyeDetailViewController new];
    vc.idd = [[self.searchedGongLueArr[indexPath.row] idd] stringValue];
    vc.shouyeModel = self.searchedGongLueArr[indexPath.row];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    
    
}


// liwuCollectionView代理方法

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.searchedLiWuArr.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    RemenCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"RemenCell" forIndexPath:indexPath];
    cell.remenModel = self.searchedLiWuArr[indexPath.row];
    return cell;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ShangPinDetailViewController *vc = [ShangPinDetailViewController new];
    vc.remenModel = self.searchedLiWuArr[indexPath.row];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
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
