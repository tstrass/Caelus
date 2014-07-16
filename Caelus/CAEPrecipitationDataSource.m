//
//  CAEPrecipitationDataSource.m
//  Caelus
//
//  Created by Thomas Strassner on 7/16/14.
//  Copyright (c) 2014 Enterprise Holdings, Inc. All rights reserved.
//

#import "CAEPrecipitationDataSource.h"

@interface CAEPrecipitationDataSource ()
@property (nonatomic) PrecipType precipType;
@property (strong, nonatomic) NSNumber *probability;
@end

@implementation CAEPrecipitationDataSource
- (instancetype)initWithPrecipType:(PrecipType)precipType Probability:(NSNumber *)probability {
    self = [super init];
    if (self) {
        self.precipType = precipType;
        self.probability = probability;
    }
    return self;
}

- (UIImage *)valueImage {
    return [UIImage imageNamed:@"rain"];
}

-(UIImage *)nonValueImage {
    return [UIImage imageNamed:@"rain-border"];
}
@end
