//
//  MapViewController.h
//  AireNL
//
//  Created by Daniel Lozano on 7/21/15.
//  Copyright (c) 2015 Icalia Labs. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MKMapView;

@interface MapViewController : UIViewController 

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end
