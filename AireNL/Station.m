//
//  Station.m
//  AireNL
//
//  Created by Daniel Lozano on 9/14/15.
//  Copyright © 2015 Icalia Labs. All rights reserved.
//

#import "Station.h"

#import "Measurement.h"
#import "NSDictionary+WithoutNSNull.h"

@implementation Station

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init]; if (!self) return nil;
    
    self.stationID = [dictionary dl_objectForKeyWithNil: @"id"];
    
    NSDictionary *attributes = [dictionary dl_objectForKeyWithNil: @"attributes"];
    self.code = [attributes dl_objectForKeyWithNil: @"code"];
    self.name = [attributes dl_objectForKeyWithNil: @"name"];
    self.shortName = [attributes dl_objectForKeyWithNil: @"short_name"];
    self.coordinateString = [attributes dl_objectForKeyWithNil: @"latlon"];
    
    NSDictionary *relationships = dictionary[@"relationships"];
    NSDictionary *lastMeasurement = [relationships dl_objectForKeyWithNil: @"last_measurement"];
    NSDictionary *lastMeasurementData = [lastMeasurement dl_objectForKeyWithNil: @"data"];
    self.lastMeasurementID = [lastMeasurementData dl_objectForKeyWithNil: @"id"];

    NSMutableArray *tempForecastIDS = [[NSMutableArray alloc] init];
    for (NSDictionary *forecast in relationships[@"current_forecasts"][@"data"]) {
        NSNumber *forecastID = forecast[@"id"];
        if (forecastID) {
            [tempForecastIDS addObject: forecastID];
        }
    }
    self.currentForecastsIDS = [NSArray arrayWithArray: tempForecastIDS];
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init]; if (!self) return nil;
    
    self.stationID = [aDecoder decodeObjectForKey: @"stationID"];
    self.code = [aDecoder decodeObjectForKey: @"code"];
    self.name = [aDecoder decodeObjectForKey: @"name"];
    self.shortName = [aDecoder decodeObjectForKey: @"shortName"];
    self.coordinateString = [aDecoder decodeObjectForKey: @"coordinateString"];
    self.lastMeasurementID = [aDecoder decodeObjectForKey: @"lastMeasurementID"];

    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject: self.stationID forKey: @"stationID"];
    [aCoder encodeObject: self.code forKey: @"code"];
    [aCoder encodeObject: self.name forKey: @"name"];
    [aCoder encodeObject: self.shortName forKey: @"shortName"];
    [aCoder encodeObject: self.coordinateString forKey: @"coordinateString"];
    [aCoder encodeObject: self.lastMeasurementID forKey: @"lastMeasurementID"];
}

#pragma mark - Public API

- (CLLocationCoordinate2D)coordinateFromString
{
    NSArray *separatedString = [self.coordinateString componentsSeparatedByString: @","];

    NSString *latitude = separatedString[0];
    NSString *longitude = separatedString[1];

    CLLocationDegrees lat = [latitude doubleValue];
    CLLocationDegrees lon = [longitude doubleValue];

    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(lat, lon);
    
    return coordinate;
}

#pragma mark - MKAnnotation Protocol

- (NSString *)title
{
    return self.name;
}

- (NSString *)subtitle
{
    return self.shortName;
}

- (CLLocationCoordinate2D)coordinate
{
    return [self coordinateFromString];
}

@end
