//
//  Measurement.h
//  AireNL
//
//  Created by Daniel Lozano on 9/14/15.
//  Copyright © 2015 Icalia Labs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, AirQualityDescriptor){
    AirQualityDescriptorGood,
    AirQualityDescriptorRegular,
    AirQualityDescriptorBad,
    AirQualityDescriptorVeryBad,
    AirQualityDescriptorExtremelyBad,
    AirQualityDescriptorNotAvailable
};

@interface Measurement : NSObject <NSCoding>

- (id)initWithDictionary:(NSDictionary *)dictionary;

// API DATA

@property (nonatomic) NSString *measurementID;

@property (nonatomic) NSDate *date;

@property (nonatomic) NSNumber *temperature;
@property (nonatomic) NSNumber *relativeHumidity;
@property (nonatomic) NSNumber *windDirection;
@property (nonatomic) NSNumber *windSpeed;

@property (nonatomic) NSNumber *imecaPoints;
@property (nonatomic) NSString *imecaCategory;
@property (nonatomic) NSNumber *precipitation;

@property (nonatomic) NSNumber *carbonMonoxide;
@property (nonatomic) NSNumber *nitricOxide;
@property (nonatomic) NSNumber *nitrogenDioxide;
@property (nonatomic) NSNumber *nitrogenOxides;
@property (nonatomic) NSNumber *sulfurDioxide;

@property (nonatomic) NSNumber *ozone;
@property (nonatomic) NSNumber *toracicParticles;
@property (nonatomic) NSNumber *respirableParticles;

@property (nonatomic) NSNumber *suspendedParticulateMatter;

// GENERATED VALUES

- (AirQualityDescriptor)airQuality;
- (UIColor *)colorForAirQuality;
- (NSString *)stringForAirQuality;

// MAPKIT

- (UIImage *)mapAnnotationImageForAirQuality;

@end
