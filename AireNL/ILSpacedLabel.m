//
//  ILSpacedLabel.m
//  AireNL
//
//  Created by Daniel Lozano on 7/22/15.
//  Copyright (c) 2015 Icalia Labs. All rights reserved.
//

#import "ILSpacedLabel.h"

@implementation ILSpacedLabel

- (void)setText:(NSString *)text
{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 10.0f;
    paragraphStyle.alignment = self.textAlignment;
    NSDictionary *attributes = @{NSParagraphStyleAttributeName: paragraphStyle};
    NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:text
                                                                         attributes:attributes];
    self.attributedText = attributedText;
}

@end
