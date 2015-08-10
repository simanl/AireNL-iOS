//
//  SecondaryInterfaceController.h
//  AireNL
//
//  Created by Daniel Lozano on 8/6/15.
//  Copyright (c) 2015 Icalia Labs. All rights reserved.
//

#import <WatchKit/WatchKit.h>
#import <Foundation/Foundation.h>

@interface SecondaryInterfaceController : WKInterfaceController

@property (weak, nonatomic) IBOutlet WKInterfaceLabel *windLabel;
@property (weak, nonatomic) IBOutlet WKInterfaceLabel *temperatureLabel;

@end
