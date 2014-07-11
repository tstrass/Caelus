//
//  CAECloudsView.m
//  Caelus
//
//  Created by Thomas Strassner on 7/11/14.
//  Copyright (c) 2014 Enterprise Holdings, Inc. All rights reserved.
//
#import "CAECloudsView.h"
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

#import "UIImageView+Tools.h"

#define CLOUD_H_PADDING 2        // space between clouds
#define CLOUD_V_PADDING 5        // space between top/bottom of clouds and top/bottom of view

@implementation CAECloudsView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void)reload {
    // nothing to load if there's no delegate
    if (self.delegate == nil) return;
    
    [self.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [obj removeFromSuperview];
    }];
    
    NSInteger maxClouds = [self.delegate maxNumberOfCloudsForCloudView:self];
    CGFloat cloudWidth = ([[UIScreen mainScreen] bounds].size.width - ((maxClouds + 1) * CLOUD_H_PADDING)) / maxClouds;
    
    CGFloat xValue = 0;
    for (int i = 0; i < [self.delegate numberOfCloudsForCloudView:self]; i++) {
        UIImageView *cloudImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cloud"]];
        xValue += CLOUD_H_PADDING;
        cloudImageView.frame = CGRectMake(xValue, CLOUD_V_PADDING, cloudWidth, [cloudImageView heightForWidth:cloudWidth]);
        [self addSubview:cloudImageView];
        xValue += cloudWidth + CLOUD_H_PADDING;
    }
}

@end
