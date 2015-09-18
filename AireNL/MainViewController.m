//
//  MainViewController.m
//  AireNL
//
//  Created by Daniel Lozano on 7/21/15.
//  Copyright (c) 2015 Icalia Labs. All rights reserved.
//

#import "MainViewController.h"

//#import <FXBlurView/FXBlurView.h>
#import <CCMPopup/FXBlurView.h>
#import <CCMPopup/CCMPopupTransitioning.h>
#import <TAOverlay/TAOverlay.h>

#import "Constants.h"
#import "UIColor+ILColor.h"
#import "ILBlurCollectionView.h"
#import "ILRadialGradientLayer.h"
#import "ILLinearGradientView.h"
#import "MapViewController.h"
#import "InfoContainerViewController.h"
//#import "InfoTableViewController.h"

#import "CurrentResults.h"
#import "PredictionResults.h"
#import "ResultsCellDelegate.h"

#import "AireNLAPI.h"

#define STATUS_BAR_HEIGHT 16
#define NAV_BAR_HEIGHT 54

@interface MainViewController () <ResultsCellDelegate, MapViewControllerDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate, CLLocationManagerDelegate>

// MAIN, LOCATION

@property (nonatomic) BOOL loadingStation;
@property (nonatomic) CLLocationManager *locationManager;

// MODEL DATA

@property (nonatomic) Station *selectedStation;
@property (nonatomic) Measurement *selectedMeasurement;

@property (nonatomic) CurrentResults *currentResults;
@property (nonatomic) PredictionResults *predictionResults;

// TABLE, SCROLL VIEW, POPUP

@property (nonatomic) NSArray *cellHeights;
@property (nonatomic) NSArray *cellWidths;
@property (nonatomic) NSArray *cellIdentifiers;

@property (nonatomic) CGFloat previousScrollViewYOffset;

@property (nonatomic) InfoContainerViewController *infoViewController;

// BACKGROUND

@property (nonatomic) BOOL backgroundHasBlur;
@property (nonatomic) UIImage *normalBackground;
@property (nonatomic) UIImage *blurredBackground;

@property (nonatomic) NSUInteger selectedBackgroundIndex;
@property (nonatomic) NSArray *backgroundImageNames;

@end

@implementation MainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self loadFakeData];
    [self cacheLoadData];
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    
    [self setBackgroundImages];
    [self addMotionEffectToBackground];
    
    [self customizeAppearance];
    [self addGestureRecognizers];
    [self registerNibs];
    
    [self loadStation];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Persistance

- (void)cacheLoadData
{
    NSLog(@"CACHE : LOADING DATA");
    
    NSData *stationData = [[NSUserDefaults standardUserDefaults] objectForKey: kCachedStationKey];
    NSData *measurementData = [[NSUserDefaults standardUserDefaults] objectForKey: kCachedMeasurementKey];
    
    Station *station = [NSKeyedUnarchiver unarchiveObjectWithData: stationData];
    Measurement *measurement = [NSKeyedUnarchiver unarchiveObjectWithData: measurementData];
    
    NSLog(@"CACHED STATION : %@", station);
    NSLog(@"CACHED MEASUREMENT: %@", measurement);
    
    self.selectedStation = station;
    self.selectedMeasurement = measurement;
    
    [self updateScreen];
}

- (void)cacheSaveData
{
    NSLog(@"CACHE : SAVING DATA");
    
    NSData *stationData = [NSKeyedArchiver archivedDataWithRootObject: self.selectedStation];
    NSData *measurementData = [NSKeyedArchiver archivedDataWithRootObject: self.selectedMeasurement];
    
    [[NSUserDefaults standardUserDefaults] setObject: stationData forKey: kCachedStationKey];
    [[NSUserDefaults standardUserDefaults] setObject: measurementData forKey: kCachedMeasurementKey];
}

#pragma mark - Network

- (void)loadStation
{
    if ([self isUsingGPS]) {
        [self loadNearestStation];
    }else{
        [self loadCurrentStation];
    }
}

