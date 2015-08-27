//
//  MeasurementLocation.m
//  AireNL
//
//  Created by Daniel Lozano on 8/24/15.
//  Copyright (c) 2015 Icalia Labs. All rights reserved.
//

#import "MeasurementLocation.h"

#import "UIColor+ILColor.h"

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
    return [NSString stringWithFormat: @"Calidad del Aire : %@", [self airQualityString]];
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

- (NSString *)airQualityString
{
    switch (self.airQuality) {
        case AirQualityTypeGood:
            return NSLocalizedString(@"Good", nil);
            break;
        case AirQualityTypeRegular:
            return NSLocalizedString(@"Regular", nil);
            break;
        case AirQualityTypeBad:
            return NSLocalizedString(@"Bad", nil);
            break;
        case AirQualityTypeVeryBad:
            return NSLocalizedString(@"Very Bad", nil);
            break;
        case AirQualityTypeExtremelyBad:
            return NSLocalizedString(@"Extremely Bad", nil);
            break;
        default:
            return nil;
            break;
    }
}

- (UIColor *)airQualityColor
{
    switch (self.airQuality) {
        case AirQualityTypeGood:
            return [UIColor il_goodColor];
            break;
        case AirQualityTypeRegular:
            return [UIColor il_regularColor];
            break;
        case AirQualityTypeBad:
            return [UIColor il_badColor];
            break;
        case AirQualityTypeVeryBad:
            return [UIColor il_veryBadColor];
            break;
        case AirQualityTypeExtremelyBad:
            return [UIColor il_extremelyBadColor];
            break;
        default:
            return nil;
            break;
    }
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

@end
