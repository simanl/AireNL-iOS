//
//  NSDictionary+WithoutNSNull.h
//  Ovatemp
//
//  Created by Daniel Lozano on 4/29/15.
//  Copyright (c) 2015 Back Forty. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (WithoutNSNull)

- (id)dl_objectForKeyWithNil:(id)key;

@end