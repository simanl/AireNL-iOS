//
//  Station.m
//  AireNL
//
//  Created by Daniel Lozano on 9/14/15.
//  Copyright © 2015 Icalia Labs. All rights reserved.
//

#import "Station.h"

#import "Measurement.h"

@implementation Station

- (instancetype)initWithDictionary:(NSDictionary *)dictionaryValue error:(NSError **)error
{
    self = [super initWithDictionary: dictionaryValue error: error];
    if (self == nil) return nil;
        
    return self;
}

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
         @"stationID" : @"id",
         @"code" : @"attributes.code",
         @"name" : @"attributes.name",
         @"shortName" : @"attributes.short_name",
         @"coordinate" : @"attributes.latlon",
         @"lastMeasurementID" : @"relationships.last_measurement.data.id"
    };
}

+ (NSValueTransformer *)JSONTransformerForKey:(NSString *)key
{
    if ([key isEqualToString: @"stationID"] || [key isEqualToString: @"lastMeasurementID"]) {
        
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
        
    return nil;
    
}

+ (NSValueTransformer *)coordinateJSONTransformer
{
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSString *coordinateString, BOOL *success, NSError *__autoreleasing *error) {
        
        NSArray *separatedString = [coordinateString componentsSeparatedByString: @","];
        
        NSString *latitude = separatedString[0];
        NSString *longitude = separatedString[1];
        
        CLLocationDegrees lat = [latitude doubleValue];
        CLLocationDegrees lon = [longitude doubleValue];
        
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(lat, lon);
        NSValue *value = [NSValue valueWithBytes: &coordinate objCType: @encode(CLLocationCoordinate2D)];
        
        return value;
        
    }];
}

@end