- (void)loadNearestStation
{
    NSLog(@"ATTEMPTING : LOAD NEAREST STATION");
    
    if (self.loadingStation) {
        NSLog(@"ABORTED");
        return;
    }
    
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    if (status == kCLAuthorizationStatusNotDetermined) {
        [self askLocationPermision];
        NSLog(@"ABORTED");
        return;
    }else if (status == kCLAuthorizationStatusDenied){
        NSLog(@"LOCATION TRACKING DENIED");
        [self loadDefaultStation];
        // POPUP SAYING THAT THEY NEED TO GO INTO SETTINGS AND GIVE PERMISSION !
        NSLog(@"ABORTED");
        return;
    }
    
    NSLog(@"LOADING NEAREST STATION");
    
    self.isUsingGPS = YES;
    self.loadingStation = YES;
    
    CLLocationCoordinate2D currentLocation = self.locationManager.location.coordinate;
    
    [[AireNLAPI sharedAPI] getNearestStationForCoordinate: currentLocation withCompletion:^(APIResults *results, NSError *error) {
        [self handleResults: results withError: error];
        self.loadingStation = NO;
    }];
    
}

- (void)loadCurrentStation
{
    NSLog(@"LOADING CURRENT STATION");
    
    if (self.selectedStation) {
        
        [[AireNLAPI sharedAPI] getStationWithId: self.selectedStation.stationID withCompletion:^(APIResults *results, NSError *error) {
            [self handleResults: results withError: error];
        }];
        
    }else{
        [self loadDefaultStation];
    }
}

- (void)loadDefaultStation
{
    NSLog(@"LOADING DEFAULT STATION");
    
    [[AireNLAPI sharedAPI] getDefaultStationWithCompletion:^(APIResults *results, NSError *error) {
        [self handleResults: results withError: error];
    }];
    
}

- (void)handleResults:(APIResults *)results withError:(NSError *)error
{
    if (!error){
        
        NSLog(@"SUCCESS!");
        
        self.selectedStation = [[results stations] firstObject];
        self.selectedMeasurement = [results lastMeasurementForStation: self.selectedStation];
        
        NSLog(@"STATION : %@", self.selectedStation);
        NSLog(@"MEASUREMENT : %@", self.selectedMeasurement);
        
        [self cacheSaveData];
        [self updateScreen];
        
    }else{
        NSLog(@"ERROR = %@", error);
    }
}

- (void)loadFakeData
{
    ContaminantResults *periodOneContamintResults = [[ContaminantResults alloc] init];
    periodOneContamintResults.pm10 = @(4);
    periodOneContamintResults.pm25 = @(14);
    periodOneContamintResults.O3 = @(40);
    
    ContaminantResults *periodTwoContamintResults = [[ContaminantResults alloc] init];
    periodTwoContamintResults.pm10 = @(5);
    periodTwoContamintResults.pm25 = @(15);
    periodTwoContamintResults.O3 = @(50);
    
    ContaminantResults *periodThreeContamintResults = [[ContaminantResults alloc] init];
    periodThreeContamintResults.pm10 = @(6);
    periodThreeContamintResults.pm25 = @(16);
    periodThreeContamintResults.O3 = @(60);
    
    PredictionResults *predictionResults = [[PredictionResults alloc] init];
    predictionResults.periodOne = periodOneContamintResults;
    predictionResults.periodTwo = periodTwoContamintResults;
    predictionResults.periodThree = periodThreeContamintResults;
    
    self.predictionResults = predictionResults;
}

#pragma mark - Appearance / Initial Setup

- (void)customizeAppearance
{
    [self setBackgroundImageWithBlur: NO];
    [self setupCollectionViewInsetsWithCellsHeight: [self getCellHeightsTotalWithLimit: 4]];
    
    [TAOverlay setOverlayLabelFont: [UIFont fontWithName: @"Avenir-Light" size: 13.0f]];
}

- (void)updateScreen
{
    self.titleLabel.text = @"MONTERREY";
    self.stationLabel.text = [self.selectedStation.name uppercaseString];
    
    [self setGpsButtonOpacity];
    
    [self.collectionView reloadData];
}

