//
//  APIResults.m
//  AireNL
//
//  Created by Daniel Lozano on 9/15/15.
//  Copyright © 2015 Icalia Labs. All rights reserved.
//

#import "APIResults.h"

@interface APIResults ()

@property (nonatomic) NSDictionary *_stations;
@property (nonatomic) NSDictionary *_measurements;

@end

@implementation APIResults

- (id)initWithStations:(NSArray *)stations measurements:(NSArray *)measurements
{
    self = [super init]; if(!self)return nil;
        
    NSMutableDictionary *tempStations = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *tempMeasurements = [[NSMutableDictionary alloc] init];
    
    for (Station *station in stations) {
        [tempStations setObject: station forKey: station.stationID];
    }
    
    for (Measurement *measurement in measurements) {
        [tempMeasurements setObject: measurement forKey: measurement.measurementID];
    }
    
    __stations = [NSDictionary dictionaryWithDictionary: tempStations];
    __measurements = [NSDictionary dictionaryWithDictionary: tempMeasurements];
    
    return self;
}

- (NSArray *)stations
{
    return [self._stations allValues];
}

- (NSArray *)measurements
{
    return [self._measurements allValues];
}

- (Measurement *)lastMeasurementForStation:(Station *)station
{    
    NSString *measurementID = station.lastMeasurementID;
    return self._measurements[measurementID];
}

@end
