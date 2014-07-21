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
    }
    return self;
}

- (instancetype)initWithName:(NSString *)name
{
    return [self initWithName:name notes:@"" rating:0 tags:[NSMutableArray array]];
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
    int tagLen = [self.tags count];
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
    NSInteger rating = arc4random() % 4;
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
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        _name = [aDecoder decodeObjectForKey:@"name"];
        _notes = [aDecoder decodeObjectForKey:@"notes"];
        _rating = [aDecoder decodeIntForKey:@"rating"];
        _tags = [aDecoder decodeObjectForKey:@"tags"];
    }
    return self;
}

@end
