//
//  ImecaResults.m
//  AireNL
//
//  Created by Daniel Lozano on 8/4/15.
//  Copyright (c) 2015 Icalia Labs. All rights reserved.
//

#import "ImecaResults.h"

#import "UIColor+ILColor.h"

@implementation ImecaResults

- (NSString *)airQualityString
{
    switch (self.airQuality) {
        case AirQualityTypeGood:
            return @"Buena";
            break;
        case AirQualityTypeRegular:
            return @"Regular";
            break;
        case AirQualityTypeBad:
            return @"Mala";
            break;
        case AirQualityTypeVeryBad:
            return @"Muy Mala";
            break;
        case AirQualityTypeExtremelyBad:
            return @"Extremadamente Mala";
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

@end
