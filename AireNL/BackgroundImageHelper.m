//
//  BackgroundImageHelper.m
//  AireNL
//
//  Created by Daniel Lozano on 9/24/15.
//  Copyright © 2015 Icalia Labs. All rights reserved.
//

#import "BackgroundImageHelper.h"

@implementation BackgroundImageHelper

+ (UIImage *)backgroundImageForCurrentTime
{
    NSString *imageName;
    
    switch ([self currentTimeOfDay]) {
        case ILTimeOfDayDay:
            imageName = @"BackgroundDay";
            break;
        case ILTimeOfDayNight:
            imageName = @"BackgroundNight";
            break;
        case ILTimeOfDaySunsetSunrise:
            imageName = @"BackgroundSunset";
            break;
        default:{
            imageName = @"BackgroundSunset";
            break;
        }
    }
    
    return [UIImage imageNamed: imageName];
}

+ (ILTimeOfDay)currentTimeOfDay
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"HH.mm"];
    
    NSString *currentTimeStr = [dateFormatter stringFromDate: [NSDate date]];
    CGFloat currentTime = [currentTimeStr floatValue];
    
    BOOL dayTime = currentTime >= 9.00 && currentTime <= 18.00;
    BOOL sunrise = currentTime >= 6.00 && currentTime <= 9.00;
    BOOL sunset = currentTime >= 18.00 && currentTime <= 21.00;
    
    if (dayTime) {
        return ILTimeOfDayDay;
    }else if (sunrise || sunset){
        return ILTimeOfDaySunsetSunrise;
    }else{
        return ILTimeOfDayNight;
    }
}

@end
