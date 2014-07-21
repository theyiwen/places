//
//  YJZPlaceStore.m
//  Places
//
//  Created by Yiwen Zhan on 7/19/14.
//  Copyright (c) 2014 Yiwen Zhan. All rights reserved.
//

#import "YJZPlaceStore.h"

@interface YJZPlaceStore ()

//@property (nonatomic) NSMutableArray *privatePlaces;

@end

@implementation YJZPlaceStore

+ (instancetype)sharedStore
{
    static YJZPlaceStore *sharedStore = nil;
    
    if (!sharedStore) {
        sharedStore = [[self alloc] initPrivate];
    }
    return sharedStore;
}

// Private init with four mutable arrays, one for each rating type
- (instancetype)initPrivate
{
    self = [super init];
    if (self) {

        NSString *path = [self itemArchivePath];
        _places = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
        
        if (!_places) {
            _places = @[[NSMutableArray array],
                        [NSMutableArray array],
                        [NSMutableArray array],
                        [NSMutableArray array]];
        }
    }
    return self;
}

- (YJZPlace *)addPlace:(YJZPlace *)place
{
    [self.places[place.rating] addObject:place];
    return place;
}

- (void)updatePlace:(YJZPlace *)place name:(NSString *)name notes:(NSString *)notes rating:(int)rating tags:(NSMutableArray *)tags
{
    place.name = name;
    place.tags = tags;
    place.notes = notes;
    if (place.rating != rating)
    {
        [self updateRating:rating forPlace:place];
    }
}

- (void)updateRating:(int)rating forPlace:(YJZPlace *)place
{
    [self removePlace:place];
    place.rating = rating;
    [self addPlace:place];
}

- (void)removePlace:(YJZPlace *)place
{
    if (self.places[place.rating])
    {
        [self.places[place.rating] removeObjectIdenticalTo:place];
    }
}

- (NSString *)itemArchivePath
{
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentDirectory = [documentDirectories firstObject];
    
    return [documentDirectory stringByAppendingPathComponent:@"items.archive"];
}

- (BOOL)saveChanges
{
    NSString *path = [self itemArchivePath];
    return [NSKeyedArchiver archiveRootObject:self.places toFile:path];
}

@end
