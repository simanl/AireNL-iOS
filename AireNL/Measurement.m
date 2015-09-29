//
//  Measurement.m
//  AireNL
//
//  Created by Daniel Lozano on 9/14/15.
//  Copyright © 2015 Icalia Labs. All rights reserved.
//

#import "Measurement.h"

#import "UIColor+ILColor.h"
#import "NSDictionary+WithoutNSNull.h"

@implementation Measurement

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init]; if (!self) return nil;
    
    self.measurementID = [dictionary dl_objectForKeyWithNil: @"id"];
    
    NSDictionary *attributes = [dictionary dl_objectForKeyWithNil: @"attributes"];
    self.date = [attributes dl_objectForKeyWithNil: @"measured_at"];
    self.temperature = [attributes dl_objectForKeyWithNil: @"temperature"];
    self.relativeHumidity = [attributes dl_objectForKeyWithNil: @"relative_humidity"];
    self.windDirection = [attributes dl_objectForKeyWithNil: @"wind_direction"];
    self.windSpeed = [attributes dl_objectForKeyWithNil: @"wind_speed"];
    self.imecaPoints = [attributes dl_objectForKeyWithNil: @"imeca_points"];
    self.precipitation = [attributes dl_objectForKeyWithNil: @"precipitation"];
    self.carbonMonoxide = [attributes dl_objectForKeyWithNil: @"carbon_monoxide"];
    self.nitricOxide = [attributes dl_objectForKeyWithNil: @"nitric_oxide"];
    self.nitrogenDioxide = [attributes dl_objectForKeyWithNil: @"nitrogen_dioxide"];
    self.nitrogenOxide = [attributes dl_objectForKeyWithNil: @"nitrogen_oxide"];
    self.ozone = [attributes dl_objectForKeyWithNil: @"ozone"];
    self.sulfurDioxide = [attributes dl_objectForKeyWithNil: @"sulfur_dioxide"];
    self.suspendedParticulateMatter = [attributes dl_objectForKeyWithNil: @"suspended_particulate_matter"];
    self.respirableSuspendedParticles = [attributes dl_objectForKeyWithNil: @"respirable_suspended_particles"];
    self.fineParticles = [attributes dl_objectForKeyWithNil: @"fine_particles"];
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init]; if (!self) return nil;
    
    self.measurementID = [aDecoder decodeObjectForKey: @"measurementID"];
    self.date = [aDecoder decodeObjectForKey: @"date"];
    self.temperature = [aDecoder decodeObjectForKey: @"temperature"];
    self.relativeHumidity = [aDecoder decodeObjectForKey: @"relativeHumidity"];
    self.windDirection = [aDecoder decodeObjectForKey: @"windDirection"];
    self.windSpeed = [aDecoder decodeObjectForKey: @"windSpeed"];
    self.imecaPoints = [aDecoder decodeObjectForKey: @"imecaPoints"];
    self.precipitation = [aDecoder decodeObjectForKey: @"precipitation"];
    self.carbonMonoxide = [aDecoder decodeObjectForKey: @"carbonMonoxide"];
    self.nitricOxide = [aDecoder decodeObjectForKey: @"nitricOxide"];
    self.nitrogenDioxide = [aDecoder decodeObjectForKey: @"nitrogenDioxide"];
    self.nitrogenOxide = [aDecoder decodeObjectForKey: @"nitrogenOxide"];
    self.ozone = [aDecoder decodeObjectForKey: @"ozone"];
    self.sulfurDioxide = [aDecoder decodeObjectForKey: @"sulfurDioxide"];
    self.suspendedParticulateMatter = [aDecoder decodeObjectForKey: @"suspendedParticulateMatter"];
    self.respirableSuspendedParticles = [aDecoder decodeObjectForKey: @"respirableSuspendedParticles"];
    self.fineParticles = [aDecoder decodeObjectForKey: @"fineParticles"];
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject: self.measurementID forKey: @"stationID"];
    [aCoder encodeObject: self.date forKey: @"date"];
    [aCoder encodeObject: self.temperature forKey: @"temperature"];
    [aCoder encodeObject: self.relativeHumidity forKey: @"relativeHumidity"];
    [aCoder encodeObject: self.windDirection forKey: @"windDirection"];
    [aCoder encodeObject: self.windSpeed forKey: @"windSpeed"];
    [aCoder encodeObject: self.imecaPoints forKey: @"imecaPoints"];
    [aCoder encodeObject: self.precipitation forKey: @"precipitation"];
    [aCoder encodeObject: self.carbonMonoxide forKey: @"carbonMonoxide"];
    [aCoder encodeObject: self.nitricOxide forKey: @"nitricOxide"];
    [aCoder encodeObject: self.nitrogenDioxide forKey: @"nitrogenDioxide"];
    [aCoder encodeObject: self.nitrogenOxide forKey: @"nitrogenOxide"];
    [aCoder encodeObject: self.ozone forKey: @"ozone"];
    [aCoder encodeObject: self.sulfurDioxide forKey: @"sulfurDioxide"];
    [aCoder encodeObject: self.suspendedParticulateMatter forKey: @"suspendedParticulateMatter"];
    [aCoder encodeObject: self.respirableSuspendedParticles forKey: @"respirableSuspendedParticles"];
    [aCoder encodeObject: self.fineParticles forKey: @"fineParticles"];
}

