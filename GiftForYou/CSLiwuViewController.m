//
//  CSLiwuViewController.m
//  GiftForYou
//
//  Created by zhumingwen on 16/3/3.
//  Copyright © 2016年 zhumingwen. All rights reserved.
//

#import "CSLiwuViewController.h"
#import "MaxView.h"
#import "FenleiCell.h"
#import "FLBigModel.h"
#import "FLSmallModel.h"
#import "LiwuHeaderView.h"
#import "BaseNetWorkManager.h"
#import "CSLiwuNextViewController.h"
@interface CSLiwuViewController () <UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic , strong) MaxView *maxView;
@property (nonatomic, strong) NSMutableArray *array;
@property (nonatomic, strong) NSMutableArray *bigArray;
@property (nonatomic, strong) NSMutableArray *smallArray;

@end

@implementation CSLiwuViewController
-(NSMutableArray *)array {
    if (!_array) {
        self.array = [NSMutableArray arrayWithCapacity:0];
    }
    return _array;
}

-(NSMutableArray *)bigArray {
    if (!_bigArray) {
        self.bigArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _bigArray;
}

-(NSMutableArray *)smallArray {
    if (!_smallArray) {
        self.smallArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _smallArray;
}

- (void)loadView
{
    [super loadView];
    self.maxView = [[MaxView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.view = self.maxView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpView];
    
    [self loadDataAndShowleft];
    
}

- (void)setUpView
{
  
    
    self.maxView.leftTableView.delegate = self;
    self.maxView.leftTableView.dataSource = self;
    self.maxView.rightCollectionView.delegate = self;
    self.maxView.rightCollectionView.dataSource = self;
    
    [self.maxView.leftTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"liwu"];
  
    [self.maxView.rightCollectionView registerNib:[UINib nibWithNibName:@"FenleiCell" bundle:nil] forCellWithReuseIdentifier:@"Fenlei"];
    [self.maxView.rightCollectionView registerClass:[LiwuHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"liwuHeader"];
    
}

- (void)loadDataAndShowleft {
    
    [BaseNetWorkManager GET:@"http://api.liwushuo.com/v2/item_categories/tree?" parameters:nil success:^(id data) {
        if (data != nil) {
            
            self.array = data[@"data"][@"categories"];
            
            for (NSDictionary *dic in self.array) {
                FLBigModel *bigModel = [FLBigModel new];
                [bigModel setValuesForKeysWithDictionary:dic];
                bigModel.subcategoriesArray = dic[@"subcategories"];
                [self.bigArray addObject:bigModel];
                NSArray *subcategoriesArray = dic[@"subcategories"];
                for (NSDictionary *dict in subcategoriesArray) {
                    FLSmallModel *smallModel = [FLSmallModel new];
                    [smallModel setValuesForKeysWithDictionary:dict];
                    [self.smallArray addObject:smallModel];
                    
                }
                //                 bigModel.subcategoriesArray = [NSMutableArray arrayWithArray:_smallArray];
                //                [self.bigArray addObject:bigModel];
                
                // MLLog(@"****%@", self.bigArray);
            }
            
            [self.maxView.rightCollectionView reloadData];
            
            [self.maxView.leftTableView reloadData];
            
        }
        
    } fail:^(NSError *error) {
        
        MLLog(@"%@", error);
        
    }];
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.bigArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"liwu" forIndexPath:indexPath];
    
    FLBigModel *model = self.bigArray[indexPath.row];
    cell.textLabel.text = model.name;
    cell.textLabel.font = [UIFont systemFontOfSize:12.0];
   
    return cell;
}

//改变cell高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kWindowW*0.133;
}

//根据点击的cell找到对应的collectionViewcell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MLLog(@"点点了");
    NSIndexPath *inPath = [NSIndexPath indexPathForItem:0 inSection:indexPath.row];
    [self.maxView.rightCollectionView scrollToItemAtIndexPath:inPath atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:YES];
    
}



#pragma mark - 数据源代理方法

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return self.bigArray.count;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    //    MLLog(@"+++%ld", [[self.bigArr[section] subcategoriesArray] count]);
    //    return [[self.bigArr[section] subcategoriesArray] count];
    
    // +++++++++++++++++++++++++++++++++++++++
    //    FLBigModel *bigModel = self.bigArr[section];
    //    return bigModel.subcategoriesArray.count;
    
    //+++++++++++++++++++++++++++++++++++++++++++
    
    //    NSMutableArray *arr = [NSMutableArray array];
    //    for (int i = 0; i < self.bigArr.count; i++) {
    //        FLBigModel *bigModel = self.bigArr[i];
    //        // arr里装着每个分区的item数组
    //        [arr addObject:bigModel.subcategoriesArray];
    //
    //    }
    //
    //    return [arr[section] count];
    // +++++++++++++++++++++++++++++++
    
    NSMutableArray * array = [NSMutableArray array];
    for (int i = 0; i < self.bigArray.count; i++) {
        NSArray * ary = self.array[i][@"subcategories"];
        [array addObject:ary];
    }
    MLLog(@"=======%ld", [array[section] count]);
    return [array[section] count];
    //+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
   
}

//此方法为计算某个section前面item总数
- (NSInteger)sumValue:(NSIndexPath *)indexPath
{
    
    NSMutableArray * array = [NSMutableArray array];
    for (int i = 0; i < self.array.count; i++) {
        NSArray * ary = self.array[i][@"subcategories"];
        [array addObject:ary];
    }
    NSInteger sum = 0;
    for (int i = 0; i < indexPath.section; i++) {
        sum += [array[i] count];
    }
    return sum;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    FenleiCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Fenlei" forIndexPath:indexPath];
    
    //    FLBigModel *bigModel = self.bigArr[indexPath.section];
    //
    //    cell.smallModel = bigModel.subcategoriesArray[indexPath.row];
    
    //    cell.smallModel = [self.bigArr[indexPath.section] subcategoriesArray][indexPath.row];
    
    cell.smallModel = self.smallArray[indexPath.row + [self sumValue:indexPath]];
    
    return cell;
}

//返回分区的头
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    LiwuHeaderView *headerView = [LiwuHeaderView new];
    headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"liwuHeader" forIndexPath:indexPath];
    
    headerView.nameLabel.text = [NSString stringWithFormat:@"-------%@-------", self.array[indexPath.section][@"name"]];
    
    return headerView;
}



//定义分区头的大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    CGSize size = {kWindowW*0.638, kWindowW*0.106};
    return size;
    
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    MLLog(@"%ld -- %ld", indexPath.section, indexPath.row);
    
    CSLiwuNextViewController *nextVC = [CSLiwuNextViewController new];
    
    FLSmallModel *model = self.smallArray[indexPath.row + [self sumValue:indexPath]];
    
    
    nextVC.ID = model.ID;
    nextVC.titleName = model.name;
  
    nextVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:nextVC animated:YES];
   
}


//根据collectionViewcell的位置确定tableViewcell的位置
- (void)collectionView:(UICollectionView *)collectionView willDisplaySupplementaryView:(UICollectionReusableView *)view forElementKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath
{
    NSIndexPath *index = [NSIndexPath indexPathForItem:indexPath.section inSection:0];
    [self.maxView.leftTableView scrollToRowAtIndexPath:index atScrollPosition:UITableViewScrollPositionTop animated:YES];
    [self.maxView.leftTableView   selectRowAtIndexPath:index animated:YES scrollPosition:UITableViewScrollPositionMiddle];
    
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
