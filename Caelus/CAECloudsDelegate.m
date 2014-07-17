//
//  CAECloudsDelegate.m
//  Caelus
//
//  Created by Thomas Strassner on 7/11/14.
//  Copyright (c) 2014 Enterprise Holdings, Inc. All rights reserved.
//
#import "CAECloudsDelegate.h"
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

#import "UIImageView+Tools.h"

@interface CAECloudsDelegate ()
@property (strong, nonatomic) NSNumber *percentCloudy;
@property (strong, nonatomic) NSNumber *probabilityOfPrecipitation;
@end

@implementation CAECloudsDelegate
const int MAX_METER_VALUE = 5;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Custom Initializers
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (instancetype)initWithPercentCloudy:(NSNumber *)percentCloudy ChanceOfPrecipitation:(NSNumber *)probabilityOfPrecipitation {
    self = [super init];
    if (self) {
        self.percentCloudy = percentCloudy;
        self.probabilityOfPrecipitation = probabilityOfPrecipitation;
    }
    return self;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - CAEDiscreteMeterView Delegate Methods
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (NSInteger)maxValueForDiscreteMeterView:(CAEDiscreteMeterView *)discreteMeterView {
    return MAX_METER_VALUE;
}

- (NSInteger)valueForDiscreteMeterView:(CAEDiscreteMeterView *)discreteMeterView {
   return (NSInteger) floor([self.percentCloudy floatValue] / (101.0 / (MAX_METER_VALUE + 1)));
}


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - CAEDiscreteMeterView Data Source Methods
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


- (UIImage *)nonValueImage {
    if (self.probabilityOfPrecipitation != nil) {
        NSNumber *cloudShade = [CAECloudsDelegate cloudShadeWithProbabilityOfPrecipitation:self.probabilityOfPrecipitation];
        NSString *imageName = [CAECloudsDelegate cloudImageNameWithFilledIn:NO CloudShade:cloudShade];
        return [UIImage imageNamed:imageName];
    }
    return [UIImage imageNamed:@"cloud-border"];
}

- (UIImage *)valueImage {
    if (self.probabilityOfPrecipitation != nil) {
        NSNumber *cloudShade = [CAECloudsDelegate cloudShadeWithProbabilityOfPrecipitation:self.probabilityOfPrecipitation];
        NSString *imageName = [CAECloudsDelegate cloudImageNameWithFilledIn:YES CloudShade:cloudShade];
        return [UIImage imageNamed:imageName];
    }
    return [UIImage imageNamed:@"cloud"];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Methods for determining image
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
