//
//  CLHourlyWeather.m
//  Caelus
//
//  Created by Tom on 7/2/14.
//  Copyright (c) 2014 Enterprise Holdings, Inc. All rights reserved.
//

#import "CLHourlyWeather.h"

@implementation CLHourlyWeather

const int NUM_HOURS = 36;

- (id)initWithJSONDict:(NSDictionary *)dict {
	self = [super init];
	if (self) {
		[self parseJSONDict:dict];
	}
	return self;
}

- (void)parseJSONDict:(NSDictionary *)dict {
	NSDictionary *hourlyForecastDict = [dict objectForKey:@"hourly_forecast"];
	//NSLog(@"hourly forecast: %@", hourlyForecastDict);
	if (hourlyForecastDict) {
		NSMutableArray *weatherHours = [[NSMutableArray alloc] init];
		for (NSDictionary *hourDict in hourlyForecastDict) {
			CLWeatherHour *weatherHour = [[CLWeatherHour alloc] initWithHourDict:hourDict];
			[weatherHours addObject:weatherHour];
		}
		self.weatherHours = [[NSArray alloc] initWithArray:weatherHours];
	}
}

@end
