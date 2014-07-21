//
//  YJZPlace.h
//  Places
//
//  Created by Yiwen Zhan on 7/19/14.
//  Copyright (c) 2014 Yiwen Zhan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YJZPlace : NSObject <NSCoding>

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *notes;

// Q: is there an enum object?
@property (nonatomic) int rating;

// Q: should this be copy? strong?
@property (nonatomic) NSMutableArray *tags;

- (instancetype)initWithName:(NSString *)name
                       notes:(NSString *)notes
                      rating:(int)rating
                        tags:(NSMutableArray *)tags;

- (instancetype)initWithName:(NSString *)name;

- (NSString *)getTagsAsString;

- (void)setTagsWithString:(NSString *)str;

+ (YJZPlace *)randomPlace;

@end