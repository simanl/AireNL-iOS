//
//  Activity.m
//  AireNL
//
//  Created by Daniel Lozano on 2/8/16.
//  Copyright © 2016 Icalia Labs. All rights reserved.
//

#import "Activity.h"

@interface Activity ()

@property (nonatomic) ActivityType type;

@end

@implementation Activity

- (id)initWithActivityType:(ActivityType)type
{
    self = [super init]; if (!self) return nil;
    
    self.type = type;
    
    return self;
}

#pragma mark - Public API

- (NSString *)description
{
    switch (self.type) {
        case ActivityTypeOutdoors:
            return NSLocalizedString(@"ACTIVITY_OUTDOORS", nil);
            break;
        case ActivityTypeLimitOutdoors:
            return NSLocalizedString(@"ACTIVITY_LIMIT_OUTDOORS", nil);
            break;
        case ActivityTypeNoOutdoors:
            return NSLocalizedString(@"ACTIVITY_NO_OUTDOORS", nil);
            break;
        case ActivityTypeExercise:
            return NSLocalizedString(@"ACTIVITY_EXERCISE", nil);
            break;
        case ActivityTypeLimitExercise:
            return NSLocalizedString(@"ACTIVITY_LIMIT_EXERCISE", nil);
            break;
        case ActivityTypeNoExercise:
            return NSLocalizedString(@"ACTIVITY_NO_EXERCISE", nil);
            break;
        case ActivityTypeSensible:
            return NSLocalizedString(@"ACTIVITY_SENSIBLE", nil);
            break;
        case ActivityTypeLimitSensible:
            return NSLocalizedString(@"ACTIVITY_LIMIT_SENSIBLE", nil);
            break;
        case ActivityTypeNoSensible:
            return NSLocalizedString(@"ACTIVITY_NO_SENSIBLE", nil);
            break;
        case ActivityTypeLimitCar:
            return NSLocalizedString(@"ACTIVITY_LIMIT_CAR", nil);
            break;
        case ActivityTypeNoCar:
            return NSLocalizedString(@"ACTIVITY_NO_CAR", nil);
            break;
        case ActivityTypeWindow:
            return NSLocalizedString(@"ACTIVITY_WINDOW", nil);
            break;
        case ActivityTypeHeart:
            return NSLocalizedString(@"ACTIVITY_HEART", nil);
            break;
        case ActivityTypeNoFuel:
            return NSLocalizedString(@"ACTIVITY_NO_FUEL", nil);
            break;
        default:
            break;
    }
}

- (UIImage *)image
{
    switch (self.type) {
        case ActivityTypeOutdoors:
            return [UIImage imageNamed: @"OutdoorsIcon"];
            break;
        case ActivityTypeLimitOutdoors:
            return [UIImage imageNamed: @"OutdoorsLimitIcon"];
            break;
        case ActivityTypeNoOutdoors:
            return [UIImage imageNamed: @"OutdoorsNoIcon"];
            break;
        case ActivityTypeExercise:
            return [UIImage imageNamed: @"ExerciseIcon"];
            break;
        case ActivityTypeLimitExercise:
            return [UIImage imageNamed: @"ExerciseLimitIcon"];
            break;
        case ActivityTypeNoExercise:
            return [UIImage imageNamed: @"ExerciseNoIcon"];
            break;
        case ActivityTypeSensible:
            return [UIImage imageNamed: @""];
            break;
        case ActivityTypeLimitSensible:
            return [UIImage imageNamed: @""];
            break;
        case ActivityTypeNoSensible:
            return [UIImage imageNamed: @""];
            break;
        case ActivityTypeLimitCar:
            return [UIImage imageNamed: @"CarLimitIcon"];
            break;
        case ActivityTypeNoCar:
            return [UIImage imageNamed: @"CarNoIcon"];
            break;
        case ActivityTypeWindow:
            return [UIImage imageNamed: @"WindowIcon"];
            break;
        case ActivityTypeHeart:
            return [UIImage imageNamed: @"HeartIcon"];
            break;
        case ActivityTypeNoFuel:
            return [UIImage imageNamed: @"FuelNoIcon"];
            break;
        default:
            break;
    }
}

@end
