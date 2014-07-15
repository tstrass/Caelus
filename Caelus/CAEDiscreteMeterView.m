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

- (id)initWithFrame:(CGRect)frame ValueImage:(UIImage *)valueImage NonValueImage:(UIImage *)nonValueImage {
    self = [super initWithFrame:frame];
    if (self) {
        self.valueImage = valueImage;
        self.nonValueImage = nonValueImage;
    }
    return self;
}

- (id)initWithValueImage:(UIImage *)valueImage NonValueImage:(UIImage *)nonValueImage {
    self = [super init];
    if (self) {
        self.valueImage = valueImage;
        self.nonValueImage = nonValueImage;
    }
    return self;
}

- (void)reload {
    // nothing to load if there's no delegate
    if (self.delegate == nil) return;
    
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    NSInteger maxValues = [self.delegate maxValueForDiscreteMeterView:self];
    NSInteger meterValue = [self.delegate valueForDiscreteMeterView:self];
    
    CGFloat subviewWidth = (self.frame.size.width - ((((maxValues + 1) * 2) - 2) * SUBVIEW_H_PADDING)) / maxValues;
    CGFloat xValue = 0;
    // render each subview
    for (int i = 0; i < maxValues; i++) {
        UIImage *subviewImage = (i < meterValue) ? self.valueImage : self.nonValueImage;
        UIImageView *subviewImageView = [[UIImageView alloc] initWithImage:subviewImage];
        xValue += SUBVIEW_H_PADDING;
        subviewImageView.frame = CGRectMake(xValue, SUBVIEW_V_PADDING, subviewWidth, [subviewImageView heightForWidth:subviewWidth]);
        [self addSubview:subviewImageView];
        xValue += subviewWidth + SUBVIEW_H_PADDING;
    }
}

@end
