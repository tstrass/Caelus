//
//  UIImageView+Tools.m
//  Caelus
//
//  Created by Thomas Strassner on 7/11/14.
//  Copyright (c) 2014 Enterprise Holdings, Inc. All rights reserved.
//

#import "UIImageView+Tools.h"

@implementation UIImageView (Tools)
- (CGFloat)heightForWidth:(CGFloat)width {
    CGFloat height = 0.0;
    if (self.image) {
        CGFloat originalWidth = self.image.size.width;
        CGFloat originalHeight = self.image.size.height;
        CGFloat heightToWidthRatio = originalHeight / originalWidth;
        height = width * heightToWidthRatio;
    }
    return height;
}
@end
