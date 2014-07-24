//
//  CAEPrecipitationDataSource.m
//  Caelus
//
//  Created by Thomas Strassner on 7/16/14.
//  Copyright (c) 2014 Enterprise Holdings, Inc. All rights reserved.
//

#import "CAEPrecipitationDelegate.h"

@interface CAEPrecipitationDelegate ()
@end

@implementation CAEPrecipitationDelegate
static const int MAX_METER_VALUE = 5;

- (instancetype)initWithPrecipType:(PrecipType)precipType Probability:(NSNumber *)probability {
    self = [super init];
    if (self) {
        self.precipType = precipType;
        self.probability = probability;
    }
    return self;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (NSInteger)maxValueForDiscreteMeterView:(CAEDiscreteMeterView *)discreteMeterView {
    return MAX_METER_VALUE;
}

- (NSInteger)valueForDiscreteMeterView:(CAEDiscreteMeterView *)discreteMeterView {
    // 101 so that if there's 100% chance of rain you still get MAX_METER_VALUE as opposed to MAX_METER_VALUE + 1
    return (NSInteger) floor([self.probability floatValue] / (101.0 / (MAX_METER_VALUE + 1.0)));
}

- (UIImage *)valueImage {
    return self.precipType == SNOW ? [UIImage imageNamed:@"snow"] : [UIImage imageNamed:@"rain"];
}

-(UIImage *)nonValueImage {
    return self.precipType == SNOW ? [UIImage imageNamed:@"snow-border"] : [UIImage imageNamed:@"rain-border"];
}
@end
