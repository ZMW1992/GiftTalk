//
//  MineHeaderView.h
//  GiftForYou
//
//  Created by zhumingwen on 16/3/11.
//  Copyright © 2016年 zhumingwen. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MineHeaderViewDelegate <NSObject>

// 头像点击
- (void)mineHeaderViewOfIconViewDidClick;

// 登陆按钮
- (void)mineHeaderViewOfLogInBtnDidClick;

// 购物车
- (void)mineHeaderViewOfGouwucheViewDidClick;
// 订单
- (void)mineHeaderViewOfDingdanViewDidClick;
// 礼券
- (void)mineHeaderViewOfLiquanViewDidClick;
// 客服
- (void)mineHeaderViewOfKefuViewDidClick;


@end

@interface MineHeaderView : UIView

@property (strong, nonatomic) IBOutlet UIImageView *iconView;

@property (nonatomic, weak) id<MineHeaderViewDelegate> delegate;

+ (instancetype)topViewWithFrame:(CGRect)frame;

@end
