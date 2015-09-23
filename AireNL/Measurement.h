//
//  Measurement.h
//  AireNL
//
//  Created by Daniel Lozano on 9/14/15.
//  Copyright © 2015 Icalia Labs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import <Mantle/Mantle.h>

typedef NS_ENUM(NSInteger, AirQualityDescriptor){
    AirQualityDescriptorGood,
    AirQualityDescriptorRegular,
    AirQualityDescriptorBad,
    AirQualityDescriptorVeryBad,
    AirQualityDescriptorExtremelyBad
};

@interface Measurement : MTLModel <MTLJSONSerializing>

// API DATA

@property (nonatomic) NSNumber *measurementID;

@property (nonatomic) NSDate *date;

@property (nonatomic) NSNumber *temperature;
@property (nonatomic) NSNumber *relativeHumidity;
@property (nonatomic) NSNumber *windDirection;
@property (nonatomic) NSNumber *windSpeed;

@property (nonatomic) NSNumber *imecaPoints;
@property (nonatomic) NSNumber *precipitation;
@property (nonatomic) NSNumber *carbonMonoxide;
@property (nonatomic) NSNumber *nitricOxide;
@property (nonatomic) NSNumber *nitrogenDioxide;
@property (nonatomic) NSNumber *nitrogenOxide;
@property (nonatomic) NSNumber *ozone;
@property (nonatomic) NSNumber *sulfurDioxide;

@property (nonatomic) NSNumber *suspendedParticulateMatter;
@property (nonatomic) NSNumber *respirableSuspendedParticles;
@property (nonatomic) NSNumber *fineParticles;

// GENERATED VALUES

- (AirQualityDescriptor)airQuality;
- (UIColor *)colorForAirQuality;
- (NSString *)stringForAirQuality;

// MAPKIT

- (UIImage *)mapAnnotationImageForAirQuality;

@end
