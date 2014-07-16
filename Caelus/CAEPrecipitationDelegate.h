//
//  CAEPrecipitationDataSource.h
//  Caelus
//
//  Created by Thomas Strassner on 7/16/14.
//  Copyright (c) 2014 Enterprise Holdings, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CAEDiscreteMeterView.h"

typedef NS_ENUM(NSInteger, PrecipType) {
    RAIN,
    SNOW
};

@interface CAEPrecipitationDelegate : NSObject <CAEDiscreteMeterViewDelegate, CAEDiscreteMeterViewDataSource>
- (instancetype)initWithPrecipType:(PrecipType)precipType Probability:(NSNumber *)probability;
@end
