//
//  HeaderViewController.m
//  GiftForYou
//
//  Created by zhumingwen on 16/3/2.
//  Copyright © 2016年 zhumingwen. All rights reserved.
//

#import "HeaderViewController.h"
#import "BaseNetWorkManager.h"
#import "ChannelModel.h"
#import "SecondaryBannersTVCell.h"
#import "RecommendTVCell.h"
#import "SelectionCell.h"
#import "RecommendTVHFV.h"
#import <SDCycleScrollView.h>
#import "BannerModel.h"
#import "CircleNextController.h"
#import "ShouyeDetailViewController.h"
#import "WebViewController.h"
#import "RCSearchViewController.h"
//频道
#define CHANNELURLSTR @"http://api.liwushuo.com/v2/channels/preset?gender=1&generation=1"
//轮播
#define BannerUrlStr @"http://api.liwushuo.com/v2/banners"
#define RecommendUrlStr @"http://api.liwushuo.com/v2/channels/100/items?ad=2&gender=1&generation=1&limit=20&offset=%ld"

//图片高度
#define PIC_HEIGHT kWindowW * 329 / 720.0

@interface HeaderViewController ()<UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate, SDCycleScrollViewDelegate>

// 解析数据前的动画
@property (nonatomic, strong)UIView *placeHodleView;
@property (nonatomic, strong)UIImageView *imageView;

@property (nonatomic, strong) NSArray *channelNameArr;
@property (nonatomic, strong) NSMutableArray *channelModelArr;//频道model数据源
@property (nonatomic, strong) UIScrollView *channelsScrollView;//频道滚动视图
@property (nonatomic, strong) UIView *indicateView;//频道指示条


@property (nonatomic, strong) NSMutableArray *bannerDataArr;//轮播数据源
@property (nonatomic, strong) UITableView *tableView;//表视图
@property (nonatomic, strong) SDCycleScrollView *cycleScrollView;//轮播视图
@property (nonatomic, strong) NSMutableDictionary *recommendDataDic;//推荐数据源字典
@property (nonatomic, strong) NSMutableArray *sortedKeyArr;

- (IBAction)searchAction:(UIBarButtonItem *)sender;


@end


//数据页数
static NSInteger offset = 0;
@implementation HeaderViewController

#pragma mark -- 开辟channelModelArr空间
- (NSMutableArray *)channelModelArr {
    if (_channelModelArr == nil) {
        self.channelModelArr = [NSMutableArray array];
    }
    return _channelModelArr;
}

#pragma mark -- 开辟数据源空间
- (NSMutableArray *)bannerDataArr {
    if (_bannerDataArr == nil) {
        self.bannerDataArr = [NSMutableArray array];
    }
    return _bannerDataArr;
}

- (NSMutableDictionary *)recommendDataDic {
    if (!_recommendDataDic) {
        self.recommendDataDic = [NSMutableDictionary dictionary];
    }
    return _recommendDataDic;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
  //  [self addPlaceHodleView];
    
    self.channelNameArr = @[@"精选", @"海淘", @"涨姿势", @"美食", @"创意生活", @"生日", @"礼物", @"结婚", @"纪念日", @"数码", @"爱运动", @"母婴", @"家居", @"情人节", @"爱读书", @"科技范", @"送爸妈", @"送基友"];
   
    //channel数据请求
    [self channelDataRequestWithUrlStr:CHANNELURLSTR];
    
    //添加channelsScrollView
    [self.view addSubview:self.channelsScrollView];
    
    //轮播数据请求
    [self dataRequestWithUrlStr:BannerUrlStr];
    
    //推荐数据请求
    
    [self recommendDataRequestWithUrlStr:[NSString stringWithFormat:RecommendUrlStr, offset]];
    //添加表视图
    [self.view addSubview:self.tableView];
    
    //添加刷新
    [self addMJRefresh];
    
    
    //注册通知中心并添加观察者,等待第二轮播点击时跳转界面
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(jumpController:) name:@"jumpController" object:nil];
  
}


