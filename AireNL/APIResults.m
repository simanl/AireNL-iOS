//
//  APIResults.m
//  AireNL
//
//  Created by Daniel Lozano on 9/15/15.
//  Copyright © 2015 Icalia Labs. All rights reserved.
//

#import "APIResults.h"

@interface APIResults ()

@property (nonatomic) NSArray *_stations;

@property (nonatomic) NSDictionary *_measurements;
@property (nonatomic) NSDictionary *_forecasts;

@end

@implementation APIResults

#pragma mark - Init

- (id)initWithStations:(NSArray *)stations measurements:(NSArray *)measurements forecasts:(NSArray *)forecasts
{
    self = [super init]; if(!self)return nil;
        
    NSMutableDictionary *tempMeasurements = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *tempForecasts = [[NSMutableDictionary alloc] init];
    
    __stations = stations;
    
    for (Measurement *measurement in measurements) {
        [tempMeasurements setObject: measurement forKey: measurement.measurementID];
    }
    
    for (Forecast *forecast in forecasts) {
        [tempForecasts setObject: forecast forKey: forecast.forecastID];
    }
    
    __measurements = [NSDictionary dictionaryWithDictionary: tempMeasurements];
    __forecasts = [NSDictionary dictionaryWithDictionary: tempForecasts];
    
    return self;
}

#pragma mark - Public API

- (NSArray *)stations
{
    return self._stations;
}

- (NSArray *)measurements
{
    return [self._measurements allValues];
}

- (NSArray *)forecasts
{
    return [self._forecasts allValues];
}

- (Measurement *)lastMeasurementForStation:(Station *)station
{    
    NSString *measurementID = station.lastMeasurementID;
    return self._measurements[measurementID];
}

- (NSArray *)currentForecastsForStation:(Station *)station
{
    NSMutableArray *tempArray = [[NSMutableArray alloc] initWithCapacity: [station.currentForecastsIDS count]];
    
    for (NSNumber *forecastID in station.currentForecastsIDS) {
        Forecast *forecast = self._forecasts[forecastID];
        if (forecast) {
            [tempArray addObject: forecast];
        }
    }
    
    return [NSArray arrayWithArray: tempArray];
}

@end
