//
//  RootViewController.m
//  GiftForYou
//
//  Created by zhumingwen on 16/3/14.
//  Copyright © 2016年 zhumingwen. All rights reserved.
//

#import "RootViewController.h"
#import "BaseTabBarController.h"
@interface RootViewController ()
{
    UIScrollView *_scrollView;
}
@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
  //  UIStoryboard *storyboard = kStoryboard(@"Main");
    
    BOOL isFirst = [[NSUserDefaults standardUserDefaults] boolForKey:@"first"];
    
    if (isFirst) {
        
        [self gotoMainTabbarControll];
//        //圖片擴大淡出的效果开始;
//        
//        //设置一个图片;
//        UIImageView *niceView = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
//        niceView.image = [UIImage imageNamed:@"LaunchImage-800-667h"];
//        
//        //添加到场景
//        [self.view addSubview:niceView];
//        
//        //放到最顶层;
//        [self.view bringSubviewToFront:niceView];
//        
//        //开始设置动画;
//        [UIView beginAnimations:nil context:nil];
//        [UIView setAnimationDuration:2.0];
//        [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:self.view cache:YES];
//        [UIView setAnimationDelegate:self];
//        //這裡還可以設置回調函數;
//        
//        //[UIView setAnimationDidStopSelector:@selector(startupAnimationDone:finished:context:)];
//        
//        niceView.alpha = 0.0;
//        niceView.frame = CGRectMake(-60, -85, 440, 635);
//        [UIView commitAnimations];
        
    } else {
        
        [self gotoScrollView];
        
    }
   
}


#pragma mark 主界面
- (void)gotoMainTabbarControll {
    MLLog(@"进入主界面");
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"first"];
    [UIView animateWithDuration:1.0f animations:^{
        _scrollView.transform = CGAffineTransformMakeScale(2, 2);
        _scrollView.alpha = 0.5;
    } completion:^(BOOL finished) {
        [_scrollView removeFromSuperview];
        UIStoryboard *storyboard = kStoryboard(@"Main");
        BaseTabBarController *tabbar = [storyboard instantiateViewControllerWithIdentifier:@"tabbar"];
        [self.navigationController pushViewController:tabbar animated:YES];
    }];
}



#pragma mark 新特征界面
- (void)gotoScrollView {
    MLLog(@"进入新特征界面");
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kWindowW, kWindowH)];
    scrollView.pagingEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    
    int imgCount = 4;
    scrollView.contentSize = CGSizeMake(imgCount * kWindowW, 0);
    
    for (int i = 0; i < imgCount; i ++) {
        UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(i * kWindowW, 0, kWindowW, kWindowH)];
        iv.image = [UIImage imageNamed:[NSString stringWithFormat:@"walkthrough_%i.jpg", i + 1]];
        [scrollView addSubview:iv];
        
        if (imgCount - 1 == i) {
            iv.userInteractionEnabled = YES;
            // 最后一张图片需要添加一个进入应用的按钮
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
            [btn setBackgroundImage:MLImage(@"btn_begin") forState:UIControlStateNormal];
            btn.center = CGPointMake(kWindowW / 2, kWindowH - 90);
            [btn addTarget:self action:@selector(gotoMainTabbarControll) forControlEvents:UIControlEventTouchUpInside];
            [iv addSubview:btn];
        }
    }
    
    [self.view addSubview:scrollView];
    _scrollView = scrollView;
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
