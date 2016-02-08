//
//  ActividadesCollectionViewCell.m
//  AireNL
//
//  Created by Daniel Lozano on 8/4/15.
//  Copyright (c) 2015 Icalia Labs. All rights reserved.
//

#import "ActividadesCollectionViewCell.h"

#import "UIColor+ILColor.h"
#import "InnerActividadesCollectionViewCell.h"

#import "Activity.h"

@interface ActividadesCollectionViewCell () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic) NSArray *selectedActivities;

@property (nonatomic) NSArray *goodActivities;
@property (nonatomic) NSArray *regularActivities;
@property (nonatomic) NSArray *badActivities;
@property (nonatomic) NSArray *veryBadActivities;
@property (nonatomic) NSArray *extremelyBadActivities;

@end

@implementation ActividadesCollectionViewCell

@synthesize delegate;

- (void)awakeFromNib
{    
    self.innerCollectionView.dataSource = self;
    self.innerCollectionView.delegate = self;
}

- (void)updateCell
{
    Measurement *measurement = [self.delegate getSelectedMeasurement];
    self.statusView.backgroundColor = [measurement colorForAirQuality];
    
//    switch ([measurement airQuality]) {
//        case AirQualityDescriptorGood:
//            self.selectedActivities = self.goodActivities;
//            break;
//        case AirQualityDescriptorRegular:
//            self.selectedActivities = self.regularActivities;
//            break;
//        case AirQualityDescriptorBad:
//            self.selectedActivities = self.badActivities;
//            break;
//        case AirQualityDescriptorVeryBad:
//            self.selectedActivities = self.veryBadActivities;
//            break;
//        case AirQualityDescriptorExtremelyBad:
//            self.selectedActivities = self.extremelyBadActivities;
//            break;
//        default:
//            self.selectedActivities = nil;
//            break;
//    }
    
    self.selectedActivities = self.extremelyBadActivities;

    [self.innerCollectionView reloadData];
}

#pragma mark - UICollectionView Data Source

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.selectedActivities count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    InnerActividadesCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier: @"IconoActividadCell"
                                                                                         forIndexPath: indexPath];
    
    Activity *activity = self.selectedActivities[indexPath.row];
    cell.activityImageView.image = [activity image];
    
    return cell;
}

#pragma mark - UICollectionView Delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector: @selector(actividadesDidSelectInfoWithText:)]){
        Activity *activity = self.selectedActivities[indexPath.row];
        [self.delegate actividadesDidSelectInfoWithText: [activity description]];
    }
}

#pragma mark - Set/Get

- (NSArray *)goodActivities
{
    if (!_goodActivities) {
        Activity *exercise = [[Activity alloc] initWithActivityType: ActivityTypeExercise];
        Activity *outdoors = [[Activity alloc] initWithActivityType: ActivityTypeOutdoors];
        Activity *sensible = [[Activity alloc] initWithActivityType: ActivityTypeSensible];

        _goodActivities = @[exercise, outdoors, sensible];
    }
    return _goodActivities;
}

- (NSArray *)regularActivities
{
    if (!_regularActivities) {
        Activity *exercise = [[Activity alloc] initWithActivityType: ActivityTypeExercise];
        Activity *outdoors = [[Activity alloc] initWithActivityType: ActivityTypeOutdoors];
        Activity *limitSensible = [[Activity alloc] initWithActivityType: ActivityTypeLimitSensible];
        
        _regularActivities = @[exercise, outdoors, limitSensible];
    }
    return _regularActivities;
}

- (NSArray *)badActivities
{
    if (!_badActivities) {
        Activity *limitExercise = [[Activity alloc] initWithActivityType: ActivityTypeLimitExercise];
        Activity *limitOutdoors = [[Activity alloc] initWithActivityType: ActivityTypeLimitOutdoors];
        Activity *noSensible = [[Activity alloc] initWithActivityType: ActivityTypeNoSensible];

        _badActivities = @[limitExercise, limitOutdoors, noSensible];
    }
    return _badActivities;
}

- (NSArray *)veryBadActivities
{
    if (!_veryBadActivities) {
        Activity *noExercise = [[Activity alloc] initWithActivityType: ActivityTypeNoExercise];
        Activity *noOutdoors = [[Activity alloc] initWithActivityType: ActivityTypeNoOutdoors];
        Activity *window = [[Activity alloc] initWithActivityType: ActivityTypeWindow];
        Activity *noSensible = [[Activity alloc] initWithActivityType: ActivityTypeNoSensible];
        Activity *heart = [[Activity alloc] initWithActivityType: ActivityTypeHeart];
        Activity *limitCar = [[Activity alloc] initWithActivityType: ActivityTypeLimitCar];
        Activity *noFuel = [[Activity alloc] initWithActivityType: ActivityTypeNoFuel];

        _veryBadActivities = @[noExercise, noOutdoors, window, noSensible, heart, limitCar, noFuel];
    }
    return _veryBadActivities;
}

- (NSArray *)extremelyBadActivities
{
    if (!_extremelyBadActivities) {
        Activity *noExercise = [[Activity alloc] initWithActivityType: ActivityTypeNoExercise];
        Activity *noOutdoors = [[Activity alloc] initWithActivityType: ActivityTypeNoOutdoors];
        Activity *window = [[Activity alloc] initWithActivityType: ActivityTypeWindow];
        Activity *noSensible = [[Activity alloc] initWithActivityType: ActivityTypeNoSensible];
        Activity *heart = [[Activity alloc] initWithActivityType: ActivityTypeHeart];
        Activity *limitCar = [[Activity alloc] initWithActivityType: ActivityTypeLimitCar];
        Activity *noFuel = [[Activity alloc] initWithActivityType: ActivityTypeNoFuel];

        _extremelyBadActivities = @[noExercise, noOutdoors, window, noSensible, heart, limitCar, noFuel];
    }
    return _extremelyBadActivities;
}

@end
