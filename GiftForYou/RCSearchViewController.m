//
//  RCSearchViewController.m
//  GiftForYou
//
//  Created by zhumingwen on 16/3/12.
//  Copyright © 2016年 zhumingwen. All rights reserved.
//

#import "RCSearchViewController.h"
#import "BaseNetWorkManager.h"
#import "TextCell.h"
#import "RECISearchSecondCell.h"
#import "RCHeaderView.h"
#import "RCFooterView.h"
#import "SearchResultViewController.h"


#define kViewCount 2
#define HotSearchWordUrlStr @"http://api.liwushuo.com/v2/search/hot_words"
#define SearchLiWuUrlStr @"http://api.liwushuo.com/v2/search/item?sort=&limit=20&offset=%ld&keyword=%@"
#define SearchGongLueUrlStr @"http://api.liwushuo.com/v2/search/post?sort=&limit=20&offset=%ld&keyword=%@"


@interface RCSearchViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UISearchBarDelegate>

@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *hotWordsArr;
@property (nonatomic, strong) NSString *searchKeyWord;
@property (nonatomic, strong) NSMutableArray *widthsM; // 存储每个item的宽度


- (IBAction)searchAction:(UIBarButtonItem *)sender;

@end


@implementation RCSearchViewController

//开辟数据源空间

- (NSMutableArray *)hotWordsArr {
    
    if (!_hotWordsArr) {
        self.hotWordsArr = [NSMutableArray array];
    }
    return _hotWordsArr;
}
- (NSMutableArray *)widthsM {
    
    if (!_widthsM) {
        self.widthsM = [NSMutableArray array];
    }
    return _widthsM;
}




- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, kWindowW-100, 30)];
    //_searchBar.showsCancelButton = YES;
    _searchBar.placeholder = @"搜索";
    _searchBar.delegate = self;
    self.navigationItem.titleView = _searchBar;
    
    [self hotWordsDataRequestWithUrlStr:HotSearchWordUrlStr];

}




//热门搜索数据请求
- (void)hotWordsDataRequestWithUrlStr:(NSString *)urlstr {
    [BaseNetWorkManager GET:urlstr parameters:nil success:^(id data) {
        
        self.hotWordsArr = [NSMutableArray arrayWithArray:data[@"data"][@"hot_words"]];
        
        for (int i = 0; i < self.hotWordsArr.count; i++) {
            UILabel *aLabel = [[UILabel alloc]init];
            aLabel.text = self.hotWordsArr[i];
            [aLabel sizeToFit]; // 算出宽度
            CGFloat w = aLabel.bounds.size.width + 20;
            NSString *key = [NSString stringWithFormat:@"%d", i];
            
            NSNumber *value = [NSNumber numberWithFloat:w];
            NSDictionary *dic = [NSDictionary dictionaryWithObject:value forKey:key];
            [self.widthsM addObject:dic];
        }
        
        [self creatCollectionView];
       
    } fail:^(NSError *error) {
        
    }];
}

 


- (void)creatCollectionView {
    
    // 创建布局对象
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kWindowW, kWindowH-44) collectionViewLayout:flowLayout];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.tag = 200;
    _collectionView.scrollEnabled = YES;
    [self.view addSubview:_collectionView];
    
    [self.collectionView registerClass:[TextCell class] forCellWithReuseIdentifier:@"text"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"RECISearchSecondCell" bundle:nil] forCellWithReuseIdentifier:@"RECISearchSecondCell"];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"RCHeaderView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"RCHeaderView"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"RCFooterView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"RCFooterView"];
    
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
   
    return 2;
}


// 返回item数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
   
        if (0 == section) {
            return self.hotWordsArr.count;
        }
        return 1;
  
  
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
   
        if (0 == indexPath.section) {
            TextCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"text" forIndexPath:indexPath];
            
            // cell.tagLabel.text = self.hotWordsArr[indexPath.row];
            cell.title = self.hotWordsArr[indexPath.row];
            return cell;
        }
        
        RECISearchSecondCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"RECISearchSecondCell" forIndexPath:indexPath];
        
        cell.backgroundColor = [UIColor colorWithRed:250/255.0 green:246/255.0 blue:232/255.0 alpha:1.0];// 米黄色
        return cell;
   
}




#pragma mark - UICollectionViewDelegateFlowLayout 方法
// 动态返回item大小的方法
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
   
        if (0 == indexPath.section) {
            NSString *s = [NSString stringWithFormat:@"%ld", (long)indexPath.row];
            
            NSDictionary *dic = self.widthsM[indexPath.row];
            NSNumber *W = dic[s];
            return CGSizeMake([W floatValue], 30);
        }
        
        return CGSizeMake(kWindowW, 40);
  
}


// 动态设置分区缩进量
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    if (0 == section) {
        return UIEdgeInsetsMake(0, 10, 5, 10);
    }
   
     return UIEdgeInsetsMake(0, 0, 0, 0);
}


// 动态设置最小行间距
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    
   
    
    return 10;
    
    
}

// 动态设置最小列间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
 
    return 10;
 
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
  
        
        if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
            if (0 == indexPath.section) {
                return [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"RCHeaderView" forIndexPath:indexPath];
            }
        }
        
        //
        //        if (0 == indexPath.section) {
        //            return [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"RCFooterView" forIndexPath:indexPath];
        //
        //    }
        
        
        return [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"RCFooterView" forIndexPath:indexPath];
 
    
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    
    if (0 == section) {
        return CGSizeMake(kWindowW, 40);
    }
  
    return CGSizeMake(kWindowW, 0);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
  
   
    return CGSizeMake(kWindowW, 15);
}

// 热词搜索点击事件
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    MLLog(@"%@--%@", indexPath, self.hotWordsArr[indexPath.row]);
    
    [self searchGiftWithKeyWord:self.hotWordsArr[indexPath.row]];
 
}



- (void)searchGiftWithKeyWord:(NSString *)keyWord {

    
    NSString *PercentKeyWord = [keyWord stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
    self.searchKeyWord = PercentKeyWord;
    
    SearchResultViewController *resultVC = [SearchResultViewController new];
    UINavigationController *resultNC = [[UINavigationController alloc] initWithRootViewController:resultVC];
    resultVC.searchKeyWord = self.searchKeyWord;
    
    [self presentViewController:resultNC animated:YES completion:^{
        
    }];
 
}

// 导航栏右侧取消按钮
- (IBAction)searchAction:(UIBarButtonItem *)sender {

   
    [self.searchBar resignFirstResponder];
}

#pragma mark -- UISearchBarDelegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
  
    self.searchKeyWord = searchText;
  
}

#pragma mark 点击搜索按钮的代理方法
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    if (0 == searchBar.text.length) return;
    [searchBar resignFirstResponder];
    
    self.searchKeyWord = searchBar.text;
    
    MLLog(@"搜索: %@", searchBar.text);
    
    SearchResultViewController *resultVC = [SearchResultViewController new];
    UINavigationController *resultNC = [[UINavigationController alloc] initWithRootViewController:resultVC];
    resultVC.searchKeyWord = self.searchKeyWord;

    
    [self presentViewController:resultNC animated:YES completion:^{

    }];
    
}







- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
   // [self.searchBar resignFirstResponder];
}


- (void)viewWillDisappear:(BOOL)animated {
    [self.searchBar resignFirstResponder];
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
