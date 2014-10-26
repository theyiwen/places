//
//  YJZAnnotation.m
//  Places
//
//  Created by Yiwen Zhan on 10/25/14.
//  Copyright (c) 2014 Yiwen Zhan. All rights reserved.
//

#import "YJZAnnotation.h"


@implementation YJZAnnotation

-(id) initWithTitle:(NSString *) title Coordinate:(CLLocationCoordinate2D)coordinate andPlace: (YJZPlace *)place
{
    self.title = title;
    self.coordinate = coordinate;
    self.place = place;
    return self;
}

@end
