//
//  CAEDiscreteMeterView.m
//  Caelus
//
//  Created by Thomas Strassner on 7/15/14.
//  Copyright (c) 2014 Enterprise Holdings, Inc. All rights reserved.
//
#import "CAEDiscreteMeterView.h"
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

#import "UIImageView+Tools.h"

@interface CAEDiscreteMeterView ()
@property (nonatomic) NSInteger meterValue;
@property (nonatomic) NSInteger maxValue;
@end

@implementation CAEDiscreteMeterView

#define SUBVIEW_H_PADDING 2
#define SUBVIEW_V_PADDING 5

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)reload {
    // No need to reload anything if the value of the meter has not changed
    if (self.meterValue == [self.delegate valueForDiscreteMeterView:self] && self.maxValue == [self.delegate maxValueForDiscreteMeterView:self]) return;
    
    // nothing to load if there's no delegate
    if (self.delegate == nil) return;
    
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    self.maxValue = [self.delegate maxValueForDiscreteMeterView:self];
    self.meterValue = [self.delegate valueForDiscreteMeterView:self];
    
    CGFloat subviewWidth = (self.frame.size.width - ((((self.maxValue + 1) * 2) - 2) * SUBVIEW_H_PADDING)) / self.maxValue;
    CGFloat xValue = 0;
    
    // render each subview
    for (int i = 0; i < self.maxValue; i++) {
        UIImage *subviewImage = (i < self.meterValue) ? [self.dataSource valueImage] : [self.dataSource nonValueImage];
        UIImageView *subviewImageView = [[UIImageView alloc] initWithImage:subviewImage];
        xValue += SUBVIEW_H_PADDING;
        subviewImageView.frame = CGRectMake(xValue, SUBVIEW_V_PADDING, subviewWidth, [subviewImageView heightForWidth:subviewWidth]);
        subviewImageView.layer.shadowOffset = CGSizeMake(1, 1);
        subviewImageView.layer.shadowColor = [[UIColor grayColor] CGColor];
        subviewImageView.layer.shadowRadius = 4.0f;
        subviewImageView.layer.shadowOpacity = 1.00f;
        [self addSubview:subviewImageView];
        xValue += subviewWidth + SUBVIEW_H_PADDING;
    }
}

@end
