//
//  MainViewController.m
//  AireNL
//
//  Created by Daniel Lozano on 7/21/15.
//  Copyright (c) 2015 Icalia Labs. All rights reserved.
//

#import "MainViewController.h"

#import "UIColor+ILColor.h"
#import "ILBlurCollectionView.h"
#import "ILRadialGradientLayer.h"
#import "MapViewController.h"

#import "CurrentResults.h"
#import "PredictionResults.h"
#import "ResultsCellDelegate.h"

@interface MainViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, ResultsCellDelegate>

@property (nonatomic) NSArray *cellHeights;
@property (nonatomic) NSArray *cellWidths;
@property (nonatomic) NSArray *cellIdentifiers;

@property (nonatomic) CurrentResults *currentResults;
@property (nonatomic) PredictionResults *predictionResults;

@end

@implementation MainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self customizeAppearance];
    [self registerNibs];
    
    [self loadAssets];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Navigation

- (IBAction)userDidSelectMap:(id)sender
{
    MapViewController *mapVC = [self.storyboard instantiateViewControllerWithIdentifier: @"MapViewController"];
    mapVC.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController: mapVC];
    [self presentViewController: navVC animated: YES completion: nil];
}

#pragma mark - Appearance / Initial Setup

- (void)customizeAppearance
{
    [self setupCollectionViewInsetsWithCellsHeight: [self getTotalHeightForCellsExceptLastOne]];
//    [self drawNavigationBarGradient];
//    [self drawBackgroundGradientWithSize: self.view.bounds.size];
}

- (void)registerNibs
{
    UINib *pronosticosNib = [UINib nibWithNibName: @"PronosticosCollectionViewCell" bundle: [NSBundle mainBundle]];
    [self.collectionView registerNib: pronosticosNib forCellWithReuseIdentifier: @"pronosticosCollectionViewCell"];
}

- (void)setupCollectionViewInsetsWithCellsHeight:(CGFloat)height
{
    CGFloat viewHeight = CGRectGetHeight(self.view.bounds);
    CGFloat totalCellsHeight = height;
    CGFloat topInset = 20.0 + (viewHeight - totalCellsHeight) - 10.0f;
    
    self.collectionView.contentInset = UIEdgeInsetsMake(topInset, 0, 0, 0);
    self.collectionView.scrollIndicatorInsets = UIEdgeInsetsMake(20, 0, 0, 0);
}

//- (void)drawNavigationBarGradient
//{
//    UIColor *blueColor = [UIColor il_blueMorningColorWithAlpha: 1.0];
//    UIColor *clearColor = [UIColor il_blueMorningColorWithAlpha: 0];
//    
//    CAGradientLayer *gradientLayer = [[CAGradientLayer alloc] init];
//    gradientLayer.frame = self.gradientView.bounds;
//    gradientLayer.colors = @[(id)blueColor.CGColor, (id)clearColor.CGColor];
//    
//    gradientLayer.startPoint = CGPointMake(0.5f, 0.0f);
//    gradientLayer.endPoint = CGPointMake(0.5f, 1.0f);
//    
//    [self.gradientView.layer insertSublayer: gradientLayer atIndex: 0];
//}

//- (void)drawBackgroundGradientWithSize:(CGSize)size
//{
//    ILRadialGradientLayer *gradientLayer = [[ILRadialGradientLayer alloc] initWithColor: [UIColor il_beigeMorningColorWithAlpha: 1]];
//    gradientLayer.frame = CGRectMake(0, 0, size.width, size.height);
//    
//    if (self.hasDrawnGradient) {
//        [self.view.layer replaceSublayer: [self.view.layer sublayers][0] with: gradientLayer];
//        
//    }else{
//        [self.view.layer insertSublayer: gradientLayer atIndex: 0];
//        self.hasDrawnGradient = YES;
//    }
//}

#pragma mark - Network

- (void)loadAssets
{
    CurrentResults *currentResults = [[CurrentResults alloc] init];
    currentResults.date = [NSDate date];
    currentResults.temperature = @(40);
    currentResults.wind = @(140);
    
    ImecaResults *imecaResults = [[ImecaResults alloc] init];
    imecaResults.amount = @(40);
    imecaResults.quality = @"Mala";
    currentResults.imeca = imecaResults;
    
    ContaminantResults *contamintResults = [[ContaminantResults alloc] init];
    contamintResults.pm10 = @(4);
    contamintResults.pm25 = @(14);
    contamintResults.O3 = @(40);
    currentResults.contaminants = contamintResults;
    
    self.currentResults = currentResults;
    
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

#pragma mark - Rotation

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [super viewWillTransitionToSize: size withTransitionCoordinator: coordinator];
    
    // BEFORE ROTATION
    
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
            [self setupCollectionViewInsetsWithCellsHeight: [self getTotalHeightForCellsExceptLastOne]];
        }else{
            [self setupCollectionViewInsetsWithCellsHeight: [self getFirstTwoCellHeights]];
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
    
    return cell;
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

- (CurrentResults *)getCurrentResults
{
    return self.currentResults;
}

- (PredictionResults *)getPredictionResults
{
    return self.predictionResults;
}

#pragma mark - Set/Get

- (NSArray *)cellHeights
{
    if (!_cellHeights) {
        _cellHeights = @[@(160), @(80), @(80), @(80), @(80), @(190)];
    }
    return _cellHeights;
}

- (NSArray *)cellWidths
{
    if (!_cellWidths) {
        CGFloat collectionWidth = CGRectGetWidth(self.collectionView.bounds);
        _cellWidths = @[@(collectionWidth), @(collectionWidth), @(collectionWidth), @(collectionWidth/2.0f), @(collectionWidth/2.0f), @(collectionWidth)];
    }
    return _cellWidths;
}

- (NSArray *)cellIdentifiers
{
    if (!_cellIdentifiers) {
        _cellIdentifiers = @[@"imecaCell", @"actividadesCell", @"contaminantesCell", @"vientoCell", @"temperaturaCell", @"pronosticosCollectionViewCell"];
    }
    return _cellIdentifiers;
}

#pragma mark - Helper's

- (void)scrollCollectionViewToTop
{
    CGPoint topPoint = CGPointMake(0, -self.collectionView.contentInset.top);
    
    [UIView animateWithDuration: 0.2 animations:^{
        self.collectionView.contentOffset = topPoint;
    }];
    
//    [self.collectionView setContentOffset: topPoint animated: YES];
}

- (CGFloat)getFirstTwoCellHeights
{
    CGFloat acum = 0;
    for (int i = 0; i < 2; i++) {
        acum += [self.cellHeights[i] floatValue];
    }
    return acum;
}

- (CGFloat)getTotalHeightForCellsExceptLastOne
{
    __block CGFloat acum = 0;
    [self.cellHeights enumerateObjectsUsingBlock:^(NSNumber *height, NSUInteger idx, BOOL *stop) {
        // SKIP LAST CELL
        if (idx == [self.cellHeights count] - 1) {
            *stop = YES;
            return;
        }
        acum += [height floatValue];
    }];
    return acum;
}

@end
