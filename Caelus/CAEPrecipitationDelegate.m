//
//  CAEPrecipitationDataSource.m
//  Caelus
//
//  Created by Thomas Strassner on 7/16/14.
//  Copyright (c) 2014 Enterprise Holdings, Inc. All rights reserved.
//

#import "CAEPrecipitationDelegate.h"

@interface CAEPrecipitationDelegate ()
@property (nonatomic) PrecipType precipType;
@property (strong, nonatomic) NSNumber *probability;
@end

@implementation CAEPrecipitationDelegate
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
    return 5;
}

- (NSInteger)valueForDiscreteMeterView:(CAEDiscreteMeterView *)discreteMeterView {
    return (NSInteger) floor([self.probability floatValue] / (101.0 / 6.0));
}

- (UIImage *)valueImage {
    // TODO: change first option to snow once you have the image
    return self.precipType == SNOW ? [UIImage imageNamed:@"rain"] : [UIImage imageNamed:@"rain"];
}

-(UIImage *)nonValueImage {
    // TODO: change first option to snow-border once you have the image
    return self.precipType == SNOW ? [UIImage imageNamed:@"rain-border"] : [UIImage imageNamed:@"rain-border"];
}
@end
