//
//  AireNLAPI.m
//  AireNL
//
//  Created by Daniel Lozano on 9/15/15.
//  Copyright © 2015 Icalia Labs. All rights reserved.
//

#import "AireNLAPI.h"

#import "Constants.h"
#import "APIResults.h"

@implementation AireNLAPI

+ (id)sharedAPI
{
    static AireNLAPI *__instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        NSURL *baseURL = [NSURL URLWithString: kBaseURL];
        __instance = [[AireNLAPI alloc] initWithBaseURL: baseURL];
        __instance.requestSerializer = [AFJSONRequestSerializer serializer];
        __instance.responseSerializer = [AFJSONResponseSerializer serializer];
//        [__instance.requestSerializer setValue: @"application/vnd.twenty_one.com+json; version=1" forHTTPHeaderField: @"Accept"];
//        [__instance.requestSerializer setValue: [[Session sharedSession] sessionToken] forHTTPHeaderField: @"Authorization"];

    });
    return __instance;
}

- (void)getStationsWithCompletion:(ArrayCompletionBlock)completion
{
    NSDictionary *params = @{@"include" : @"last_measurement"};
    
    [self GET: @"/stations.json" parameters: params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        
        NSArray *stationDicts = responseObject[@"data"];
        NSArray *measurementDicts = responseObject[@"included"];
        
        NSMutableArray *stations = [[NSMutableArray alloc] initWithCapacity: [stationDicts count]];
        NSMutableArray *measurements = [[NSMutableArray alloc] initWithCapacity: [measurementDicts count]];
                
        for (NSDictionary *stationDict in stationDicts) {
            NSError *error = nil;
            Station *station = [MTLJSONAdapter modelOfClass: Station.class
                                         fromJSONDictionary: stationDict
                                                      error: &error];
            if (error) {
                NSLog(@"MANTLE PARSE ERROR : %@", error);
            }else{
                [stations addObject: station];
            }
        }
        
        for (NSDictionary *measurementDict in measurementDicts) {
            NSError *error = nil;
            Measurement *measurement = [MTLJSONAdapter modelOfClass: Measurement.class
                                                 fromJSONDictionary: measurementDict
                                                              error: &error];
            if (error) {
                NSLog(@"MANTLE PARSE ERROR : %@", error);
            }else{
                [measurements addObject: measurement];
            }
        }
        
        APIResults *results = [[APIResults alloc] initWithStations: stations measurements: measurements];
        completion(results, nil);
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        completion(nil, error);
    }];
    
}

@end
