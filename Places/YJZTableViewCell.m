//
//  YJZTableViewCell.m
//  Places
//
//  Created by Yiwen Zhan on 9/29/14.
//  Copyright (c) 2014 Yiwen Zhan. All rights reserved.
//

#import "YJZTableViewCell.h"

@implementation YJZTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (UIImage *)thumbnailFromImage:(UIImage *)image
{
    CGSize origImageSize = image.size;
    CGRect newRect = CGRectMake(0,0,64,64);
    UIGraphicsBeginImageContextWithOptions(newRect.size, NO, 0.0);
    float ratio = newRect.size.width / origImageSize.width;
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:newRect cornerRadius:5.0];
    
    [path addClip];
    
    CGRect projectRect;
    projectRect.size.width = ratio * origImageSize.width * 1.5;
    projectRect.size.height = ratio * origImageSize.height * 1.5;
    projectRect.origin.x = (newRect.size.width - projectRect.size.width)/2.0;
    projectRect.origin.y = (newRect.size.height - projectRect.size.height) / 2.0;
    
    [image drawInRect:projectRect];
    
    UIImage *smallImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return smallImage;
}

@end
