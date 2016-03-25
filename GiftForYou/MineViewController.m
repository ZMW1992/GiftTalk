//
//  MineViewController.m
//  GiftForYou
//
//  Created by zhumingwen on 16/3/2.
//  Copyright © 2016年 zhumingwen. All rights reserved.
//

#import "MineViewController.h"
#import "MineFirstCell.h"
#import "MineSecondCell.h"
#import "MineHeaderView.h"
#import "ShouyeModel.h"
#import "ShangPinDetailViewController.h"
#import "ShouyeDetailViewController.h"
#import "MoreViewController.h"
#import "BaseNavigationController.h"
#import "TempViewController.h"
#import "UserMessageDataManager.h"
#import "CustomSheetView.h"
#import "LogInViewController.h"


@interface MineViewController () <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate, MineSecondCellDelegate, MineHeaderViewDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate, CustomSheetViewDelegate>

{
    
    NSArray * titleArray;
    NSArray * imageArray;
    NSArray * pointArray;
    NSString * activityName;
    BOOL ShowRedDot;
}


@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *indicateView;//指示条
@property (nonatomic, assign) CGFloat secondCellHelght;

@property (nonatomic, strong) MineHeaderView *headerView;
@property (nonatomic, strong) UIImagePickerController *imagePick;

@end

@implementation MineViewController

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    titleArray = [[NSArray alloc]init];
    imageArray = [[NSArray alloc]init];
    pointArray = [[NSArray alloc]init];
    
    titleArray = @[@"微信",@"微信朋友圈",@"微信收藏",@"新浪微博",@"QQ",@"QQ空间",@"腾讯微博",@"人人网",@"短信",@"邮件",@"复制链接"];
    imageArray = @[@"wechat",@"wechatf",@"wechatc",@"sina",@"qq",@"qqzone",@"tcwb",@"renn",@"sms",@"email",@"mark"];
    // 积分数组
    pointArray = @[@"",@"",@"",@"",@"",@"",@"",@"",@"",@""];
    
}




- (void)viewDidLoad {
    [super viewDidLoad];
  
    // 左边扫描二维码
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"iconfont-saomiao@2x"] style:(UIBarButtonItemStylePlain) target:self action:@selector(scan)];
    
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"iconfont-shezhi@2x"] style:(UIBarButtonItemStyleDone) target:self action:@selector(moreClick:)];
    self.navigationItem.rightBarButtonItem = item;
    
    
    //self.navigationController.navigationBar.barTintColor = [UIColor clearColor];
   // self.navigationController.navigationBar.translucent = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kWindowW, kWindowH - 64 - 54)];
    self.headerView = [MineHeaderView topViewWithFrame:CGRectMake(0, 0, kWindowW, 240)];
    
    
    
    FMDatabaseQueue *queue = [UserMessageDataManager shareData];
    [queue inDatabase:^(FMDatabase *db) {
        FMResultSet *rb = [db executeQuery:@"select *from userInfo;"];
        
        while ([rb next]) {
            
            NSData *imgData = [rb dataForColumn:@"imgView"];
            if (imgData) {
                // 反归档
                self.headerView.iconView.image = [UIImage imageWithData:imgData];
            }
            
        }
    }];
    
    
    
    _headerView.delegate = self;
    _tableView.tableHeaderView = _headerView;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    // 隐藏虚假的(没有内容)cell
    _tableView.tableFooterView = [UIView new];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"MineFirstCell" bundle:nil] forCellReuseIdentifier:@"MineFirstCell"];
    
    [self.tableView registerClass:[MineSecondCell class] forCellReuseIdentifier:@"MineSecondCell"];
    
    [self.view addSubview:_tableView];
    
    //添加观察者,改变指示条偏移量
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mineVCchangeIndicateViewOffset:) name:@"mineVCchangeIndicateViewOffset" object:nil];
    
    
}

// 扫描二维码方法
- (void)scan {
    TempViewController *tempVC = [TempViewController new];
    tempVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:tempVC animated:YES];
}

