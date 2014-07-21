//
//  CAEHorizontalScrollView.m
//  Caelus
//
//  Created by Thomas Strassner on 7/17/14.
//  Copyright (c) 2014 Enterprise Holdings, Inc. All rights reserved.
//

#import "CAEHorizontalScrollView.h"

@interface CAEHorizontalScrollView () <UIScrollViewDelegate>
@property (strong, nonatomic) UIView *indicatorView;
@property (nonatomic) CGFloat xOffset;
@property (strong, nonatomic) UIScrollView *scrollView;
@end

@implementation CAEHorizontalScrollView

static const float VIEW_WIDTH = 75.0;
static const float VIEW_PADDING = 10.0;
static const float INDICATOR_WIDTH = 1.0;
static const float INDICATOR_HEIGHT = 10.0;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.scrollView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        self.scrollView.delegate = self;
        [self addSubview:self.scrollView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self formatIndicatorView];
}

- (void)reload {
    //nothing to load if there's no delegate
    if (self.poopcheese == nil) return;
    
    //remove all subviews
    [self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    [self.scrollView addSubview:self.indicatorView];
    
    self.xOffset = (self.frame.size.width / 2) - ([self.dataSource viewAtIndex:0 forHorizontalScrollView:self].frame.size.width / 2) - VIEW_PADDING;
    
    
    //xValue is the starting point of the views inside the scroller
    CGFloat xValue = self.xOffset;
    NSInteger numSubviews = [self.poopcheese numberOfViewsForHorizonalScrollView:self];
    for (NSInteger i = 0; i < numSubviews; i++) {
        //add a view at the right position
        xValue += VIEW_PADDING;
        UIView *view = [self.dataSource viewAtIndex:i forHorizontalScrollView:self];
        view.frame = CGRectMake(xValue, 0, VIEW_WIDTH, view.frame.size.height);
        [self insertSubview:view belowSubview:self.indicatorView];
        xValue += view.frame.size.width + VIEW_PADDING;
    }
    [self.scrollView setContentSize:CGSizeMake(xValue + self.xOffset, self.frame.size.height)];
    self.scrollView.scrollEnabled = YES;
}

- (void)formatIndicatorView {
    CGFloat xOffset = self.scrollView.contentOffset.x;
    xOffset = self.frame.size.width / 2 - (INDICATOR_WIDTH / 2) + xOffset;
    if (self.indicatorView == nil) {
        self.indicatorView = [[UIView alloc] init];
        self.indicatorView.backgroundColor = [UIColor redColor];
        [self addSubview:self.indicatorView];
    }
    self.indicatorView.frame = CGRectMake(xOffset, self.layer.borderWidth, INDICATOR_WIDTH, INDICATOR_HEIGHT);
    //[self bringSubviewToFront:self.indicatorView];
}

- (void)centerCurrentView {
    CGFloat xFinal = self.scrollView.contentOffset.x + (self.xOffset / 2) + VIEW_PADDING;
    NSInteger viewIndex = xFinal / (VIEW_WIDTH + (2 * VIEW_PADDING));
    xFinal = viewIndex * (VIEW_WIDTH + (2 * VIEW_PADDING));
    [self.scrollView setContentOffset:CGPointMake(xFinal, 0) animated:YES];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) [self centerCurrentView];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self centerCurrentView];
}


@end
