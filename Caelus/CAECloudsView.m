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
    //NSLog(@"Maximum number of clouds: %lu", (long)maxClouds);
    NSInteger numClouds = [self.delegate numberOfCloudsForCloudView:self];
    //NSLog(@"Number of clouds to display: %lu", (long)numClouds);
    NSNumber *cloudShade = nil;
    if ([self.delegate respondsToSelector:@selector(percentageRainChance)]) cloudShade = [self calculateCloudShade];
    
    CGFloat cloudWidth = (self.frame.size.width - ((((maxClouds + 1) * 2) - 2) * CLOUD_H_PADDING)) / maxClouds;
    CGFloat xValue = 0;
    
    for (int i = 0; i < maxClouds; i++) {
        // Use cloud border image if we already have enough clouds to represent % cloudiness
        NSString *imageName = [self imageNameWithFilledIn:(i < numClouds) CloudShade:cloudShade];
        NSLog(@"Using cloud image: %@", imageName);
        UIImageView *cloudImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
        xValue += CLOUD_H_PADDING;
        cloudImageView.frame = CGRectMake(xValue, CLOUD_V_PADDING, cloudWidth, [cloudImageView heightForWidth:cloudWidth]);
        [self addSubview:cloudImageView];
        xValue += cloudWidth + CLOUD_H_PADDING;
    }
}

- (NSString *)imageNameWithFilledIn:(BOOL)filledIn CloudShade:(NSNumber *)cloudShade {
    // Only consider cloud shade if we have that information
    return cloudShade ? [self cloudImageNameWithFilledIn:filledIn CloudShade:cloudShade] : [self cloudImageNameWithFilledIn:filledIn];
}

- (NSNumber *)calculateCloudShade {
    NSInteger cloudShadeInteger = (NSInteger) floor([[self.delegate percentageRainChance] floatValue] / (101.0 / 6.0));
    return [NSNumber numberWithInteger:cloudShadeInteger];
}

- (NSString *)cloudImageNameWithFilledIn:(BOOL)filledIn CloudShade:(NSNumber *)cloudShade {
    if (filledIn) {
        switch ([cloudShade integerValue]) {
            case 0:
                return @"cloud-rain0";
            case 1:
                return @"cloud-rain1";
            case 2:
                return @"cloud-rain2";
            case 3:
                return @"cloud-rain3";
            case 4:
                return @"cloud-rain4";
            case 5:
                return @"cloud-rain5";
            default:
                NSLog(@"Error when determining cloud shade. Reason: invalid cloud shade value");
                return nil;
        }
    } else {
        switch ([cloudShade integerValue]) {
            case 0:
                return @"cloud-border-rain0";
            case 1:
                return @"cloud-border-rain1";
            case 2:
                return @"cloud-border-rain2";
            case 3:
                return @"cloud-border-rain3";
            case 4:
                return @"cloud-border-rain4";
            case 5:
                return @"cloud-border-rain5";
            default:
                NSLog(@"Error when determining cloud shade. Reason: invalid cloud shade value");
                return nil;
        }
    }
}

- (NSString *)cloudImageNameWithFilledIn:(BOOL)filledIn {
    if (filledIn) {
        return @"cloud";
    }
    return @"cloud-border";
}
@end
