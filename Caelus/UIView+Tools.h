//
//  UIView+Tools.h
//  Caelus
//
//  Created by Thomas Strassner on 7/17/14.
//  Copyright (c) 2014 Enterprise Holdings, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Tools)
/** Returns the proper width for a UIView given a desired height, while keeping the aspect ratio of frame of the view */
- (CGFloat)widthForHeight:(CGFloat)height;
@end
