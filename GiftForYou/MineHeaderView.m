//
//  MineHeaderView.m
//  GiftForYou
//
//  Created by zhumingwen on 16/3/11.
//  Copyright © 2016年 zhumingwen. All rights reserved.
//

#import "MineHeaderView.h"

@interface MineHeaderView ()



@property (strong, nonatomic) IBOutlet UIImageView *gouwuche;

@property (strong, nonatomic) IBOutlet UIImageView *dingdan;

@property (strong, nonatomic) IBOutlet UIImageView *liquan;

@property (strong, nonatomic) IBOutlet UIImageView *kefu;


@end


@implementation MineHeaderView

- (IBAction)loginBtn:(UIButton *)sender {
    
   // MLLog(@"点了登陆");
    
   
    if ([self.delegate conformsToProtocol:@protocol(MineHeaderViewDelegate)] && [_delegate respondsToSelector:@selector(mineHeaderViewOfLogInBtnDidClick)]) {
        
        [_delegate mineHeaderViewOfLogInBtnDidClick];
    }
    
}


+ (instancetype)topViewWithFrame:(CGRect)frame {
    
  // MineHeaderView *headerView = [[[NSBundle mainBundle] loadNibNamed:@"MineHeaderView" owner:nil options:nil] lastObject];
    
    MineHeaderView *headerView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
    
    headerView.frame = frame;
    
  


   return headerView;
}


- (void)awakeFromNib {
 
    self.iconView.layer.cornerRadius = 30;
    self.iconView.layer.masksToBounds = YES;
    
  
    // 添加手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewClicked:)];
    [self.iconView addGestureRecognizer:tap];
    
    
    [self.gouwuche addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gouwucheClick:)]];
    
    [self.dingdan addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dingdanClick:)]];
    
    [self.liquan addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(liquanClick:)]];
    
    [self.kefu addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(kefuClick:)]];

}

// 头像点击
- (void)viewClicked:(UITapGestureRecognizer *)tap {
    
    if ([_delegate conformsToProtocol:@protocol(MineHeaderViewDelegate)]) {
        if ([_delegate respondsToSelector:@selector(mineHeaderViewOfIconViewDidClick)]) {
            
            [_delegate mineHeaderViewOfIconViewDidClick];
        }
    }
  
}

- (void)gouwucheClick:(UIImageView *)sender {
   
//    if ([self.delegate conformsToProtocol:@protocol(MineHeaderViewDelegate)] && [_delegate respondsToSelector:@selector(mineHeaderViewOfGouwucheViewDidClick)]) {
//        
//        [_delegate mineHeaderViewOfGouwucheViewDidClick];
//    }
    
    if ([_delegate conformsToProtocol:@protocol(MineHeaderViewDelegate)]) {
        if ([_delegate respondsToSelector:@selector(mineHeaderViewOfGouwucheViewDidClick)]) {
            
            [_delegate mineHeaderViewOfGouwucheViewDidClick];
        }
    }

    
}


- (void)dingdanClick:(UIImageView *)sender {
    
    if ([self.delegate conformsToProtocol:@protocol(MineHeaderViewDelegate)] && [_delegate respondsToSelector:@selector(mineHeaderViewOfDingdanViewDidClick)]) {
        
        [_delegate mineHeaderViewOfDingdanViewDidClick];
    }
}


- (void)liquanClick:(UIImageView *)sender {
    
    if ([self.delegate conformsToProtocol:@protocol(MineHeaderViewDelegate)] && [_delegate respondsToSelector:@selector(mineHeaderViewOfLiquanViewDidClick)]) {
        
        [_delegate mineHeaderViewOfLiquanViewDidClick];
    }
}


- (void)kefuClick:(UIImageView *)sender {
    
    if ([self.delegate conformsToProtocol:@protocol(MineHeaderViewDelegate)] && [_delegate respondsToSelector:@selector(mineHeaderViewOfKefuViewDidClick)]) {
        
        [_delegate mineHeaderViewOfKefuViewDidClick];
    }
}





























































//- (instancetype)initWithFrame:(CGRect)frame {
//    if (self = [super initWithFrame:frame]) {
//        
//        [self addSubViews];
//    }
//    
//    return self;
//}
//
//- (void)addSubViews {
//    
//    UIImageView *bgIV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64, kWindowW, kWindowW / 2 - 10)];
//    bgIV.image = MLImage(@"Me_ProfileBackground@2x.jpg");
//    [self addSubview:bgIV];
//    
//    
//    CGFloat iconWH = bgIV.size.height / 2;
//    UIImageView *iconIV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 20, iconWH, iconWH)];
//    iconIV.layer.cornerRadius = iconWH / 2;
//    iconIV.clipsToBounds = YES;
//    iconIV.centerX = kWindowW / 2;
//    iconIV.image = MLImage(@"ig_profile_photo_default");
//    [bgIV addSubview:iconIV];
//    
//    UIButton *logInBtn = [UIButton buttonWithType:(UIButtonTypeRoundedRect)];
//    [logInBtn setTitle:@"点击登录" forState:(UIControlStateNormal)];
//    logInBtn.frame = CGRectMake(0, iconIV.maxY + 10, 60, 30);
//    [bgIV addSubview:logInBtn];
//    
//    
//}




@end
