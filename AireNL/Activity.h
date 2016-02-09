//
//  Activity.h
//  AireNL
//
//  Created by Daniel Lozano on 2/8/16.
//  Copyright © 2016 Icalia Labs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ActivityType)
{
    ActivityTypeOutdoors,
    ActivityTypeLimitOutdoors,
    ActivityTypeNoOutdoors,
    
    ActivityTypeExercise,
    ActivityTypeLimitExercise,
    ActivityTypeNoExercise,
    
    ActivityTypeSensible,
    ActivityTypeLimitSensible,
    ActivityTypeNoSensible,
    
    ActivityTypeLimitCar,
    ActivityTypeNoCar,
    
    ActivityTypeLimitSmoking,
    ActivityTypeNoSmoking,

    ActivityTypeWindow,
    ActivityTypeHeart,
    ActivityTypeNoFuel
};

@interface Activity : NSObject

- (id)initWithActivityType:(ActivityType)type;

- (NSString *)description;
- (UIImage *)image;

@end
