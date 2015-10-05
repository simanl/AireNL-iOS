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

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init]; if (!self) return nil;
    
    self.forecastID = [aDecoder decodeObjectForKey: @"forecastID"];
    self.date = [aDecoder decodeObjectForKey: @"date"];
    self.updatedAt = [aDecoder decodeObjectForKey: @"updatedAt"];
    self.ozone = [aDecoder decodeObjectForKey: @"ozone"];
    self.toracicParticles = [aDecoder decodeObjectForKey: @"toracicParticles"];
    self.respirableParticles = [aDecoder decodeObjectForKey: @"respirableParticles"];
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject: self.forecastID forKey: @"forecastID"];
    [aCoder encodeObject: self.date forKey: @"date"];
    [aCoder encodeObject: self.updatedAt forKey: @"updatedAt"];
    [aCoder encodeObject: self.ozone forKey: @"ozone"];
    [aCoder encodeObject: self.toracicParticles forKey: @"toracicParticles"];
    [aCoder encodeObject: self.respirableParticles forKey: @"respirableParticles"];
}

- (NSString *)description
{
    return [NSString stringWithFormat: @"ID:%@ DATE:%@ UPDATED_AT:%@ OZONE:%@ TORACIC_PARTICLES:%@ RESPIRABLE_PARTICLES:%@",
            self.forecastID, self.date, self.updatedAt, self.ozone, self.toracicParticles, self.respirableParticles];
}

@end
