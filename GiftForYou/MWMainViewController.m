//
//  MWMainViewController.m
//  GiftForYou
//
//  Created by zhumingwen on 16/3/13.
//  Copyright © 2016年 zhumingwen. All rights reserved.
//

#import "MWMainViewController.h"
#import "SCNavTabBarController.h"
#import "HeaderViewController.h"
#import "OtherViewController.h"
@interface MWMainViewController ()

@end

@implementation MWMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"礼物说";
    
    [self configureSCNavTabBar];
}

- (void)configureSCNavTabBar {
    NSArray *group = @[@"精选", @"海淘", @"涨姿势", @"美食", @"创意生活", @"生日", @"礼物", @"结婚", @"纪念日", @"数码", @"爱运动", @"母婴", @"家居", @"情人节", @"爱读书", @"科技范", @"送爸妈", @"送基友"];
    NSArray *idArr = @[@"129", @"120", @"118", @"125", @"30", @"111", @"33", @"31", @"121", @"123", @"119", @"112", @"32", @"124", @"28", @"6", @"26"];
    NSMutableArray *vcs = [NSMutableArray arrayWithCapacity:group.count];
    HeaderViewController *headerVC = [HeaderViewController new];
    headerVC.title = group[0];
    [vcs addObject:headerVC];
    for (int i = 0; i < group.count-1; i++) {
        OtherViewController *otherVC = [[OtherViewController alloc] init];
        otherVC.ID = idArr[i];
        otherVC.title = group[i+1];
        [vcs addObject:otherVC];
        
    }
    
    SCNavTabBarController *navTBC = [[SCNavTabBarController alloc] init];
    navTBC.subViewControllers = vcs;
    
    
    navTBC.navTabBarColor = [UIColor colorWithRed:250/255.0 green:246/255.0 blue:232/255.0 alpha:1.0];// 米黄色
    navTBC.navTabBarLineColor = [UIColor redColor];
    // 显示箭头
    navTBC.showArrowButton = YES;
    navTBC.scrollAnimation = YES;
    [navTBC addParentController:self];
    
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
