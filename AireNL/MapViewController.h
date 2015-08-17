//
//  MapViewController.h
//  AireNL
//
//  Created by Daniel Lozano on 7/21/15.
//  Copyright (c) 2015 Icalia Labs. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, MapViewControllerNavBarType){
    MapViewControllerNavBarTypeNight = 0,
    MapViewControllerNavBarTypeDay,
    MapViewControllerNavBarTypeSunset
};

@class MKMapView;

@interface MapViewController : UIViewController 

@property (nonatomic) MapViewControllerNavBarType type;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end
