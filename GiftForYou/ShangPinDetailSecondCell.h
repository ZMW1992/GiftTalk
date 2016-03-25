//
//  ShangPinDetailSecondCell.h
//  GiftForYou
//
//  Created by zhumingwen on 16/3/10.
//  Copyright © 2016年 zhumingwen. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ShangPinDetailModel;
typedef void(^ShangPinDetailWebViewBolck)(CGFloat height);
@interface ShangPinDetailSecondCell : UITableViewCell
@property (strong, nonatomic) UIScrollView *scrollView;

@property (strong, nonatomic) UIWebView *webView;

@property (strong, nonatomic) UITableView *tableView;

@property (nonatomic, strong) ShangPinDetailModel *model;
@property (nonatomic, copy) NSString *urlID;
@property (nonatomic, copy) ShangPinDetailWebViewBolck shangPinDetailWebViewBolck;
@end
