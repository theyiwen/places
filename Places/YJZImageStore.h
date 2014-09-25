//
//  YJZImageStore.h
//  Places
//
//  Created by Yiwen Zhan on 7/27/14.
//  Copyright (c) 2014 Yiwen Zhan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YJZImageStore : NSObject

+ (instancetype)sharedStore;
- (void)setImage:(UIImage *)img forKey:(NSString *)key;
- (UIImage *)imageForKey:(NSString *)key;
- (void)deleteImageForKey:(NSString *)key;
- (NSString *)imagePathForKey:(NSString *)key;

@end
