//
//  GlanceController.h
//  AireNL WatchKit Extension
//
//  Created by Daniel Lozano on 8/6/15.
//  Copyright (c) 2015 Icalia Labs. All rights reserved.
//

#import <WatchKit/WatchKit.h>
#import <Foundation/Foundation.h>

@interface GlanceController : WKInterfaceController

@property (weak, nonatomic) IBOutlet WKInterfaceLabel *locationTitleLabel;
@property (weak, nonatomic) IBOutlet WKInterfaceLabel *locationSubtitleLabel;

@property (weak, nonatomic) IBOutlet WKInterfaceLabel *imecaAmountLabel;
@property (weak, nonatomic) IBOutlet WKInterfaceLabel *imecaQualityLabel;

@end
