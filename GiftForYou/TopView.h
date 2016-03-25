//
//  TopView.h
//  GiftForYou
//
//  Created by zhumingwen on 16/3/6.
//  Copyright © 2016年 zhumingwen. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TopViewDelegate <NSObject>

- (void)topViewOfImageViewClicked:(NSString *)ID title:(NSString *)title;
- (void)topViewBtnClicked;

@end

@interface TopView : UIView

@property (nonatomic, weak) id<TopViewDelegate> delegate;

+ (instancetype)topViewWithFrame:(CGRect)frame dataArr:(NSArray *)dataArr;

@end
