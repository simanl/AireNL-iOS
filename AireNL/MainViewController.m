//
//  MainViewController.m
//  AireNL
//
//  Created by Daniel Lozano on 7/21/15.
//  Copyright (c) 2015 Icalia Labs. All rights reserved.
//

#import "MainViewController.h"

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
#import "BackgroundImageHelper.h"

#import "AireNLAPI.h"
#import "PredictionResults.h"
#import "ResultsCellDelegate.h"

#define STATUS_BAR_HEIGHT 16
#define NAV_BAR_HEIGHT 54

@interface MainViewController () <ResultsCellDelegate, MapViewControllerDelegate,
UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate, CLLocationManagerDelegate>

// LOCATION

@property (nonatomic) BOOL gettingLocation;
@property (nonatomic) BOOL loadingStation;
@property (nonatomic) CLLocationManager *locationManager;

// MODEL DATA

@property (nonatomic) Station *selectedStation;
@property (nonatomic) Measurement *selectedMeasurement;
@property (nonatomic) PredictionResults *predictionResults;

// TABLE, SCROLL VIEW, POPUP

@property (nonatomic) UIRefreshControl *refreshControl;

@property (nonatomic) NSArray *cellHeights;
@property (nonatomic) NSArray *cellWidths;
@property (nonatomic) NSArray *cellIdentifiers;

@property (nonatomic) CGFloat previousScrollViewYOffset;

@property (nonatomic) InfoContainerViewController *infoViewController;

// BACKGROUND

@property (nonatomic) BOOL backgroundHasBlur;
@property (nonatomic) UIImage *normalBackground;
@property (nonatomic) UIImage *blurredBackground;
@property (nonatomic) ILTimeOfDay currentTimeOfDay;

@end

@implementation MainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setUpNotifications];
    [self loadFakeData]; // REMOVE
    [self cacheLoadData];
    
    [self updateBackgroundImagesFirstTime: YES];
    [self addMotionEffectToBackground];
    [self customizeAppearance];
    [self registerNibs];
//    [self loadStation]; // This is handled by the 'AppDidBecomeActive notification'
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)setUpNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(appDidBecomeActive)
                                                 name: UIApplicationDidBecomeActiveNotification object: nil];

}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver: self];
}

- (void)appDidBecomeActive
{
    [self updateBackgroundImagesFirstTime: NO];
    [self loadStation];
}

#pragma mark - Persistance

- (void)cacheLoadData
{
    NSLog(@"CACHE : LOADING DATA");
    
    NSData *stationData = [[NSUserDefaults standardUserDefaults] objectForKey: kCachedStationKey];
    NSData *measurementData = [[NSUserDefaults standardUserDefaults] objectForKey: kCachedMeasurementKey];
    Station *station = [NSKeyedUnarchiver unarchiveObjectWithData: stationData];
    Measurement *measurement = [NSKeyedUnarchiver unarchiveObjectWithData: measurementData];
    
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
    NSLog(@"LOAD NEAREST STATION : ATTEMPTING");
    
    if (self.gettingLocation) {
        NSLog(@"LOAD NEAREST STATION : ABORTED");
        return;
    }
    
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    if (status == kCLAuthorizationStatusNotDetermined) {
        [self askLocationPermision];
        NSLog(@"LOAD NEAREST STATION : PERMISSION NOT DETERMINED : ABORTED");
        return;
    }else if (status == kCLAuthorizationStatusDenied){
        NSLog(@"LOAD NEAREST STATION : PERMISSION DENIED : ABORTED");
        [self loadDefaultStation];
        [self showGpsPermissionAlert];
        return;
    }
    
    NSLog(@"LOADING NEAREST STATION!");
    [self showLoading];
    
    self.isUsingGPS = YES;
    self.gettingLocation = YES;
    
    [self.locationManager startUpdatingLocation];
}

- (void)loadNearestStationForCoordinate:(CLLocationCoordinate2D)coordinate
{
    self.gettingLocation = NO;
    
    if (self.loadingStation){
        return;
    }
    
    self.loadingStation = YES;
    
    [[AireNLAPI sharedAPI] getNearestStationForCoordinate: coordinate withCompletion:^(APIResults *results, NSError *error) {
        [self handleResults: results withError: error];
        [self hideLoading];
        self.loadingStation = NO;
    }];
}

- (void)loadCurrentStation
{
    if (self.loadingStation) {
        return;
    }
    
    NSLog(@"LOADING CURRENT STATION");
    [self showLoading];
    
    if (self.selectedStation) {
        
        self.loadingStation = YES;
        
        [[AireNLAPI sharedAPI] getStationWithId: self.selectedStation.stationID withCompletion:^(APIResults *results, NSError *error) {
            [self handleResults: results withError: error];
            [self hideLoading];
            self.loadingStation = NO;
        }];
        
    }else{
        [self loadDefaultStation];
    }
}

