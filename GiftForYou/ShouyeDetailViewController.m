//
//  ShouyeDetailViewController.m
//  GiftForYou
//
//  Created by zhumingwen on 16/3/3.
//  Copyright © 2016年 zhumingwen. All rights reserved.
//

#import "ShouyeDetailViewController.h"
#import "GonglueDetailModel.h"
#import "BaseNetWorkManager.h"
#import <UIImageView+WebCache.h>
#import "ShouyeModel.h"
#import "DBManager2.h"
#import <SVProgressHUD.h>
#import <UMSocial.h>

#define GonglueDetailUrlStr @"http://api.liwushuo.com/v2/posts/%@"

//图片高度
#define PIC_HEIGHT kWindowW * 329 / 720.0
@interface ShouyeDetailViewController ()<UIWebViewDelegate, UIScrollViewDelegate, UMSocialUIDelegate, UMSocialDataDelegate>

@property (nonatomic, retain) UIWebView *webView;
@property (nonatomic, strong) GonglueDetailModel *gonglueDetailModel;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *descripeLabel;


@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIButton *likeButton;
@property (nonatomic, strong) UIButton *shareButton;
@property (nonatomic, strong) UIButton *commentButton;
//@property (nonatomic, strong) NSMutableArray *collectedArr; // 已收藏数组
@property (nonatomic, strong) UIView *shareView;
@property (nonatomic, strong) UIView *alphaView; // 点击分享的时候出现灰色蒙版
@property (nonatomic, strong) UIView *imgalphaView; // 顶部图片的灰色蒙版

@property (nonatomic , retain) NSTimer *timer;

@end

@implementation ShouyeDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 支持右滑返回
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.backBarButtonItem = barItem;
    
    
//    self.collectedArr = [NSMutableArray array];
    
    [self scrollViewDidScroll:self.scrollView];
    
    [self loadDataAndShow];
    [self setUpView];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:8 target:self selector:@selector(timerAction:) userInfo:nil repeats:YES];
  
}

#pragma mark - 定时器
- (void)timerAction:(NSTimer *)timer
{
    [SVProgressHUD dismiss];
    [self.timer invalidate];
}


- (void)setUpView {
    self.title = @"攻略详情";
    self.view.backgroundColor = [UIColor whiteColor];
    //添加scrollView
    [self.view addSubview:self.scrollView];
    [self.view addSubview:self.alphaView];
    [self.view addSubview:self.bottomView];
    [self.view addSubview:self.shareView];
}


- (void)loadDataAndShow
{

    [self dataRequestWithUrlStr:[NSString stringWithFormat:GonglueDetailUrlStr, self.shouyeModel.idd]];
}


//数据请求
- (void)dataRequestWithUrlStr:(NSString *)urlStr {
    [SVProgressHUD showWithStatus:@"正在加载"];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
    [BaseNetWorkManager GET:urlStr parameters:nil success:^(id data) {
        self.gonglueDetailModel = [GonglueDetailModel new];
       
        [self.gonglueDetailModel setValuesForKeysWithDictionary:data[@"data"]];
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:self.gonglueDetailModel.cover_image_url]];
        [self.webView loadHTMLString:self.gonglueDetailModel.content_html baseURL:nil];
        self.descripeLabel.text = self.gonglueDetailModel.title;
        [self.likeButton setTitle:[self.gonglueDetailModel.likes_count stringValue] forState:UIControlStateNormal];
        
        [self.likeButton setImage:[UIImage imageNamed:@"like.png"] forState:UIControlStateNormal];
        [self.likeButton setImage:[UIImage imageNamed:@"like2.png"] forState:UIControlStateSelected];
        BOOL isExists = [[DBManager2 shareManager] selectOneDataWithSelectionID:self.idd];
        if (isExists) {
            _likeButton.selected = YES;
        } else {
            _likeButton.selected = NO;
        }
        
        [self.shareButton setTitle:[self.gonglueDetailModel.shares_count stringValue] forState:UIControlStateNormal];
        [self.commentButton setTitle:[self.gonglueDetailModel.comments_count stringValue] forState:UIControlStateNormal];
    } fail:^(NSError *error) {
        
    }];
    
}


