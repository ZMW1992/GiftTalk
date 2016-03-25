//
//  CSGonglueViewController.m
//  GiftForYou
//
//  Created by zhumingwen on 16/3/3.
//  Copyright © 2016年 zhumingwen. All rights reserved.
//

#import "CSGonglueViewController.h"
#import "FenleiCell.h"
#import "TopView.h"
#import "CollectionModel.h"
#import "BaseNetWorkManager.h"
#import "GroupModel.h"
#import "GroupDetailModel.h"
#import "CollectionHeaderView.h"
#import "AllCollectionViewController.h"
#import "CircleNextController.h"
@interface CSGonglueViewController () <UICollectionViewDataSource, UICollectionViewDelegate, TopViewDelegate>

@property (nonatomic, retain) UICollectionView *collectionView;

@property (nonatomic, strong) NSMutableArray *specialDataArr;
@property (nonatomic, strong) NSMutableArray *array;
@property (nonatomic, strong) NSMutableArray *bigArray;
@property (nonatomic, strong) NSMutableArray *miniArray;


@end



@implementation CSGonglueViewController

- (NSMutableArray *)specialDataArr {
    
    if (!_specialDataArr) {
        self.specialDataArr = [NSMutableArray array];
    }
    return _specialDataArr;
}

- (NSMutableArray *)bigArray {
    
    if (!_bigArray) {
        self.bigArray = [NSMutableArray array];
    }
    return _bigArray;
}

- (NSMutableArray *)miniArray {
    
    if (!_miniArray) {
        self.miniArray = [NSMutableArray array];
    }
    return _miniArray;
}

- (NSMutableArray *)array {
    
    if (!_array) {
        self.array = [NSMutableArray array];
    }
    return _array;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
   
    [self creatCollectionView];
    
    [self initData];
    
}

#pragma mark 创建集合视图
- (void)creatCollectionView {
   
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(kWindowW*0.189, kWindowW*0.266);
    layout.minimumInteritemSpacing = kWindowW*0.0156;
    layout.sectionInset = UIEdgeInsetsMake(5, 0, 0, 0);
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kWindowW, kWindowH) collectionViewLayout:layout];
    
   // self.collectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    
    // 注册cell
    
 
    [self.collectionView registerNib:[UINib nibWithNibName:@"FenleiCell" bundle:nil] forCellWithReuseIdentifier:@"Fenlei"];
//    [self.collectionView registerNib:[UINib nibWithNibName:@"CollectionHeaderView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"collectionHeader"];

    // 注册区头
    [self.collectionView registerClass:[CollectionHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"collectionHeader"];
    
    [self.view addSubview:self.collectionView];
    
}


#pragma mark 初始化数据
- (void)initData {
    
    dispatch_queue_t _mainQueue = dispatch_get_main_queue();
    dispatch_async(_mainQueue, ^{
        [self loadDataWithLimitNumber:@"6" offset:@"0"];
    });
    dispatch_async(_mainQueue, ^{
        [self loadData];
    });
    
}

#pragma mark 加载专题数据
- (void)loadDataWithLimitNumber:(NSString *)lNumber offset:(NSString *)oNumber {
    
    NSString *url = [NSString stringWithFormat:@"http://api.liwushuo.com/v1/collections?channel=104&limit=%@&offset=%@",lNumber,oNumber];
    [BaseNetWorkManager GET:url parameters:nil success:^(id data) {
        
        if (data != nil) {
            MLLog(@"%@", data);
            NSArray *collections = data[@"data"][@"collections"];
            for (NSDictionary *dict in collections) {
                CollectionModel *model = [[CollectionModel alloc] init];
                [model setValuesForKeysWithDictionary:dict];
                model.ID = dict[@"id"];
                model.titleName = dict[@"title"];
                [self.specialDataArr addObject:model]; // 此处一定要用self.specialDataArr, 否则加不进去
               // MLLog(@"===%ld", _specialDataArr.count);
            }
            [self creatTopView];
        }
        
    } fail:^(NSError *error) {
         MLLog(@"%@",error);
    }];
    
}

