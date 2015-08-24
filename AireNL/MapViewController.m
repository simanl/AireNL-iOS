//
//  MapViewController.m
//  AireNL
//
//  Created by Daniel Lozano on 7/21/15.
//  Copyright (c) 2015 Icalia Labs. All rights reserved.
//

#import "MapViewController.h"

#import <MapKit/MapKit.h>
#import "MKMapView+ZoomLevel.h"

#import "MeasurementLocation.h"
#import "UIColor+ILColor.h"

@interface MapViewController () <CLLocationManagerDelegate, MKMapViewDelegate>

@property (nonatomic) CLLocationManager *locationManager;

@property (nonatomic) MKMapRect monterreyRect;
@property (nonatomic) MKMapRect lastGoodMapRect;
@property (nonatomic) BOOL manuallyChangingMapRect;

@end

@implementation MapViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = @"Puntos de Medicion";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemDone
                                                                                           target: self
                                                                                           action: @selector(didSelectDone)];

    [self setUpLocationManager];
    [self setNavBarImageWithType: self.type];
    
    
    CLLocationCoordinate2D monterreyCenter = CLLocationCoordinate2DMake(25.670104, -100.309675);
    CLLocationDistance latitudeDistance = 50000;
    CLLocationDistance longitudeDistance = 50000;
    MKCoordinateRegion monterreyRegion = MKCoordinateRegionMakeWithDistance(monterreyCenter, latitudeDistance, longitudeDistance);
    self.monterreyRect = [self MKMapRectForCoordinateRegion: monterreyRegion];
    
    [self.mapView setCenterCoordinate: monterreyCenter zoomLevel: 5 animated: YES];
    [self addAnnotations];
    
    self.mapView.showsUserLocation = YES;
    self.mapView.delegate = self;

    // "Zoom" to a coordinate
    //    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(monterreyCenter, 100, 100);
    //    MKCoordinateRegion adjustedRegion = [self.mapView regionThatFits: viewRegion];
    //    [self.mapView setRegion: adjustedRegion animated: YES];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)didSelectDone
{
    [self dismissViewControllerAnimated: YES completion: nil];
}

- (void)setNavBarImageWithType:(MapViewControllerNavBarType)type
{    
    NSString *imageName;
    switch (type) {
        case MapViewControllerNavBarTypeDay:
            imageName = @"NavBarDay";
            break;
        case MapViewControllerNavBarTypeSunset:
            imageName = @"NavBarSunset";
            break;
        case MapViewControllerNavBarTypeNight:
            imageName = @"NavBarNight";
            break;
        default:
            return;
            break;
    }
    
    UIImage *navBarImage = [UIImage imageNamed: imageName];
    [self.navigationController.navigationBar setBackgroundImage: navBarImage forBarMetrics: UIBarMetricsDefault];
}

- (void)setUpLocationManager
{
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    
    if (status == kCLAuthorizationStatusNotDetermined) {
        [self askLocationPermision];
    }else if (status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        [self startTrackingUser];
    }else if (status == kCLAuthorizationStatusDenied){
        NSLog(@"WARNING: LOCATION TRACKING DENIED");
    }
    
}

- (void)askLocationPermision
{
    NSLog(@"ASKING LOCATION PERMISSION");
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }
}

- (void)startTrackingUser
{
    self.mapView.showsUserLocation = YES;
//    [self.mapView setUserTrackingMode: MKUserTrackingModeFollow];
}

#pragma mark - CLLocationManager Delegate

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    switch (status) {
        case kCLAuthorizationStatusNotDetermined:
            [self askLocationPermision];
            break;
        case kCLAuthorizationStatusAuthorizedWhenInUse:
            [self startTrackingUser];
            break;
        default:
            break;
    }
}

