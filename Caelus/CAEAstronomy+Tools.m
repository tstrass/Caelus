//
//  CAEAstronomy+Tools.m
//  Caelus
//
//  Created by Tom on 7/30/14.
//  Copyright (c) 2014 Enterprise Holdings, Inc. All rights reserved.
//

#import "CAEAstronomy+Tools.h"

@implementation CAEAstronomy (Tools)
static const float MIN_GREEN = 0.276;
static const float MIN_BLUE = 0.435;
static const float MAX_GREEN = 0.635;
static const float MAX_BLUE = 1.000;

- (UIColor *)backgroundColorFromWeatherHour:(CAEWeatherHour *)weatherHour hourPercentage:(CGFloat)hourPercentage {
	CGFloat currentMinuteTime = [weatherHour.hour floatValue] * 60.0 + (hourPercentage * 60.0);
    CAESunPhase *sunPhase = self.sunPhase;

	if (currentMinuteTime < sunPhase.sunriseStartMinuteTime || currentMinuteTime >= sunPhase.nightStartMinuteTime) {
        // night
        return [UIColor colorWithRed:0.000 green:MIN_GREEN blue:MIN_BLUE alpha:1.000];
    } else if (currentMinuteTime >= sunPhase.dayStartMinuteTime && currentMinuteTime < sunPhase.sunsetStartMinuteTime) {
        // day
        return [UIColor colorWithRed:0.000 green:MAX_GREEN blue:MAX_BLUE alpha:1.000];
    } else if (currentMinuteTime < sunPhase.dayStartMinuteTime) {
        // sunrise
        CGFloat sunriseGreenRange = MAX_GREEN - MIN_GREEN;
        CGFloat sunriseBlueRange = MAX_BLUE - MIN_BLUE;
        CGFloat timeRange = sunPhase.dayStartMinuteTime - sunPhase.sunriseStartMinuteTime;
        CGFloat greenValue = (currentMinuteTime - sunPhase.sunriseStartMinuteTime) / timeRange * sunriseGreenRange + MIN_GREEN;
        CGFloat blueValue = (currentMinuteTime - sunPhase.sunriseStartMinuteTime) * sunriseBlueRange / timeRange + MIN_BLUE;
        return [UIColor colorWithRed:0.000 green:greenValue blue:blueValue alpha:1.000];
    } else {
        // sunset
        CGFloat sunsetGreenRange = MAX_GREEN - MIN_GREEN;
        CGFloat sunsetBlueRange = MAX_BLUE - MIN_BLUE;
        CGFloat timeRange = sunPhase.nightStartMinuteTime - sunPhase.sunsetStartMinuteTime;
        CGFloat newTime = sunPhase.nightStartMinuteTime - (currentMinuteTime - sunPhase.sunsetStartMinuteTime);
        CGFloat greenValue = (newTime - sunPhase.sunsetStartMinuteTime) * sunsetGreenRange / timeRange + MIN_GREEN;
        CGFloat blueValue = (newTime - sunPhase.sunsetStartMinuteTime) * sunsetBlueRange / timeRange + MIN_BLUE;
        return [UIColor colorWithRed:0.000 green:greenValue blue:blueValue alpha:1.000];
    }
}

@end
