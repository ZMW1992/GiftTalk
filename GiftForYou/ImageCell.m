//
//  ImageCell.m
//  GiftForYou
//
//  Created by zhumingwen on 16/3/4.
//  Copyright © 2016年 zhumingwen. All rights reserved.
//

#import "ImageCell.h"


@interface ImageCell ()

@end


@implementation ImageCell

- (void)awakeFromNib {
    // Initialization code
}


- (void)setTempModel:(BannerModel *)tempModel {
    _tempModel = tempModel;
    
   // SDWebImageManager *manager = [SDWebImageManager sharedManager];
   // manager.delegate = self;
    
    
    [self.picImageView sd_setImageWithURL:[NSURL URLWithString:tempModel.image_url] placeholderImage:[UIImage imageNamed:@""]];
 
//    [manager downloadImageWithURL:[NSURL URLWithString:tempModel.image_url] options:0 width:160 height:160 progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
//        if (image) {
//            self.picImageView.image = image;
//        }
//    }];
    
}



//- (UIImage *)imageManager:(SDWebImageManager *)imageManager width:(CGFloat)width height:(CGFloat)height transformDownloadedImage:(UIImage *)image withURL:(NSURL *)imageURL {
//    
//    // Create a graphics image context
//    UIGraphicsBeginImageContext(CGSizeMake(width, height));
//    // Tell the old image to draw in this new context, with the desired
//    // new size
//    [image drawInRect:CGRectMake(0,0,width, height)];
//    // Get the new image from the context
//    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
//    // End the context
//    UIGraphicsEndImageContext();
//    return newImage;
//}

@end
