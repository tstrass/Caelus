//
//  UIView+SizingTools.h
//  Caelus
//
//  Created by Tom on 8/7/14.
//  Copyright (c) 2014 Enterprise Holdings, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (SizingTools)

- (void)setY:(CGFloat)newY;

- (void)setX:(CGFloat)newX;

- (void)setOrigin:(CGPoint)origin;

- (void)setWidth:(CGFloat)newWidth;

- (void)setHeight:(CGFloat)newHeight;

- (void)roundTopCornersWithRadius:(float)radius;

- (void)roundBottomCornersWithRadius:(float)radius;

- (void)roundCornersWithRadius:(float)radius;

- (void)addTopBorderWithColor:(UIColor *)color andWidth:(CGFloat)borderWidth;

- (void)addBottomBorderWithColor:(UIColor *)color andWidth:(CGFloat)borderWidth;

- (void)addLeftBorderWithColor:(UIColor *)color andWidth:(CGFloat)borderWidth;

- (void)addRightBorderWithColor:(UIColor *)color andWidth:(CGFloat)borderWidth;

- (void)addBorderWithColor:(UIColor *)color andWidth:(CGFloat)borderWidth;

- (void)addContainerCellBottomBorderWithColor:(UIColor *)color andWidth:(CGFloat)borderWidth;

- (void)addIndentedTopBorderWithColor:(UIColor *)color andWidth:(CGFloat)borderWidth;

- (void)removeAllSubviews;

- (id)getSuperViewOfClass:(Class)class;

@end
