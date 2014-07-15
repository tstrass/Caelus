//
//  CAECloudsView.m
//  Caelus
//
//  Created by Thomas Strassner on 7/11/14.
//  Copyright (c) 2014 Enterprise Holdings, Inc. All rights reserved.
//
#import "CAECloudsDataSource.h"
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

#import "UIImageView+Tools.h"

@interface CAECloudsDataSource ()
@property (strong, nonatomic) NSNumber *probabilityOfPrecipitation;
@end

@implementation CAECloudsDataSource

- (instancetype)initWithChanceOfPrecipitation:(NSNumber *)probabilityOfPrecipitation {
    self = [super init];
    if (self) {
        self.probabilityOfPrecipitation = probabilityOfPrecipitation;
    }
    return self;
}

- (UIImage *)nonValueImage {
    if (self.probabilityOfPrecipitation != nil) {
        NSNumber *cloudShade = [CAECloudsDataSource cloudShadeWithProbabilityOfPrecipitation:self.probabilityOfPrecipitation];
        NSString *imageName = [CAECloudsDataSource cloudImageNameWithFilledIn:NO CloudShade:cloudShade];
        return [UIImage imageNamed:imageName];
    }
    return [UIImage imageNamed:@"cloud-border"];
}

- (UIImage *)valueImage {
    if (self.probabilityOfPrecipitation != nil) {
        NSNumber *cloudShade = [CAECloudsDataSource cloudShadeWithProbabilityOfPrecipitation:self.probabilityOfPrecipitation];
        NSString *imageName = [CAECloudsDataSource cloudImageNameWithFilledIn:YES CloudShade:cloudShade];
        return [UIImage imageNamed:imageName];
    }
    return [UIImage imageNamed:@"cloud"];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Determining of image
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

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
@end
