//
//  CAEDiscreteMeterView.h
//  Caelus
//
//  Created by Thomas Strassner on 7/15/14.
//  Copyright (c) 2014 Enterprise Holdings, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CAEDiscreteMeterViewDelegate;

/**
 *  This object is a meter that represents discrete values. The values are represented with images.
 *
 *  Note: You must call the reload method for any data to be rendered.
 */
@interface CAEDiscreteMeterView : UIView
@property (weak) id<CAEDiscreteMeterViewDelegate> delegate;
- (id)initWithFrame:(CGRect)frame ValueImage:(UIImage *)valueImage NonValueImage:(UIImage *)nonValueImage;
- (id)initWithValueImage:(UIImage *)valueImage NonValueImage:(UIImage *)nonValueImage;
- (void)reload;
/** image to represent a "filled in" value in the meter */
@property (strong, nonatomic)UIImage *valueImage;
/** image to represent a "non filled in" value in the meter */
@property (strong, nonatomic)UIImage *nonValueImage;
@end

@protocol CAEDiscreteMeterViewDelegate <NSObject>
@required
- (NSInteger)maxValueForDiscreteMeterView:(CAEDiscreteMeterView *)discreteMeterView;
/** value for meter (out of max value). i.e. number of "filled in" images */
- (NSInteger)valueForDiscreteMeterView:(CAEDiscreteMeterView *)discreteMeterView;
@end
