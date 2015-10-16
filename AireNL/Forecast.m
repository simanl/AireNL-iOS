//
//  Forecast.m
//  AireNL
//
//  Created by Daniel Lozano on 10/5/15.
//  Copyright © 2015 Icalia Labs. All rights reserved.
//

#import "Forecast.h"

#import "NSDictionary+WithoutNSNull.h"

@interface Forecast ()

@property (nonatomic) NSDateFormatter *dateFormatter;

@end

@implementation Forecast

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init]; if(!self) return nil;
    
    self.forecastID = [dictionary dl_objectForKeyWithNil: @"id"];
    
    NSDictionary *attributes = [dictionary dl_objectForKeyWithNil: @"attributes"];
    
    NSString *startsAtDateString = [attributes dl_objectForKeyWithNil: @"starts_at"];
    self.startsAt = [self.dateFormatter dateFromString: startsAtDateString];    
    NSString *endsAtDateString = [attributes dl_objectForKeyWithNil: @"ends_at"];
    self.endsAt = [self.dateFormatter dateFromString: endsAtDateString];
    
    self.ozone = [attributes dl_objectForKeyWithNil: @"ozone"];
    self.toracicParticles = [attributes dl_objectForKeyWithNil: @"toracic_particles"];
    self.respirableParticles = [attributes dl_objectForKeyWithNil: @"respirable_particles"];
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init]; if (!self) return nil;
    
    self.forecastID = [aDecoder decodeObjectForKey: @"forecastID"];
    self.startsAt = [aDecoder decodeObjectForKey: @"starts_at"];
    self.endsAt = [aDecoder decodeObjectForKey: @"ends_at"];
    self.ozone = [aDecoder decodeObjectForKey: @"ozone"];
    self.toracicParticles = [aDecoder decodeObjectForKey: @"toracicParticles"];
    self.respirableParticles = [aDecoder decodeObjectForKey: @"respirableParticles"];
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject: self.forecastID forKey: @"forecastID"];
    [aCoder encodeObject: self.startsAt forKey: @"starts_at"];
    [aCoder encodeObject: self.endsAt forKey: @"ends_at"];
    [aCoder encodeObject: self.ozone forKey: @"ozone"];
    [aCoder encodeObject: self.toracicParticles forKey: @"toracicParticles"];
    [aCoder encodeObject: self.respirableParticles forKey: @"respirableParticles"];
}

- (NSString *)description
{
    return [NSString stringWithFormat: @"ID:%@ STARTS_AT:%@ ENDS_AT:%@ OZONE:%@ TORACIC_PARTICLES:%@ RESPIRABLE_PARTICLES:%@",
            self.forecastID, self.startsAt, self.endsAt, self.ozone, self.toracicParticles, self.respirableParticles];
}

#pragma mark - Set/Get

- (NSDateFormatter *)dateFormatter
{
    if (!_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        [_dateFormatter setLocale: [NSLocale localeWithLocaleIdentifier: @"en_US_POSIX"]];
        [_dateFormatter setDateFormat: @"YYYY-MM-dd'T'HH:mm:ss.SSSZ"];
    }
    return _dateFormatter;
}

@end
