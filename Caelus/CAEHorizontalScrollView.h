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

@interface CAEHorizontalScrollView : UIView
@property (nonatomic, strong) id<CAEHorizontalScrollViewDelegate> hoursDelegate;
@property (nonatomic, strong) id<CAEHorizontalScrollViewDataSource> dataSource;

- (void)reload;
@end

@protocol CAEHorizontalScrollViewDelegate <NSObject>
@optional
- (void)scrollViewSubviewDidChange:(NSInteger)index;
@end

@protocol CAEHorizontalScrollViewDataSource <NSObject>
/** specify a view to put at this index */
- (UIView *)viewAtIndex:(NSInteger)index forHorizontalScrollView:(CAEHorizontalScrollView *)horizontalScrollView;
@required
/** total number of subviews for the horizontal scrollView to contain */
- (NSInteger)numberOfViewsForHorizonalScrollView:(CAEHorizontalScrollView *)horizontalScrollView;
@end