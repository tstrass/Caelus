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
static const float VIEW_PADDING = 20.0;
static const float INDICATOR_WIDTH = 1.0;
static const float INDICATOR_HEIGHT = 10.0;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpScrollView];
        [self setUpIndicatorView];
    }
    return self;
}

- (void)reload {
    //nothing to load if there's no delegate
    if (self.hoursDelegate == nil) return;
    
    if (!self.scrollView) [self setUpScrollView];
    if (!self.indicatorView) [self setUpIndicatorView];

    
    //remove all subviews
    [self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    self.xOffset = (self.frame.size.width / 2) - (VIEW_WIDTH / 2) - VIEW_PADDING;
    
    
    //xValue is the starting point of the views inside the scroller
    CGFloat xValue = self.xOffset;
    NSInteger numSubviews = [self.hoursDelegate numberOfViewsForHorizonalScrollView:self];
    for (NSInteger i = 0; i < numSubviews; i++) {
        //add a view at the right position
        xValue += VIEW_PADDING;
        UIView *view = [self.dataSource viewAtIndex:i forHorizontalScrollView:self];
        view.frame = CGRectMake(xValue, 0, VIEW_WIDTH, view.frame.size.height);
        [self.scrollView addSubview:view];
        xValue += view.frame.size.width + VIEW_PADDING;
    }
    
    [self.scrollView setContentSize:CGSizeMake(xValue + self.xOffset, self.frame.size.height)];
}

- (void)setUpScrollView {
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    self.scrollView.delegate = self;
    [self addSubview:self.scrollView];
}

- (void)setUpIndicatorView {
    self.indicatorView = [[UIView alloc] init];
    self.indicatorView.frame = CGRectMake((self.frame.size.width / 2) - (INDICATOR_WIDTH / 2), self.layer.borderWidth, INDICATOR_WIDTH, INDICATOR_HEIGHT);
    self.indicatorView.backgroundColor = [UIColor redColor];
    [self addSubview:self.indicatorView];
}

- (void)centerCurrentView {
    CGFloat xFinal = self.scrollView.contentOffset.x + (VIEW_WIDTH / 2) + VIEW_PADDING;
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
