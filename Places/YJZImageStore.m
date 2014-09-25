//
//  YJZImageStore.m
//  Places
//
//  Created by Yiwen Zhan on 7/27/14.
//  Copyright (c) 2014 Yiwen Zhan. All rights reserved.
//

#import "YJZImageStore.h"

@interface YJZImageStore ()

@property (nonatomic, strong) NSMutableDictionary *images;

@end

@implementation YJZImageStore

+ (instancetype)sharedStore
{
    static YJZImageStore *sharedStore = nil;
    
    if (!sharedStore) {
        sharedStore = [[self alloc] initPrivate];
    }
    return sharedStore;
}

- (instancetype)initPrivate
{
    self = [super init];
    if (self ) {
        //todo - archiving
        
        if (!_images) {
            _images = [[NSMutableDictionary alloc] init];
        }
    }
    return self;
}

- (void)setImage:(UIImage *)img forKey:(NSString *)key
{
    self.images[key] = img;
    
    //create path for image
    NSString *imagePath = [self imagePathForKey:key];
    
    //turn image into jpeg data
    NSData *data = UIImageJPEGRepresentation(img, 1);
    
    [data writeToFile:imagePath atomically:YES];
}

- (UIImage *)imageForKey:(NSString *)key
{
    UIImage *img = self.images[key];
    
    if (!img) {
        NSString *imagePath = [self imagePathForKey:key];
        
        img = [UIImage imageWithContentsOfFile:imagePath];
        
        if (img) {
            self.images[key] = img;
        }
        else {
            NSLog(@"Error: unable to find %@", [self imagePathForKey:key]);
        }
    }
    
    return img;
    
}

- (void)deleteImageForKey:(NSString *)key
{
    if (!key){
        return;
    }
    [self.images removeObjectForKey:key];
    
    NSString *imagePath = [self imagePathForKey:key];
    [[NSFileManager defaultManager] removeItemAtPath:imagePath error:nil];
}

- (NSString *)imagePathForKey:(NSString *)key
{
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [documentDirectories firstObject];
    return [documentDirectory stringByAppendingPathComponent:key];
}

@end
