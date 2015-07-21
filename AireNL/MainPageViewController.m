//
//  MainPageViewController.m
//  AireNL
//
//  Created by Daniel Lozano on 7/21/15.
//  Copyright (c) 2015 Icalia Labs. All rights reserved.
//

#import "MainPageViewController.h"

#import "MainViewController.h"
#import "MapViewController.h"
#import "UIColor+ILColor.h"

@interface MainPageViewController () <UIPageViewControllerDataSource, UIPageViewControllerDelegate>

@property (nonatomic) NSArray *mainViewControllers;

@end

@implementation MainPageViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
        
    [self initializePageViewController];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Appearance/Initial Setup

- (void)initializePageViewController
{
    self.dataSource = self;
    self.delegate = self;
    
    [self setViewControllers: @[self.mainViewControllers[0]] direction: UIPageViewControllerNavigationDirectionForward animated: YES completion: nil];
}

- (NSArray *)initializedViewControllers
{
    MainViewController *mainVC = [self.storyboard instantiateViewControllerWithIdentifier: @"MainViewController"];
    MapViewController *mapVC = [self.storyboard instantiateViewControllerWithIdentifier: @"MapViewController"];
    return @[mainVC, mapVC];
}

#pragma mark - UIPageViewController Data Source

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    id<MainContainerChild> containerChildVC = (id<MainContainerChild>)viewController;
    NSUInteger index = containerChildVC.index;
    
    if (index == 0) {
        return nil;
    }
    
    index--;
    
    return [self viewControllerAtIndex: index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    id<MainContainerChild> containerChildVC = (id<MainContainerChild>)viewController;
    NSUInteger index = containerChildVC.index;
    
    index++;
    
    if (index == [self.mainViewControllers count]) {
        return nil;
    }
    
    return [self viewControllerAtIndex: index];
}

#pragma mark - Helper's

- (UIViewController *)viewControllerAtIndex:(NSUInteger)index
{
    return self.mainViewControllers[index];
}

#pragma mark - Getters

- (NSArray *)mainViewControllers
{
    if (!_mainViewControllers) {
        _mainViewControllers = [self initializedViewControllers];
    }
    return _mainViewControllers;
}

@end