//scrollView
- (UIScrollView *)scrollView {
    if (!_scrollView) {
        self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kWindowW, kWindowH - 64 - 44)];
        _scrollView.backgroundColor = [UIColor whiteColor];
        _scrollView.delegate = self;
        //添加imageView
        [_scrollView addSubview:self.imageView];
        
        [_scrollView addSubview:self.imgalphaView];
        //添加webView
        [_scrollView addSubview:self.webView];
        
        [_scrollView addSubview:self.descripeLabel];
        
    }
    return _scrollView;
}


- (UIView *)imgalphaView {
    
    if (!_imageView) {
        self.imgalphaView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWindowW, CGRectGetMaxY(self.imageView.frame))];
    }
    return _imgalphaView;
}





//imageView
- (UIImageView *)imageView {
    if (_imageView == nil) {
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kWindowW, PIC_HEIGHT * 1.2)];
        
//        self.imgalphaView = [[UIView alloc] initWithFrame:_imageView.bounds];
//        _imgalphaView.backgroundColor = [UIColor grayColor];
//        _imgalphaView.alpha = 0.2;
//        [_imageView addSubview:_imgalphaView];
        //添加label
       // [_imageView addSubview:self.descripeLabel];
    }
    return _imageView;
}


//webView
- (UIWebView *)webView {
    if (_webView == nil) {
        //SCREEN_HEIGHT - CGRectGetMaxY(self.imageView.frame)
        self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.imageView.frame), kWindowW, 0.1)];
        _webView.delegate = self;
        _webView.backgroundColor = [UIColor whiteColor];
        _webView.scrollView.scrollEnabled = NO;
    }
    
    return _webView;
}


//descripeLabel
- (UILabel *)descripeLabel {
    if (!_descripeLabel) {
        self.descripeLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(self.imageView.frame) - 64, kWindowW - 30, 54)];

        _descripeLabel.numberOfLines = 0;
        _descripeLabel.textColor = [UIColor whiteColor];
        _descripeLabel.font = [UIFont boldSystemFontOfSize:20];
    }
    return _descripeLabel;
}