- (void)loadDefaultStation
{
    if (self.loadingStation) {
        return;
    }
    
    NSLog(@"LOADING DEFAULT STATION");
    [self showLoading];
    
    self.loadingStation = YES;
    
    [[AireNLAPI sharedAPI] getDefaultStationWithCompletion:^(APIResults *results, NSError *error) {
        [self handleResults: results withError: error];
        [self hideLoading];
        self.loadingStation = NO;
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
    self.backgroundImageView.image = self.normalBackground;
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

- (void)updateBackgroundImagesFirstTime:(BOOL)first
{
    NSLog(@"UPDATING BACKGROUND IMAGES : %@", first ? @"FIRST TIME" : @"NOT FIRST TIME");
    
    ILTimeOfDay timeOfDay = [BackgroundImageHelper currentTimeOfDay];
    UIImage *backgroundImage = [BackgroundImageHelper backgroundImageForCurrentTime];

    if (first) {
        self.currentTimeOfDay = timeOfDay;
        self.normalBackground = backgroundImage;
        self.blurredBackground = [backgroundImage blurredImageWithRadius: 10.0f iterations: 2 tintColor: nil];
    }else{
        if (timeOfDay != self.currentTimeOfDay) {
            NSLog(@"SETTING NEW IMAGES");
            self.normalBackground = backgroundImage;
            self.blurredBackground = [backgroundImage blurredImageWithRadius: 10.0f iterations: 2 tintColor: nil];
        }else{
            NSLog(@"ABORTED SETTING IMAGES");
        }
    }
    
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
    mapVC.delegate = self;

    UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController: mapVC];
    [self presentViewController: navVC animated: YES completion: nil];
}

- (IBAction)didSelectGPS:(id)sender
{
    if ([self isUsingGPS]) {
        [self showGpsAlreadyActivatedAlert];
        return;
    }
    
    [self loadNearestStation];
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
    
    [self handleRotationForInfoScreenForSize: size withTransitionCoordinator: coordinator];
    [self reloadCollectionViewLayout];
    
    // Redraw blur with NEW size BEFORE rotation, since it's going to be bigger (NOT REALLY BLUR, JUST FADE NOW)
    UIInterfaceOrientation beforeOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    if (beforeOrientation == UIInterfaceOrientationPortrait) {
        [self.collectionView setBlurNeedsRedraw: YES withNewSize: size];
        [self.collectionView drawBlur];
    }
    
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context){
        // WHILE ROTATING
        [self setupInsetAndScrollCollectionViewWithAnimation: NO];
        
     }completion:^(id<UIViewControllerTransitionCoordinatorContext> context){
         // AFTER ROTATION
         
         [UIView animateWithDuration: 0.2 animations:^{
             self.topView.alpha = 1.0f;
         }];
         
         // Set blur needs redraw with current size bc it's now smaller, let layoutsubview handle drawing
         UIInterfaceOrientation afterOrientation = [[UIApplication sharedApplication] statusBarOrientation];
         if (afterOrientation == UIInterfaceOrientationPortrait) {
             self.collectionView.blurNeedsRedraw = YES;
         }
         
     }];

}

- (void)reloadCollectionViewLayout
{
    self.cellWidths = nil;
    [self.collectionView.collectionViewLayout invalidateLayout];
}

- (void)setupInsetAndScrollCollectionViewWithAnimation:(BOOL)animation
{
    UIInterfaceOrientation afterOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    if (afterOrientation == UIInterfaceOrientationPortrait) {
        [self setupCollectionViewInsetsWithCellsHeight: [self getCellHeightsTotalWithLimit: 4]];
    }else{
        [self setupCollectionViewInsetsWithCellsHeight: [self getCellHeightsTotalWithLimit: 2] - 25.0];
    }
    
    [self scrollCollectionViewToTopWithAnimation: animation];
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
        
    }else if(indexPath.row == 5){
        // Predictions Cell
        [self showInfoScreenForContaminants];
    }
}

- (void)actividadesDidSelectInfoWithText:(NSString *)text
{
    [self showInfoScreenForActivityWithText: text];
}

#pragma mark - MapViewController Delegate

- (void)mapDidSelectStation:(Station *)station withMeasurement:(Measurement *)measurement
{
    [self dismissViewControllerAnimated: YES completion:^{
        // FIX INSETS, AND SCROLL (TO FIX IF VC WAS ROTATED WHILE INSIDE MAP)
        [self setupInsetAndScrollCollectionViewWithAnimation: YES];
        self.topView.alpha = 1.0f;
        
        [self showFirstGpsUserAlert];
    }];
    
    self.isUsingGPS = NO;
    self.selectedStation = station;
    self.selectedMeasurement = measurement;
    
    [self cacheSaveData];
    [self updateScreen];
    
    // FIX COLLECTION VIEW LAYOUT (TO FIX IF VC WAS ROTATED WHILE INSIDE MAP)
    [self reloadCollectionViewLayout];    
}