- (void)setGpsButtonOpacity
{
    if ([self isUsingGPS]) {
        self.gpsButton.alpha = 1.0f;
    }else{
        self.gpsButton.alpha = 0.5f;
    }
}

- (void)setBackgroundImages
{
    NSString *backgroundImageName = self.backgroundImageNames[self.selectedBackgroundIndex];
    UIImage *backgroundImage = [UIImage imageNamed: backgroundImageName];
    
    self.normalBackground = backgroundImage;
    self.blurredBackground = [backgroundImage blurredImageWithRadius: 10.0f iterations: 2 tintColor: nil];
}

- (void)setBackgroundImageWithBlur:(BOOL)blur
{
    if (blur && self.backgroundHasBlur) {
        return;
    }
    
    if (!blur && !self.backgroundHasBlur) {
        return;
    }
    
    self.backgroundImageView.image = (blur)? self.blurredBackground : self.normalBackground;
    self.backgroundHasBlur = blur;
}

- (void)registerNibs
{
    UINib *pronosticosNib = [UINib nibWithNibName: @"PronosticosCollectionViewCell" bundle: [NSBundle mainBundle]];
    [self.collectionView registerNib: pronosticosNib forCellWithReuseIdentifier: @"pronosticosCollectionViewCell"];
}

- (void)addGestureRecognizers
{
    UITapGestureRecognizer *doubleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget: self
                                                                                          action: @selector(userDidSelectSwitchBackground)];
    doubleTapRecognizer.numberOfTapsRequired = 2;
    [self.topView addGestureRecognizer: doubleTapRecognizer];

}

- (void)addMotionEffectToBackground
{
    UIInterpolatingMotionEffect *verticalMotionEffect = [[UIInterpolatingMotionEffect alloc]
                                                         initWithKeyPath: @"center.y"
                                                         type: UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
    verticalMotionEffect.minimumRelativeValue = @(-20);
    verticalMotionEffect.maximumRelativeValue = @(20);
    
    UIInterpolatingMotionEffect *horizontalMotionEffect = [[UIInterpolatingMotionEffect alloc]
                                                           initWithKeyPath: @"center.x"
                                                           type: UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
    
    horizontalMotionEffect.minimumRelativeValue = @(-20);
    horizontalMotionEffect.maximumRelativeValue = @(20);
    
    UIMotionEffectGroup *group = [UIMotionEffectGroup new];
    group.motionEffects = @[horizontalMotionEffect, verticalMotionEffect];
    
    [self.backgroundImageView addMotionEffect: group];
}

- (void)setupCollectionViewInsetsWithCellsHeight:(CGFloat)height
{
    CGFloat viewHeight = CGRectGetHeight(self.view.bounds);
    CGFloat totalCellsHeight = height;
    CGFloat topInset = STATUS_BAR_HEIGHT + NAV_BAR_HEIGHT + 25.0 + (viewHeight - totalCellsHeight);
    
    self.collectionView.contentInset = UIEdgeInsetsMake(topInset, 0, 0, 0);
    self.collectionView.scrollIndicatorInsets = UIEdgeInsetsMake(20, 0, 0, 0);
}

#pragma mark - IBActions

- (IBAction)userDidSelectMap:(id)sender
{
    MapViewController *mapVC = [self.storyboard instantiateViewControllerWithIdentifier: @"MapViewController"];
    mapVC.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    mapVC.type = self.selectedBackgroundIndex;
    mapVC.delegate = self;

    UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController: mapVC];
    [self presentViewController: navVC animated: YES completion: nil];
}

- (IBAction)didSelectGPS:(id)sender
{
    if (self.isUsingGPS) {
        [self showGpsAlreadyActivatedAlert];
        return;
    }
    
    [self loadNearestStation];
    
}

- (void)userDidSelectSwitchBackground
{
    if (self.selectedBackgroundIndex == [self.backgroundImageNames count] - 1) {
        self.selectedBackgroundIndex = 0;
    }else{
        self.selectedBackgroundIndex ++;
    }
    
    [self setBackgroundImages];
    
    self.backgroundImageView.image = self.backgroundHasBlur ? self.blurredBackground : self.normalBackground;
}

#pragma mark - UIScrollView Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat correctedOffset = scrollView.contentInset.top + scrollView.contentOffset.y;
    if (correctedOffset <= 10) {
        [self setBackgroundImageWithBlur: NO];
        if (IS_IPHONE) {
            [[UIApplication sharedApplication] setStatusBarHidden: NO withAnimation: UIStatusBarAnimationSlide];
        }
    }else{
        [self setBackgroundImageWithBlur: YES];
        if (IS_IPHONE) {
            [[UIApplication sharedApplication] setStatusBarHidden: YES withAnimation: UIStatusBarAnimationSlide];
        }
    }
    
    [self animateTopViewWithScrollView: scrollView];
}

