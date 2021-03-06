//
//  APIResults.h
//  AireNL
//
//  Created by Daniel Lozano on 9/15/15.
//  Copyright © 2015 Icalia Labs. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Station.h"
#import "Measurement.h"
#import "Forecast.h"

@interface APIResults : NSObject

- (id)initWithStations:(NSArray *)stations measurements:(NSArray *)measurements forecasts:(NSArray *)forecasts;

- (NSArray *)stations;
- (NSArray *)measurements;
- (NSArray *)forecasts;

- (Measurement *)lastMeasurementForStation:(Station *)station;
- (NSArray *)currentForecastsForStation:(Station *)station;

@end
