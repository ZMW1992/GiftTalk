//
//  MacroHeader.h
//  GiftForYou
//
//  Created by lanouhn on 16/3/2.
//  Copyright © 2016年 zhumingwen. All rights reserved.
//

#ifndef MacroHeader_h
#define MacroHeader_h

//通过RGB设置颜色
#define kRGBColor(R,G,B) [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:1.0]

#define kWindowH   [UIScreen mainScreen].bounds.size.height //应用程序的屏幕高度
#define kWindowW    [UIScreen mainScreen].bounds.size.width  //应用程序的屏幕宽度

//滚动视图的宽
#define KSCOLLVIEW_WIDTH CGRectGetWidth([UIScreen mainScreen].bounds)
//滚动视图的高
#define KSCOLLVIEW_HEIGHT CGRectGetHeight([UIScreen mainScreen].bounds)

#define kAppDelegate ((AppDelegate*)([UIApplication sharedApplication].delegate))

#define kStoryboard(StoryboardName) [UIStoryboard storyboardWithName:StoryboardName bundle:nil]

//通过Storyboard ID 在对应Storyboard中获取场景对象
#define kVCFromSb(storyboardId, storyboardName)     [[UIStoryboard storyboardWithName:storyboardName bundle:nil] \
instantiateViewControllerWithIdentifier:storyboardId]

//移除iOS7之后，cell默认左侧的分割线边距
#define kRemoveCellSeparator \
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{\
cell.separatorInset = UIEdgeInsetsZero;\
cell.layoutMargins = UIEdgeInsetsZero; \
cell.preservesSuperviewLayoutMargins = NO; \
}

// 登录
#define kLogin  LogInViewController *loginVC = [LogInViewController new];\
UINaviViewController *navi = [[UINaviViewController alloc] initWithRootViewController:loginVC];\
navi.hidesBottomBarWhenPushed = YES;








#endif /* MacroHeader_h */
