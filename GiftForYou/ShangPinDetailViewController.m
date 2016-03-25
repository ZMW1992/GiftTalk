//
//  ShangPinDetailViewController.m
//  GiftForYou
//
//  Created by lanouhn on 16/3/10.
//  Copyright © 2016年 zhumingwen. All rights reserved.
//

// 商品详情, 类似网页布局
#import "ShangPinDetailViewController.h"
#import "ShangPinDetailModel.h"
#import "BaseNetWorkManager.h"
#import "ShangPinDetailFirstCell.h"
#import "ShangPinDetailSecondCell.h"
#import "WebViewController.h"
#import "DBManager.h"
#import "RemenModel.h"
#import <SVProgressHUD.h>
#import <UMSocial.h>

#define COLOR [UIColor colorWithRed:242 / 255.0 green:59 / 255.0 blue:45 / 255.0 alpha:1]
#define BannerUrlStr @"http://api.liwushuo.com/v2/items/%@"
#define RecommendUrlStr @"http://api.liwushuo.com/v2%2Fitems%2F1045861%2Frecommend"
#define CommentsUrlStr @"http://api.liwushuo.com/v2/items/%@/comments?limit=20&offset=0"
@interface ShangPinDetailViewController () <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate, UMSocialDataDelegate, UMSocialUIDelegate>

@property (nonatomic, strong) ShangPinDetailModel *detailModel;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *commentsArr;//评论数据源
@property (nonatomic, strong) UIView *indicateView;//指示条
@property (nonatomic, assign) CGFloat secondCellHeight;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) NSMutableArray *collectedModelArr;
@property (nonatomic, strong) UIView *shareView;
@property (nonatomic, strong) UIView *alphaView;

@end

@implementation ShangPinDetailViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
   self.navigationItem.title = @"商品详情";
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self initNavigationC];
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(0, 0, 44, 44);
    [rightButton setImage:[UIImage imageNamed:@"share.png"] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(rightButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    
    // 高度自适应
//    self.tableView.estimatedRowHeight = 100;
//    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kWindowW, kWindowH - 44)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    //注册可重用cell
    //[self.tableView registerNib:[UINib nibWithNibName:@"ShangPinDetailFirstCell" bundle:nil] forCellReuseIdentifier:@"ShangPinDetailFirstCell"];
    [self.tableView registerClass:[ShangPinDetailFirstCell class] forCellReuseIdentifier:@"ShangPinDetailFirstCell"];
    [self.tableView registerClass:[ShangPinDetailSecondCell class] forCellReuseIdentifier:@"ShangPinDetailSecondCell"];
    // [self.tableView registerNib:[UINib nibWithNibName:@"ShangPinDetailSecondCell" bundle:nil] forCellReuseIdentifier:@"ShangPinDetailSecondCell"];
    
    MLLog(@"-----%@", self.remenModel.idd);
    
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.alphaView];
    [self.view addSubview:self.bottomView];
    [self.view addSubview:self.shareView];
    
    //添加观察者,改变指示条偏移量
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeIndicateViewOffset:) name:@"changeIndicateViewOffset" object:nil];
    //数据请求
    [self dataRequestWithUrlStr:[NSString stringWithFormat:BannerUrlStr, self.remenModel.idd]];
}

//========================================================================

-(void)initNavigationC{
    self.navigationController.navigationBar.barStyle=UIBarStyleDefault;
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.navigationBar.shadowImage=[UIImage new];
    [self.navigationController.navigationBar setBackgroundImage:[self getImageWithAlpha:1] forBarMetrics:UIBarMetricsDefault];
    
    [self scrollViewDidScroll:self.tableView];
    
}

