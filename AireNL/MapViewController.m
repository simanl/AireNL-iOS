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
#import "ILAnnotationView.h"
#import "UIColor+ILColor.h"

@interface MapViewController () <CLLocationManagerDelegate, MKMapViewDelegate>

@property (nonatomic) CLLocationManager *locationManager;

@property (nonatomic) MKMapRect monterreyRect;
@property (nonatomic) MKMapRect lastGoodMapRect;
@property (nonatomic) BOOL manuallyChangingMapRect;

@property (nonatomic) MeasurementLocation *selectedLocation;

@property (nonatomic) UIBarButtonItem *doneButton;
@property (nonatomic) UIBarButtonItem *switchButton;

@property (nonatomic) UIView *customCalloutView;

@end

@implementation MapViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Puntos de Medicion";
    self.navigationItem.leftBarButtonItem = self.doneButton;

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

- (void)didSelectSwitch
{
    if (!self.selectedLocation) return;
    
    CurrentResults *currentResults = [[CurrentResults alloc] init];
    currentResults.date = [NSDate date];
    currentResults.temperature = @(40);
    currentResults.wind = @(140);
    
    ImecaResults *imecaResults = [[ImecaResults alloc] init];
    imecaResults.amount = @(40);
    imecaResults.airQuality = self.selectedLocation.airQuality;
    
    ContaminantResults *contamintResults = [[ContaminantResults alloc] init];
    contamintResults.pm10 = @(4);
    contamintResults.pm25 = @(14);
    contamintResults.O3 = @(40);
    
    currentResults.imeca = imecaResults;
    currentResults.contaminants = contamintResults;
    currentResults.location = self.selectedLocation;
    
    [self dismissViewControllerAnimated: YES completion:^{
        if ([self.delegate respondsToSelector: @selector(didSelectLocationWithCurrentResults:)]) {
            [self.delegate didSelectLocationWithCurrentResults: currentResults];
        }
    }];
    
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
    ILAnnotationView *pinView =
    (ILAnnotationView *)[self.mapView dequeueReusableAnnotationViewWithIdentifier: SFAnnotationIdentifier];
    
    if (!pinView){
        if ([annotation isKindOfClass: [MeasurementLocation class]]) {
            ILAnnotationView *annotationView = [[ILAnnotationView alloc] initWithAnnotation: annotation reuseIdentifier: SFAnnotationIdentifier];
            MeasurementLocation *measurementLocationAnnotation = (MeasurementLocation *)annotation;
            
            annotationView.image = [measurementLocationAnnotation annotationImage];
            annotationView.canShowCallout = NO;
            return annotationView;
        }
        
    }else{
        pinView.annotation = annotation;
    }
    
    return pinView;
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    if ([view.annotation isKindOfClass: [MeasurementLocation class]]) {
        MeasurementLocation *annotation = (MeasurementLocation *)view.annotation;

        self.selectedLocation = annotation;
        self.navigationItem.rightBarButtonItem = self.switchButton;
        
        self.customCalloutView = [self createCalloutViewForAnnotationView: view];
        [view addSubview: self.customCalloutView];
        
        [self.mapView setCenterCoordinate: annotation.locationCoordinate animated: YES];
        
    }
}

- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view
{
    if ([view.annotation isKindOfClass: [MeasurementLocation class]]) {
        
        self.selectedLocation = nil;
        self.navigationItem.rightBarButtonItem = nil;
        
        [self.customCalloutView removeFromSuperview];
    }
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
    MeasurementLocation *location1 = [[MeasurementLocation alloc] initWithCityName: @"Monterrey"
                                                                          areaName: @"Estacion Centro Obispado"
                                                                        airQuality: AirQualityTypeGood
                                                                        coordinate: CLLocationCoordinate2DMake(25.684299, -100.316563)];
    
    MeasurementLocation *location2 = [[MeasurementLocation alloc] initWithCityName: @"San Nicolas de los Garza"
                                                                          areaName: @"Estacion San Nicolas"
                                                                        airQuality: AirQualityTypeRegular
                                                                        coordinate: CLLocationCoordinate2DMake(25.743689, -100.286994)];
    
    MeasurementLocation *location3 = [[MeasurementLocation alloc] initWithCityName: @"Escobedo"
                                                                          areaName: @"Estacion Escobedo"
                                                                        airQuality: AirQualityTypeBad
                                                                        coordinate: CLLocationCoordinate2DMake(25.776156, -100.316177)];
    
    MeasurementLocation *location4 = [[MeasurementLocation alloc] initWithCityName: @"Santa Catarina"
                                                                          areaName: @"Estacion Santa Catarina"
                                                                        airQuality: AirQualityTypeVeryBad
                                                                        coordinate: CLLocationCoordinate2DMake(25.673315, -100.457025)];
    
    MeasurementLocation *location5 = [[MeasurementLocation alloc] initWithCityName: @"Guadalupe"
                                                                          areaName: @"Estacion Guadalupe"
                                                                        airQuality: AirQualityTypeExtremelyBad
                                                                        coordinate: CLLocationCoordinate2DMake(25.660008, -100.191293)];

    [self.mapView addAnnotations: @[location1, location2, location3, location4, location5]];
}

- (UIView *)createCalloutViewForAnnotationView:(MKAnnotationView *)view
{
    UIView *calloutView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, 280, 110)];
    calloutView.backgroundColor = [UIColor whiteColor];
    calloutView.alpha = 0.95;
    calloutView.layer.cornerRadius = 5.0f;
    calloutView.center = CGPointMake(view.bounds.size.width * 0.5f, -view.bounds.size.height * 0.5f - 35.0f);
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame: CGRectMake(0, 0, 260, 20)];
    UILabel *subtitleLabel = [[UILabel alloc] initWithFrame: CGRectMake(0, 0, 260, 20)];
    
    titleLabel.center = CGPointMake(140, 20);
    titleLabel.text = [self.selectedLocation.areaName uppercaseString];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont fontWithName: @"Avenir-Medium" size: 16.0f];
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.alpha = 0.7f;
    
    subtitleLabel.center = CGPointMake(140, 45);
    subtitleLabel.text = @"CALIDAD DEL AIRE";
    subtitleLabel.textAlignment = NSTextAlignmentCenter;
    subtitleLabel.font = [UIFont fontWithName: @"Avenir-Light" size: 12.0f];
    subtitleLabel.textColor = [UIColor blackColor];
    subtitleLabel.alpha = 0.35f;
    
    [calloutView addSubview: titleLabel];
    [calloutView addSubview: subtitleLabel];
    
    UIView *airQualityView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, 260, 40)];
    airQualityView.center = CGPointMake(140, 80);
    airQualityView.backgroundColor = [self.selectedLocation airQualityColor];
    airQualityView.layer.cornerRadius = 20.0f;
    
    UILabel *airQualityLabel = [[UILabel alloc] initWithFrame: CGRectMake(0, 0, 240, 20)];
    airQualityLabel.center = CGPointMake(130, 20);
    airQualityLabel.text = [[self.selectedLocation airQualityString] uppercaseString];
    airQualityLabel.textColor = [UIColor whiteColor];
    airQualityLabel.textAlignment = NSTextAlignmentCenter;
    airQualityLabel.font = [UIFont fontWithName: @"Avenir-Light" size: 16.0f];
    
    [airQualityView addSubview: airQualityLabel];
    [calloutView addSubview: airQualityView];
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget: self action: @selector(didSelectSwitch)];
    [calloutView addGestureRecognizer: tapRecognizer];
    
    return calloutView;
}

#pragma mark - Set/Get

- (UIBarButtonItem *)doneButton
{
    if (!_doneButton) {
        _doneButton = [[UIBarButtonItem alloc] initWithImage: [UIImage imageNamed: @"CloseIconWhite"] style: UIBarButtonItemStylePlain target:self action: @selector(didSelectDone)];
    }
    return _doneButton;
}

- (UIBarButtonItem *)switchButton
{
    if (!_switchButton) {
        _switchButton = [[UIBarButtonItem alloc] initWithImage: [UIImage imageNamed: @"SwitchIcon"] style: UIBarButtonItemStylePlain target: self action: @selector(didSelectSwitch)];
    }
    return _switchButton;
}

@end
