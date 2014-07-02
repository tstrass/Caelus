//
//  CLWeatherHour.m
//  Caelus
//
//  Created by Tom on 7/2/14.
//  Copyright (c) 2014 Enterprise Holdings, Inc. All rights reserved.
//

#import "CLWeatherHour.h"

@implementation CLWeatherHour
- (id)initWithHourDict:(NSDictionary *)hourDict {
	self = [super init];
	if (self) {
		[self parseHourDict:hourDict];
	}
	return self;
}

- (void)parseHourDict:(NSDictionary *)hourDict {
	NSDictionary *timeDict = [hourDict objectForKey:@"FCTTIME"];
	NSDictionary *tempDict = [hourDict objectForKey:@"temp"];

	[self setHour:[[timeDict objectForKey:@"hour"] intValue]];
	[self setWeekdayNameAbbrev:[timeDict objectForKey:@"weekday_name_abbrev"]];
	[self setTemp:[[tempDict objectForKey:@"english"] intValue]];
	[self setCondition:[hourDict objectForKey:@"condition"]];
	[self setCloudCover:[[hourDict objectForKey:@"sky"] intValue]];

	NSLog(@"Hour parsed: %ld", (long)self.hour);
}

@end
