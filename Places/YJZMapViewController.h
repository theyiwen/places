//
//  YJZMapViewController.h
//  Places
//
//  Created by Yiwen Zhan on 10/24/14.
//  Copyright (c) 2014 Yiwen Zhan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface YJZMapViewController : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;




@end