- (void)moreClick:(UIBarButtonItem *)sender {
    
    MoreViewController *moreVC = [MoreViewController new];
    moreVC.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    BaseNavigationController *moreNC = [[BaseNavigationController alloc] initWithRootViewController:moreVC];
    
    moreNC.hidesBottomBarWhenPushed = YES;
    [self presentViewController:moreNC animated:YES completion:nil];
    
}


#pragma mark - MineHeaderViewDelegate方法
- (void)mineHeaderViewOfIconViewDidClick {
    // 点击换头像
    self.imagePick = [[UIImagePickerController alloc] init];
    // 选中来源
    _imagePick.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    // 是否可以被编辑
    _imagePick.allowsEditing = YES;
    _imagePick.delegate = self;
    [self presentViewController:self.imagePick animated:YES completion:nil];
   
}


// 登陆按钮
- (void)mineHeaderViewOfLogInBtnDidClick {
    
    MLLog(@"登陆");
    
    CustomSheetView *sheetView = [[CustomSheetView alloc]initWithTitle:@"分享到"
                                                            Delegate:self
                                                          titleArray:titleArray
                                                          imageArray:imageArray
                                                          PointArray:pointArray
                                                          ShowRedDot:ShowRedDot
                                                        ActivityName:activityName
                                                              Middle:NO];
    [sheetView ShowInView:self.view];
    
  
}

#pragma mark ----------分享UI按钮----------
//点击分享界面按钮执行的各个平台的分享方法
-(void)ShareButtonAction:(NSInteger *)buttonIndex
{
    switch ((int)buttonIndex)
    {
        case 0:
        {
            //微信分享
            [self presentViewController:[[UINavigationController alloc] initWithRootViewController:[LogInViewController new]] animated:YES completion:nil];
        }
            break;
        case 1:
        {
            //微信朋友圈分享
            [self presentViewController:[[UINavigationController alloc] initWithRootViewController:[LogInViewController new]] animated:YES completion:nil];
        }
            break;
        case 2:
        {
            //微信收藏
            [self presentViewController:[[UINavigationController alloc] initWithRootViewController:[LogInViewController new]] animated:YES completion:nil];
        }
            break;
        case 3:
        {
            //新浪微博
            [self presentViewController:[[UINavigationController alloc] initWithRootViewController:[LogInViewController new]] animated:YES completion:nil];
            
        }
            break;
        case 4:
        {
            //QQ分享
            [self presentViewController:[[UINavigationController alloc] initWithRootViewController:[LogInViewController new]] animated:YES completion:nil];
        }
            break;
        case 5:
        {
            //QQ空间分享
            [self presentViewController:[[UINavigationController alloc] initWithRootViewController:[LogInViewController new]] animated:YES completion:nil];
        }
            break;
        case 6:
        {
            //腾讯微博分享
            [self presentViewController:[[UINavigationController alloc] initWithRootViewController:[LogInViewController new]] animated:YES completion:nil];
        }
            break;
        case 7:
        {
            //人人网分享
            [self presentViewController:[[UINavigationController alloc] initWithRootViewController:[LogInViewController new]] animated:YES completion:nil];
        }
            break;
        case 8:
        {
            //短信分享
            [self presentViewController:[[UINavigationController alloc] initWithRootViewController:[LogInViewController new]] animated:YES completion:nil];
        }
            break;
        case 9:
        {
            //邮件分享
            [self presentViewController:[[UINavigationController alloc] initWithRootViewController:[LogInViewController new]] animated:YES completion:nil];
        }
            break;
        case 10:
        {
            //复制链接
            
            ShowAlertss(nil, @"复制链接成功")
            
        }
            break;
            
    }
}
/**
 *  当有积分活动时,取消按钮变成了前往积分兑换的方法,需要实现此代理
 */
-(void)goToPointStoreAction
{
    
}


// 购物车
- (void)mineHeaderViewOfGouwucheViewDidClick {
    MLLog(@"点了购物车");
}
// 订单
- (void)mineHeaderViewOfDingdanViewDidClick {
    MLLog(@"点了订单");
    
}
// 礼券
- (void)mineHeaderViewOfLiquanViewDidClick {
    MLLog(@"点了礼券");
    
}
// 客服
- (void)mineHeaderViewOfKefuViewDidClick {
    MLLog(@"点了客服");
    
}






