#pragma mark - Rotation

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [super viewWillTransitionToSize: size withTransitionCoordinator: coordinator];
    
    // BEFORE ROTATION
    
    // Handle rotation if info popup is displayed
    [self handleRotationForInfoScreenForSize: size withTransitionCoordinator: coordinator];
    
    // Reload collection view layout
    self.cellWidths = nil;
    [self.collectionView.collectionViewLayout invalidateLayout];
    
    // Redraw blur with NEW size BEFORE rotation, since it's going to be bigger
    UIInterfaceOrientation beforeOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    if (beforeOrientation == UIInterfaceOrientationPortrait) {
        [self.collectionView setBlurNeedsRedraw: YES withNewSize: size];
        [self.collectionView drawBlur];
    }
    
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context){
        // WHILE ROTATING
        
        // Reset scrollView offset and scroll to top WHILE animating to prevent jerkiness
        UIInterfaceOrientation afterOrientation = [[UIApplication sharedApplication] statusBarOrientation];
        if (afterOrientation == UIInterfaceOrientationPortrait) {
            [self setupCollectionViewInsetsWithCellsHeight: [self getCellHeightsTotalWithLimit: 4]];
        }else{
            [self setupCollectionViewInsetsWithCellsHeight: [self getCellHeightsTotalWithLimit: 2] - 25.0];
        }
        [self scrollCollectionViewToTop];
        
     }completion:^(id<UIViewControllerTransitionCoordinatorContext> context){
        // AFTER ROTATION
         
         // Set blur needs redraw with current size bc it's now smaller, let layoutsubview handle drawing
         UIInterfaceOrientation afterOrientation = [[UIApplication sharedApplication] statusBarOrientation];
         if (afterOrientation == UIInterfaceOrientationPortrait) {
             self.collectionView.blurNeedsRedraw = YES;
         }
         
     }];

}

#pragma mark - UICollectionView Data Source

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.cellIdentifiers count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = self.cellIdentifiers[indexPath.row];
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier: cellIdentifier forIndexPath: indexPath];

    ((id<ResultsDelegateSettable>)cell).delegate = self;
    [((id<ResultsCellUpdateable>)cell) updateCell];

    return cell;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

#pragma mark - UICollectionView DelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = [((NSNumber *)self.cellHeights[indexPath.row]) floatValue];
    CGFloat width = [((NSNumber *)self.cellWidths[indexPath.row]) floatValue];
    
    return CGSizeMake(width, height);
}

#pragma mark - ResultsCellDelegate

- (PredictionResults *)getPredictionResults
{
    return self.predictionResults;
}

- (Station *)getSelectedStation
{
    return self.selectedStation;
}

- (Measurement *)getSelectedMeasurement
{
    return self.selectedMeasurement;
}

- (void)didSelectInfoAtCell:(UICollectionViewCell *)cell
{
    NSIndexPath *indexPath = [self.collectionView indexPathForCell: cell];
    
    if (indexPath.row == 0){
        // Header Cell
        [self showInfoScreenForAirQuality];
        
    }else if (indexPath.row == 1) {
        // Actividades Cell
        [self showInfoScreenForActivities];
        
    }else if(indexPath.row == 5){
        // Predictions Cell
        [self showInfoScreenForContaminants];
    }
}

