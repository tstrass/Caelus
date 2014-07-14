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
    
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    NSInteger maxClouds = [self.delegate maxNumberOfCloudsForCloudView:self];
    NSLog(@"Maximum number of clouds: %lu", (long)maxClouds);
    NSInteger numClouds = [self.delegate numberOfCloudsForCloudView:self];
    NSLog(@"Number of clouds to display: %lu", (long)numClouds);
    CGFloat cloudWidth = (self.frame.size.width - ((((maxClouds + 1) * 2) - 2) * CLOUD_H_PADDING)) / maxClouds;
    CGFloat xValue = 0;
    for (int i = 0; i < [self.delegate maxNumberOfCloudsForCloudView:self]; i++) {
        // Use cloud border image if we already have enough clouds to represent % cloudiness
        NSString *imageName = i < numClouds ? @"cloud" : @"cloud-border";
        UIImageView *cloudImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
        xValue += CLOUD_H_PADDING;
        cloudImageView.frame = CGRectMake(xValue, CLOUD_V_PADDING, cloudWidth, [cloudImageView heightForWidth:cloudWidth]);
        [self addSubview:cloudImageView];
        xValue += cloudWidth + CLOUD_H_PADDING;
    }
}

@end
