//
//  CAEAstronomy.m
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

@property (nonatomic) NSNumber *currentHour;
@property (nonatomic) NSNumber *currentMinute;

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

- (id)initWithAstronomyDict:(NSDictionary *)astronomyDict {
	self = [super init];
	if (self) {
		[self updateCurrentMinuteTime];
		[self parseAstronomyDict:astronomyDict];
		[self calcLightPeriodIntervals];
		[self calcCurrentLightPeriod];
	}
	return self;
}

- (void)parseAstronomyDict:(NSDictionary *)astronomyDict {
	NSDictionary *sunPhaseDict = [astronomyDict objectForKey:@"sun_phase"];
	NSDictionary *moonPhaseDict = [astronomyDict objectForKey:@"moon_phase"];
	NSDictionary *currentTimeDict = [astronomyDict objectForKey:@"current_time"];

	self.sunPhase = sunPhaseDict ? [[CAESunPhase alloc] initWithSunPhaseDict:sunPhaseDict] : nil;
	self.moonPhase = moonPhaseDict ? [[CAEMoonPhase alloc] initWithMoonDict:moonPhaseDict] : nil;

	self.currentHour = [NSNumber numberWithInteger:[[currentTimeDict objectForKey:@"hour"] integerValue]];
	self.currentMinute = [NSNumber numberWithInteger:[[currentTimeDict objectForKey:@"minute"] integerValue]];
}

- (void)calcLightPeriodIntervals {
	self.sunriseMinuteTime = [self minuteTimeFromHour:[self.sunPhase.sunriseHour integerValue]
	                                           minute:[self.sunPhase.sunriseMinute integerValue]];
	self.sunsetMinuteTime = [self minuteTimeFromHour:[self.sunPhase.sunsetHour integerValue]
	                                          minute:[self.sunPhase.sunsetMinute integerValue]];
	self.dawnMinuteTime = self.sunriseMinuteTime - DAWN_DURATION;
	self.dayMinuteTime = self.sunriseMinuteTime + SUNRISE_DURATION;
	self.sunsetMinuteTime = self.sunsetMinuteTime - SUNSET_DURATION;
	self.duskMinuteTime = self.sunsetMinuteTime + SUNSET_DURATION;
	self.nightMinuteTime = self.duskMinuteTime + DUSK_DURATION;
}

// TODO: put this method in a different class as a class method
- (NSInteger)minuteTimeFromHour:(NSInteger)hour minute:(NSInteger)minute {
	return hour * 60 + minute;
}

- (void)updateCurrentMinuteTime {
	self.currentMinuteTime = [self minuteTimeFromHour:[self.currentHour integerValue]
	                                           minute:[self.currentMinute integerValue]];
}

- (void)calcCurrentLightPeriod {
	if (self.currentMinuteTime < self.dawnMinuteTime || self.currentMinuteTime > (self.duskMinuteTime + DUSK_DURATION)) {
		self.lightPeriod = NIGHT;
	}
	else if (self.currentMinuteTime < self.sunriseMinuteTime) {
		self.lightPeriod = DAWN;
	}
	else if (self.currentMinuteTime < self.dayMinuteTime) {
		self.lightPeriod = SUNRISE;
	}
	else if (self.currentMinuteTime < self.sunsetMinuteTime) {
		self.lightPeriod = DAY;
	}
	else if (self.currentMinuteTime < self.duskMinuteTime) {
		self.lightPeriod = SUNSET;
	}
	else if (self.currentMinuteTime < self.nightMinuteTime) {
		self.lightPeriod = DUSK;
	}
	else {
		NSLog(@"Error: could not determine proper light period in CLAstronomy");
	}
}

@end
