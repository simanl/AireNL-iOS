//
//  NSDictionary+WithoutNSNull.m
//  Ovatemp
//
//  Created by Daniel Lozano on 4/29/15.
//  Copyright (c) 2015 Back Forty. All rights reserved.
//

#import "NSDictionary+WithoutNSNull.h"

@implementation NSDictionary (WithoutNSNull)

- (id)dl_objectForKeyWithNil:(id)key
{
    return ![self[key] isKindOfClass: [NSNull class]] ? self[key] : nil;
}

@end