// 导航条初始透明度为0
-(UIImage *)getImageWithAlpha:(CGFloat)alpha{
    
    UIColor *color = [UIColor colorWithRed:1 green:0 blue:0 alpha:alpha];
    
  
    CGSize colorSize=CGSizeMake(1, 1);
    
    UIGraphicsBeginImageContext(colorSize);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, color.CGColor);
    
    CGContextFillRect(context, CGRectMake(0, 0, 1, 1));
    
    UIImage *img=UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return img;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    CGFloat alpha=scrollView.contentOffset.y/90.0f>1.0f?1:scrollView.contentOffset.y/90.0f;
    [self.navigationController.navigationBar setBackgroundImage:[self getImageWithAlpha:alpha] forBarMetrics:UIBarMetricsDefault];
   // self.navigationController.navigationBar.translucent = NO;
    
    //     float X = scrollView->getInnerContainer()->getPositionX();
    //   float Y = scrollView->getInnerContainer()->getPositionY();
    
   
    
}


//============================================================================

- (void)rightButtonAction:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    
    MLLog(@"%d", sender.selected);
    
    if (sender.selected == YES) {
        [UIView animateWithDuration:0.3 animations:^{
            self.shareView.frame = CGRectMake(0, self.shareView.frame.origin.y - self.shareView.frame.size.height, self.shareView.frame.size.width, self.shareView.frame.size.height);
        }];
        self.alphaView.alpha = 0.3;
        
    }else {
        [UIView animateWithDuration:0.3 animations:^{
            self.shareView.frame = CGRectMake(0, self.shareView.frame.origin.y + self.shareView.frame.size.height, self.shareView.frame.size.width, self.shareView.frame.size.height);
        }];
        self.alphaView.alpha = 0;
        
    }
}

// 点击分享的灰色蒙版
- (UIView *)alphaView {
    if (_alphaView == nil) {
        self.alphaView = [[UIView alloc] initWithFrame:self.view.bounds];
        _alphaView.backgroundColor = [UIColor blackColor];
        _alphaView.alpha = 0;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        [_alphaView addGestureRecognizer:tap];
        
    }
    return _alphaView;
}

// 灰色蒙版轻拍手势回调
- (void)tapAction:(UITapGestureRecognizer *)sender {
    
    UIButton *shareButton = (UIButton *)self.navigationItem.rightBarButtonItem.customView;
    [self rightButtonAction:shareButton];
    
}


- (UIView *)shareView {
    
    if (_shareView == nil) {
        self.shareView = [[UIView alloc] initWithFrame:CGRectMake(0, kWindowH, kWindowW, 100)];
        _shareView.backgroundColor = [UIColor whiteColor];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, kWindowH, 20)];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.text = @"分享到";
        [_shareView addSubview:titleLabel];
        
        NSArray *nameArr = @[@"新浪微博", @"腾讯微博", @"人人网", @"豆瓣"];
        NSArray *imageArr = @[@"xinlang.png", @"tencent.png", @"renren.png", @"douban.png"];
        for (int i = 0; i < 4; i++) {
            
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(((kWindowW - 40 * 4) / 5.0 + 40) * i + (kWindowW - 40 * 4) / 5.0, 35, 40, 40);
            [button setImage:[UIImage imageNamed:imageArr[i]] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(shareButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            button.tag = 1000 + i;
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(button.frame.origin.x - 10, CGRectGetMaxY(button.frame), button.frame.size.width + 20, 20)];
            label.text = nameArr[i];
            label.textAlignment = NSTextAlignmentCenter;
            label.font = [UIFont systemFontOfSize:12];
            [_shareView addSubview:button];
            [_shareView addSubview:label];
            
        }
     
    }
    return _shareView;
}


- (void)shareButtonAction:(UIButton *)sender {
    UIButton *shareButton = (UIButton *)self.navigationItem.rightBarButtonItem.customView;
    [self rightButtonAction:shareButton];
    
    if (sender.tag == 1000) {
        [self shareToPlatformWithTypes:@[UMShareToSina]];
    }else if (sender.tag == 1001) {
        [self shareToPlatformWithTypes:@[UMShareToTencent]];
    }else if (sender.tag == 1002) {
        [self shareToPlatformWithTypes:@[UMShareToRenren]];
    }else {
        [self shareToPlatformWithTypes:@[UMShareToDouban]];
    }
    
}



