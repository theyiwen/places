//
//  YJZAnnotation.h
//  Places
//
//  Created by Yiwen Zhan on 10/25/14.
//  Copyright (c) 2014 Yiwen Zhan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "YJZPlace.h"

@interface YJZAnnotation : NSObject <MKAnnotation>

@property (nonatomic, copy) NSString *title;
@property (nonatomic, readwrite) CLLocationCoordinate2D coordinate;
@property (nonatomic) YJZPlace *place;

-(id) initWithTitle:(NSString *) title Coordinate: (CLLocationCoordinate2D)coordinate andPlace: (YJZPlace *)place;
@end
