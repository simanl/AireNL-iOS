//
//  Forecast.m
//  AireNL
//
//  Created by Daniel Lozano on 10/5/15.
//  Copyright © 2015 Icalia Labs. All rights reserved.
//

#import "Forecast.h"

#import "NSDictionary+WithoutNSNull.h"

@implementation Forecast

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init]; if(!self) return nil;
    
    self.forecastID = [dictionary dl_objectForKeyWithNil: @"id"];
    
    NSDictionary *attributes = [dictionary dl_objectForKeyWithNil: @"attributes"];
    self.date = [attributes dl_objectForKeyWithNil: @"forecasted_datetime"];
    self.updatedAt = [attributes dl_objectForKeyWithNil: @"updated_at"];
    
    self.ozone = [attributes dl_objectForKeyWithNil: @"ozone"];
    self.toracicParticles = [attributes dl_objectForKeyWithNil: @"toracic_particles"];
    self.respirableParticles = [attributes dl_objectForKeyWithNil: @"respirable_particles"];
    
    return self;
}

@end
