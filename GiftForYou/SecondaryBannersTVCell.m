//
//  SecondaryBannersTVCell.m
//  GiftForYou
//
//  Created by zhumingwen on 16/3/8.
//  Copyright © 2016年 zhumingwen. All rights reserved.
//

#import "SecondaryBannersTVCell.h"
#import "ImageCell.h"
#import "BaseNetWorkManager.h"
#import "BannerModel.h"

#define SecondaryBannersUrlStr @"http://api.liwushuo.com/v2/secondary_banners?gender=1&generation=1"

@interface SecondaryBannersTVCell ()
@property (nonatomic, strong) NSMutableArray *dataSourceArr;//数据源数组

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;


@end

@implementation SecondaryBannersTVCell
//开辟数据源空间
- (NSMutableArray *)dataSourceArr {
    if (!_dataSourceArr) {
        self.dataSourceArr = [NSMutableArray array];
    }
    return _dataSourceArr;
}


- (void)awakeFromNib {
    //数据请求
    [self dataRequestWithUrlStr:SecondaryBannersUrlStr];
    
   self.scrollView.showsHorizontalScrollIndicator = NO;
    
}

//数据请求
- (void)dataRequestWithUrlStr:(NSString *)urlStr {
    
    [BaseNetWorkManager GET:urlStr parameters:nil success:^(id data) {
        [self modelDataByDic:data];
        
        MLLog(@"******************%@", data);
    } fail:^(NSError *error) {
        
    }];
}



//封装model
- (void)modelDataByDic:(NSDictionary *)data {
    NSArray *bannerArr = data[@"data"][@"secondary_banners"];
    for (NSDictionary *bannerDic in bannerArr) {
        BannerModel *bannerModel = [[BannerModel alloc] initWithDictionary:bannerDic];
        [self.dataSourceArr addObject:bannerModel];
    }
    //        [self.dataSourceArr removeObjectAtIndex:0];
    //        [self.dataSourceArr removeObjectAtIndex:0];
    
    [self addSubviews];
    
}


- (void)addSubviews {
    
    NSInteger imgCount = self.dataSourceArr.count;
    
    CGFloat imageW = 80;

    for (int i = 0; i< imgCount; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(15 + i * (imageW + 20), 5, imageW, 80)];
        
        [imageView sd_setImageWithURL:[NSURL URLWithString:[self.dataSourceArr[i] image_url]] placeholderImage:MLImage(@"ig_holder_image")];
        //imageView.layer.cornerRadius = 10;
        //imageView.clipsToBounds = YES;
        imageView.tag = i;
        imageView.userInteractionEnabled = YES;
        imageView.backgroundColor = [UIColor cyanColor];
        
        // 添加手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewClicked:)];
        [imageView addGestureRecognizer:tap];
        
        [self.scrollView addSubview:imageView];
    }
    
    _scrollView.contentSize = CGSizeMake(imgCount * (imageW + 20) + 10, 90);
    
}

- (void)viewClicked:(UITapGestureRecognizer *)sender {
    
    MLLog(@"点了");
    BannerModel *model = self.dataSourceArr[sender.view.tag];
    NSDictionary *dic = [self modelInfoWithTargetUrl:model.target_url];

    //注册通知中心并发送通知,跳转界面
    [[NSNotificationCenter defaultCenter] postNotificationName:@"jumpController" object:self userInfo:dic];
    
}


//字符串信息提取
- (NSDictionary *)modelInfoWithTargetUrl:(NSString *)targetUrl {
    
    NSRange typeRange = [targetUrl rangeOfString:@"type="];
    NSString *subStr = [targetUrl substringFromIndex:typeRange.location + typeRange.length];
    NSRange range = [subStr rangeOfString:@"&"];
    NSString *type = [subStr substringToIndex:range.location];
    NSDictionary *dic = [NSDictionary dictionary];
    
    if ([type isEqualToString:@"url"]) {
        NSRange urlRange = [targetUrl rangeOfString:@"url="];
        NSString *urlStr = [targetUrl substringFromIndex:urlRange.location + urlRange.length];
        NSRange aRang = [urlStr rangeOfString:@"&"];
        if (aRang.length != 0) {
            urlStr = [urlStr substringToIndex:aRang.location];
        }
        dic = @{@"type":@"url", @"url":urlStr};
    }else if ([type isEqualToString:@"post"]) {
        NSRange postRange = [targetUrl rangeOfString:@"post_id="];
        NSString *postID = [targetUrl substringFromIndex:postRange.location + postRange.length];
        NSRange aRang = [postID rangeOfString:@"&"];
        if (aRang.length != 0) {
            postID = [postID substringToIndex:aRang.location];
        }
        dic = @{@"type":@"post", @"post_id":postID};
    }else if ([type isEqualToString:@"topic"]) {
        NSRange topicRange = [targetUrl rangeOfString:@"topic_id="];
        NSString *topicID = [targetUrl substringFromIndex:topicRange.location + topicRange.length];
        NSRange aRang = [topicID rangeOfString:@"&"];
        if (aRang.length != 0) {
            topicID = [topicID substringToIndex:aRang.location];
        }
        dic = @{@"type":@"topic", @"topic_id":topicID};
    }
    
    
    return dic;
    
}






- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end
