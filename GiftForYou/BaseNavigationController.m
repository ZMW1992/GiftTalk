//
//  BaseNavigationController.m
//  GiftForYou
//
//  Created by zhumingwen on 16/3/2.
//  Copyright © 2016年 zhumingwen. All rights reserved.
//

#import "BaseNavigationController.h"

@interface BaseNavigationController ()

@end

@implementation BaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /** 设置导航栏不透明 */
    self.navigationBar.translucent = NO;
    /** 导航栏的样式 */
    // 背景色
    self.navigationBar.barTintColor = kRGBColor(239, 48, 50);
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[NSForegroundColorAttributeName] = kRGBColor(244, 244, 244);
    dic[NSFontAttributeName] = [UIFont boldSystemFontOfSize:20];
    self.navigationBar.titleTextAttributes = dic;
    // 控件颜色
    self.navigationBar.tintColor = kRGBColor(244, 244, 244);

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
