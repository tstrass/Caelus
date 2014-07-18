//
//  CAEHorizontalScrollView.m
//  Caelus
//
//  Created by Thomas Strassner on 7/17/14.
//  Copyright (c) 2014 Enterprise Holdings, Inc. All rights reserved.
//

#import "CAEHorizontalScrollView.h"

@implementation CAEHorizontalScrollView
@dynamic delegate;


static const float VIEW_PADDING = 10.0;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void)reload {
    //nothing to load if there's no delegate
    if (self.delegate == nil) return;
    
    //remove all subviews
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    //xValue is the starting point of the views inside the scroller
    CGFloat xValue = VIEW_PADDING;
    NSInteger numSubviews = [self.delegate numberOfViewsForHorizonalScrollView:self];
    for (NSInteger i = 0; i < numSubviews; i++) {
        //add a view at the right position
        xValue += VIEW_PADDING;
        UIView *view = [self.dataSource viewAtIndex:i ForHorizontalScrollView:self];
        view.frame = CGRectMake(xValue, 0, view.frame.size.width, view.frame.size.height);
        [self addSubview:view];
        xValue += view.frame.size.width + VIEW_PADDING;
    }
    
    [self setContentSize:CGSizeMake(xValue, self.frame.size.height)];
}


@end
