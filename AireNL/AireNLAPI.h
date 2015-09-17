//
//  AireNLAPI.h
//  AireNL
//
//  Created by Daniel Lozano on 9/15/15.
//  Copyright © 2015 Icalia Labs. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AFHTTPSessionManager.h"
#import "APIResults.h"

typedef void (^CompletionBlock)(BOOL success, NSError *error);
typedef void (^ResultCompletionBlock)(APIResults *results, NSError *error);

@interface AireNLAPI : AFHTTPSessionManager

+ (id)sharedAPI;

- (void)getStationsWithCompletion:(ResultCompletionBlock)completion;
- (void)getNearestStationForCoordinate:(CLLocationCoordinate2D)coordinate withCompletion: (ResultCompletionBlock)completion;

@end
