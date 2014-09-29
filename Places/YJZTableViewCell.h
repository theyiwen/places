//
//  YJZTableViewCell.h
//  Places
//
//  Created by Yiwen Zhan on 9/29/14.
//  Copyright (c) 2014 Yiwen Zhan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YJZTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *thumbnailView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *tagsLabel;

+ (UIImage *)thumbnailFromImage:(UIImage *)image;

@end
