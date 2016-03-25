//
//  MoreViewController.m
//  GiftForYou
//
//  Created by zhumingwen on 16/3/12.
//  Copyright © 2016年 zhumingwen. All rights reserved.
//

#import "MoreViewController.h"
#import "MJSettingItem.h"
#import "MJSettingGroup.h"
#import "MJSettingArrowItem.h"
#import "MJSettingSwitchItem.h"
#import "MJSettingGroup.h"
#import "MJSettingCell.h"
#import "AboutUsViewController.h"
#import "ShengMingViewController.h"

//#import <MBProgressHUD.h>
#import <SVProgressHUD.h>
@interface MoreViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) NSMutableArray *data;
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation MoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.data = [NSMutableArray array];
    self.navigationItem.title = @"更多";
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 30, 30);
    [button setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(backLastViewController:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = barButtonItem;
    self.tableView.backgroundColor = [UIColor colorWithRed:250/255.0 green:246/255.0 blue:232/255.0 alpha:1.0];// 米黄色
    self.tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:(UITableViewStyleGrouped)];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = NO;
    
    self.view = self.tableView;
    
    // 添加数据
    [self setupGroup0];
    [self setupGroup1];
    [self setupGroup2];
}

- (void)backLastViewController:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}



- (void)setupGroup0 {
    
    MJSettingItem *item1 = [MJSettingItem itemWithIcon:@"iconfont-tuijian@2x" title:@"向好友推荐礼物说"];
    MJSettingItem *item2 = [MJSettingArrowItem itemWithIcon:@"iconfont-xing@2x" title:@"给我们评分吧" destVcClass: nil];
    MJSettingItem *item3 = [MJSettingArrowItem itemWithIcon:@"iconfont-yijianfankui@2x" title:@"意见反馈" destVcClass: nil];
    
    MJSettingGroup *group0 = [[MJSettingGroup alloc] init];
    group0.items = @[item1, item2, item3];
    [_data addObject:group0];
    
    
    
}



- (void)setupGroup1 {
    
    MJSettingItem *item4 = [MJSettingArrowItem itemWithIcon:@"iconfont-shenfen@2x" title:@"我的身份" destVcClass:nil];
    MJSettingItem *item5 = [MJSettingArrowItem itemWithIcon:@"iconfont-laji@2x" title:@"清理缓存"];
    
    item5.option = ^{
    
//        NSUInteger size = [[SDImageCache sharedImageCache] getSize];
//        
//        NSString *cacheSize = [NSString stringWithFormat:@"清除缓存%ldM",size/1024/1024];
//        //    NSLog(@"%@",cacheSize);
//        
//        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"清除缓存" message:cacheSize preferredStyle:UIAlertControllerStyleAlert];
//        
//        [self showDetailViewController:alert sender:nil];
//        
//        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//            
//            //[self dismissViewControllerAnimated:YES completion:nil];
//        }];
        
//        [alert addAction:action];
        
        
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
        NSString *path = [paths lastObject];
        NSString *str = [NSString stringWithFormat:@"缓存大小%.1fM", [self folderSizeAtPath:path]];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:str message:@"确定要清除缓存吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alert.tag = 111;
        [alert show];
     
    };
  
    
    MJSettingSwitchItem *item6 = [MJSettingSwitchItem itemWithIcon:@"iconfont-huidanjieshou@2x" title:@"接收消息提醒"];
   
    
    MJSettingSwitchItem *item7 = [MJSettingSwitchItem itemWithIcon:@"iconfont-yueliang@2x" title:@"深夜显示开关"];
  
    
    MJSettingGroup *group1 = [[MJSettingGroup alloc] init];
    group1.items = @[item4, item5, item6, item7];
    [_data addObject:group1];
}


//alertView 的代理方法
//根据被点击按钮的索引处理点击事件
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //根据alertView 的tag确定alert
    if (alertView.tag == 111) {
        //如果点击取消 什么事情也不做
        if (buttonIndex == alertView.cancelButtonIndex) {
            ;
        }
        //如果点击确定 清除缓存
        if (buttonIndex == alertView.firstOtherButtonIndex) {
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
            NSString *path = [paths lastObject];
            NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:path];
            for (NSString *p in files) {
                NSError *error;
                NSString *Path = [path stringByAppendingPathComponent:p];
                if ([[NSFileManager defaultManager] fileExistsAtPath:Path]) {
                    [[NSFileManager defaultManager] removeItemAtPath:Path error:&error];
                }
            }
            
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"清除缓存成功" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//            [alert show];
           
            [SVProgressHUD showSuccessWithStatus:@"清除缓存成功"];
            
        }
    }
}



//计算单个文件大小
- (long long)fileSizeAtPath:(NSString*)filePath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}

//遍历文件夹获得文件夹大小，返回多少M
- (float)folderSizeAtPath:(NSString*) folderPath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:folderPath]) return 0;
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
    NSString* fileName;
    long long folderSize = 0;
    while ((fileName = [childFilesEnumerator nextObject]) != nil){
        NSString* fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
    }
    return folderSize/(1024.0*1024.0);
}


- (void)setupGroup2 {
    
    MJSettingItem *item8 = [MJSettingArrowItem itemWithIcon:@"iconfont-guanyuwomen@2x" title:@"关于我们" destVcClass:[AboutUsViewController class]];
   
    
    MJSettingItem *item9 = [MJSettingArrowItem itemWithIcon:@"iconfont-mianze@2x" title:@"免责声明" destVcClass:[ShengMingViewController class]];

    
    MJSettingItem *item10 = [MJSettingArrowItem itemWithIcon:@"iconfont-banbengengxin@2x" title:@"检查新版本"];
    
    item10.option = ^{
        

        [SVProgressHUD showWithStatus:@"正在拼命检查中....."];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [SVProgressHUD showErrorWithStatus:@"没有新版本..."];
        });
        
       // [SVProgressHUD dismiss];
      
    };
    
    MJSettingGroup *group2 = [[MJSettingGroup alloc] init];
    group2.items = @[item8, item9, item10];
    [_data addObject:group2];
}



#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.data.count;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    MJSettingGroup *group = self.data[section];
    return group.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 1.创建cell
    MJSettingCell *cell = [MJSettingCell cellWithTableView:tableView];
    
    // 2.给cell传递模型数据
    MJSettingGroup *group = self.data[indexPath.section];
    cell.item = group.items[indexPath.row];
    
    
    cell.switchOption = ^(UISwitch *switchView){
    
        [switchView addTarget:self action:@selector(handSwitchBtn:) forControlEvents:UIControlEventValueChanged];
        
        
    };
  
    
    // 3.返回cell
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 1.取消选中这行
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // 2.模型数据
    MJSettingGroup *group = self.data[indexPath.section];
    MJSettingItem *item = group.items[indexPath.row];
    
    if (item.option) { // block有值(点击这个cell,.有特定的操作需要执行)
        item.option();
    } else if ([item isKindOfClass:[MJSettingArrowItem class]]) { // 箭头
        MJSettingArrowItem *arrowItem = (MJSettingArrowItem *)item;
        
        // 如果没有需要跳转的控制器
        if (arrowItem.destVcClass == nil) return;
        
        UIViewController *vc = [[arrowItem.destVcClass alloc] init];
        vc.title = arrowItem.title;
        [self.navigationController pushViewController:vc  animated:YES];
    }
}


// 夜间模式//控制屏幕的透明度
- (void)handSwitchBtn:(UISwitch *)sender {
    MLLog(@"天黑了");
    if (sender.on == NO) {
        self.view.window.alpha = 1.0;
    }else{
        self.view.window.alpha = 0.6;
    }
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
