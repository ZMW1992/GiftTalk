//
//  ClassifyViewController.m
//  GiftForYou
//
//  Created by zhumingwen on 16/3/2.
//  Copyright © 2016年 zhumingwen. All rights reserved.
//

#import "ClassifyViewController.h"
#import "CSGonglueViewController.h"
#import "CSLiwuViewController.h"
@interface ClassifyViewController () <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentControl;

- (IBAction)onClick:(UISegmentedControl *)sender;

@end

@implementation ClassifyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.scrollView.delegate = self;
    
    self.segmentControl.frame = CGRectMake(0, 0, 200, 20);
   
//    CSGonglueViewController *gonglueVC = self.childViewControllers[0];
//    CSLiwuViewController *liwuVC = self.childViewControllers[1];
    
//    gonglueVC.view.frame = CGRectMake(0, 0, KSCOLLVIEW_WIDTH, KSCOLLVIEW_HEIGHT);
//    liwuVC.view.frame = CGRectMake(KSCOLLVIEW_WIDTH, 0, KSCOLLVIEW_WIDTH, KSCOLLVIEW_HEIGHT);
    
    
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGPoint offset = scrollView.contentOffset;
    self.segmentControl.selectedSegmentIndex = offset.x/kWindowW;
}


- (IBAction)onClick:(UISegmentedControl *)sender {
    
    self.scrollView.contentOffset = CGPointMake(kWindowW*self.segmentControl.selectedSegmentIndex, 0);
    
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
