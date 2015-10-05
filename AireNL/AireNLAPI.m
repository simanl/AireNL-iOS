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

@interface AireNLAPI ()

@property (nonatomic) NSURLSession *session;

@end

@implementation AireNLAPI

#pragma mark - Init

+ (id)sharedAPI
{
    static AireNLAPI *__instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __instance = [[AireNLAPI alloc] init];
    });
    return __instance;
}

- (id)init
{
    self = [super init]; if (!self) return nil;
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    self.session = [NSURLSession sessionWithConfiguration: configuration];
    
    return self;
}

#pragma mark - Public API

- (void)disableCaching
{
    NSURLSessionConfiguration *newConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    newConfiguration.requestCachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
    self.session = [NSURLSession sessionWithConfiguration: newConfiguration];
}

- (void)getStationsWithCompletion:(ResultCompletionBlock)completion
{
    NSString *address = @"/stations.json";
    NSDictionary *params = @{@"include" : @"last_measurement,current_forecasts"};
    
    [self GET: address withParameters: params withCompletion:^(id responseObject, NSError *error) {
        
        if (!error) {
            
            APIResults *results = [self resultsForResponseObject: responseObject];
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(results, nil);
            });
            
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(nil, error);
            });
        }
        
    }];
    
}

- (void)getDefaultStationWithCompletion:(ResultCompletionBlock)completion
{
    [self getStationWithId: @"1" withCompletion: completion];
}

- (void)getStationWithId:(NSString *)stationID withCompletion:(ResultCompletionBlock)completion
{
    NSString *address = [NSString stringWithFormat: @"/stations/%@", stationID];
    NSDictionary *params = @{@"include" : @"last_measurement,current_forecasts"};

    [self GET: address withParameters: params withCompletion:^(id responseObject, NSError *error) {
       
        if (!error) {
            
            APIResults *results = [self resultsForSingleResponseObject: responseObject];
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(results, nil);
            });
            
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(nil, error);
            });
        }
        
    }];
    
}

- (void)getNearestStationForCoordinate:(CLLocationCoordinate2D)coordinate withCompletion:(ResultCompletionBlock)completion
{
    NSString *address = @"/stations.json";
    
    NSString *coordinateString = [NSString stringWithFormat: @"%f,%f", coordinate.latitude, coordinate.longitude];
    NSDictionary *params = @{@"include" : @"last_measurement,current_forecasts",
                             @"page[limit]" : @"1",
                             @"nearest_from" : coordinateString};
    
    [self GET: address withParameters: params withCompletion:^(id responseObject, NSError *error) {
        
        if (!error) {
            
            APIResults *results = [self resultsForResponseObject: responseObject];
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(results, nil);
            });
            
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(nil, error);
            });
        }
        
    }];
    
}

#pragma mark - Private HTTP Methods (NSURLSession)

- (void)GET:(NSString *)urlString withParameters:(NSDictionary *)params withCompletion:(APICompletionBlock)completion
{
    NSURL *URL = [self URLforRelativePath: urlString withURLParameters: params];
    
    NSURLSessionDataTask *dataTask =
    [self.session dataTaskWithURL: URL completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (!error) {
            
            NSHTTPURLResponse *httpResp = (NSHTTPURLResponse *)response;
            if (httpResp.statusCode == 200) {
                                
                NSError *jsonError;
                NSDictionary *JSON = [NSJSONSerialization JSONObjectWithData: data options: NSJSONReadingAllowFragments error: &jsonError];
                
                if (!jsonError) {
                    completion(JSON, nil);
                }else{
                    completion(nil, jsonError);
                }
            
            }else{
                completion(nil, error);
            }
            
        }else{
            completion(nil, error);
        }
        
    }];
    
    [dataTask resume];
}

#pragma mark - URL Helper's

- (NSURL *)URLforRelativePath:(NSString *)path withURLParameters:(NSDictionary *)parameters
{
    NSString *URLString = [NSString stringWithFormat: @"%@%@", kBaseURL, path];
    NSURLComponents *components = [NSURLComponents componentsWithString: URLString];
    
    NSMutableArray *queryItems = [NSMutableArray array];
    for (NSString *key in parameters) {
        [queryItems addObject: [NSURLQueryItem queryItemWithName: key value: parameters[key]]];
    }
    components.queryItems = queryItems;
    
    return components.URL;
}

#pragma mark - APIResults Helper's

- (APIResults *)resultsForSingleResponseObject:(NSDictionary *)responseObject
{    
    NSDictionary *stationDict = responseObject[@"data"];
    NSArray *included = responseObject[@"included"];

    NSMutableArray *measurements = [[NSMutableArray alloc] init];
    NSMutableArray *forecasts = [[NSMutableArray alloc] init];
    
    Station *station = [[Station alloc] initWithDictionary: stationDict];
    
    for (NSDictionary *includedDict in included) {
        NSString *type = includedDict[@"type"];
        
        if ([type isEqualToString: @"measurements"]) {
            Measurement *measurement = [[Measurement alloc] initWithDictionary: includedDict];
            [measurements addObject: measurement];
            
        }else if ([type isEqualToString: @"forecasts"]){
            Forecast *forecast = [[Forecast alloc] initWithDictionary: includedDict];
            [forecasts addObject: forecast];
        }
        
    }
    
    return [[APIResults alloc] initWithStations: @[station] measurements: measurements forecasts: forecasts];

}

- (APIResults *)resultsForResponseObject:(NSDictionary *)responseObject
{
    NSArray *stationDicts = responseObject[@"data"];
    NSArray *included = responseObject[@"included"];
    
    NSMutableArray *stations = [[NSMutableArray alloc] initWithCapacity: [stationDicts count]];
    NSMutableArray *measurements = [[NSMutableArray alloc] init];
    NSMutableArray *forecasts = [[NSMutableArray alloc] init];
    
    for (NSDictionary *stationDict in stationDicts) {
        Station *station = [[Station alloc] initWithDictionary: stationDict];
        [stations addObject: station];
    }
    
    for (NSDictionary *includedDict in included) {
        NSString *type = includedDict[@"type"];
        
        if ([type isEqualToString: @"measurements"]) {
            Measurement *measurement = [[Measurement alloc] initWithDictionary: includedDict];
            [measurements addObject: measurement];
            
        }else if ([type isEqualToString: @"forecasts"]){
            Forecast *forecast = [[Forecast alloc] initWithDictionary: includedDict];
            [forecasts addObject: forecast];
        }
        
    }
        
    return [[APIResults alloc] initWithStations: stations measurements: measurements forecasts: forecasts];
}

@end
