//
//  Forecast.h
//  AireNL
//
//  Created by Daniel Lozano on 10/5/15.
//  Copyright © 2015 Icalia Labs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Forecast : NSObject <NSCoding>

- (id)initWithDictionary:(NSDictionary *)dictionary;

// API DATA

@property (nonatomic) NSString *forecastID;

@property (nonatomic) NSDate *startsAt;
@property (nonatomic) NSDate *endsAt;

@property (nonatomic) NSString *ozone;
@property (nonatomic) NSString *toracicParticles;
@property (nonatomic) NSString *respirableParticles;

@end
