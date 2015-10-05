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

#import "ILAnnotationView.h"
#import "UIColor+ILColor.h"

#import "AireNLAPI.h"

@interface MapViewController () <CLLocationManagerDelegate, MKMapViewDelegate>

@property (nonatomic) APIResults *stationsAPIResults;
@property (nonatomic) Station *selectedStation;

@property (nonatomic) CLLocationManager *locationManager;

@property (nonatomic) MKMapRect monterreyRect;
@property (nonatomic) MKMapRect lastGoodMapRect;
@property (nonatomic) BOOL manuallyChangingMapRect;

@property (nonatomic) UIBarButtonItem *doneButton;
@property (nonatomic) UIBarButtonItem *switchButton;

@property (nonatomic) UIBarButtonItem *activityButton;
@property (nonatomic) UIActivityIndicatorView *activityView;

@property (nonatomic) UIView *customCalloutView;

@end

@implementation MapViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"Measurement Stations", nil);
    self.navigationItem.leftBarButtonItem = self.doneButton;

    self.mapView.showsUserLocation = YES;
    self.mapView.delegate = self;
    
    [self setUpLocationManager];
    [self setNavBarImageWithType: self.type];

    [self loadStations];
    [self zoomToMonterrey];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Network

- (void)loadStations
{
    NSLog(@"MAP : LOADING STATIONS");
    [self showLoading];
    
    [[AireNLAPI sharedAPI] getStationsWithCompletion:^(APIResults *results, NSError *error) {
        
        if (!error) {
            
            NSLog(@"SUCCESS!");
            self.stationsAPIResults = results;
            [self.mapView addAnnotations: [results stations]];
            
        }else{
            NSLog(@"ERROR : %@", error);
        }
        [self hideLoading];
    }];
}

#pragma mark - Appearance

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

#pragma mark - IBAction's

- (void)didSelectDone
{
    [self dismissViewControllerAnimated: YES completion: nil];
}

- (void)didSelectSwitch
{
    if (!self.selectedStation) return;
    
    if ([self.delegate respondsToSelector: @selector(mapDidSelectStation:withMeasurement:currentForecasts:)]) {
        
        Measurement *measurement = [self.stationsAPIResults lastMeasurementForStation: self.selectedStation];
        NSArray *forecasts = [self.stationsAPIResults currentForecastsForStation: self.selectedStation];
        
        [self.delegate mapDidSelectStation: self.selectedStation withMeasurement: measurement currentForecasts: forecasts];
    }
    
}

#pragma mark - Map/Location

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

- (void)zoomToMonterrey
{
    CLLocationCoordinate2D monterreyCenter = CLLocationCoordinate2DMake(25.670104, -100.309675);
    CLLocationDistance latitudeDistance = 50000;
    CLLocationDistance longitudeDistance = 50000;
    MKCoordinateRegion monterreyRegion = MKCoordinateRegionMakeWithDistance(monterreyCenter, latitudeDistance, longitudeDistance);
    self.monterreyRect = [self MKMapRectForCoordinateRegion: monterreyRegion];
    
    [self.mapView setCenterCoordinate: monterreyCenter zoomLevel: 5 animated: YES];
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
        if ([annotation isKindOfClass: [Station class]]) {
            ILAnnotationView *annotationView = [[ILAnnotationView alloc] initWithAnnotation: annotation reuseIdentifier: SFAnnotationIdentifier];
            
            Station *station = (Station *)annotation;
            Measurement *measurement = [self.stationsAPIResults lastMeasurementForStation: station];
            
            annotationView.image = [measurement mapAnnotationImageForAirQuality];
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
    NSLog(@"DID SELECT ANNOTATION VIEW");
    
    if ([view.annotation isKindOfClass: [Station class]]) {
        
        Station *annotation = (Station *)view.annotation;

        NSLog(@"MAP : SELECTED STATION : %@", annotation);
        
        self.selectedStation = annotation;
        self.navigationItem.rightBarButtonItem = self.switchButton;
        
        self.customCalloutView = [self createCalloutViewForAnnotationView: view];
        [view addSubview: self.customCalloutView];
        
        [self.mapView setCenterCoordinate: [annotation coordinate] animated: YES];
        
    }
}

- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view
{
    NSLog(@"DID DE-SELECT ANNOTATION VIEW");
    
    if ([view.annotation isKindOfClass: [Station class]]) {
        
        self.selectedStation = nil;
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

- (UIView *)createCalloutViewForAnnotationView:(MKAnnotationView *)view
{
    Measurement *selectedMeasurement = [self.stationsAPIResults lastMeasurementForStation: self.selectedStation];
    
    UIView *calloutView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, 280, 110)];
    calloutView.backgroundColor = [UIColor whiteColor];
    calloutView.alpha = 0.95;
    calloutView.layer.cornerRadius = 5.0f;
    calloutView.center = CGPointMake(view.bounds.size.width * 0.5f, -view.bounds.size.height * 0.5f - 35.0f);
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame: CGRectMake(0, 0, 260, 20)];
    UILabel *subtitleLabel = [[UILabel alloc] initWithFrame: CGRectMake(0, 0, 260, 20)];
    
    titleLabel.center = CGPointMake(140, 20);
    titleLabel.text = [self.selectedStation.name uppercaseString];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont fontWithName: @"Avenir-Medium" size: 16.0f];
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.alpha = 0.7f;
    
    subtitleLabel.center = CGPointMake(140, 45);
    subtitleLabel.text = NSLocalizedString(@"AIR QUALITY",  nil);
    subtitleLabel.textAlignment = NSTextAlignmentCenter;
    subtitleLabel.font = [UIFont fontWithName: @"Avenir-Light" size: 12.0f];
    subtitleLabel.textColor = [UIColor blackColor];
    subtitleLabel.alpha = 0.35f;
    
    [calloutView addSubview: titleLabel];
    [calloutView addSubview: subtitleLabel];
    
    UIView *airQualityView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, 260, 40)];
    airQualityView.center = CGPointMake(140, 80);
    airQualityView.backgroundColor = [selectedMeasurement colorForAirQuality];
    airQualityView.layer.cornerRadius = 20.0f;
    
    UILabel *airQualityLabel = [[UILabel alloc] initWithFrame: CGRectMake(0, 0, 240, 20)];
    airQualityLabel.center = CGPointMake(130, 20);
    airQualityLabel.text = [[selectedMeasurement stringForAirQuality] uppercaseString];
    airQualityLabel.textColor = [UIColor whiteColor];
    airQualityLabel.textAlignment = NSTextAlignmentCenter;
    airQualityLabel.font = [UIFont fontWithName: @"Avenir-Light" size: 16.0f];
    
    [airQualityView addSubview: airQualityLabel];
    [calloutView addSubview: airQualityView];
    
//    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget: self action: @selector(didSelectSwitch)];
//    [calloutView addGestureRecognizer: tapRecognizer];
    
    return calloutView;
}

#pragma mark - Helper's

- (void)showLoading
{
    self.navigationItem.rightBarButtonItem = self.activityButton;
    [self.activityView startAnimating];
}

- (void)hideLoading
{
    [self.activityView stopAnimating];
    self.navigationItem.rightBarButtonItem = nil;
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

- (UIBarButtonItem *)activityButton
{
    if (!_activityButton) {
        _activityButton = [[UIBarButtonItem alloc] initWithCustomView: self.activityView];
    }
    return _activityButton;
}

- (UIActivityIndicatorView *)activityView
{
    if (!_activityView) {
        _activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle: UIActivityIndicatorViewStyleWhite];
    }
    return _activityView;
}

@end
