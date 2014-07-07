//
//  CLAstronomy.h
//  Caelus
//
//  Created by Thomas Strassner on 7/1/14.
//  Copyright (c) 2014 Enterprise Holdings, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CAESunPhase.h"

typedef NS_ENUM (NSInteger, LightPeriod) {
	DAWN, SUNRISE, DAY, SUNSET, DUSK, NIGHT
};

@interface CAEAstronomy : NSObject
// always use this custom initializer
- (id)initWithAstronomyDict:(NSDictionary *)astronomyDict;

@property (strong, nonatomic)CAESunPhase *sunPhase;

// current time
@property (nonatomic, readonly) LightPeriod lightPeriod;
@end
