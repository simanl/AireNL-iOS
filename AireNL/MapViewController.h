//
//  MapViewController.h
//  AireNL
//
//  Created by Daniel Lozano on 7/21/15.
//  Copyright (c) 2015 Icalia Labs. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CurrentResults.h"

typedef NS_ENUM(NSInteger, MapViewControllerNavBarType){
    MapViewControllerNavBarTypeNight = 0,
    MapViewControllerNavBarTypeDay,
    MapViewControllerNavBarTypeSunset
};

@protocol MapViewControllerDelegate <NSObject>

- (void)didSelectLocationWithCurrentResults:(CurrentResults *)results;

@end

@class MKMapView;

@interface MapViewController : UIViewController 

@property (nonatomic) MapViewControllerNavBarType type;
@property (weak, nonatomic) id<MapViewControllerDelegate> delegate;

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end