//+ (NSDictionary *)JSONKeyPathsByPropertyKey
//{
//    return @{
//             @"measurementID" : @"id",
//             @"date" : @"attributes.measured_at",
//             @"temperature" : @"attributes.temperature",
//             @"relativeHumidity" : @"attributes.relative_humidity",
//             @"windDirection" : @"attributes.wind_direction",
//             @"windSpeed" : @"attributes.wind_speed",
//             @"imecaPoints" : @"attributes.imeca_points",
//             @"precipitation" : @"attributes.precipitation",
//             @"carbonMonoxide" : @"attributes.carbon_monoxide",
//             @"nitricOxide" : @"attributes.nitric_oxide",
//             @"nitrogenDioxide" : @"attributes.nitrogen_dioxide",
//             @"nitrogenOxide" : @"attributes.nitrogen_oxide",
//             @"ozone" : @"attributes.ozone",
//             @"sulfurDioxide" : @"attributes.sulfur_dioxide",
//             @"suspendedParticulateMatter" : @"attributes.suspended_particulate_matter",
//             @"respirableSuspendedParticles" : @"attributes.respirable_suspended_particles",
//             @"fineParticles" : @"attributes.fine_particles",
//             };
//}

#pragma mark - Public API

- (AirQualityDescriptor)airQuality
{
    NSInteger imecaPoints = [self.imecaPoints integerValue];
    
    if (imecaPoints <= 130) {
        return AirQualityDescriptorGood;
    }else if (imecaPoints > 130 && imecaPoints <= 140) {
        return AirQualityDescriptorRegular;
    }else if (imecaPoints > 140 && imecaPoints <= 165) {
        return AirQualityDescriptorBad;
    }else if (imecaPoints > 165 && imecaPoints <= 185) {
        return AirQualityDescriptorVeryBad;
    }else{
        return AirQualityDescriptorExtremelyBad;
    }
    
}

- (NSString *)stringForAirQuality
{
    switch ([self airQuality]) {
        case AirQualityDescriptorGood:
            return NSLocalizedString(@"Good", nil);
            break;
        case AirQualityDescriptorRegular:
            return NSLocalizedString(@"Regular", nil);
            break;
        case AirQualityDescriptorBad:
            return NSLocalizedString(@"Bad", nil);
            break;
        case AirQualityDescriptorVeryBad:
            return NSLocalizedString(@"Very Bad", nil);
            break;
        case AirQualityDescriptorExtremelyBad:
            return NSLocalizedString(@"Extremely Bad", nil);
            break;
        default:
            return nil;
            break;
    }
}

- (UIColor *)colorForAirQuality
{
    switch ([self airQuality]) {
        case AirQualityDescriptorGood:
            return [UIColor il_goodColor];
            break;
        case AirQualityDescriptorRegular:
            return [UIColor il_regularColor];
            break;
        case AirQualityDescriptorBad:
            return [UIColor il_badColor];
            break;
        case AirQualityDescriptorVeryBad:
            return [UIColor il_veryBadColor];
            break;
        case AirQualityDescriptorExtremelyBad:
            return [UIColor il_extremelyBadColor];
            break;
        default:
            return nil;
            break;
    }
}

- (UIImage *)mapAnnotationImageForAirQuality
{
    return [self imageForType: [self airQuality]];
}

#pragma mark - Helper's

- (UIImage *)imageForType:(AirQualityDescriptor)type
{
    switch (type) {
        case AirQualityDescriptorGood:{
            return [UIImage imageNamed: @"WaypointIconGood"];
            break;
        }
        case AirQualityDescriptorRegular:{
            return [UIImage imageNamed: @"WaypointIconRegular"];
            break;
        }
        case AirQualityDescriptorBad:{
            return [UIImage imageNamed: @"WaypointIconBad"];
            break;
        }
        case AirQualityDescriptorVeryBad:{
            return [UIImage imageNamed: @"WaypointIconVeryBad"];
            break;
        }
        case AirQualityDescriptorExtremelyBad:{
            return [UIImage imageNamed: @"WaypointIconExtremelyBad"];
            break;
        }
        default:
            return nil;
            break;
    }
}

@end
