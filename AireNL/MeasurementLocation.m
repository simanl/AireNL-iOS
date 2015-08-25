//
//  MeasurementLocation.m
//  AireNL
//
//  Created by Daniel Lozano on 8/24/15.
//  Copyright (c) 2015 Icalia Labs. All rights reserved.
//

#import "MeasurementLocation.h"

@interface MeasurementLocation ()

@property (nonatomic, copy, readwrite) NSString *cityName;
@property (nonatomic, copy, readwrite) NSString *areaName;
@property (nonatomic, assign, readwrite) AirQualityType airQuality;
@property (nonatomic, assign, readwrite) CLLocationCoordinate2D locationCoordinate;


@end

@implementation MeasurementLocation

- (id)initWithCityName:(NSString *)cityName areaName:(NSString *)areaName
{
    return [self initWithCityName: cityName
                         areaName: areaName
                       airQuality: AirQualityTypeGood
                       coordinate: CLLocationCoordinate2DMake(0, 0)];
}

- (id)initWithCityName:(NSString *)cityName areaName:(NSString *)areaName airQuality:(AirQualityType)type coordinate:(CLLocationCoordinate2D)coordinate
{
    self = [super init];
    if (!self) return nil;
    
    self.cityName = cityName;
    self.areaName = areaName;
    self.airQuality = type;
    self.locationCoordinate = coordinate;
    
    return self;
}

#pragma mark - MKAnnotation Protocol

- (NSString *)title
{
    return self.areaName;
}

- (NSString *)subtitle
{
    return [self descriptionForType: self.airQuality];
}

- (CLLocationCoordinate2D)coordinate
{
    return self.locationCoordinate;
}

#pragma mark - Public Helper's

- (UIImage *)annotationImage
{
    return [self imageForType: self.airQuality];
}

#pragma mark - Helper's

- (UIImage *)imageForType:(AirQualityType)type
{
    switch (type) {
        case AirQualityTypeGood:{
            return [UIImage imageNamed: @"WaypointIconGood"];
            break;
        }
        case AirQualityTypeRegular:{
            return [UIImage imageNamed: @"WaypointIconRegular"];
            break;
        }
        case AirQualityTypeBad:{
            return [UIImage imageNamed: @"WaypointIconBad"];
            break;
        }
        case AirQualityTypeVeryBad:{
            return [UIImage imageNamed: @"WaypointIconVeryBad"];
            break;
        }
        case AirQualityTypeExtremelyBad:{
            return [UIImage imageNamed: @"WaypointIconExtremelyBad"];
            break;
        }
        default:
            return nil;
            break;
    }
}

- (NSString *)descriptionForType:(AirQualityType)type
{
    switch (type) {
        case AirQualityTypeGood:{
            return @"Calidad del Aire: Buena";
            break;
        }
        case AirQualityTypeRegular:{
            return @"Calidad del Aire: Regular";
            break;
        }
        case AirQualityTypeBad:{
            return @"Calidad del Aire: Mala";
            break;
        }
        case AirQualityTypeVeryBad:{
            return @"Calidad del Aire: Muy Mala";
            break;
        }
        case AirQualityTypeExtremelyBad:{
            return @"Calidad del Aire: Extremadamente Mala";
            break;
        }
        default:
            return @"";
            break;
    }
}

@end
