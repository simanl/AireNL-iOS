//
//  Measurement.m
//  AireNL
//
//  Created by Daniel Lozano on 9/14/15.
//  Copyright © 2015 Icalia Labs. All rights reserved.
//

#import "Measurement.h"

#import "UIColor+ILColor.h"

@implementation Measurement

- (instancetype)initWithDictionary:(NSDictionary *)dictionaryValue error:(NSError **)error
{
    self = [super initWithDictionary: dictionaryValue error: error];
    if (self == nil) return nil;
    
    return self;
}

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"measurementID" : @"id",
             @"date" : @"attributes.measured_at",
             @"temperature" : @"attributes.temperature",
             @"relativeHumidity" : @"attributes.relative_humidity",
             @"windDirection" : @"attributes.wind_direction",
             @"windSpeed" : @"attributes.wind_speed",
             @"imecaPoints" : @"attributes.imeca_points",
             @"precipitation" : @"attributes.precipitation",
             @"carbonMonoxide" : @"attributes.carbon_monoxide",
             @"nitricOxide" : @"attributes.nitric_oxide",
             @"nitrogenDioxide" : @"attributes.nitrogen_dioxide",
             @"nitrogenOxide" : @"attributes.nitrogen_oxide",
             @"ozone" : @"attributes.ozone",
             @"sulfurDioxide" : @"attributes.sulfur_dioxide",
             @"suspendedParticulateMatter" : @"attributes.suspended_particulate_matter",
             @"respirableSuspendedParticles" : @"attributes.respirable_suspended_particles",
             @"fineParticles" : @"attributes.fine_particles",
             };
}

+ (NSValueTransformer *)JSONTransformerForKey:(NSString *)key
{
    if ([key isEqualToString: @"date"]) {
        return nil;
    }else{
        
        return [MTLValueTransformer transformerUsingForwardBlock: ^id(id value, BOOL *success, NSError *__autoreleasing *error) {
            
            if ([value isKindOfClass: [NSString class]]) {
                NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
                formatter.numberStyle = NSNumberFormatterDecimalStyle;
                return [formatter numberFromString: value];
            }else{
                return nil;
            }
            
        }];
        
    }

}

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
