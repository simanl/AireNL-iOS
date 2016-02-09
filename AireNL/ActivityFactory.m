//
//  ActivityFactory.m
//  AireNL
//
//  Created by Daniel Lozano on 2/9/16.
//  Copyright © 2016 Icalia Labs. All rights reserved.
//

#import "ActivityFactory.h"

@implementation ActivityFactory

+ (NSArray<Activity *> *)activitiesForAirqualityDescriptor:(AirQualityDescriptor)descriptor
{
    switch (descriptor) {
        case AirQualityDescriptorGood:
            return [self goodActivities];
            break;
        case AirQualityDescriptorRegular:
            return [self regularActivities];
            break;
        case AirQualityDescriptorBad:
            return [self badActivities];
            break;
        case AirQualityDescriptorVeryBad:
            return [self veryBadActivities];
            break;
        case AirQualityDescriptorExtremelyBad:
            return [self extremelyBadActivities];
            break;
        default:
            return nil;
            break;
    }
}

#pragma mark - Private Helper's

+ (NSArray<Activity *> *)goodActivities
{
    Activity *exercise = [[Activity alloc] initWithActivityType: ActivityTypeExercise];
    Activity *outdoors = [[Activity alloc] initWithActivityType: ActivityTypeOutdoors];
    Activity *sensible = [[Activity alloc] initWithActivityType: ActivityTypeSensible];
    
    return  @[exercise, outdoors, sensible];
}

+ (NSArray<Activity *> *)regularActivities
{
    Activity *exercise = [[Activity alloc] initWithActivityType: ActivityTypeExercise];
    Activity *outdoors = [[Activity alloc] initWithActivityType: ActivityTypeOutdoors];
    Activity *limitSensible = [[Activity alloc] initWithActivityType: ActivityTypeLimitSensible];
    
    return @[exercise, outdoors, limitSensible];
}

+ (NSArray<Activity *> *)badActivities
{
    Activity *limitExercise = [[Activity alloc] initWithActivityType: ActivityTypeLimitExercise];
    Activity *limitOutdoors = [[Activity alloc] initWithActivityType: ActivityTypeLimitOutdoors];
    Activity *noSensible = [[Activity alloc] initWithActivityType: ActivityTypeNoSensible];
    
    return @[limitExercise, limitOutdoors, noSensible];
}

+ (NSArray<Activity *> *)veryBadActivities
{
    Activity *noExercise = [[Activity alloc] initWithActivityType: ActivityTypeNoExercise];
    Activity *noOutdoors = [[Activity alloc] initWithActivityType: ActivityTypeNoOutdoors];
    Activity *window = [[Activity alloc] initWithActivityType: ActivityTypeWindow];
    Activity *noSensible = [[Activity alloc] initWithActivityType: ActivityTypeNoSensible];
    Activity *heart = [[Activity alloc] initWithActivityType: ActivityTypeHeart];
    Activity *limitCar = [[Activity alloc] initWithActivityType: ActivityTypeLimitCar];
    Activity *noFuel = [[Activity alloc] initWithActivityType: ActivityTypeNoFuel];
    Activity *limitSmoking = [[Activity alloc] initWithActivityType: ActivityTypeLimitSmoking];
    
    return @[noExercise, noOutdoors, window, noSensible, heart, limitCar, noFuel, limitSmoking];
}

+ (NSArray<Activity *> *)extremelyBadActivities
{
    Activity *noExercise = [[Activity alloc] initWithActivityType: ActivityTypeNoExercise];
    Activity *noOutdoors = [[Activity alloc] initWithActivityType: ActivityTypeNoOutdoors];
    Activity *window = [[Activity alloc] initWithActivityType: ActivityTypeWindow];
    Activity *noSensible = [[Activity alloc] initWithActivityType: ActivityTypeNoSensible];
    Activity *heart = [[Activity alloc] initWithActivityType: ActivityTypeHeart];
    Activity *limitCar = [[Activity alloc] initWithActivityType: ActivityTypeLimitCar];
    Activity *noFuel = [[Activity alloc] initWithActivityType: ActivityTypeNoFuel];
    Activity *noSmoking = [[Activity alloc] initWithActivityType: ActivityTypeNoSmoking];
    
    return  @[noExercise, noOutdoors, window, noSensible, heart, limitCar, noFuel, noSmoking];
}

@end
