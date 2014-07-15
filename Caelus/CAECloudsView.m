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

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - class methods
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

+ (NSString *)imageNameWithFilledIn:(BOOL)filledIn CloudShade:(NSNumber *)cloudShade {
    // Only consider cloud shade if we have that information
    return cloudShade ? [self cloudImageNameWithFilledIn:filledIn CloudShade:cloudShade] : [self cloudImageNameWithFilledIn:filledIn];
}

+ (NSNumber *)cloudShadeWithProbabilityOfPrecipitation:(NSNumber *)probabilityOfPrecipitation {
    NSInteger cloudShadeInteger = (NSInteger) floor([probabilityOfPrecipitation floatValue] / (101.0 / 6.0));
    return [NSNumber numberWithInteger:cloudShadeInteger];
}

+ (NSString *)cloudImageNameWithFilledIn:(BOOL)filledIn CloudShade:(NSNumber *)cloudShade {
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

+ (NSString *)cloudImageNameWithFilledIn:(BOOL)filledIn {
    if (filledIn) {
        return @"cloud";
    }
    return @"cloud-border";
}
@end
