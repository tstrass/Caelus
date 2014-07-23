//
//  UIImageView+Tools.h
//  Caelus
//
//  Created by Thomas Strassner on 7/11/14.
//  Copyright (c) 2014 Enterprise Holdings, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (Tools)
/** Returns proper height for an imageView given a width, in order to keep the aspect ratio of the original image.
 *  If the imageView has no image, this method will return 0.0
 */
- (CGFloat)heightForWidth:(CGFloat)width;
@end
