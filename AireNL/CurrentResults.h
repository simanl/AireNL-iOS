//
//  TotalResults.h
//  AireNL
//
//  Created by Daniel Lozano on 8/4/15.
//  Copyright (c) 2015 Icalia Labs. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ImecaResults.h"
#import "ContaminantResults.h"

@interface CurrentResults : NSObject

@property (nonatomic) NSDate *date;

@property (nonatomic) ImecaResults *imeca;
@property (nonatomic) ContaminantResults *contaminants;

@property (nonatomic) NSNumber *temperature;
@property (nonatomic) NSNumber *wind;

@end
