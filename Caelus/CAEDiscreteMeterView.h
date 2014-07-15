//
//  CAEDiscreteMeterView.h
//  Caelus
//
//  Created by Thomas Strassner on 7/15/14.
//  Copyright (c) 2014 Enterprise Holdings, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CAEDiscreteMeterViewDelegate;
@protocol CAEDiscreteMeterViewDataSource;

/**
 *  This object is a meter that represents discrete values. The values are represented with images.
 *
 *  Note: You must call the reload method for any data to be rendered.
 */
@interface CAEDiscreteMeterView : UIView
@property (weak) id<CAEDiscreteMeterViewDelegate> delegate;
@property (weak) id<CAEDiscreteMeterViewDataSource> dataSource;
//- (id)initWithFrame:(CGRect)frame ValueImage:(UIImage *)valueImage NonValueImage:(UIImage *)nonValueImage;
//- (id)initWithValueImage:(UIImage *)valueImage NonValueImage:(UIImage *)nonValueImage;
- (void)reload;
@end

@protocol CAEDiscreteMeterViewDelegate <NSObject>
@required
- (NSInteger)maxValueForDiscreteMeterView:(CAEDiscreteMeterView *)discreteMeterView;
/** value for meter (out of max value). i.e. number of "filled in" images */
- (NSInteger)valueForDiscreteMeterView:(CAEDiscreteMeterView *)discreteMeterView;
@end


@protocol CAEDiscreteMeterViewDataSource <NSObject>
@required
/** image to represent a "filled in" value in the meter */
- (UIImage *)valueImage;
/** image to represent a "non filled in" value in the meter */
- (UIImage *)nonValueImage;
@end