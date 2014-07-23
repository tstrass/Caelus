//
//  UIView+Tools.m
//  Caelus
//
//  Created by Thomas Strassner on 7/17/14.
//  Copyright (c) 2014 Enterprise Holdings, Inc. All rights reserved.
//

#import "UIView+Tools.h"

@implementation UIView (Tools)
- (CGFloat)widthForHeight:(CGFloat)height {
    CGFloat originalWidth = self.frame.size.width;
    CGFloat originalHeight = self.frame.size.height;
    CGFloat widthToHeightRatio = originalWidth / originalHeight;
    return height * widthToHeightRatio;
}
@end
