//
//  PredictionResults.h
//  AireNL
//
//  Created by Daniel Lozano on 8/4/15.
//  Copyright (c) 2015 Icalia Labs. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ContaminantResults;

@interface PredictionResults : NSObject

@property (nonatomic) ContaminantResults *periodOne;
@property (nonatomic) ContaminantResults *periodTwo;
@property (nonatomic) ContaminantResults *periodThree;

@end