#pragma mark - MapViewController Delegate

//- (void)didSelectLocationWithCurrentResults:(CurrentResults *)results
//{
//    self.isUsingGPS = NO;
//    
//    self.currentResults = results;
//    
//    [self updateScreen];
//    [self.collectionView reloadData];
//    
//    [self showFirstGpsUserAlert];
//}

- (void)mapDidSelectStation:(Station *)station withMeasurement:(Measurement *)measurement
{
    self.isUsingGPS = NO;
    
    self.selectedStation = station;
    self.selectedMeasurement = measurement;
    
    [self updateScreen];
    [self.collectionView reloadData];
    
    [self showFirstGpsUserAlert];
}

#pragma mark - CLLocationManager Delegate

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    switch (status) {
        case kCLAuthorizationStatusNotDetermined:
            [self askLocationPermision];
            break;
        case kCLAuthorizationStatusAuthorizedWhenInUse:
            // DO SOMETHING ABOUT THIS , NEEDS TO BE CALLED BUT MAY INTERFERE WHEN NOT USING GPS
//            [self loadNearestStation];
            break;
        default:
            break;
    }
}

#pragma mark - Location Helper's

- (void)askLocationPermision
{
    NSLog(@"ASKING LOCATION PERMISSION");
    [self.locationManager requestWhenInUseAuthorization];
}

- (BOOL)isUsingGPS
{
    return [[NSUserDefaults standardUserDefaults] boolForKey: kIsUsingGpsKey];
}

- (void)setIsUsingGPS:(BOOL)isUsing
{
    [[NSUserDefaults standardUserDefaults] setBool: isUsing forKey: kIsUsingGpsKey];
    [self setGpsButtonOpacity];
}

- (void)showFirstGpsUserAlert
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    BOOL hasShownGpsAlert = [userDefaults boolForKey: kHasShownGpsAlertKey];
    
    if (!hasShownGpsAlert) {
        NSString *text = NSLocalizedString(@"To go back to the default behavior of using GPS to find the nearest station press the icon in the top left corner.", nil);
        [self showAlertWithText: text];
        
        [userDefaults setBool: YES forKey: kHasShownGpsAlertKey];
    }
}

- (void)showGpsAlreadyActivatedAlert
{
    NSString *text = NSLocalizedString(@"You are already using GPS to find the nearest station. If you want to change station use the map.", nil);
    [self showAlertWithText: text];
}

#pragma mark - Helper's

- (void)scrollCollectionViewToTop
{
    CGPoint topPoint = CGPointMake(0, -self.collectionView.contentInset.top);
    
    [UIView animateWithDuration: 0.2 animations:^{
        self.collectionView.contentOffset = topPoint;
    }];

}

- (CGFloat)getCellHeightsTotalWithLimit:(NSInteger)limit
{
    if (limit > [self.cellHeights count]) {
        limit = [self.cellHeights count];
    }
    
    CGFloat acum = 0;
    for (NSInteger i = 0; i < limit; i++) {
        acum += [self.cellHeights[i] floatValue];
    }
    return acum;
}

- (void)animateTopViewWithScrollView:(UIScrollView *)scrollView
{
    if (IS_IPAD) {
        return;
    }
    
    CGRect frame = self.topView.frame;
    CGFloat size = frame.size.height - 21;
    CGFloat framePercentageHidden = ((20 - frame.origin.y) / (frame.size.height - 1));
    CGFloat scrollOffset = scrollView.contentOffset.y;
    CGFloat scrollDiff = scrollOffset - self.previousScrollViewYOffset;
    CGFloat scrollHeight = scrollView.frame.size.height;
    CGFloat scrollContentSizeHeight = scrollView.contentSize.height + scrollView.contentInset.bottom;
    
    if (scrollOffset <= -scrollView.contentInset.top) {
        self.topViewConstraint.constant = 20;
    } else if ((scrollOffset + scrollHeight) >= scrollContentSizeHeight) {
        self.topViewConstraint.constant = -size;
    } else {
        self.topViewConstraint.constant = MIN(20, MAX(-size, frame.origin.y - scrollDiff));
    }
    
    self.topView.alpha = (1 - framePercentageHidden);
    self.previousScrollViewYOffset = scrollOffset;
}

