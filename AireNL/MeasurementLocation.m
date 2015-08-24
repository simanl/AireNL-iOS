//
//  MeasurementLocation.m
//  AireNL
//
//  Created by Daniel Lozano on 8/24/15.
//  Copyright (c) 2015 Icalia Labs. All rights reserved.
//

#import "MeasurementLocation.h"

@interface MeasurementLocation ()

@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) MeasurementLocationAirQualityType airQualityType;
@property (nonatomic, assign) CLLocationCoordinate2D locationCoordinate;

@end

@implementation MeasurementLocation

- (id)initWithName:(NSString *)name airQuality:(MeasurementLocationAirQualityType)type coordinate:(CLLocationCoordinate2D)coordinate
{
    self = [super init];
    if (!self) return nil;
    
    self.name = name;
    self.airQualityType = type;
    self.locationCoordinate = coordinate;
    
    return self;
}

#pragma mark - MKAnnotation Protocol

- (NSString *)title
{
    return self.name;
}

- (NSString *)subtitle
{
    return [self descriptionForType: self.airQualityType];
}

- (CLLocationCoordinate2D)coordinate
{
    return self.locationCoordinate;
}

#pragma mark - Public Helper's

- (UIImage *)annotationImage
{
    return [self imageForType: self.airQualityType];
}

#pragma mark - Helper's

- (UIImage *)imageForType:(MeasurementLocationAirQualityType)type
{
    switch (type) {
        case MeasurementLocationAirQualityTypeGood:{
            return [UIImage imageNamed: @"WaypointIconGood"];
            break;
        }
        case MeasurementLocationAirQualityTypeRegular:{
            return [UIImage imageNamed: @"WaypointIconRegular"];
            break;
        }
        case MeasurementLocationAirQualityTypeBad:{
            return [UIImage imageNamed: @"WaypointIconBad"];
            break;
        }
        case MeasurementLocationAirQualityTypeVeryBad:{
            return [UIImage imageNamed: @"WaypointIconVeryBad"];
            break;
        }
        case MeasurementLocationAirQualityTypeExtremelyBad:{
            return [UIImage imageNamed: @"WaypointIconExtremelyBad"];
            break;
        }
        default:
            return nil;
            break;
    }
}

- (NSString *)descriptionForType:(MeasurementLocationAirQualityType)type
{
    switch (type) {
        case MeasurementLocationAirQualityTypeGood:{
            return @"Calidad del Aire: Buena";
            break;
        }
        case MeasurementLocationAirQualityTypeRegular:{
            return @"Calidad del Aire: Regular";
            break;
        }
        case MeasurementLocationAirQualityTypeBad:{
            return @"Calidad del Aire: Mala";
            break;
        }
        case MeasurementLocationAirQualityTypeVeryBad:{
            return @"Calidad del Aire: Muy Mala";
            break;
        }
        case MeasurementLocationAirQualityTypeExtremelyBad:{
            return @"Calidad del Aire: Extremadamente Mala";
            break;
        }
        default:
            return @"";
            break;
    }
}

@end
