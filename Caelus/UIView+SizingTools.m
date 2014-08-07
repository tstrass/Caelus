//
//  UIView+SizingTools.m
//  Caelus
//
//  Created by Tom on 8/7/14.
//  Copyright (c) 2014 Enterprise Holdings, Inc. All rights reserved.
//

#import "UIView+SizingTools.h"

@implementation UIView (SizingTools)


- (void)setY:(CGFloat)newY {
    CGRect frame = self.frame;
    
    frame.origin.y = newY;
    self.frame = frame;
}

- (void)setX:(CGFloat)newX {
    CGRect frame = self.frame;
    
    frame.origin.x = newX;
    self.frame = frame;
}

- (void)setOrigin:(CGPoint)origin {
    [self setY:origin.y];
    [self setX:origin.x];
}

- (void)setWidth:(CGFloat)newWidth {
    CGRect frame = self.frame;
    
    frame.size.width = newWidth;
    self.frame = frame;
}

- (void)setHeight:(CGFloat)newHeight {
    CGRect frame = self.frame;
    
    frame.size.height = newHeight;
    self.frame = frame;
}

- (void)roundTopCornersWithRadius:(float)radius {
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                                   byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight
                                                         cornerRadii:CGSizeMake(radius, radius)];
    
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}

- (void)roundBottomCornersWithRadius:(float)radius {
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                                   byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight
                                                         cornerRadii:CGSizeMake(radius, radius)];
    
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}

- (void)roundCornersWithRadius:(float)radius {
    self.layer.cornerRadius = radius;
}

- (void)addTopBorderWithColor:(UIColor *)color andWidth:(CGFloat)borderWidth {
    CALayer *border = [CALayer layer];
    
    border.backgroundColor = color.CGColor;
    border.frame = CGRectMake(0, 0, self.frame.size.width, borderWidth);
    [border setMasksToBounds:YES];
    [border setCornerRadius:2.0];
    [self.layer addSublayer:border];
}

- (void)addIndentedTopBorderWithColor:(UIColor *)color andWidth:(CGFloat)borderWidth {
    CALayer *border = [CALayer layer];
    
    border.backgroundColor = color.CGColor;
    border.frame = CGRectMake(10, 0, self.frame.size.width, borderWidth);
    [border setMasksToBounds:YES];
    [border setCornerRadius:2.0];
    [self.layer addSublayer:border];
}

- (void)addBottomBorderWithColor:(UIColor *)color andWidth:(CGFloat)borderWidth {
    CALayer *border = [CALayer layer];
    
    border.backgroundColor = color.CGColor;
    border.frame = CGRectMake(0, self.frame.size.height - 1, self.frame.size.width, borderWidth);
    [border setMasksToBounds:YES];
    [border setCornerRadius:1.0];
    [self.layer addSublayer:border];
}

- (void)addLeftBorderWithColor:(UIColor *)color andWidth:(CGFloat)borderWidth {
    CALayer *border = [CALayer layer];
    
    border.backgroundColor = color.CGColor;
    border.frame = CGRectMake(0, 0, borderWidth, self.frame.size.height);
    [border setMasksToBounds:YES];
    [border setCornerRadius:1.0];
    [self.layer addSublayer:border];
}

- (void)addRightBorderWithColor:(UIColor *)color andWidth:(CGFloat)borderWidth {
    CALayer *border = [CALayer layer];
    
    border.backgroundColor = color.CGColor;
    border.frame = CGRectMake(self.frame.size.width - borderWidth, 0, borderWidth, self.frame.size.height);
    [border setMasksToBounds:YES];
    [border setCornerRadius:1.0];
    [self.layer addSublayer:border];
}

- (void)addBorderWithColor:(UIColor *)color andWidth:(CGFloat)borderWidth {
    self.layer.borderColor = color.CGColor;
    self.layer.borderWidth = borderWidth;
}

- (void)addContainerCellBottomBorderWithColor:(UIColor *)color andWidth:(CGFloat)borderWidth {
    CALayer *border = [CALayer layer];
    
    border.backgroundColor = color.CGColor;
    border.frame = CGRectMake(0.5, self.frame.size.height - (borderWidth + 1), self.frame.size.width - 1.2, borderWidth);
    [border setMasksToBounds:YES];
    [border setCornerRadius:1.0];
    [self.layer addSublayer:border];
}

- (void)removeAllSubviews {
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
}

- (id)getSuperViewOfClass:(Class)class {
    id view = self.superview;
    
    while (view && [view isKindOfClass:[class class]] == NO)
        view = [view superview];
    
    return view;
}

@end
