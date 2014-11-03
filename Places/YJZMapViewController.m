//
//  YJZMapViewController.m
//  Places
//
//  Created by Yiwen Zhan on 10/24/14.
//  Copyright (c) 2014 Yiwen Zhan. All rights reserved.
//

#import "YJZMapViewController.h"
#import "YJZAnnotation.h"
#import "YJZPlaceStore.h"
#import "YJZPlace.h"
#import "YJZDetailViewController.h"
#import "YJZConstants.h"

@import CoreLocation;

@interface YJZMapViewController ()
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (nonatomic) BOOL didZoom;
@end

@implementation YJZMapViewController

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.tabBarItem.title = @"Map";
        self.didZoom = false;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    _mapView.showsUserLocation = YES;
    
    // start off by default in San Francisco
    MKCoordinateRegion newRegion;
    newRegion.center.latitude = 37.786996;
    newRegion.center.longitude = -122.440100;
    newRegion.span.latitudeDelta = 0.020;
    newRegion.span.longitudeDelta = 0.020;
   
    CLLocationCoordinate2D coord;
    coord.latitude = 37.786996;
    coord.longitude = -122.440100;
    YJZAnnotation *placeAnnot = [[YJZAnnotation alloc] initWithTitle:@"default" Coordinate:coord andPlace:nil];
    [self.mapView addAnnotations:@[placeAnnot]];
    
    [self.mapView setUserTrackingMode:MKUserTrackingModeFollow];
    NSLog(@"Set to default");

    [self.mapView setRegion:newRegion animated:YES];
    [self.mapView addAnnotations:[self realLocations]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setTranslucent:NO];
    [self.navigationController.navigationBar setBarTintColor:ORANGE_COLOR];
    [self.navigationController.navigationBar
     setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    self.navigationItem.title = @"search";


}
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    if (!self.didZoom)
    {
        self.mapView.centerCoordinate = userLocation.location.coordinate;
        self.didZoom = true;
        NSLog(@"Set to user");
    }
}

- (NSMutableArray *)realLocations
{
    NSMutableArray *annot = [[NSMutableArray alloc] init];
    
    for (int i=0; i<4; i++) {
        int len = [[[YJZPlaceStore sharedStore] places][i] count];
        for (int j=0; j<len; j++)
        {
            CLLocationCoordinate2D coord;
            YJZPlace *place = [[YJZPlaceStore sharedStore] places][i][j];
            coord.latitude = place.latitude;
            coord.longitude = place.longitude;
            YJZAnnotation *placeAnnot = [[YJZAnnotation alloc] initWithTitle:place.name Coordinate:coord andPlace:place];
            [annot addObject:placeAnnot];
        }
    }
    return annot;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    NSLog(@"Tapped");
    id <MKAnnotation> annotation = [view annotation];
    if ([annotation isKindOfClass:[YJZAnnotation class]])
    {
        YJZDetailViewController *dvc = [[YJZDetailViewController alloc] initWithPlace:((YJZAnnotation *) annotation).place];
        [self.navigationController pushViewController:dvc animated:YES];
    }


}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{

    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    
    MKAnnotationView *returnedAnnotationView =
    [mapView dequeueReusableAnnotationViewWithIdentifier:NSStringFromClass([YJZAnnotation class])];
    if (returnedAnnotationView == nil)
    {
        returnedAnnotationView =
        [[MKAnnotationView alloc] initWithAnnotation:annotation
                                        reuseIdentifier:NSStringFromClass([YJZAnnotation class])];
        returnedAnnotationView.canShowCallout = YES;
        returnedAnnotationView.image = [UIImage imageNamed:@"pin.png"];
        UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        [rightButton addTarget:nil action:nil forControlEvents:UIControlEventTouchUpInside];
        returnedAnnotationView.rightCalloutAccessoryView = rightButton;
    }
    
    return returnedAnnotationView;

}

@end