- (void)shareToPlatformWithTypes:(NSArray *)platformTypes {
    
    NSString *content = [NSString stringWithFormat:@"%@(分享自@淘礼物)%@", self.detailModel.name, self.detailModel.url];
    
    [[UMSocialControllerService defaultControllerService] setShareText:content
                                                            shareImage:nil
                                                      socialUIDelegate:self];        //设置分享内容和回调对象
    [UMSocialSnsPlatformManager getSocialPlatformWithName:[platformTypes firstObject]].snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
    [[UMSocialData defaultData].urlResource setResourceType:UMSocialUrlResourceTypeImage url:self.detailModel.cover_image_url];
    
    
}


- (void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response {
    if (response.responseCode == UMSResponseCodeSuccess) {
        MLLog(@"%@", [response.data allKeys]);
    }
    
}




//数据请求
- (void)dataRequestWithUrlStr:(NSString *)urlStr {
    [SVProgressHUD showWithStatus:@"正在加载"];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
    [BaseNetWorkManager GET:urlStr parameters:nil success:^(id data) {
        
       NSDictionary *dic = data[@"data"];
        self.detailModel = [[ShangPinDetailModel alloc] initWithDictionary:dic error:nil];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            [SVProgressHUD dismiss];
        });
        
    } fail:^(NSError *error) {
        
    }];
  
}



#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

//每个分区cell个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (0 == indexPath.section) {
        ShangPinDetailFirstCell *firstcell = [tableView dequeueReusableCellWithIdentifier:@"ShangPinDetailFirstCell" forIndexPath:indexPath];
        firstcell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        firstcell.tempModel = self.detailModel;
        
        return firstcell;
    } else {
        
        ShangPinDetailSecondCell *secondcell = [tableView dequeueReusableCellWithIdentifier:@"ShangPinDetailSecondCell" forIndexPath:indexPath];
        secondcell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if (self.detailModel != nil && self.secondCellHeight == 0) {
            // 给cell传值
            secondcell.model = self.detailModel;
            secondcell.urlID = self.remenModel.idd;
        }
        
        // block回调, 传进来cell高度
        __weak ShangPinDetailViewController *weakSelf = self;
        secondcell.shangPinDetailWebViewBolck = ^(CGFloat height) {
            weakSelf.secondCellHeight = height;
            [tableView reloadData];
        };
        
        
        return secondcell;
    }
   
}


//行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        
        return [[ShangPinDetailFirstCell new] getHeightForCellByModel:self.detailModel] + 10;
    }
    
    if (self.secondCellHeight == 0) {
        return kWindowH - 64 - 30;
    }else {
        return self.secondCellHeight; // 有值就返回真实高度
    }
    
}

//区头高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0.1;
    }
    return 30;
}

//区尾高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 1) {
        return 0.1;
    }
    return 15;
}

