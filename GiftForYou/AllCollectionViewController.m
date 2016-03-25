//
//  AllCollectionViewController.m
//  GiftForYou
//
//  Created by zhumingwen on 16/3/7.
//  Copyright © 2016年 zhumingwen. All rights reserved.
//

#import "AllCollectionViewController.h"
#import "AllGLZhuantiCell.h"
#import "BaseNetWorkManager.h"
#import "CollectionModel.h"
#import <SVProgressHUD.h>
#import "CircleNextController.h"
@interface AllCollectionViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (assign, nonatomic) NSInteger pageNumber;
@end

@implementation AllCollectionViewController

- (NSMutableArray *)dataArr
{
    if (nil == _dataArr) {
        _dataArr = [NSMutableArray arrayWithCapacity: 1];
    }
    
    return _dataArr;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
    
    // 马上进入刷新状态
    [self.tableView.mj_header beginRefreshing];
}

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.title = @"全部专题";
  
    [self createTableView];
}

- (void)createTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kWindowW, kWindowH) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:_tableView];
    
   
    [_tableView registerClass:[AllGLZhuantiCell class] forCellReuseIdentifier:@"iden"];
    
    [self addRefresh];
}

- (void)addRefresh {
    
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.pageNumber = 0;
        [self loadDataWithPageNumber:@"0" isRemove:YES];
    }];
    
    _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        self.pageNumber += 20;
        [self loadDataWithPageNumber:[NSString stringWithFormat:@"%ld",_pageNumber] isRemove:NO];
    }];
    
}

- (void)loadDataWithPageNumber:(NSString *)page isRemove:(BOOL)isRemove {
    
    [BaseNetWorkManager GET:[NSString stringWithFormat:@"http://api.liwushuo.com/v1/collections?channel=104&limit=20&offset=%ld", self.pageNumber] parameters:nil success:^(id data) {
        
        if (data != nil) {
            
            if (self.pageNumber == 0) {
                [self.dataArr removeAllObjects];
            }
            NSArray *collections = data[@"data"][@"collections"];
            for (NSDictionary *dict in collections) {
                CollectionModel *model = [[CollectionModel alloc] init];
                [model setValuesForKeysWithDictionary:dict];
                model.ID = dict[@"id"];
                model.titleName = dict[@"title"];
                [_dataArr addObject:model];
            }
           
           
            [_tableView.mj_header endRefreshing];
            [_tableView.mj_footer endRefreshing];
            [self.tableView reloadData];
        }
      
    } fail:^(NSError *error) {
        MLLog(@"%@",error);
        [_tableView.mj_header endRefreshing];
        [_tableView.mj_footer endRefreshing];
        
        [SVProgressHUD showErrorWithStatus:@"加载失败..."];
    }];
    
}

#pragma mark UITableViewDataSource & UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AllGLZhuantiCell *cell = [tableView dequeueReusableCellWithIdentifier:@"iden" forIndexPath:indexPath];
    
    cell.model = _dataArr[indexPath.row];
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kWindowW*0.532;
    //return [AllGLZhuantiCell cellHeight];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CircleNextController *collectionVC = [[CircleNextController alloc] init];
    collectionVC.idd = [_dataArr[indexPath.row] ID];
    collectionVC.titleName = [_dataArr[indexPath.row] titleName];
   
    collectionVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:collectionVC animated:YES];
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
