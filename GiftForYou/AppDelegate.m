//
//  AppDelegate.m
//  GiftForYou
//
//  Created by zhumingwen on 16/3/2.
//  Copyright © 2016年 zhumingwen. All rights reserved.
//

#import "AppDelegate.h"
#import <SVProgressHUD.h>
#import <UMSocial.h>


@interface AppDelegate ()
{
    UIScrollView *_scrollView;
}
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [UMSocialData setAppKey:@"56e6cd69e0f55ac508001418"];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    

    // 设置开机启动图必须写这句话
    [self.window makeKeyAndVisible];
   
  
#pragma mark - 网络监测
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeNone];
    //厚度
    [SVProgressHUD setRingThickness:6];
    //1.获得网络监控的管理者
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    //2.设置网络状态改变后的处理
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        //当网络状态改变后，会调用这个方法
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:{
                UIAlertView *alert1 = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"请检查您当前的网路" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert1 show];
                
            }
                break;
            case AFNetworkReachabilityStatusNotReachable:
            {
                UIAlertView *alert2 = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"好痛苦！断网了！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert2 show];
                
            }
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
            {
                [SVProgressHUD showSuccessWithStatus:@"3G/4G网络"];
            }
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
            {
                [SVProgressHUD showSuccessWithStatus:@"WIFI"];
            }
                break;
            default:
                break;
        }
        
    }];
    
    //3 开始监测
    [manager startMonitoring];
    
    
    NSURLCache *cathe = [[NSURLCache alloc] initWithMemoryCapacity:4*1024*1024 diskCapacity:20*1024*1024 diskPath:nil];
    [NSURLCache setSharedURLCache:cathe];
   
    
    
    //圖片擴大淡出的效果开始;
    
    //设置一个图片;
    UIImageView *niceView = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    niceView.image = [UIImage imageNamed:@"LaunchImage-800-667h"];
    
    //添加到场景
    [self.window addSubview:niceView];
    
    //放到最顶层;
    [self.window bringSubviewToFront:niceView];
    
    //开始设置动画;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:2.0];
    [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:self.window cache:YES];
    [UIView setAnimationDelegate:self];
    //這裡還可以設置回調函數;
    
    //[UIView setAnimationDidStopSelector:@selector(startupAnimationDone:finished:context:)];
    
    niceView.alpha = 0.0;
    niceView.frame = CGRectMake(-60, -85, 440, 635);
    [UIView commitAnimations];
    
    
   
    return YES;
}


#pragma mark 主界面
- (void)gotoMainTabbarControll {
    MLLog(@"进入主界面");
    
    [UIView animateWithDuration:1.0f animations:^{
        _scrollView.transform = CGAffineTransformMakeScale(2, 2);
        _scrollView.alpha = 0.5;
    } completion:^(BOOL finished) {
        [_scrollView removeFromSuperview];
        self.window.rootViewController = kVCFromSb(@"tabbar", @"Main");
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
    
    [self.window addSubview:scrollView];
    _scrollView = scrollView;
}














- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
