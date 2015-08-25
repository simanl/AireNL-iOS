//
//  MeasurementLocation.h
//  AireNL
//
//  Created by Daniel Lozano on 8/24/15.
//  Copyright (c) 2015 Icalia Labs. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <MapKit/MapKit.h>

#import "ImecaResults.h"

@interface MeasurementLocation : NSObject <MKAnnotation>

- (id)initWithCityName:(NSString *)cityName areaName:(NSString *)areaName;
- (id)initWithCityName:(NSString *)cityName areaName:(NSString *)areaName airQuality:(AirQualityType)type coordinate:(CLLocationCoordinate2D)coordinate;
- (UIImage *)annotationImage;

@property (nonatomic, copy, readonly) NSString *cityName;
@property (nonatomic, copy, readonly) NSString *areaName;
@property (nonatomic, assign, readonly) AirQualityType airQuality;
@property (nonatomic, assign, readonly) CLLocationCoordinate2D locationCoordinate;

@end
