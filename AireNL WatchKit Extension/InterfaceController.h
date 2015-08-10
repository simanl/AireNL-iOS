//
//  InterfaceController.h
//  AireNL WatchKit Extension
//
//  Created by Daniel Lozano on 8/6/15.
//  Copyright (c) 2015 Icalia Labs. All rights reserved.
//

#import <WatchKit/WatchKit.h>
#import <Foundation/Foundation.h>

@interface InterfaceController : WKInterfaceController

@property (weak, nonatomic) IBOutlet WKInterfaceGroup *mainGroup;

@property (weak, nonatomic) IBOutlet WKInterfaceLabel *imecaAmountLabel;
@property (weak, nonatomic) IBOutlet WKInterfaceLabel *imecaQualityLabel;

@end
