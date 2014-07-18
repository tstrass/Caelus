//
//  CAEHorizontalScrollView.m
//  Caelus
//
//  Created by Thomas Strassner on 7/17/14.
//  Copyright (c) 2014 Enterprise Holdings, Inc. All rights reserved.
//

#import "CAEHorizontalScrollView.h"

@interface CAEHorizontalScrollView ()
@property (strong, nonatomic) UIView *indicatorView;
@end

@implementation CAEHorizontalScrollView
@dynamic delegate;


static const float VIEW_PADDING = 10.0;
static const float INDICATOR_WIDTH = 1.0;
static const float INDICATOR_HEIGHT = 10.0;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self formatIndicatorView];
}

- (void)reload {
    //nothing to load if there's no delegate
    if (self.delegate == nil) return;
    
    //remove all subviews
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    [self addSubview:self.indicatorView];
    
    CGFloat xOffset = (self.frame.size.width / 2) - ([self.dataSource viewAtIndex:0 ForHorizontalScrollView:self].frame.size.width / 2) - VIEW_PADDING;
    
    //xValue is the starting point of the views inside the scroller
    CGFloat xValue = xOffset;
    NSInteger numSubviews = [self.delegate numberOfViewsForHorizonalScrollView:self];
    for (NSInteger i = 0; i < numSubviews; i++) {
        //add a view at the right position
        xValue += VIEW_PADDING;
        UIView *view = [self.dataSource viewAtIndex:i ForHorizontalScrollView:self];
        view.frame = CGRectMake(xValue, 0, view.frame.size.width, view.frame.size.height);
        [self insertSubview:view belowSubview:self.indicatorView];
        xValue += view.frame.size.width + VIEW_PADDING;
    }
    [self setContentSize:CGSizeMake(xValue + xOffset, self.frame.size.height)];
}

- (void)formatIndicatorView {
    CGFloat xOffset = self.contentOffset.x;
    xOffset = self.frame.size.width / 2 - (INDICATOR_WIDTH / 2) + xOffset;
    if (self.indicatorView == nil) {
        self.indicatorView = [[UIView alloc] init];
        self.indicatorView.backgroundColor = [UIColor redColor];
        [self addSubview:self.indicatorView];
    }
    self.indicatorView.frame = CGRectMake(xOffset, self.layer.borderWidth, INDICATOR_WIDTH, INDICATOR_HEIGHT);
    //[self bringSubviewToFront:self.indicatorView];
}

@end
