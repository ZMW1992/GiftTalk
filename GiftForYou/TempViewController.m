//
//  TempViewController.m
//  GiftForYou
//
//  Created by zhumingwen on 16/3/13.
//  Copyright © 2016年 zhumingwen. All rights reserved.
//

#import "TempViewController.h"
#import "SHBQRView.h"
@interface TempViewController ()<SHBQRViewDelegate>

@end

@implementation TempViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 新建扫描视图控制器
    SHBQRView *qrView = [[SHBQRView alloc] initWithFrame:self.view.bounds];
    qrView.delegate = self;
    [self.view addSubview:qrView];

}



// 扫描结果方法
- (void)qrView:(SHBQRView *)view ScanResult:(NSString *)result {
    [view stopScan];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:[NSString stringWithFormat:@"扫描结果：%@", result] preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"Sure" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        // 重新扫描
        [view startScan];
    }]];
    [self presentViewController:alert animated:true completion:nil];
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