- (void)addPlaceHodleView{
    self.placeHodleView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.placeHodleView.backgroundColor = [UIColor colorWithRed:140/255.0 green:139/255.0 blue:145/255.0 alpha:1];
    [self.view addSubview:self.placeHodleView];
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:38];
    for (int i = 1; i < 39; i++) {
        NSString *name = [NSString stringWithFormat:@"%02d.tiff",i];
        UIImage *image = [UIImage imageNamed:name];
        [arr addObject:image];
    }
    self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake(kWindowW/2-150, kWindowH/2-140, 300, 150)];
    self.imageView.animationImages = arr;
    self.imageView.animationDuration = 2;
    [self.placeHodleView addSubview:self.imageView];
    [self.imageView startAnimating];
    [NSTimer scheduledTimerWithTimeInterval:5.0f target:self selector:@selector(addButton) userInfo:nil repeats:NO];
}

- (void)addButton{
    [self.imageView stopAnimating];
    UIButton *button = [UIButton buttonWithType:(UIButtonTypeSystem)];
    [self.placeHodleView addSubview:button];
    button.frame = CGRectMake(kWindowW/2-150,kWindowH/2, 300, 50);
    [button setTitle:@"加载失败,点击重新加载..." forState:(UIControlStateNormal)];
    button.titleLabel.textColor = [UIColor whiteColor];
    [button addTarget:self action:@selector(recommendDataRequestWithUrlStr:) forControlEvents:(UIControlEventTouchUpInside)];
}




#pragma mark -- 观察者方法实现
- (void)jumpController:(NSNotification *)notification {
    NSDictionary *infoDic = notification.userInfo;
    if ([infoDic[@"type"] isEqualToString:@"url"]) {
        NSString *url = infoDic[@"url"];
        WebViewController *webVC = [WebViewController new];
        webVC.webUrl = url;
        webVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:webVC animated:YES];
    }else if ([infoDic[@"type"] isEqualToString:@"post"]) {
        NSString *postID = infoDic[@"post_id"];
        CircleNextController *postVC = [CircleNextController new];
        postVC.idd = postID;
        postVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:postVC animated:YES];
    }else if ([infoDic[@"type"] isEqualToString:@"topic"]) {
        NSString *topicID = infoDic[@"topic_id"];
        CircleNextController *moreVC = [CircleNextController new];
        moreVC.idd = topicID;
        moreVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:moreVC animated:YES];
    }
}



#pragma mark -- 轮播图数据请求
- (void)dataRequestWithUrlStr:(NSString *)urlStr {
   // [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [BaseNetWorkManager GET:urlStr parameters:nil success:^(id data) {
        [self modelDataByDic:data];
    } fail:^(NSError *error) {
        
    }];
}

//封装轮播图model
- (void)modelDataByDic:(NSDictionary *)data {
    NSArray *bannerArr = data[@"data"][@"banners"];
    for (NSDictionary *bannerDic in bannerArr) {
        BannerModel *bannerModel = [[BannerModel alloc] initWithDictionary:bannerDic];
        [self.bannerDataArr addObject:bannerModel];
    }
    
    self.tableView.tableHeaderView = self.cycleScrollView;
}

#pragma mark -- cycleScrollView
- (SDCycleScrollView *)cycleScrollView {
    if (!_cycleScrollView) {
        
        NSMutableArray *imageUrlStrArr = [NSMutableArray array];
        for (BannerModel *bannerModel in self.bannerDataArr) {
            [imageUrlStrArr addObject:bannerModel.image_url];
        }
        CGFloat height = kWindowW * 288 / 720.0;
        self.cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, kWindowW, height) imageURLStringsGroup:imageUrlStrArr];
        _cycleScrollView.delegate = self;
        
    }
    return _cycleScrollView;
}

//cycleScrollView选中代理方法
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    
    MLLog(@"%ld", index);;
    BannerModel *bannerModel = [self.bannerDataArr objectAtIndex:index];
    
    CircleNextController *vc = [CircleNextController new];
    vc.idd = [bannerModel.target_id stringValue];
    vc.navigationItem.title = bannerModel.target.title;
    [self.navigationController pushViewController:vc animated:YES];
    
}




