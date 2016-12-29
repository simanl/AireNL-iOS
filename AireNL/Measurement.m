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

@interface Measurement ()

@property (nonatomic) NSDateFormatter *dateFormatter;

@end

@implementation Measurement

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init]; if (!self) return nil;
    
    self.measurementID = [dictionary dl_objectForKeyWithNil: @"id"];
    
    NSDictionary *attributes = [dictionary dl_objectForKeyWithNil: @"attributes"];

    NSString *dateString = [attributes dl_objectForKeyWithNil: @"measured_at"];
    self.date = [self.dateFormatter dateFromString: dateString];
    
    self.temperature = [attributes dl_objectForKeyWithNil: @"temperature"];
    self.relativeHumidity = [attributes dl_objectForKeyWithNil: @"relative_humidity"];
    self.windDirection = [attributes dl_objectForKeyWithNil: @"wind_direction"];
    self.windSpeed = [attributes dl_objectForKeyWithNil: @"wind_speed"];
    self.imecaPoints = [attributes dl_objectForKeyWithNil: @"imeca_points"];
    self.imecaCategory = [attributes dl_objectForKeyWithNil: @"imeca_category"];
    self.precipitation = [attributes dl_objectForKeyWithNil: @"precipitation"];
    self.carbonMonoxide = [attributes dl_objectForKeyWithNil: @"carbon_monoxide"];
    self.nitricOxide = [attributes dl_objectForKeyWithNil: @"nitric_oxide"];
    self.nitrogenDioxide = [attributes dl_objectForKeyWithNil: @"nitrogen_dioxide"];
    self.nitrogenOxides = [attributes dl_objectForKeyWithNil: @"nitrogen_oxides"];
    self.sulfurDioxide = [attributes dl_objectForKeyWithNil: @"sulfur_dioxide"];

    self.ozone = [attributes dl_objectForKeyWithNil: @"ozone"];
    self.toracicParticles = [attributes dl_objectForKeyWithNil: @"toracic_particles"];
    self.respirableParticles = [attributes dl_objectForKeyWithNil: @"respirable_particles"];
    
    self.suspendedParticulateMatter = [attributes dl_objectForKeyWithNil: @"suspended_particulate_matter"];
    
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
    self.imecaCategory = [aDecoder decodeObjectForKey: @"imecaCategory"];
    self.precipitation = [aDecoder decodeObjectForKey: @"precipitation"];
    self.carbonMonoxide = [aDecoder decodeObjectForKey: @"carbonMonoxide"];
    self.nitricOxide = [aDecoder decodeObjectForKey: @"nitricOxide"];
    self.nitrogenDioxide = [aDecoder decodeObjectForKey: @"nitrogenDioxide"];
    self.nitrogenOxides = [aDecoder decodeObjectForKey: @"nitrogenOxides"];
    self.sulfurDioxide = [aDecoder decodeObjectForKey: @"sulfurDioxide"];
    
    self.ozone = [aDecoder decodeObjectForKey: @"ozone"];
    self.toracicParticles = [aDecoder decodeObjectForKey: @"toracicParticles"];
    self.respirableParticles = [aDecoder decodeObjectForKey: @"respirableParticles"];
    
    self.suspendedParticulateMatter = [aDecoder decodeObjectForKey: @"suspendedParticulateMatter"];
    
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
    [aCoder encodeObject: self.imecaCategory forKey: @"imecaCategory"];
    [aCoder encodeObject: self.precipitation forKey: @"precipitation"];
    [aCoder encodeObject: self.carbonMonoxide forKey: @"carbonMonoxide"];
    [aCoder encodeObject: self.nitricOxide forKey: @"nitricOxide"];
    [aCoder encodeObject: self.nitrogenDioxide forKey: @"nitrogenDioxide"];
    [aCoder encodeObject: self.nitrogenOxides forKey: @"nitrogenOxides"];
    [aCoder encodeObject: self.sulfurDioxide forKey: @"sulfurDioxide"];
    
    [aCoder encodeObject: self.ozone forKey: @"ozone"];
    [aCoder encodeObject: self.toracicParticles forKey: @"respirableSuspendedParticles"];
    [aCoder encodeObject: self.respirableParticles forKey: @"fineParticles"];
    
    [aCoder encodeObject: self.suspendedParticulateMatter forKey: @"suspendedParticulateMatter"];
}

#pragma mark - Public API

- (AirQualityDescriptor)airQuality
{
    if ([self.imecaCategory isEqualToString: @"good"]) {
        return AirQualityDescriptorGood;
        
    }else if ([self.imecaCategory isEqualToString: @"regular"]) {
        return AirQualityDescriptorRegular;
        
    }else if ([self.imecaCategory isEqualToString: @"bad"]) {
        return AirQualityDescriptorBad;
        
    }else if ([self.imecaCategory isEqualToString: @"very_bad"]){
        return AirQualityDescriptorVeryBad;
        
    }else if ([self.imecaCategory isEqualToString: @"extremely_bad"]){
        return AirQualityDescriptorExtremelyBad;
        
    }else{
        return AirQualityDescriptorNotAvailable;
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
            return NSLocalizedString(@"Not Available", nil);
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
            return [UIColor il_notAvailableColor];
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
            return [UIImage imageNamed: @"WaypointIconNotAvailable"];
            break;
    }
}

#pragma mark - Set/Get

- (NSDateFormatter *)dateFormatter
{
    if (!_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        [_dateFormatter setLocale: [NSLocale localeWithLocaleIdentifier: @"en_US_POSIX"]];
        [_dateFormatter setDateFormat: @"YYYY-MM-dd'T'HH:mm:ss.SSSZ"];
    }
    return _dateFormatter;
}

@end
