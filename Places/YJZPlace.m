//
//  YJZPlace.m
//  Places
//
//  Created by Yiwen Zhan on 7/19/14.
//  Copyright (c) 2014 Yiwen Zhan. All rights reserved.
//

#import "YJZPlace.h"

@implementation YJZPlace

- (instancetype)initWithName:(NSString *)name
                       notes:(NSString *)notes
                      rating:(int)rating
                        tags:(NSMutableArray *)tags
{
    self = [super init];
    if (self) {
        _name = name;
        _notes = notes;
        _rating = rating;
        _tags = tags;
        NSUUID *uuid = [[NSUUID alloc] init];
        NSString *key = [uuid UUIDString];
        _key = key;
    }
    return self;
}

- (instancetype)initWithName:(NSString *)name
{
    return [self initWithName:name notes:@"" rating:0 tags:[NSMutableArray array]];
}

- (instancetype)initWithFSData:(NSDictionary *)data rating:(int)rating
{
    self = [super init];
    if(self) {
        _fsID = data[@"id"];
        _name = data[@"name"];
        _streetName = data[@"location"][@"address"];
        NSArray *cat = data[@"categories"];
        _fsCategories = [[NSMutableArray alloc] init];
        _rating = rating;
        for (int i=0; i<[cat count]; i++)
            [self.fsCategories addObject:cat[i][@"name"] ];
        
        NSUUID *uuid = [[NSUUID alloc] init];
        NSString *key = [uuid UUIDString];
        _key = key;
        return self;
    }
    return nil;
}

- (NSString *)description
{
    NSString *descStr =
    [NSString stringWithFormat:@"Place: %@ \r\nNotes:%@ \r\nRating:%d \r\nTags: %@",
     self.name, self.notes, self.rating, self.tags];
    
    return descStr;
}

- (NSString *)getTagsAsString
{
    int tagLen = (int)[self.tags count];
    if (tagLen == 0)
        return @"";
    else {
        NSMutableString *tagStr = [[NSMutableString alloc] initWithString:self.tags[0]];
        for (int i=1; i<tagLen; i++) {
            [tagStr appendString:[NSString stringWithFormat:@", %@",self.tags[i]]];
        }
        return tagStr;
    }
}


- (NSString *)getCatsAsString
{
    int tagLen = (int)[self.fsCategories count];
    if (tagLen == 0)
        return @"";
    else {
        NSMutableString *tagStr = [[NSMutableString alloc] initWithString:self.fsCategories[0]];
        for (int i=1; i<tagLen; i++) {
            [tagStr appendString:[NSString stringWithFormat:@", %@",self.fsCategories[i]]];
        }
        return tagStr;
    }
}

- (void)setTagsWithString:(NSString *)str
{
    self.tags = [[NSMutableArray alloc] initWithArray:[str componentsSeparatedByString:@", "]];
}

+ (YJZPlace *)randomPlace
{
    NSArray *names = @[@"nopa",@"tradition",@"mission beach cafe",@"izakaya sozai",@"orenchi",
                       @"benu",@"state bird provisions",@"smuggler's cove",@"o'toro",@"birite"];
    NSInteger namesIndex = arc4random() % [names count];
    
    NSArray *tags = @[@"brunch",@"ramen",@"healthy",@"dinner",@"snack"];
    NSInteger tagIndex = arc4random() % [tags count];
    int rating = arc4random() % 4;
    NSMutableArray *newTags = [NSMutableArray arrayWithObject:tags[tagIndex]];
    
    return [[YJZPlace alloc] initWithName:names[namesIndex]
                                    notes:@""
                                   rating:rating
                                     tags:newTags];
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.notes forKey:@"notes"];
    [aCoder encodeInt:self.rating forKey:@"rating"];
    [aCoder encodeObject:self.tags forKey:@"tags"];
    [aCoder encodeObject:self.fsID forKey:@"fsID"];
    [aCoder encodeObject:self.fsCategories forKey:@"fsCategories"];
    [aCoder encodeObject:self.streetName forKey:@"streetName"];

}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        _name = [aDecoder decodeObjectForKey:@"name"];
        _notes = [aDecoder decodeObjectForKey:@"notes"];
        _rating = [aDecoder decodeIntForKey:@"rating"];
        _tags = [aDecoder decodeObjectForKey:@"tags"];
        _fsCategories = [aDecoder decodeObjectForKey:@"fsCategories"];
        _fsID = [aDecoder decodeObjectForKey:@"fsID"];
        _streetName = [aDecoder decodeObjectForKey:@"streetName"];

    }
    return self;
}

@end