#pragma mark - MKMapViewDelegate

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    if (self.manuallyChangingMapRect) {
        return;
    }
    
    BOOL mapContains = MKMapRectContainsRect(mapView.visibleMapRect, self.monterreyRect);
    BOOL mapIntersects = MKMapRectIntersectsRect(mapView.visibleMapRect, self.monterreyRect);
    
    if (mapContains) {
        
        // The overlay is entirely inside the map view but adjust if user is zoomed out too much...
        double widthRatio = self.monterreyRect.size.width / mapView.visibleMapRect.size.width;
        double heightRatio = self.monterreyRect.size.height / mapView.visibleMapRect.size.height;
        
        // adjust ratios as needed
        if ((widthRatio < 0.6) || (heightRatio < 0.6)) {
            self.manuallyChangingMapRect = YES;
            [mapView setVisibleMapRect: self.monterreyRect animated: YES];
            self.manuallyChangingMapRect = NO;
        }
        
    } else if (!mapIntersects) {
        
        // Overlay is no longer visible in the map view.
        // Reset to last "good" map rect...
        
        self.manuallyChangingMapRect = YES;
        [mapView setVisibleMapRect: self.lastGoodMapRect animated:YES];
        self.manuallyChangingMapRect = NO;
        
    } else {
        self.lastGoodMapRect = mapView.visibleMapRect;
    }
    
}

- (MKAnnotationView *)mapView:(MKMapView *)theMapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    static NSString *SFAnnotationIdentifier = @"AnnotationIdentifier";
    MKPinAnnotationView *pinView =
    (MKPinAnnotationView *)[self.mapView dequeueReusableAnnotationViewWithIdentifier: SFAnnotationIdentifier];
    
    if (!pinView){
        if ([annotation isKindOfClass: [MeasurementLocation class]]) {
            MKAnnotationView *annotationView = [[MKAnnotationView alloc] initWithAnnotation: annotation reuseIdentifier: SFAnnotationIdentifier];
            MeasurementLocation *measurementLocationAnnotation = (MeasurementLocation *)annotation;
            
            annotationView.image = [measurementLocationAnnotation annotationImage];
            annotationView.canShowCallout = YES;
            return annotationView;
        }
        
    }else{
        pinView.annotation = annotation;
    }
    
    return pinView;
}

#pragma mark - Map Helper's

- (MKMapRect)MKMapRectForCoordinateRegion:(MKCoordinateRegion)region
{
    MKMapPoint a = MKMapPointForCoordinate(CLLocationCoordinate2DMake(
                                                                      region.center.latitude + region.span.latitudeDelta / 2,
                                                                      region.center.longitude - region.span.longitudeDelta / 2));
    MKMapPoint b = MKMapPointForCoordinate(CLLocationCoordinate2DMake(
                                                                      region.center.latitude - region.span.latitudeDelta / 2,
                                                                      region.center.longitude + region.span.longitudeDelta / 2));
    return MKMapRectMake(MIN(a.x,b.x), MIN(a.y,b.y), ABS(a.x-b.x), ABS(a.y-b.y));
}

- (void)addAnnotations
{
    MeasurementLocation *location1 = [[MeasurementLocation alloc] initWithName: @"Estacion Centro Obispado"
                                                                    airQuality: MeasurementLocationAirQualityTypeGood
                                                                    coordinate: CLLocationCoordinate2DMake(25.684299, -100.316563)];
    
    MeasurementLocation *location2 = [[MeasurementLocation alloc] initWithName: @"Estacion San Nicolas"
                                                                    airQuality: MeasurementLocationAirQualityTypeRegular
                                                                    coordinate: CLLocationCoordinate2DMake(25.743689, -100.286994)];
    
    MeasurementLocation *location3 = [[MeasurementLocation alloc] initWithName: @"Estacion Escobedo"
                                                                    airQuality: MeasurementLocationAirQualityTypeBad
                                                                    coordinate: CLLocationCoordinate2DMake(25.776156, -100.316177)];

    MeasurementLocation *location4 = [[MeasurementLocation alloc] initWithName: @"Estacion Santa Catarina"
                                                                    airQuality: MeasurementLocationAirQualityTypeVeryBad
                                                                    coordinate: CLLocationCoordinate2DMake(25.673315, -100.457025)];
    
    MeasurementLocation *location5 = [[MeasurementLocation alloc] initWithName: @"Estacion Guadalupe"
                                                                    airQuality: MeasurementLocationAirQualityTypeExtremelyBad
                                                                    coordinate: CLLocationCoordinate2DMake(25.660008, -100.191293)];

    [self.mapView addAnnotations: @[location1, location2, location3, location4, location5]];
}

@end