// tableview下拉刷新,上拉加载
- (void)addMJRefresh {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    __weak HeaderViewController *weakSelf = self;
    //下拉刷新
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        offset = 0;
       
        [weakSelf recommendDataRequestWithUrlStr:[NSString stringWithFormat:RecommendUrlStr, offset]];

        //轮播数据请求
        [weakSelf.bannerDataArr removeAllObjects];
       [weakSelf dataRequestWithUrlStr:BannerUrlStr];
    }];
    
    //上拉加载
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    self.tableView.mj_footer = [MJRefreshBackStateFooter footerWithRefreshingBlock:^{
        offset += 20;
        [weakSelf recommendDataRequestWithUrlStr:[NSString stringWithFormat:RecommendUrlStr, offset]];
        
    }];
}


//推荐数据请求
- (void)recommendDataRequestWithUrlStr:(NSString *)urlStr {
    
    [BaseNetWorkManager GET:urlStr parameters:nil success:^(id data) {
        
        [self modelRecommendDataByDic:data];
        
    } fail:^(NSError *error) {
        
    }];
   
}
//推荐model封装
- (void)modelRecommendDataByDic:(NSDictionary *)data {
    if (offset == 0) { // 刷新
        [self.sortedKeyArr removeAllObjects];
        [self.recommendDataDic removeAllObjects];
    }
    
    NSArray *recommendArr = data[@"data"][@"items"];
    
//    [recommendArr enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        
//    }];
    
    for (NSDictionary *recommendDic in recommendArr) {
        ShouyeModel *giftModel = [ShouyeModel new];
        [giftModel setValuesForKeysWithDictionary:recommendDic];
        //将请求到的数据按时间分组
        [self groupRecommendModelByDateWithRecommendModel:giftModel];
      
    }
   
}

//将请求到的数据按时间分组
- (void)groupRecommendModelByDateWithRecommendModel:(ShouyeModel *)model {
    
    double timeInterval = [model.published_at doubleValue];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd EEEE"];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    NSString *dateStr = [formatter stringFromDate:date];
    
    NSString *currentDateStr = [formatter stringFromDate:[NSDate date]];
    if ([dateStr compare:currentDateStr] > 0) {
        dateStr = [dateStr stringByReplacingOccurrencesOfString:@"2016" withString:@"2015"];
    }
    
    //        NSString *subStr = [dateStr substringFromIndex:11];
    //        NSString *newDateStr = nil;
    //        if ([subStr isEqualToString:@"Monday"]) {
    //            newDateStr = [dateStr stringByReplacingOccurrencesOfString:@"Monday" withString:@"星期一"];
    //        }else if ([subStr isEqualToString:@"Tuesday"]) {
    //            newDateStr = [dateStr stringByReplacingOccurrencesOfString:@"Tuesday" withString:@"星期二"];
    //        }else if ([subStr isEqualToString:@"Wednesday"]) {
    //            newDateStr = [dateStr stringByReplacingOccurrencesOfString:@"Wednesday" withString:@"星期三"];
    //        }else if ([subStr isEqualToString:@"Thursday"]) {
    //            newDateStr = [dateStr stringByReplacingOccurrencesOfString:@"Thursday" withString:@"星期四"];
    //        }else if ([subStr isEqualToString:@"Friday"]) {
    //            newDateStr = [dateStr stringByReplacingOccurrencesOfString:@"Friday" withString:@"星期五"];
    //        }else if ([subStr isEqualToString:@"Saturday"]) {
    //            newDateStr = [dateStr stringByReplacingOccurrencesOfString:@"Saturday" withString:@"星期六"];
    //        }else if ([subStr isEqualToString:@"Sunday"]) {
    //            newDateStr = [dateStr stringByReplacingOccurrencesOfString:@"Sunday" withString:@"星期日"];
    //        }
    
    
    if (![[self.recommendDataDic allKeys] containsObject:dateStr]) {
        NSMutableArray *mutArr = [NSMutableArray array];
        // 存入字典
        [self.recommendDataDic setObject:mutArr forKey:dateStr];
    }
    
    [[self.recommendDataDic objectForKey:dateStr] addObject:model];
    NSArray *sortedKeyArr = [[self.recommendDataDic allKeys] sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj2 compare:obj1];
    }];
    self.sortedKeyArr = [NSMutableArray arrayWithArray:sortedKeyArr];
    
    //刷新界面
   // [self.placeHodleView removeFromSuperview];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [self.tableView.mj_footer endRefreshing];
    [self.tableView.mj_header endRefreshing];
    
    
}

