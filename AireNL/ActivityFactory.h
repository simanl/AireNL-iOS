//
//  ActivityFactory.h
//  AireNL
//
//  Created by Daniel Lozano on 2/9/16.
//  Copyright © 2016 Icalia Labs. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Activity.h"
#import "Measurement.h"

@interface ActivityFactory : NSObject

+ (NSArray<Activity *> *)activitiesForAirqualityDescriptor:(AirQualityDescriptor)descriptor;

@end
