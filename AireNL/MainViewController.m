//
//  MainViewController.m
//  AireNL
//
//  Created by Daniel Lozano on 7/21/15.
//  Copyright (c) 2015 Icalia Labs. All rights reserved.
//

#import "MainViewController.h"

#import <FXBlurView/FXBlurView.h>

#import "UIColor+ILColor.h"
#import "ILBlurCollectionView.h"
#import "ILRadialGradientLayer.h"
#import "ILLinearGradientView.h"
#import "MapViewController.h"

#import "CurrentResults.h"
#import "PredictionResults.h"
#import "ResultsCellDelegate.h"

@interface MainViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate, ResultsCellDelegate>

@property (nonatomic) NSArray *cellHeights;
@property (nonatomic) NSArray *cellWidths;
@property (nonatomic) NSArray *cellIdentifiers;

@property (nonatomic) CurrentResults *currentResults;
@property (nonatomic) PredictionResults *predictionResults;

@property (nonatomic) BOOL backgroundHasBlur;
@property (nonatomic) UIImage *normalBackground;
@property (nonatomic) UIImage *blurredBackground;

@property (nonatomic) BOOL dayMode;
@property (nonatomic) CGFloat previousScrollViewYOffset;

@end

@implementation MainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UITapGestureRecognizer *doubleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget: self
                                                                                       action: @selector(userDidSelectSwitchBackground)];
    doubleTapRecognizer.numberOfTapsRequired = 2;
    [self.topView addGestureRecognizer: doubleTapRecognizer];
    
    self.normalBackground = [UIImage imageNamed: @"BackgroundIMG"];
    self.blurredBackground = [[UIImage imageNamed: @"BackgroundIMG"] blurredImageWithRadius: 10.0f iterations: 2 tintColor: nil];
    
    [self customizeAppearance];
    [self registerNibs];
    
    [self loadAssets];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - IBActions

- (IBAction)userDidSelectMap:(id)sender
{
    MapViewController *mapVC = [self.storyboard instantiateViewControllerWithIdentifier: @"MapViewController"];
    mapVC.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController: mapVC];
    [self presentViewController: navVC animated: YES completion: nil];
}

- (void)userDidSelectSwitchBackground
{
    if (!self.dayMode) {
        self.normalBackground = [UIImage imageNamed: @"BackgroundDia"];
        self.blurredBackground = [[UIImage imageNamed: @"BackgroundDia"] blurredImageWithRadius: 10.0f iterations: 2 tintColor: nil];
        self.dayMode = YES;
    }else{
        self.normalBackground = [UIImage imageNamed: @"BackgroundIMG"];
        self.blurredBackground = [[UIImage imageNamed: @"BackgroundIMG"] blurredImageWithRadius: 10.0f iterations: 2 tintColor: nil];
        self.dayMode = NO;
    }
    
    self.backgroundImageView.image = self.backgroundHasBlur ? self.blurredBackground : self.normalBackground;
}

#pragma mark - Appearance / Initial Setup

- (void)customizeAppearance
{
    [self setBackgroundImageWithBlur: NO];
    [self setupCollectionViewInsetsWithCellsHeight: [self getTotalHeightForCellsExceptLastOne]];
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

- (void)setupCollectionViewInsetsWithCellsHeight:(CGFloat)height
{
    CGFloat viewHeight = CGRectGetHeight(self.view.bounds);
    CGFloat totalCellsHeight = height;
    CGFloat topInset = 25.0 + (viewHeight - totalCellsHeight);
    
    self.collectionView.contentInset = UIEdgeInsetsMake(topInset, 0, 0, 0);
    self.collectionView.scrollIndicatorInsets = UIEdgeInsetsMake(20, 0, 0, 0);
}

#pragma mark - UIScrollView Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat correctedOffset = scrollView.contentInset.top + scrollView.contentOffset.y;
    if (correctedOffset <= 10) {
        [self setBackgroundImageWithBlur: NO];
    }else{
        [self setBackgroundImageWithBlur: YES];
    }
    
    [self animateTopViewWithScrollView: scrollView];
}

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
        _cellHeights = @[@(160), @(100), @(100), @(100), @(100), @(190)];
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

- (void)animateTopViewWithScrollView:(UIScrollView *)scrollView
{
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

@end
