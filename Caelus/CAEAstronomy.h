//
//  CLAstronomy.h
//  Caelus
//
//  Created by Thomas Strassner on 7/1/14.
//  Copyright (c) 2014 Enterprise Holdings, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM (NSInteger, LightPeriod) {
	DAWN, SUNRISE, DAY, SUNSET, DUSK, NIGHT
};

@interface CAEAstronomy : NSObject
// specifies which period of the day it is currently

// always use this custom initializer
- (id)initWithSunriseHour:(NSNumber *)riseHour
            SunriseMinute:(NSNumber *)riseMinute
               SunsetHour:(NSNumber *)setHour
             SunsetMinute:(NSNumber *)setMinute;

// sunrise
@property (strong, nonatomic) NSNumber *sunriseHour;
@property (strong, nonatomic) NSNumber *sunriseMinute;

// sunset
@property (strong, nonatomic) NSNumber *sunsetHour;
@property (strong, nonatomic) NSNumber *sunsetMinute;

// current time
@property (nonatomic, readonly) LightPeriod lightPeriod;
@end
