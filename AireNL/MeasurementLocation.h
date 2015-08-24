//
//  MeasurementLocation.h
//  AireNL
//
//  Created by Daniel Lozano on 8/24/15.
//  Copyright (c) 2015 Icalia Labs. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <MapKit/MapKit.h>

typedef NS_ENUM(NSInteger, MeasurementLocationAirQualityType){
    MeasurementLocationAirQualityTypeGood,
    MeasurementLocationAirQualityTypeRegular,
    MeasurementLocationAirQualityTypeBad,
    MeasurementLocationAirQualityTypeVeryBad,
    MeasurementLocationAirQualityTypeExtremelyBad
};

@interface MeasurementLocation : NSObject <MKAnnotation>

- (id)initWithName:(NSString *)name airQuality:(MeasurementLocationAirQualityType)type coordinate:(CLLocationCoordinate2D)coordinate;

- (UIImage *)annotationImage;

@end