#pragma mark -- tableView
- (UITableView *)tableView {
    if (_tableView == nil) {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kWindowW, kWindowH - 30 - 44 - 66) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorColor = [UIColor clearColor];
        [_tableView registerNib:[UINib nibWithNibName:@"SecondaryBannersTVCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"SBTVCell"];
      //  [_tableView registerNib:[UINib nibWithNibName:@"RecommendTVCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"RTVCell"];
        
       
        [_tableView registerClass:[RecommendTVHFV class] forHeaderFooterViewReuseIdentifier:@"HeaderView"];
        
    }
    return _tableView;
}


#pragma mark - UITableViewDataSource & UITableViewDelegate
//分区数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.recommendDataDic.count + 1;
}
//每个分区行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        return 1;
    }
    
    NSString *key = self.sortedKeyArr[section - 1];
    return [[self.recommendDataDic objectForKey:key] count];
}

// cell配置
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (0 == indexPath.section) {
        SecondaryBannersTVCell *SBTVCell = [tableView dequeueReusableCellWithIdentifier:@"SBTVCell" forIndexPath:indexPath];
        
    
        return SBTVCell;
    }
    
 
    SelectionCell *RTVCell = [SelectionCell cellWithTableView:tableView];
    
    
    ShouyeModel *model = [self.recommendDataDic objectForKey:self.sortedKeyArr[indexPath.section - 1]][indexPath.row];
    
    
//        MLLog(@"--%ld", indexPath.section-1);
//        NSString *key = self.sortedKeyArr[indexPath.section-1];
//        
//        MLLog(@"%@", key);
//        NSArray *arr = self.recommendDataDic[key];
//        MLLog(@"%ld", arr.count);
//        MLLog(@"--%ld", indexPath.row);
//        if (1 == arr.count) {
//            ShouyeModel *model = arr[indexPath.row];
//            RTVCell.model = model;
//            
//            return RTVCell;
//        }
//        
//        ShouyeModel *model = arr[indexPath.row];
    
        
        RTVCell.model = model;
        
       
   
  return RTVCell;
}

// 选中cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section != 0) {
        NSString *key = self.sortedKeyArr[indexPath.section - 1];
        ShouyeModel *model = self.recommendDataDic[key][indexPath.row];
       
        // 从SB加载控制器
        ShouyeDetailViewController *detailVC = kVCFromSb(@"shouyedetail", @"Main");
        detailVC.navigationItem.title = @"攻略详情";
        detailVC.idd = [model.idd stringValue];
        detailVC.shouyeModel = model;
        detailVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:detailVC animated:YES];
    }
}


//区头配置
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return nil;
    }
    RecommendTVHFV *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"HeaderView"];
    headerView.contentView.backgroundColor = [UIColor colorWithRed:250/255.0 green:246/255.0 blue:232/255.0 alpha:1.0];// 米黄色
    headerView.headerTitle = self.sortedKeyArr[section - 1];
    return headerView;
    
}

//行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 95;
    }
    
    //return PIC_HEIGHT;
    return [SelectionCell cellHeight];
}
//区头高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0.01;
    }
    return 30;
}
//区尾高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 15;
}


