//
//  MapViewController.h
//  AireNL
//
//  Created by Daniel Lozano on 7/21/15.
//  Copyright (c) 2015 Icalia Labs. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MainPageViewController.h"

@class MKMapView;

@interface MapViewController : UIViewController <MainContainerChild>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end
