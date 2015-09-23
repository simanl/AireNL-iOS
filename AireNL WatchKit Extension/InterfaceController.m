//
//  InterfaceController.m
//  AireNL WatchKit Extension
//
//  Created by Daniel Lozano on 8/6/15.
//  Copyright (c) 2015 Icalia Labs. All rights reserved.
//

#import "InterfaceController.h"

#import <CoreLocation/CoreLocation.h>

#import "AireNLAPI.h"
#import "APIResults.h"

#import "Station.h"
#import "Measurement.h"

#import "Constants.h"

@interface InterfaceController() <CLLocationManagerDelegate>

// MODEL DATA

@property (nonatomic) Station *selectedStation;
@property (nonatomic) Measurement *selectedMeasurement;

// LOCATION

@property (nonatomic) BOOL gettingLocation;
@property (nonatomic) CLLocationManager *locationManager;

@property (nonatomic) BOOL loadingStation;

@end

@implementation InterfaceController

- (void)awakeWithContext:(id)context
{
    // Configure interface objects here.
    [super awakeWithContext: context];

    [[AireNLAPI sharedAPI] disableCaching];    
}

- (void)willActivate
{
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
    
    [self loadNearestStation];
}

- (void)didDeactivate
{
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
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
        NSLog(@"LOAD NEAREST STATION : PERMISSION NOT DETERMINED : ABORTED");
        [self loadDefaultStation];
        return;
    }else if (status == kCLAuthorizationStatusDenied){
        NSLog(@"LOAD NEAREST STATION : PERMISSION DENIED : ABORTED");
        [self loadDefaultStation];
        return;
    }
    
    NSLog(@"LOADING NEAREST STATION!");
//    [self showLoading];
    
    self.gettingLocation = YES;
    [self.locationManager requestLocation];
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
//        [self hideLoading];
        self.loadingStation = NO;
    }];
}

- (void)loadDefaultStation
{
    if (self.loadingStation) {
        return;
    }
    
    NSLog(@"LOADING DEFAULT STATION");
//    [self showLoading];
    
    self.loadingStation = YES;
    
    [[AireNLAPI sharedAPI] getDefaultStationWithCompletion:^(APIResults *results, NSError *error) {
        [self handleResults: results withError: error];
//        [self hideLoading];
        self.loadingStation = NO;
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
        
        [self postNotification];
        [self updateScreen];
        
    }else{
        NSLog(@"ERROR = %@", error);
    }
}

- (void)postNotification
{
    NSDictionary *userInfo;
    if (self.selectedStation && self.selectedMeasurement) {
        userInfo = @{@"selectedStation" : self.selectedStation,
                     @"selectedMeasurement" : self.selectedMeasurement};
    }else if(self.selectedStation){
        userInfo = @{@"selectedStation" : self.selectedStation};
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName: kWatchkitDidDownloadDataNotification
                                                        object: self
                                                      userInfo: userInfo];
}

#pragma mark - Appearance

- (void)updateScreen
{
    [self setTitle: self.selectedStation.name];
    
    NSNumber *imecaPoints = self.selectedMeasurement.imecaPoints ?: @(0);
    [self.imecaAmountLabel setText: [imecaPoints stringValue]];
}

#pragma mark - CLLocationManager Delegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    CLLocation *location = [locations lastObject];
    CLLocationCoordinate2D coordinate = location.coordinate;
    CLLocationAccuracy horizontalAccuracy = location.horizontalAccuracy;
    CLLocationAccuracy verticalAccuracy = location.verticalAccuracy;
//    NSTimeInterval locationAge = -[location.timestamp timeIntervalSinceNow];
    
    NSLog(@"DID UPDATE LOCATION : %f , %f", coordinate.latitude, coordinate.longitude);
    NSLog(@"WITH ACCURACY : %f , %f", horizontalAccuracy, verticalAccuracy);
    
    //    if (verticalAccuracy < 0 || horizontalAccuracy < 0) {
    //        NSLog(@"LOCATION ABORTED : ACCURACY");
    //        return;
    //    }
    
//    if (locationAge > 5.0){
//        NSLog(@"LOCATION ABORTED : AGE");
//        return;
//    }
    
    [manager stopUpdatingLocation];
    [self loadNearestStationForCoordinate: coordinate];
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
//    switch (status) {
//        case kCLAuthorizationStatusNotDetermined:
//            [self askLocationPermision];
//            break;
//        case kCLAuthorizationStatusAuthorizedWhenInUse:
//            [self loadNearestStation];
//            break;
//        default:
//            break;
//    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"LOCATION MANAGER : ERROR : %@", error.localizedDescription);
    
    [self loadDefaultStation];
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



