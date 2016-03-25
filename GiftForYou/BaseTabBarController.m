//
//  BaseTabBarController.m
//  GiftForYou
//
//  Created by zhumingwen on 16/3/2.
//  Copyright © 2016年 zhumingwen. All rights reserved.
//

#import "BaseTabBarController.h"

@interface BaseTabBarController ()

@end

@implementation BaseTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    NSMutableDictionary *textSelectedAtt = [NSMutableDictionary dictionary];
//    textSelectedAtt[NSForegroundColorAttributeName] = kRGBColor(255, 160, 21);
//    [self.tabBarItem setTitleTextAttributes:textSelectedAtt forState:UIControlStateSelected];
    
    self.tabBar.tintColor = [UIColor redColor];
    
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
