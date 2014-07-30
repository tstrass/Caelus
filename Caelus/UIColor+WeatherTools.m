//
//  UIColor+WeatherTools.m
//  Caelus
//
//  Created by Tom on 7/30/14.
//  Copyright (c) 2014 Enterprise Holdings, Inc. All rights reserved.
//

#import "UIColor+WeatherTools.h"

@implementation UIColor (WeatherTools)
static const float DAWN_DURATION = 30.0;
static const float DUSK_DURATION = 30.0;
static const float SUNRISE_DURATION = 30.0;
static const float SUNSET_DURATION = 30.0;

+ (UIColor *)backgroundColorFromWeatherHour:(CAEWeatherHour *)weatherHour
                                  astronomy:(CAEAstronomy *)astronomy
                             hourPercentage:(CGFloat)hourPercentage {
	CGFloat currentMinuteTime = [weatherHour.hour floatValue] * 60.0 + (hourPercentage * 60.0);
	CGFloat sunriseMinuteTime = [astronomy.sunPhase.sunriseMinuteTime floatValue];
	CGFloat sunsetMinuteTime = [astronomy.sunPhase.sunsetMinuteTime floatValue];

	if (currentMinuteTime > (sunriseMinuteTime + SUNRISE_DURATION) && currentMinuteTime < (sunsetMinuteTime - SUNSET_DURATION)) {
		return [UIColor colorWithRed:0.000 green:0.000 blue:0.502 alpha:0.500];
	} else if (currentMinuteTime < (sunriseMinuteTime - DAWN_DURATION) || currentMinuteTime > (sunsetMinuteTime + DUSK_DURATION)) {
        return [UIColor colorWithRed:0.000 green:0.000 blue:0.502 alpha:1.000];
    }
    return [UIColor colorWithRed:0.000 green:0.000 blue:0.502 alpha:0.750];
}

@end
