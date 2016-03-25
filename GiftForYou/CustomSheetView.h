//
//  CustomSheetView.h
//  GiftForYou
//
//  Created by zhumingwen on 16/3/24.
//  Copyright © 2016年 zhumingwen. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CustomSheetViewDelegate <NSObject>

-(void)ShareButtonAction:(NSInteger *)buttonIndex;
@optional
-(void)FreeGeekgoToPointStore;

@end


@interface CustomSheetView : UIView<UIScrollViewDelegate>

/**
 *  展示控件
 *
 *  @param Title                       分享控件的标题
 *  @param titleArray                  分享按钮的标题数组
 *  @param imageArray                  分享按钮的图片数组
 *  @param PointArray                  分享奖励的积分数组
 *  @param ShowRedDot                  是否展示右上角的小红点
 *  @param ActivityName                检测用户后台是否设置了推广活动  设置nil则使用默认的取消按钮
 *  @param Middle                      YES:展示居中视图    NO:展示底部视图
 *
 */

-(id)initWithTitle:(NSString *)Title Delegate:(id<CustomSheetViewDelegate>)delegate titleArray:(NSArray *)titleArray imageArray:(NSArray *)imageArray PointArray:(NSArray *)pointArray ShowRedDot:(BOOL)ShowRedDot ActivityName:(NSString *)activityName Middle:(BOOL)Middle;
-(void)ShowInView:(UIView *)view;

@end