//自定义区头
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        return nil;
    }
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    view.backgroundColor = [UIColor grayColor];
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(0, 1, kWindowW / 2.0 - 0.5, 28);
    leftButton.backgroundColor = [UIColor whiteColor];
    [leftButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [leftButton setTitle:@"图文介绍" forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(kWindowW / 2.0 + 0.5, 1, kWindowW / 2.0 - 1, 28);
    rightButton.backgroundColor = [UIColor whiteColor];
    [rightButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [rightButton setTitle:@"评论" forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [view addSubview:leftButton];
    [view addSubview:rightButton];
    [view addSubview:self.indicateView];
    return view;
}

// 区头button方法
- (void)buttonAction:(UIButton *)sender {
    
    CGPoint offset = CGPointZero;
    if ([sender.titleLabel.text isEqualToString:@"图文介绍"]) {
        offset = CGPointMake(0, 0);
    }else {
        offset = CGPointMake(kWindowW, 0);
    }
    //发出通知,改变偏移量, 将点击button的偏移量通知出去
    [[NSNotificationCenter defaultCenter] postNotificationName:@"changeScrollViewOffset" object:self userInfo:@{@"offset":[NSValue valueWithCGPoint:offset]}];
    
}

// 观察者方法,改变指示条偏移量
- (void)changeIndicateViewOffset:(NSNotification *)notification {
    
    CGFloat offset = [notification.userInfo[@"offset"] floatValue];
    
    CGFloat scale = kWindowW / 2.0 / kWindowW;
    
    self.indicateView.frame = CGRectMake(offset * scale, 28, kWindowW / 2.0, 2);
    
    
}

- (UIView *)indicateView {
    if (_indicateView == nil) {
        self.indicateView = [[UIView alloc] initWithFrame:CGRectMake(0, 28, kWindowW / 2.0, 2)];
       _indicateView.backgroundColor = [UIColor orangeColor];
    }
    return _indicateView;
}



// bottomView
- (UIView *)bottomView {
    
    if (_bottomView == nil) {
        self.bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, kWindowH-44, kWindowW, 44)];
        
        UIButton *likeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        likeButton.frame = CGRectMake(10, 7, 120, 30);
        [likeButton setTitle:@"喜欢" forState:UIControlStateNormal];
        [likeButton setTitleColor:COLOR forState:UIControlStateNormal];
        likeButton.layer.cornerRadius = 15;
        likeButton.layer.borderWidth = 1;
        likeButton.layer.borderColor = COLOR.CGColor;
        likeButton.layer.masksToBounds = YES;
        
        
        [likeButton setImage:[UIImage imageNamed:@"like.png"] forState:UIControlStateNormal];
        [likeButton setImage:[UIImage imageNamed:@"like2.png"] forState:UIControlStateSelected];
        BOOL isExists = [[DBManager shareManager] selectOneDataWithGiftID:self.remenModel.idd];
        if (isExists) {
            likeButton.selected = YES;
        } else {
            likeButton.selected = NO;
        }
        
        
        [likeButton addTarget:self action:@selector(likeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        likeButton.tag = 123;
        
        
        
        UIButton *purchaseButton = [UIButton buttonWithType:UIButtonTypeCustom];
        purchaseButton.frame = CGRectMake(CGRectGetMaxX(likeButton.frame) + 20, 7, kWindowW -CGRectGetMaxX(likeButton.frame) - 20 - 10, 30);
        purchaseButton.backgroundColor = COLOR;
        [purchaseButton setTitle:@"去天猫购买" forState:UIControlStateNormal];
        purchaseButton.layer.cornerRadius = 15;
        purchaseButton.layer.masksToBounds = YES;
        [purchaseButton addTarget:self action:@selector(purchaseButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        
      
        [_bottomView addSubview:likeButton];
        [_bottomView addSubview:purchaseButton];
        
        
    }
    
    return _bottomView;
    
}


// 商品收藏
- (void)likeButtonAction:(UIButton *)sender {
 
    BOOL isExists = [[DBManager shareManager] selectOneDataWithGiftID:self.remenModel.idd];
    if (!isExists) {
        // 收藏, 插入数据
        [[DBManager shareManager] insertDataWithHotModel:self.remenModel];
        sender.selected = YES;
        // 显示弹框效果
        [SVProgressHUD showSuccessWithStatus:@"已收藏"];
        [SVProgressHUD dismissWithDelay:1.0];
    } else {
        
        [[DBManager shareManager] deleteDataWithGiftID:self.remenModel.idd];
        sender.selected = NO;
        [SVProgressHUD showErrorWithStatus:@"已取消收藏"];
        [SVProgressHUD dismissWithDelay:1.0];
    }
  
}


// 去淘宝,天猫
- (void)purchaseButtonAction:(UIButton *)sender {
    
    WebViewController *webVC = [WebViewController new];
    webVC.webUrl = self.detailModel.purchase_url;
    webVC.navTitle = self.detailModel.name;
    [self.navigationController pushViewController:webVC animated:YES];
    
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