// 创建顶部视图
- (void)creatTopView {
    
    TopView *view = [TopView topViewWithFrame:CGRectMake(2, -kWindowW*0.3125, kWindowW-2*2, kWindowW*0.3125) dataArr:self.specialDataArr];
    view.delegate = self;
    view.backgroundColor = [UIColor cyanColor];
    self.collectionView.contentInset = UIEdgeInsetsMake(kWindowW*0.3125, 0, 0, 0);
    [self.collectionView addSubview:view];
   
}

#pragma mark 加载group数据
- (void)loadData {
    
    [BaseNetWorkManager GET:@"http://api.liwushuo.com/v1/channel_groups/all" parameters:nil success:^(id data) {
        
        if (data != nil) {

            self.array = data[@"data"][@"channel_groups"];
            
            for (NSDictionary *dic in self.array) {
                GroupModel *bigModel = [GroupModel new];
                [bigModel setValuesForKeysWithDictionary:dic];
                
                [self.bigArray addObject:bigModel];
                NSArray *arr = dic[@"channels"];
                for (NSDictionary *dict in arr) {
                    GroupDetailModel *smallModel = [GroupDetailModel new];
                    [smallModel setValuesForKeysWithDictionary:dict];
                    [self.miniArray addObject:smallModel];
                }
               
            }
           [self.collectionView reloadData];
        }
        
    } fail:^(NSError *error) {
        MLLog(@"%@", error);
    }];
  
}

#pragma mark - UICollectionViewDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
   
        return self.array.count;
}



- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
 
     NSMutableArray * array = [NSMutableArray array];
    for (int i = 0; i < self.array.count; i++) {
        NSArray *arr = self.array[i][@"channels"];
        [array addObject:arr];
    }
    return [array[section] count];
}


//此方法为计算某个section前面item总数
- (NSInteger)sumValue:(NSIndexPath *)indexPath
{
    
    NSMutableArray * array = [NSMutableArray array];
    
    for (int i = 0; i < self.array.count; i++) {
        NSArray * ary = self.array[i][@"channels"];
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
    
    cell.detailModel = self.miniArray[indexPath.row + [self sumValue:indexPath]];
   
    return cell;
}


#pragma mark - 集合视图分区偏移
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    if (3 == section) {
        return UIEdgeInsetsMake(0, 5, 114, 5);
    }
    return UIEdgeInsetsMake(0, 5, 0, 5);
    
}




#pragma mark - 返回分区的头
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    
    CollectionHeaderView *headerView = [CollectionHeaderView new];
    headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"collectionHeader" forIndexPath:indexPath];
    
    headerView.nameLabel.text = [self.bigArray[indexPath.section] name];
    
    return headerView;
    
}


//定义分区头的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    CGSize size = {kWindowW*0.638,kWindowW*0.106};
    return size;
    
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    MLLog(@"%ld- %ld",indexPath.section, indexPath.row);
    
    CircleNextController *nextVC = [CircleNextController new];
    GroupDetailModel *model = self.miniArray[indexPath.row + [self sumValue:indexPath]];
    
    nextVC.idd = model.ID;
    nextVC.titleName = model.name;
    
    nextVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:nextVC animated:YES];
}

#pragma mark - TopViewDelegate
- (void)topViewOfImageViewClicked:(NSString *)ID title:(NSString *)title {
    MLLog(@"被点了");
    CircleNextController *nextVC = [CircleNextController new];
    
    nextVC.idd = ID;
    nextVC.titleName = title;
    
    nextVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:nextVC animated:YES];
}
- (void)topViewBtnClicked {
    
    MLLog(@"查看全部");
    AllCollectionViewController *allVC = [[AllCollectionViewController alloc] init];
    allVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:allVC animated:YES];
    
    
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
