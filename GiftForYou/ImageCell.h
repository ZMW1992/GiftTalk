//
//  ImageCell.h
//  GiftForYou
//
//  Created by zhumingwen on 16/3/4.
//  Copyright © 2016年 zhumingwen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BannerModel.h"
#import <UIImageView+WebCache.h>
@interface ImageCell : UICollectionViewCell

@property (strong, nonatomic) IBOutlet UIImageView *picImageView;

@property (strong, nonatomic) BannerModel *tempModel;

@end
