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
#import <MapKit/MapKit.h>

@interface Station : NSObject <NSCoding, MKAnnotation>

- (id)initWithDictionary:(NSDictionary *)dictionary;

@property (nonatomic) NSString *stationID;

@property (nonatomic) NSString *code;
@property (nonatomic) NSString *name;
@property (nonatomic) NSString *shortName;

@property (nonatomic) NSString *coordinateString;

- (CLLocationCoordinate2D)coordinate;

// RELATIONSHIPS

@property (nonatomic) NSString *lastMeasurementID;

@end
