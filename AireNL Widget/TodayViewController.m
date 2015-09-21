//
//  TodayViewController.m
//  AireNL Widget
//
//  Created by Daniel Lozano on 8/5/15.
//  Copyright (c) 2015 Icalia Labs. All rights reserved.
//

#import "TodayViewController.h"

#import <CoreLocation/CoreLocation.h>
#import <NotificationCenter/NotificationCenter.h>

#import "AireNLAPI.h"

#import "Station.h"
#import "Measurement.h"
#import "APIResults.h"

@interface TodayViewController () <NCWidgetProviding, CLLocationManagerDelegate>

// MODEL DATA

@property (nonatomic) Station *selectedStation;
@property (nonatomic) Measurement *selectedMeasurement;

// LOCATION

@property (nonatomic) BOOL gettingLocation;
@property (nonatomic) CLLocationManager *locationManager;

@property (nonatomic) BOOL loadingStation;

@end

@implementation TodayViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self loadNearestStation];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler
{
    // Perform any setup necessary in order to update the view.
    
    // If an error is encountered, use NCUpdateResultFailed
    // If there's no update required, use NCUpdateResultNoData
    // If there's an update, use NCUpdateResultNewData

    completionHandler(NCUpdateResultNewData);
}

- (UIEdgeInsets)widgetMarginInsetsForProposedMarginInsets:(UIEdgeInsets)defaultMarginInsets
{
    return UIEdgeInsetsZero;
}

#pragma mark - Network

- (void)loadNearestStation
{
    NSLog(@"LOAD NEAREST STATION : ATTEMPTING");
    
    if (self.gettingLocation) {
        NSLog(@"LOAD NEAREST STATION : ABORTED");
        return;
    }
    
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    if (status == kCLAuthorizationStatusNotDetermined) {
        [self askLocationPermision];
        NSLog(@"LOAD NEAREST STATION : PERMISSION NOT DETERMINED : ABORTED");
        return;
    }else if (status == kCLAuthorizationStatusDenied){
        NSLog(@"LOAD NEAREST STATION : PERMISSION DENIED : ABORTED");
        [self loadDefaultStation];
        return;
    }
    
    NSLog(@"LOADING NEAREST STATION!");
    [self showLoading];
    
    self.gettingLocation = YES;
    [self.locationManager startUpdatingLocation];
}

- (void)loadNearestStationForCoordinate:(CLLocationCoordinate2D)coordinate
{
    self.gettingLocation = NO;
    
    if (self.loadingStation){
        return;
    }
    
    self.loadingStation = YES;
    
    [[AireNLAPI sharedAPI] getNearestStationForCoordinate: coordinate withCompletion:^(APIResults *results, NSError *error) {
        [self handleResults: results withError: error];
        [self hideLoading];
        self.loadingStation = NO;
    }];
}

- (void)loadDefaultStation
{
    NSLog(@"LOADING DEFAULT STATION");
    [self showLoading];
    
    [[AireNLAPI sharedAPI] getDefaultStationWithCompletion:^(APIResults *results, NSError *error) {
        [self handleResults: results withError: error];
        [self hideLoading];
    }];
    
}

- (void)handleResults:(APIResults *)results withError:(NSError *)error
{
    if (!error){
        
        NSLog(@"SUCCESS!");
        
        self.selectedStation = [[results stations] firstObject];
        self.selectedMeasurement = [results lastMeasurementForStation: self.selectedStation];
        
        NSLog(@"STATION : %@", self.selectedStation);
        NSLog(@"MEASUREMENT : %@", self.selectedMeasurement);
        
        [self updateScreen];
        
    }else{
        NSLog(@"ERROR = %@", error);
    }
}

#pragma mark - Appearance

- (void)updateScreen
{
    self.locationTitleLabel.text = [@"Monterrey" uppercaseString];
    self.locationSubtitleLabel.text = [self.selectedStation.name uppercaseString];
 
    NSNumber *imecaPoints = self.selectedMeasurement.imecaPoints ?: @(0);
    self.imecaLabel.text = [imecaPoints stringValue];
    
    NSString *localizedQualityText = NSLocalizedString(@"Air Quality", nil);
    self.imecaQualityLabel.text = [NSString stringWithFormat: @"%@: %@", localizedQualityText, [self.selectedMeasurement stringForAirQuality]];
        
    self.windLabel.text = [self stringForWindValue: self.selectedMeasurement.windSpeed];
    self.tempLabel.text = [self stringForTempValue: self.selectedMeasurement.temperature];
}

- (void)showLoading
{
    for (UIView *subView in self.view.subviews) {
        subView.hidden = YES;
    }
    
    self.activityView.hidden = NO;
    [self.activityView startAnimating];
}

- (void)hideLoading
{
    for (UIView *subView in self.view.subviews) {
        subView.hidden = NO;
    }
    
    [self.activityView stopAnimating];
    self.activityView.hidden = YES;
}

#pragma mark - CLLocationManager Delegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    CLLocation *location = [locations lastObject];
    CLLocationCoordinate2D coordinate = location.coordinate;
    CLLocationAccuracy horizontalAccuracy = location.horizontalAccuracy;
    CLLocationAccuracy verticalAccuracy = location.verticalAccuracy;
    NSTimeInterval locationAge = -[location.timestamp timeIntervalSinceNow];
    
    NSLog(@"DID UPDATE LOCATION : %f , %f", coordinate.latitude, coordinate.longitude);
    NSLog(@"WITH ACCURACY : %f , %f", horizontalAccuracy, verticalAccuracy);
    
//    if (verticalAccuracy < 0 || horizontalAccuracy < 0) {
//        NSLog(@"LOCATION ABORTED : ACCURACY");
//        return;
//    }
    
    if (locationAge > 5.0){
        NSLog(@"LOCATION ABORTED : AGE");
        return;
    }
    
    [manager stopUpdatingLocation];
    [self loadNearestStationForCoordinate: coordinate];
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    switch (status) {
        case kCLAuthorizationStatusNotDetermined:
            [self askLocationPermision];
            break;
        case kCLAuthorizationStatusAuthorizedWhenInUse:
            [self loadNearestStation];
            break;
        default:
            break;
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"LOCATION MANAGER : ERROR : %@", error.localizedDescription);
}

#pragma mark - Location Helper's

- (void)askLocationPermision
{
    NSLog(@"ASKING LOCATION PERMISSION");
    [self.locationManager requestWhenInUseAuthorization];
}


#pragma mark - Helper's

- (NSString *)stringForWindValue:(NSNumber *)value
{
    return [NSString stringWithFormat: @"%@ k/h", value?: @(0)];
}

- (NSString *)stringForTempValue:(NSNumber *)value
{
    return [NSString stringWithFormat: @"%@ \u00B0 C", value?: @(0)];
}

#pragma mark - Set/Get

- (CLLocationManager *)locationManager
{
    if (!_locationManager) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        _locationManager.distanceFilter = kCLDistanceFilterNone;
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    }
    return _locationManager;
}

@end
