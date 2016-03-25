//
//  AboutUsViewController.m
//  GiftForYou
//
//  Created by zhumingwen on 16/3/13.
//  Copyright © 2016年 zhumingwen. All rights reserved.
//

#import "AboutUsViewController.h"

@interface AboutUsViewController ()

@end

@implementation AboutUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:250/255.0 green:246/255.0 blue:232/255.0 alpha:1.0];// 米黄色
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, kWindowW-20, kWindowH)];
    label.font = [UIFont systemFontOfSize:14.0];
    //label.textColor = [UIColor lightGrayColor];
    [self.view addSubview:label];
    label.numberOfLines = 0;
    
    
    label.text = @"    1.本软件不担保网络服务一定能满足用户的要求,也不担保网络服务不会中断,对网络的及时性,安全性,准确性也都不担保.\n    2.对于因电信系统或者互联网的故障,计算机故障或病毒,信息损坏或者丢失,计算机系统或者其他不可抗原因产生的损失,本软件不承担任何责任,或将尽力减少给用户造成的损失.\n    3.本软件提供的网络服务中包含的任何文本,图片,图形,音频,视频等仅仅用来学习和交流,上述材料均不得用于任何商业目的.\n    4.本软件是非营利性软件,如果所涉及的内容与其他软件所设计的内容相同,保证不会侵犯任何第三方的专利权,著作权,商标权,名誉权或其他任何合法权利!在此郑重承诺.\n    5.本软件在法律允许的最大范围内对本协议拥有相关解释权和修改权!\n\n\n\n\n\n\n\n\n\n\n\n\n";
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
