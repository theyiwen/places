//
//  YJZPlaceStore.h
//  Places
//
//  Created by Yiwen Zhan on 7/19/14.
//  Copyright (c) 2014 Yiwen Zhan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YJZPlace.h"

@interface YJZPlaceStore : NSObject

@property (nonatomic, readonly) NSArray *places;

+ (instancetype)sharedStore;
- (YJZPlace *)addPlace:(YJZPlace *)place;
- (void)removePlace:(YJZPlace *)place;
- (void)updatePlace:(YJZPlace *)place
               name:(NSString *)name
              notes:(NSString *)notes
             rating:(int)rating
               tags:(NSMutableArray *)tags;
- (void)updateRating:(int)rating
            forPlace:(YJZPlace *)place;

- (BOOL)saveChanges;
@end