// 图片选择结束之后，走这个方法，字典存放所有图片信息
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    UIImage *img = [info objectForKey:UIImagePickerControllerOriginalImage];
    self.headerView.iconView.image = img;
    [self dismissViewControllerAnimated:YES completion:nil];
    
    [self uploadClick];
}

- (void)uploadClick {
    
    NSData *data = UIImagePNGRepresentation(self.headerView.iconView.image);
    
    FMDatabaseQueue *queue = [UserMessageDataManager shareData];
    [queue inDatabase:^(FMDatabase *db) {
        
        [db executeUpdate:@"update userInfo set imgView = ?", data];
    }];
    
}




- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (0 == indexPath.section) {
//        
//        MineFirstCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MineFirstCell" forIndexPath:indexPath];
//        
//        return cell;
//    }
//    
    MineSecondCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MineSecondCell" forIndexPath:indexPath];
    
    cell.delegate = self;
    __weak MineViewController *weakSelf = self;
    cell.secondCellHightBolck = ^(CGFloat height) {
        weakSelf.secondCellHelght = height;
        [tableView reloadData];
    };
    
    return cell;
    
}

// 行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
 
    if (self.secondCellHelght == 0) {
        return kWindowH - 64 - 30;
    } else {
        
        return self.secondCellHelght; // 有值就返回真实高度
    }
  
}

// 区头高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
   
    return 30;
}

// 自定义区头
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    view.backgroundColor = [UIColor grayColor];
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(0, 1, kWindowW / 2.0 - 0.5, 28);
    leftButton.backgroundColor = [UIColor whiteColor];
    [leftButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [leftButton setTitle:@"喜欢的礼物" forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(kWindowW / 2.0 + 0.5, 1, kWindowW / 2.0 - 1, 28);
    rightButton.backgroundColor = [UIColor whiteColor];
    [rightButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [rightButton setTitle:@"喜欢的攻略" forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [view addSubview:leftButton];
    [view addSubview:rightButton];
    [view addSubview:self.indicateView];
    return view;
}

- (UIView *)indicateView {
    if (_indicateView == nil) {
        self.indicateView = [[UIView alloc] initWithFrame:CGRectMake(0, 28, kWindowW / 2.0, 2)];
        _indicateView.backgroundColor = [UIColor orangeColor];
    }
    return _indicateView;
}


// 区头button方法
- (void)buttonAction:(UIButton *)sender {
    
    CGPoint offset = CGPointZero;
    if ([sender.titleLabel.text isEqualToString:@"喜欢的礼物"]) {
        offset = CGPointMake(0, 0);
    }else {
        offset = CGPointMake(kWindowW, 0);
    }
    //发出通知,改变偏移量, 将点击button的偏移量通知出去
    [[NSNotificationCenter defaultCenter] postNotificationName:@"mineVCchangeScrollViewOffset" object:self userInfo:@{@"offset":[NSValue valueWithCGPoint:offset]}];
    
}

// 观察者方法,改变指示条偏移量
- (void)mineVCchangeIndicateViewOffset:(NSNotification *)notification {
    
    CGFloat offset = [notification.userInfo[@"offset"] floatValue];
    
    CGFloat scale = kWindowW / 2.0 / kWindowW;
    
    self.indicateView.frame = CGRectMake(offset * scale, 28, kWindowW / 2.0, 2);
    
    
}



#pragma mark - MineSecondCellDelegate

- (void)collectionViewItemClick:(RemenModel *)remenModel {
    
    ShangPinDetailViewController *vc = [ShangPinDetailViewController new];
    vc.remenModel = remenModel;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
 
}

- (void)tableViewCellClick:(ShouyeModel *)shouyeModel {
    
    ShouyeDetailViewController *VC = [ShouyeDetailViewController new];
    VC.shouyeModel = shouyeModel;
    VC.idd = [shouyeModel.idd stringValue];
    VC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:VC animated:YES];
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