//
- (UIView *)bottomView {
    
    if (_bottomView == nil) {
        self.bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, kWindowH - 44 - 64, kWindowW, 44)];
        _bottomView.backgroundColor = [UIColor whiteColor];
        
        
        self.likeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.likeButton.frame = CGRectMake(0, 7, kWindowW / 3.0, 30);
        self.likeButton.titleLabel.font = [UIFont systemFontOfSize:14];
        self.likeButton.adjustsImageWhenHighlighted = NO;
        [self.likeButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [self.likeButton addTarget:self action:@selector(shoucangButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView addSubview:self.likeButton];
        
        self.shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.shareButton.frame = CGRectMake(kWindowW / 3.0, 7, kWindowW / 3.0, 30);
        self.shareButton.titleLabel.font = [UIFont systemFontOfSize:14];
        self.shareButton.adjustsImageWhenHighlighted = NO;
        [self.shareButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [self.shareButton setImage:[UIImage imageNamed:@"fenxiang.png"] forState:UIControlStateNormal];
        [self.shareButton addTarget:self action:@selector(shareButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView addSubview:self.shareButton];
        
        self.commentButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.commentButton.frame = CGRectMake(kWindowW / 3.0 * 2, 7, kWindowW / 3.0, 30);
        self.commentButton.titleLabel.font = [UIFont systemFontOfSize:14];
        self.commentButton.adjustsImageWhenHighlighted = NO;
        [self.commentButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [self.commentButton setImage:[UIImage imageNamed:@"pinglun.png"] forState:UIControlStateNormal];
        [self.commentButton addTarget:self action:@selector(commentButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView addSubview:self.commentButton];
       
    }
    
    return _bottomView;
}


// 评论按钮
- (void)commentButtonAction:(UIButton *)sender {
    
    
 
}


- (void)shoucangButtonAction:(UIButton *)sender {
    MLLog(@"收藏成功");
    BOOL isExists = [[DBManager2 shareManager] selectOneDataWithSelectionID:self.idd];
    if (!isExists) {
        [[DBManager2 shareManager] insertDataWithSelectionModel:self.shouyeModel];
        sender.selected = YES;
        // 显示弹框效果
        [SVProgressHUD showSuccessWithStatus:@"已收藏"];
        [SVProgressHUD dismissWithDelay:1.0];
    } else {
        [[DBManager2 shareManager] deleteDataWithSelectionID:self.idd];
        sender.selected = NO;
        [SVProgressHUD showErrorWithStatus:@"已取消收藏"];
        [SVProgressHUD dismissWithDelay:1.0];
    }
    
}




// 分享按钮
- (void)shareButtonAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    
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


- (UIView *)shareView {
    
    if (_shareView == nil) {
        self.shareView = [[UIView alloc] initWithFrame:CGRectMake(0, kWindowH - 64, kWindowH, 100)];
        _shareView.backgroundColor = [UIColor whiteColor];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, kWindowW, 20)];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.text = @"分享到";
        [_shareView addSubview:titleLabel];
        
        NSArray *nameArr = @[@"新浪微博", @"腾讯微博", @"人人网", @"豆瓣"];
        NSArray *imageArr = @[@"xinlang.png", @"tencent.png", @"renren.png", @"douban.png"];
        for (int i = 0; i < 4; i++) {
            
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(((kWindowW - 40 * 4) / 5.0 + 40) * i + (kWindowW - 40 * 4) / 5.0, 35, 40, 40);
            [button setImage:[UIImage imageNamed:imageArr[i]] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
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

// 分享弹框按钮
- (void)buttonAction:(UIButton *)sender {
    
    [self shareButtonAction:self.shareButton];
    
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
    
    NSString *content = [NSString stringWithFormat:@"%@(分享自@淘礼物)%@", self.gonglueDetailModel.title, self.gonglueDetailModel.url];
    
//    UMSocialUrlResource *urlResource = [[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeImage url:self.gonglueDetailModel.cover_image_url];
//    
//    [[UMSocialDataService defaultDataService] postSNSWithTypes:platformTypes content:content image:nil location:nil urlResource:urlResource completion:^(UMSocialResponseEntity *response) {
//        
//        if (response.responseCode == UMSResponseCodeSuccess) {
//            MLLog(@"分享成功");
//        }
//        
//      //  [SVProgressHUD showImage:[UIImage imageNamed:@""] status:@"分享成功" duration:1.5 complete:nil];
//        
//    }];
 //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    
    [[UMSocialControllerService defaultControllerService] setShareText:content
                                                            shareImage:nil
                                                      socialUIDelegate:self];        //设置分享内容和回调对象
    [UMSocialSnsPlatformManager getSocialPlatformWithName:[platformTypes firstObject]].snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
    [[UMSocialData defaultData].urlResource setResourceType:UMSocialUrlResourceTypeImage url:self.gonglueDetailModel.cover_image_url];
    
    
    
}







- (UIView *)alphaView {
    if (_alphaView == nil) {
        self.alphaView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWindowW, kWindowH-100)];
        _alphaView.backgroundColor = [UIColor blackColor];
        _alphaView.alpha = 0;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        [_alphaView addGestureRecognizer:tap];
        
        
    }
    
    return _alphaView;
}


- (void)tapAction:(UITapGestureRecognizer *)sender {
    
    [self shareButtonAction:self.shareButton];
    
}





//webView代理方法
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
   
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    float height = [[webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.scrollHeight"] floatValue];
    self.webView.frame = CGRectMake(0, CGRectGetMaxY(self.imageView.frame), kWindowW, height);
    
   
    self.scrollView.contentSize = CGSizeMake(kWindowW,  height + self.imageView.frame.size.height);
    
    [SVProgressHUD dismiss];
  
}



- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat yOffset  = scrollView.contentOffset.y;
    
    MLLog(@"%f", yOffset);
    
    CGRect f = self.imageView.frame;
    
    f.origin.y = yOffset;
    f.size.height = -yOffset + PIC_HEIGHT * 1.2;
    f.origin.x = -(f.size.height*kWindowW/(PIC_HEIGHT * 1.2) -  kWindowW)/2;
    f.size.width = f.size.height*kWindowW/(PIC_HEIGHT * 1.2);
    
    self.imageView.frame = f;
    
   
    self.imgalphaView.frame = CGRectMake(0, 0, kWindowW, CGRectGetMaxY(self.imageView.frame));
    
    self.descripeLabel.frame = CGRectMake(15, CGRectGetMaxY(self.imageView.frame) - 64, kWindowW - 30, 54);
  
    
}




- (void)viewWillDisappear:(BOOL)animated {
    
    [SVProgressHUD dismiss];
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
