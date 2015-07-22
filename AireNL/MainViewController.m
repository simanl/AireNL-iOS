//
//  MainViewController.m
//  AireNL
//
//  Created by Daniel Lozano on 7/21/15.
//  Copyright (c) 2015 Icalia Labs. All rights reserved.
//

#import "MainViewController.h"

#import "UIColor+ILColor.h"
#import "ILGradientLayer.h"
#import "MapViewController.h"
#import "HeaderCollectionReusableView.h"

@interface MainViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, HeaderCollectionReusableViewDelegate>

@property (nonatomic) NSArray *cellHeights;
@property (nonatomic) NSArray *cellWidths;
@property (nonatomic) NSArray *cellIdentifiers;

@property (nonatomic) BOOL hasDrawnGradient;

@end

@implementation MainViewController

@synthesize index;
@synthesize parentVC;

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.index = 0;
    
    [self customizeAppearance];
    [self addGestureRecognizers];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear: animated];
    
    self.gradientView.hidden = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Appearance / Initial Setup

- (void)addGestureRecognizers
{
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] init];
    [tapRecognizer addTarget: self action: @selector(userDidSelectMap)];
    [self.topView addGestureRecognizer: tapRecognizer];
}

- (void)customizeAppearance
{
    self.view.backgroundColor = [UIColor il_blueMorningColorWithAlpha: 1];
    
    [self setupCollectionViewInsets];
    [self drawNavigationBarGradient];
    [self drawBackgroundGradientWithSize: self.view.bounds.size];
}

- (void)setupCollectionViewInsets
{
    CGFloat viewHeight = CGRectGetHeight(self.view.bounds);
    CGFloat totalCellsHeight = [self getTotalHeightForCells];
    CGFloat topInset = 20.0 + (viewHeight - totalCellsHeight) - 10.0f;
    
    self.collectionView.contentInset = UIEdgeInsetsMake(topInset, 0, 1000, 0);
    self.collectionView.scrollIndicatorInsets = UIEdgeInsetsMake(20, 0, 0, 0);
}

- (void)drawNavigationBarGradient
{
    UIColor *blueColor = [UIColor il_blueMorningColorWithAlpha: 1.0];
    UIColor *clearColor = [UIColor il_blueMorningColorWithAlpha: 0];
    
    CAGradientLayer *gradientLayer = [[CAGradientLayer alloc] init];
    gradientLayer.frame = self.gradientView.bounds;
    gradientLayer.colors = @[(id)blueColor.CGColor, (id)clearColor.CGColor];
    
    gradientLayer.startPoint = CGPointMake(0.5f, 0.0f);
    gradientLayer.endPoint = CGPointMake(0.5f, 1.0f);
    
    [self.gradientView.layer insertSublayer: gradientLayer atIndex: 0];
}

- (void)drawBackgroundGradientWithSize:(CGSize)size
{
    ILGradientLayer *gradientLayer = [[ILGradientLayer alloc] initWithColor: [UIColor il_beigeMorningColorWithAlpha: 1]];
    gradientLayer.frame = CGRectMake(0, 0, size.width, size.height);
    
    if (self.hasDrawnGradient) {
        [self.view.layer replaceSublayer: [self.view.layer sublayers][0] with: gradientLayer];
        
    }else{
        [self.view.layer insertSublayer: gradientLayer atIndex: 0];
        self.hasDrawnGradient = YES;
    }
}

#pragma mark - Rotation

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];

    // BEFORE ROTATION
    [self drawBackgroundGradientWithSize: size];
    
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context){
        // WHILE ROTATING
        
     }completion:^(id<UIViewControllerTransitionCoordinatorContext> context){
         // AFTER ROTATION
         self.cellWidths = nil;
         [self.collectionView reloadData];

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

#pragma mark - HeaderReusableView Delegate

- (void)userDidSelectMap
{
    self.gradientView.hidden = YES;
    
    MapViewController *mapVC = [self.storyboard instantiateViewControllerWithIdentifier: @"MapViewController"];
    mapVC.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController: mapVC];
    [self presentViewController: navVC animated: YES completion: nil];
}

#pragma mark - Getters

- (NSArray *)cellHeights
{
    if (!_cellHeights) {
        _cellHeights = @[@(160), @(80), @(80), @(80), @(80)];
    }
    return _cellHeights;
}

- (NSArray *)cellWidths
{
    if (!_cellWidths) {
        CGFloat collectionWidth = CGRectGetWidth(self.collectionView.bounds);
        _cellWidths = @[@(collectionWidth), @(collectionWidth), @(collectionWidth), @(collectionWidth/2.0f), @(collectionWidth/2.0f)];
    }
    return _cellWidths;
}

- (NSArray *)cellIdentifiers
{
    if (!_cellIdentifiers) {
        _cellIdentifiers = @[@"imecaCell", @"actividadesCell", @"contaminantesCell", @"vientoCell", @"temperaturaCell"];
    }
    return _cellIdentifiers;
}

#pragma mark - Helper's

- (CGFloat)getTotalHeightForCells
{
    CGFloat acum = 0;
    for (NSNumber *height in self.cellHeights) {
        acum += [height floatValue];
    }
    return acum;
}

//- (CGFloat)getCenterPoint
//{
//    [self.view setNeedsLayout];
//    [self.view layoutIfNeeded];
//    
//    return CGRectGetMidY(self.collectionView.bounds);
//}

@end
