//
//  ImecaResults.h
//  AireNL
//
//  Created by Daniel Lozano on 8/4/15.
//  Copyright (c) 2015 Icalia Labs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, AirQualityType){
    AirQualityTypeGood,
    AirQualityTypeRegular,
    AirQualityTypeBad,
    AirQualityTypeVeryBad,
    AirQualityTypeExtremelyBad
};

@interface ImecaResults : NSObject

@property (nonatomic) NSNumber *amount;
@property (nonatomic) AirQualityType airQuality;

- (NSString *)airQualityString;
- (UIColor *)airQualityColor;

@end
