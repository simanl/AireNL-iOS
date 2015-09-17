//
//  Station.h
//  AireNL
//
//  Created by Daniel Lozano on 9/14/15.
//  Copyright © 2015 Icalia Labs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import <CoreLocation/CoreLocation.h>
#import <Mantle/Mantle.h>

@interface Station : MTLModel <MTLJSONSerializing>

@property (nonatomic) NSNumber *stationID;

@property (nonatomic) NSString *code;
@property (nonatomic) NSString *name;
@property (nonatomic) NSString *shortName;

@property (nonatomic) NSString *coordinateString;

- (CLLocationCoordinate2D)coordinate;

// RELATIONSHIPS

@property (nonatomic) NSNumber *lastMeasurementID;

@end
