//
//  Measurement.m
//  AireNL
//
//  Created by Daniel Lozano on 9/14/15.
//  Copyright © 2015 Icalia Labs. All rights reserved.
//

#import "Measurement.h"

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
             @"rainfall" : @"attributes.rainfall",
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

@end
