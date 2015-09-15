//
//  Measurement.h
//  AireNL
//
//  Created by Daniel Lozano on 9/14/15.
//  Copyright © 2015 Icalia Labs. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <Mantle/Mantle.h>

@interface Measurement : MTLModel <MTLJSONSerializing>

@property (nonatomic) NSNumber *measurementID;

@property (nonatomic) NSDate *date;

@property (nonatomic) NSNumber *temperature;
@property (nonatomic) NSNumber *relativeHumidity;
@property (nonatomic) NSNumber *windDirection;
@property (nonatomic) NSNumber *windSpeed;

@property (nonatomic) NSNumber *imecaPoints;
@property (nonatomic) NSNumber *rainfall;
@property (nonatomic) NSNumber *carbonMonoxide;
@property (nonatomic) NSNumber *nitricOxide;
@property (nonatomic) NSNumber *nitrogenDioxide;
@property (nonatomic) NSNumber *nitrogenOxide;
@property (nonatomic) NSNumber *ozone;
@property (nonatomic) NSNumber *sulfurDioxide;

@property (nonatomic) NSNumber *suspendedParticulateMatter;
@property (nonatomic) NSNumber *respirableSuspendedParticles;
@property (nonatomic) NSNumber *fineParticles;

@end
