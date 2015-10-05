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

@property (nonatomic) NSString *date;
@property (nonatomic) NSString *updatedAt;

@property (nonatomic) NSNumber *ozone;
@property (nonatomic) NSNumber *toracicParticles;
@property (nonatomic) NSNumber *respirableParticles;

@end
