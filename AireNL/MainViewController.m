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
    self.view.backgroundColor = [UIColor il_blueMorningColor];
    
    [self drawBackgroundWithSize: self.view.bounds.size];
    [self customizeAppearance];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Appearance

- (void)customizeAppearance
{
    self.collectionView.contentInset = UIEdgeInsetsMake(0, 0, 50.0, 0);
}

- (void)drawBackgroundWithSize:(CGSize)size
{
    ILGradientLayer *gradientLayer = [[ILGradientLayer alloc] initWithColor: [UIColor il_beigeMorningColor]];
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
    [self drawBackgroundWithSize: size];
    
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context){
        // WHILE ROTATING
        
     }completion:^(id<UIViewControllerTransitionCoordinatorContext> context){
         // AFTER ROTATION
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

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath
{
    HeaderCollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind: UICollectionElementKindSectionHeader
                                                                                  withReuseIdentifier: @"headerView"
                                                                                         forIndexPath: indexPath];
    headerView.delegate = self;
    return headerView;
}

#pragma mark - UICollectionView DelegateFlowLayout

- (CGSize) collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(0, [self getCenterPoint]);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = [((NSNumber *)self.cellHeights[indexPath.row]) floatValue];
    CGFloat width;
    if (indexPath.row == 3 || indexPath.row == 4) {
        width = CGRectGetWidth(self.collectionView.bounds) / 2;
    }else{
        width = CGRectGetWidth(self.collectionView.bounds);
    }
    
    return CGSizeMake(width, height);
}

#pragma mark - HeaderReusableView Delegate

- (void)userDidSelectMap
{
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

- (NSArray *)cellIdentifiers
{
    if (!_cellIdentifiers) {
        _cellIdentifiers = @[@"imecaCell", @"actividadesCell", @"contaminantesCell", @"vientoCell", @"temperaturaCell"];
    }
    return _cellIdentifiers;
}

#pragma mark - Helper's

- (CGFloat)getCenterPoint
{
    [self.view setNeedsLayout];
    [self.view layoutIfNeeded];
    
    return CGRectGetMidY(self.collectionView.bounds);
}

@end