- (void)showInfoScreenForAirQuality
{
    [self showInfoScreenForControllerWithName: @"airQualityInfoViewController" height: 430.0f];
}

- (void)showInfoScreenForActivities
{
    [self showInfoScreenForControllerWithName: @"actividadesInfoViewController" height: 200.0f];
}

- (void)showInfoScreenForContaminants
{
    [self showInfoScreenForControllerWithName: @"contaminantesViewController" height: 380.0f];
}

- (void)showInfoScreenForControllerWithName:(NSString *)name height:(CGFloat)height
{
    self.infoViewController = [self.storyboard instantiateViewControllerWithIdentifier: name];
    self.infoViewController.view.layer.cornerRadius = 5.0f;
    self.infoViewController.regularHeight = height;
    
    CCMPopupTransitioning *popup = [CCMPopupTransitioning sharedInstance];
    
    CGRect screenBounds = [UIScreen mainScreen].bounds;
    if (self.view.bounds.size.height < 420 && height > screenBounds.size.height) {
        popup.destinationBounds = CGRectMake(0, 0, 300, screenBounds.size.height - 35);
    } else {
        popup.destinationBounds = CGRectMake(0, 0, 300, height);
    }
    
    popup.presentedController = self.infoViewController;
    popup.presentingController = self;
    popup.dismissableByTouchingBackground = YES;
    popup.backgroundBlurRadius = 20.0f;
    popup.backgroundViewColor = [UIColor darkGrayColor];
    popup.backgroundViewAlpha = 0.5f;
    
    [self presentViewController: self.infoViewController animated: YES completion: nil];
}

- (void)handleRotationForInfoScreenForSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    if (size.height < 420) {
        
        if (self.infoViewController.view.bounds.size.height < size.height) {
            return;
        }
        
        [UIView animateWithDuration: [coordinator transitionDuration] animations:^{
            self.infoViewController.view.bounds = CGRectMake(0, 0, 300, size.height - 35);
        }];
        
    } else {
        [UIView animateWithDuration: [coordinator transitionDuration] animations:^{
            self.infoViewController.view.bounds = CGRectMake(0, 0, 300, self.infoViewController.regularHeight);
        }];
    }
}

- (void)showAlertWithText:(NSString *)text
{
    [TAOverlay showOverlayWithLabel: text Options: TAOverlayOptionOverlaySizeRoundedRect | TAOverlayOptionOverlayDismissTap | TAOverlayOptionOverlayTypeInfo];
}

#pragma mark - Set/Get

- (NSArray *)cellHeights
{
    if (!_cellHeights) {
        _cellHeights = @[@(180), @(120), @(100), @(100), @(100), @(190)];
    }
    return _cellHeights;
}

- (NSArray *)cellWidths
{
    if (!_cellWidths) {
        CGFloat collectionWidth = CGRectGetWidth(self.collectionView.bounds);
        _cellWidths = @[@(collectionWidth), @(collectionWidth), @(collectionWidth/2.0f), @(collectionWidth/2.0f), @(collectionWidth), @(collectionWidth)];
    }
    return _cellWidths;
}

- (NSArray *)cellIdentifiers
{
    if (!_cellIdentifiers) {
        _cellIdentifiers = @[@"imecaCell", @"actividadesCell", @"vientoCell", @"temperaturaCell", @"contaminantesCell",  @"pronosticosCollectionViewCell"];
    }
    return _cellIdentifiers;
}

- (NSArray *)backgroundImageNames
{
    if (!_backgroundImageNames) {
        _backgroundImageNames = @[@"BackgroundNight", @"BackgroundDay", @"BackgroundSunset"];
    }
    return _backgroundImageNames;
}

@end
