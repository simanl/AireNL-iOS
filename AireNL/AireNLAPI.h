//
//  AireNLAPI.h
//  AireNL
//
//  Created by Daniel Lozano on 9/15/15.
//  Copyright © 2015 Icalia Labs. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "APIResults.h"

typedef void (^ResultCompletionBlock)(APIResults *results, NSError *error);
typedef void (^APICompletionBlock)(id responseObject, NSError *error);

@interface AireNLAPI : NSObject

+ (id)sharedAPI;

- (void)getStationsWithCompletion:(ResultCompletionBlock)completion;
- (void)getDefaultStationWithCompletion:(ResultCompletionBlock)completion;
- (void)getStationWithId:(NSString *)stationID withCompletion:(ResultCompletionBlock)completion;
- (void)getNearestStationForCoordinate:(CLLocationCoordinate2D)coordinate withCompletion:(ResultCompletionBlock)completion;

- (void)disableCaching;

@end
