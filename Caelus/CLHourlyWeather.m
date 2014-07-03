//
//  CLHourlyWeather.m
//  Caelus
//
//  Created by Tom on 7/2/14.
//  Copyright (c) 2014 Enterprise Holdings, Inc. All rights reserved.
//
#import "CLHourlyWeather.h"
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

@implementation CLHourlyWeather

- (id)initWithJSONDict:(NSDictionary *)dict {
	self = [super init];
	if (self) {
		[self parseJSONDict:dict];
	}
	return self;
}

/**
 *  Parse the array of weather hour dictionaries out of the response dictionary, send each hour to CLWeatherHour and
 *  create the array.
 *
 *  @param dict needs to be the response from weather underground API hourly feature
 */
- (void)parseJSONDict:(NSDictionary *)dict {
	NSDictionary *hourlyForecastDict = [dict objectForKey:@"hourly_forecast"];
    
	if (hourlyForecastDict) {
		NSMutableArray *weatherHours = [[NSMutableArray alloc] init];
        // send each weather hour dictionary to CLWeatherHour for parsing, then add it to the array
		for (NSDictionary *hourDict in hourlyForecastDict) {
			CLWeatherHour *weatherHour = [[CLWeatherHour alloc] initWithHourDict:hourDict];
			[weatherHours addObject:weatherHour];
		}
		self.weatherHours = [[NSArray alloc] initWithArray:weatherHours];
	}
}

@end