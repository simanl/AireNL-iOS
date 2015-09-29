//
//  BackgroundImageHelper.h
//  AireNL
//
//  Created by Daniel Lozano on 9/24/15.
//  Copyright © 2015 Icalia Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, ILTimeOfDay){
    ILTimeOfDaySunsetSunrise,
    ILTimeOfDayDay,
    ILTimeOfDayNight
};

@interface BackgroundImageHelper : NSObject

+ (ILTimeOfDay)currentTimeOfDay;
+ (UIImage *)backgroundImageForCurrentTime;
+ (NSString *)descriptionForImageForCurrentTime;

@end