//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#pragma mark -- channel数据请求
- (void)channelDataRequestWithUrlStr:(NSString *)urlStr {
    [BaseNetWorkManager GET:urlStr parameters:nil success:^(id data) {
        [self modelChannelModelWithDictionary:data];
    } fail:^(NSError *error) {
        
    }];
  
}
#pragma mark -- 封装channelModel到数据源数组
- (void)modelChannelModelWithDictionary:(id)data {
    NSDictionary *dic = (NSDictionary *)data;
    NSArray *channelsArr = dic[@"data"][@"channels"];
    for (NSDictionary *channelDic in channelsArr) {
        ChannelModel *model = [ChannelModel new];
        [model setValuesForKeysWithDictionary:channelDic];
        [self.channelModelArr addObject:model];
    }
    //数据请求完毕,刷新界面
    
}


/*
#pragma mark -- 创建channelsScrollView
- (UIScrollView *)channelsScrollView {
    if (_channelsScrollView == nil) {
        self.channelsScrollView = [UIScrollView new];
        _channelsScrollView.frame = CGRectMake(0, 0, kWindowW, 30);
        _channelsScrollView.contentSize = CGSizeMake(kWindowW / 5.0 * self.channelNameArr.count, 30);
        _channelsScrollView.showsHorizontalScrollIndicator = NO;
        _channelsScrollView.showsVerticalScrollIndicator = NO;
        _channelsScrollView.bounces = NO;
        //添加button
        [self addButtonTochannelsScrollView:_channelsScrollView];
        //添加指示条
        [_channelsScrollView addSubview:self.indicateView];
        
    }
    return _channelsScrollView;
}
//添加button
- (void)addButtonTochannelsScrollView:(UIScrollView *)channelsScrollView {
    for (int i = 0; i < self.channelNameArr.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(kWindowW / 5.0 * i, 0, kWindowW / 5.0, 26);
        [button setTitle:self.channelNameArr[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        [button addTarget:self action:@selector(channelButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [_channelsScrollView addSubview:button];
    }
}

- (void)channelButtonAction:(UIButton *)sender {
    
    NSString *title = sender.titleLabel.text;
    NSInteger index = 0;
    for (NSString *channelName in self.channelNameArr) {
        if ([title isEqualToString:channelName]) {
            index = [self.channelNameArr indexOfObject:channelName];
        }
    }
    //改变collectionView偏移量
    CGPoint offset = CGPointMake(kWindowW * index, 0);
   // [self.collectionView setContentOffset:offset animated:YES];
    
    if ([sender.titleLabel.text isEqualToString:@"精选"]) {
        
    }else {
        
    }
    
    
    if (self.channelModelArr.count == 0) {
        [self channelDataRequestWithUrlStr:CHANNELURLSTR];
    }
   
}

#pragma mark -- 频道指示条
- (UIView *)indicateView {
    if (_indicateView == nil) {
        self.indicateView = [UIView new];
        _indicateView.frame = CGRectMake(0, 28, kWindowW / 5.0, 2);
        _indicateView.backgroundColor = [UIColor colorWithRed:242 / 255.0 green:59 / 255.0 blue:45 / 255.0 alpha:1];
    }
    
    return _indicateView;
}










#pragma mark -- UIScrollViewDelegate代理方法
//开始拖拽
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
}
//正在滑动
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat scale = kWindowW / 5.0 / kWindowW;
    CGRect rect = self.indicateView.frame;
    rect.origin.x = scrollView.contentOffset.x * scale;
    self.indicateView.frame = rect;
    
    if (rect.origin.x > kWindowW / 5.0 * 13) {
        self.channelsScrollView.contentOffset = CGPointMake(kWindowW / 5.0 * 13, 0);
    }else {
        self.channelsScrollView.contentOffset = CGPointMake(rect.origin.x, 0);
    }
   
}
//减速完成
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
   
    
}
*/



- (IBAction)searchAction:(UIBarButtonItem *)sender {
    
//    SearchViewController *searchVC = [SearchViewController new];
//    searchVC.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:searchVC animated:YES];
    
}


// 拉线跳转
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    RCSearchViewController *searchVC = [segue destinationViewController];
    searchVC.hidesBottomBarWhenPushed = YES;
   
}











- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation




@end
