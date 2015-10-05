//
//  PronosticoTableViewCell.m
//  AireNL
//
//  Created by Daniel Lozano on 7/28/15.
//  Copyright (c) 2015 Icalia Labs. All rights reserved.
//

#import "PronosticoTableViewCell.h"

@implementation PronosticoTableViewCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
//    PredictionResults *predictionResults = [self.delegate getPredictionResults];
//    
//    if ([self.row integerValue] == 0) {
//        
//        self.firstLabel.text = [predictionResults.periodOne.pm10 stringValue];
//        self.secondLabel.text = [predictionResults.periodTwo.pm10 stringValue];
//        self.thirdLabel.text = [predictionResults.periodThree.pm10 stringValue];
//        
//    }else if ([self.row integerValue] == 1) {
//        
//        self.firstLabel.text = [predictionResults.periodOne.pm25 stringValue];
//        self.secondLabel.text = [predictionResults.periodTwo.pm25 stringValue];
//        self.thirdLabel.text = [predictionResults.periodThree.pm25 stringValue];
//        
//    }else{
//        
//        self.firstLabel.text = [predictionResults.periodOne.O3 stringValue];
//        self.secondLabel.text = [predictionResults.periodTwo.O3 stringValue];
//        self.thirdLabel.text = [predictionResults.periodThree.O3 stringValue];
//        
//    }

}

@end
