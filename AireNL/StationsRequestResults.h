//
//  StationsRequestResults.h
//  AireNL
//
//  Created by Daniel Lozano on 9/14/15.
//  Copyright © 2015 Icalia Labs. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Station.h"
#import "Measurement.h"

@interface StationsRequestResults : NSObject

- (id)initWithStations:(NSArray *)stations measurements:(NSArray *)measurements;

- (NSArray *)stations;
- (NSArray *)measurements;

- (Station *)stationForMeasurement:(Measurement *)measurement;
- (Measurement *)lastMeasurementForStation:(Station *)station;

@end
