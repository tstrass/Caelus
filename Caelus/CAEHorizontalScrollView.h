//
//  CAEHorizontalScrollView.h
//  Caelus
//
//  Created by Thomas Strassner on 7/17/14.
//  Copyright (c) 2014 Enterprise Holdings, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CAEHorizontalScrollViewDelegate;
@protocol CAEHorizontalScrollViewDataSource;

@interface CAEHorizontalScrollView : UIScrollView
@property (nonatomic, assign) id<UIScrollViewDelegate, CAEHorizontalScrollViewDelegate> delegate;
@property (nonatomic, weak) id<CAEHorizontalScrollViewDataSource> dataSource;

- (void)reload;
@end

@protocol CAEHorizontalScrollViewDelegate <UIScrollViewDelegate>
@required
/** total number of subviews for the horizontal scrollView to contain */
- (NSInteger)numberOfViewsForHorizonalScrollView:(CAEHorizontalScrollView *)horizontalScrollView;
@end

@protocol CAEHorizontalScrollViewDataSource <NSObject>
/** specify a view to put at this index */
- (UIView *)viewAtIndex:(NSInteger)index ForHorizontalScrollView:(CAEHorizontalScrollView *)horizontalScrollView;
@end