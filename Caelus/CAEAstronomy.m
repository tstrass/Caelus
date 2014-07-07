//
//  CLAstronomy.m
//  Caelus
//
//  Created by Thomas Strassner on 7/1/14.
//  Copyright (c) 2014 Enterprise Holdings, Inc. All rights reserved.
//

#import "CAEAstronomy.h"

@interface CAEAstronomy ()
// all these times mark the start of the named lightPeriod
// assumes dawn starts after midnight and dusk ends before midnight
@property (nonatomic) NSInteger dawnMinuteTime;
@property (nonatomic) NSInteger sunriseMinuteTime;
@property (nonatomic) NSInteger dayMinuteTime;
@property (nonatomic) NSInteger sunsetMinuteTime;
@property (nonatomic) NSInteger duskMinuteTime;
@property (nonatomic) NSInteger nightMinuteTime;

@property (nonatomic) NSInteger currentMinuteTime;
@property (nonatomic, readwrite) LightPeriod lightPeriod;
@end

@implementation CAEAstronomy

const unsigned long DAWN_DURATION = 30;
const unsigned long DUSK_DURATION = 30;
const unsigned long SUNRISE_DURATION = 30;
const unsigned long SUNSET_DURATION = 30;

- (id)init {
	self = [super init];
	if (self) {
		[self updateCurrentMinuteTime];
	}
	return self;
}

- (id)initWithSunriseHour:(NSNumber *)riseHour
            SunriseMinute:(NSNumber *)riseMinute
               SunsetHour:(NSNumber *)setHour
             SunsetMinute:(NSNumber *)setMinute {
	self = [super init];
	if (self) {
		[self updateCurrentMinuteTime];
		[self setSunriseHour:riseHour];
		[self setSunriseMinute:riseMinute];
		[self setSunsetHour:setHour];
		[self setSunsetMinute:setMinute];

		[self calcLightPeriodIntervals];
		[self calcCurrentLightPeriod];
	}
	return self;
}

- (void)calcLightPeriodIntervals {
	[self setSunriseMinuteTime:[self minuteTimeFromHour:[self.sunriseHour intValue]
	                                             Minute:[self.sunriseMinute intValue]]];
	[self setSunsetMinuteTime:[self minuteTimeFromHour:[self.sunsetHour intValue]
	                                            Minute:[self.sunsetMinute intValue]]];
	[self setDawnMinuteTime:self.sunriseMinuteTime - DAWN_DURATION];
	[self setDayMinuteTime:self.sunriseMinuteTime + SUNRISE_DURATION];
	[self setSunsetMinuteTime:self.sunsetMinuteTime - SUNSET_DURATION];
	[self setDuskMinuteTime:self.sunsetMinuteTime + SUNSET_DURATION];
	[self setNightMinuteTime:self.duskMinuteTime + DUSK_DURATION];
}

- (NSInteger)minuteTimeFromHour:(NSInteger)hour Minute:(NSInteger)minute {
	return hour * 60 + minute;
}

- (void)updateCurrentMinuteTime {
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"HH"];
	NSInteger hour = [[dateFormatter stringFromDate:[NSDate date]] intValue];

	[dateFormatter setDateFormat:@"mm"];
	NSInteger minute = [[dateFormatter stringFromDate:[NSDate date]] intValue];

	[self setCurrentMinuteTime:[self minuteTimeFromHour:hour Minute:minute]];
}

- (void)calcCurrentLightPeriod {
	if (self.currentMinuteTime < self.dawnMinuteTime || self.currentMinuteTime > (self.duskMinuteTime + DUSK_DURATION)) {
		[self setLightPeriod:NIGHT];
	}
	else if (self.currentMinuteTime < self.sunriseMinuteTime) {
		[self setLightPeriod:DAWN];
	}
	else if (self.currentMinuteTime < self.dayMinuteTime) {
		[self setLightPeriod:SUNRISE];
	}
	else if (self.currentMinuteTime < self.sunsetMinuteTime) {
		[self setLightPeriod:DAY];
	}
	else if (self.currentMinuteTime < self.duskMinuteTime) {
		[self setLightPeriod:SUNSET];
	}
	else if (self.currentMinuteTime < self.nightMinuteTime) {
		[self setLightPeriod:DUSK];
	}
	else {
		NSLog(@"Error: could not determine proper light period in CLAstronomy");
	}
}

@end