#pragma mark - CLLocationManager Delegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    CLLocation *location = [locations lastObject];
    CLLocationCoordinate2D coordinate = location.coordinate;
    CLLocationAccuracy horizontalAccuracy = location.horizontalAccuracy;
    CLLocationAccuracy verticalAccuracy = location.verticalAccuracy;
//    NSTimeInterval locationAge = -[location.timestamp timeIntervalSinceNow];
    
    NSLog(@"DID UPDATE LOCATION : %f , %f", coordinate.latitude, coordinate.longitude);
    NSLog(@"WITH ACCURACY : %f , %f", horizontalAccuracy, verticalAccuracy);
    
//    if (verticalAccuracy < 0 || horizontalAccuracy < 0) {
//        NSLog(@"LOCATION ABORTED : ACCURACY");
//        return;
//    }
//    
//    if (locationAge > 5.0){
//        NSLog(@"LOCATION ABORTED : AGE");
//        return;
//    }
    
    [manager stopUpdatingLocation];
    [self loadNearestStationForCoordinate: coordinate];
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    NSLog(@"LOCATION MANAGER : DID CHANGE AUTHORIZATION STATUS");
    switch (status) {
        case kCLAuthorizationStatusNotDetermined:
            [self askLocationPermision];
            break;
        case kCLAuthorizationStatusAuthorizedWhenInUse:
            if ([self isUsingGPS]) {
                [self loadNearestStation];
            }
            break;
        default:
            break;
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"LOCATION MANAGER : ERROR : %@", error);
    [self hideLoading];
    [self loadCurrentStation];
}

#pragma mark - Location Helper's

- (void)askLocationPermision
{
    NSLog(@"ASKING LOCATION PERMISSION");
    [self.locationManager requestWhenInUseAuthorization];
}

- (BOOL)isUsingGPS
{
    return ![[NSUserDefaults standardUserDefaults] boolForKey: kIsGpsDisabledKey];
}

- (void)setIsUsingGPS:(BOOL)isUsing
{
    [[NSUserDefaults standardUserDefaults] setBool: !isUsing forKey: kIsGpsDisabledKey];
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

- (void)showGpsPermissionAlert
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    BOOL hasShownGpsAlert = [userDefaults boolForKey: kHasShownGpsDisabledAlertKey];
    
    if (!hasShownGpsAlert) {
        NSString *text = NSLocalizedString(@"GPS tracking is disabled on your phone. If you want to enable this functionality to find the nearest station automatically go to Settings and turn it on.", nil);
        [self showAlertWithText: text];
        
        [userDefaults setBool: YES forKey: kHasShownGpsDisabledAlertKey];
    }
}

#pragma mark - Helper's

- (void)showLoading
{
    self.titleLabel.hidden = YES;
    self.stationLabel.hidden = YES;

    self.activityView.hidden = NO;
    [self.activityView startAnimating];
}

- (void)hideLoading
{
    [self.activityView stopAnimating];
    self.activityView.hidden = YES;
    
    self.titleLabel.hidden = NO;
    self.stationLabel.hidden = NO;
}

- (void)scrollCollectionViewToTopWithAnimation:(BOOL)animation
{
    CGPoint topPoint = CGPointMake(0, -self.collectionView.contentInset.top);
    if (animation) {
        [UIView animateWithDuration: 0.2 animations:^{
            self.collectionView.contentOffset = topPoint;
        }];
    }else{
        self.collectionView.contentOffset = topPoint;
    }
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
    [self showInfoScreenForControllerWithName: @"airQualityInfoViewController" height: 430.0f infoText: nil];
}

- (void)showInfoScreenForContaminants
{
    [self showInfoScreenForControllerWithName: @"contaminantesViewController" height: 380.0f infoText: nil];
}

- (void)showInfoScreenForActivityWithText:(NSString *)text
{
    [self showInfoScreenForControllerWithName: @"actividadesInfoViewController" height: 150.0f infoText: text];
}

- (void)showInfoScreenForControllerWithName:(NSString *)name height:(CGFloat)height infoText:(NSString *)infoText
{
    self.infoViewController = [self.storyboard instantiateViewControllerWithIdentifier: name];
    self.infoViewController.view.layer.cornerRadius = 5.0f;
    self.infoViewController.regularHeight = height;
    self.infoViewController.infoText = infoText;
    
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

- (CLLocationManager *)locationManager
{
    if (!_locationManager) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        _locationManager.distanceFilter = kCLDistanceFilterNone;
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    }
    return _locationManager;
}

- (NSArray *)cellHeights
{
    if (!_cellHeights) {
        _cellHeights = @[@(180), @(128), @(100), @(100), @(100), @(205)];
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

@end
