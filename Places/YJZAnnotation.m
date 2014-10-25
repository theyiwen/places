//
//  YJZAnnotation.m
//  Places
//
//  Created by Yiwen Zhan on 10/25/14.
//  Copyright (c) 2014 Yiwen Zhan. All rights reserved.
//

#import "YJZAnnotation.h"


@implementation YJZAnnotation

-(id) initWithTitle:(NSString *)title AndCoordinate:(CLLocationCoordinate2D)coordinate
{
    self.title = title;
    self.coordinate = coordinate;
    return self;
}

@end
