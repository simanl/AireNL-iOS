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
    
//    self.ozone = [attributes dl_objectForKeyWithNil: @"ozone"];
//    self.toracicParticles = [attributes dl_objectForKeyWithNil: @"toracic_particles"];
//    self.respirableParticles = [attributes dl_objectForKeyWithNil: @"respirable_particles"];
    
    self.ozoneIndex = [attributes dl_objectForKeyWithNil: @"ozone_index"];
    self.toracicParticlesIndex = [attributes dl_objectForKeyWithNil: @"toracic_particles_index"];
    self.respirableParticlesIndex = [attributes dl_objectForKeyWithNil: @"respirable_particles_index"];

    self.ozoneCategory = [attributes dl_objectForKeyWithNil: @"ozone_category"];
    self.toracicParticlesCategory = [attributes dl_objectForKeyWithNil: @"toracic_particles_category"];
    self.respirableParticlesCategory = [attributes dl_objectForKeyWithNil: @"respirable_particles_category"];
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init]; if (!self) return nil;
    
    self.forecastID = [aDecoder decodeObjectForKey: @"forecastID"];
    self.startsAt = [aDecoder decodeObjectForKey: @"starts_at"];
    self.endsAt = [aDecoder decodeObjectForKey: @"ends_at"];
    
//    self.ozone = [aDecoder decodeObjectForKey: @"ozone"];
//    self.toracicParticles = [aDecoder decodeObjectForKey: @"toracicParticles"];
//    self.respirableParticles = [aDecoder decodeObjectForKey: @"respirableParticles"];
    
    self.ozoneIndex = [aDecoder decodeObjectForKey: @"ozoneIndex"];
    self.toracicParticlesIndex = [aDecoder decodeObjectForKey: @"toracicParticlesIndex"];
    self.respirableParticlesIndex = [aDecoder decodeObjectForKey: @"respirableParticlesIndex"];
    
    self.ozoneCategory = [aDecoder decodeObjectForKey: @"ozoneCategory"];
    self.toracicParticlesCategory = [aDecoder decodeObjectForKey: @"toracicParticlesCategory"];
    self.respirableParticlesCategory = [aDecoder decodeObjectForKey: @"respirableParticlesCategory"];
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject: self.forecastID forKey: @"forecastID"];
    [aCoder encodeObject: self.startsAt forKey: @"starts_at"];
    [aCoder encodeObject: self.endsAt forKey: @"ends_at"];
    
//    [aCoder encodeObject: self.ozone forKey: @"ozone"];
//    [aCoder encodeObject: self.toracicParticles forKey: @"toracicParticles"];
//    [aCoder encodeObject: self.respirableParticles forKey: @"respirableParticles"];
    
    [aCoder encodeObject: self.ozoneIndex forKey: @"ozoneIndex"];
    [aCoder encodeObject: self.toracicParticlesIndex forKey: @"toracicParticlesIndex"];
    [aCoder encodeObject: self.respirableParticlesIndex forKey: @"respirableParticlesIndex"];
    
    [aCoder encodeObject: self.ozoneCategory forKey: @"ozoneCategory"];
    [aCoder encodeObject: self.toracicParticlesCategory forKey: @"toracicParticlesCategory"];
    [aCoder encodeObject: self.respirableParticlesCategory forKey: @"respirableParticlesCategory"];
    
}

- (NSString *)description
{
    return [NSString stringWithFormat: @"ID:%@ STARTS_AT:%@ ENDS_AT:%@ OZONE:%@ TORACIC_PARTICLES:%@ RESPIRABLE_PARTICLES:%@",
            self.forecastID, self.startsAt, self.endsAt, self.ozoneIndex, self.toracicParticlesIndex, self.respirableParticlesIndex];
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
