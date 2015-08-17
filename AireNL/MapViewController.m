//
//  MapViewController.m
//  AireNL
//
//  Created by Daniel Lozano on 7/21/15.
//  Copyright (c) 2015 Icalia Labs. All rights reserved.
//

#import <MapKit/MapKit.h>

#import "MapViewController.h"

#import "UIColor+ILColor.h"

@interface MapViewController () <CLLocationManagerDelegate, MKMapViewDelegate>

@property (nonatomic) CLLocationManager *locationManager;

@end

@implementation MapViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = @"Puntos de Medicion";
    
    [self setUpLocationManager];
    [self setNavBarImageWithType: self.type];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemDone
                                                                                          target: self
                                                                                          action: @selector(didSelectDone)];
    
//    self.mapView.showsUserLocation = YES;
    self.mapView.delegate = self;
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
//    self.mapView.showsUserLocation = YES;
    [self.mapView setUserTrackingMode: MKUserTrackingModeFollow];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
