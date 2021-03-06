//
//  CAEHourlyWeather.m
//  Caelus
//
//  Created by Tom on 7/2/14.
//  Copyright (c) 2014 Enterprise Holdings, Inc. All rights reserved.
//
#import "CAEHourlyWeather.h"
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

@implementation CAEHourlyWeather

- (id)initWithHourlyDict:(NSDictionary *)hourlyDict {
	self = [super init];
	if (self) {
		[self parseHourlyDict:hourlyDict];
	}
	return self;
}

/**
 *  Parse the array of weather hour dictionaries out of the response dictionary, send each hour to CAEWeatherHour and
 *  create the array.
 *
 *  @param hourlyDict needs to be the response from weather underground API hourly feature
 */
- (void)parseHourlyDict:(NSDictionary *)hourlyDict {
    NSDictionary *hourlyForecastDict = [hourlyDict objectForKey:@"hourly_forecast"];
        
    if (hourlyForecastDict) {
        NSMutableArray *weatherHours = [[NSMutableArray alloc] initWithCapacity:hourlyForecastDict.count];
            
        // send each weather hour dictionary to CLWeatherHour for parsing, then add it to the array
        for (NSDictionary *hourDict in hourlyForecastDict) {
            CAEWeatherHour *weatherHour = [[CAEWeatherHour alloc] initWithHourDict:hourDict];
            [weatherHours addObject:weatherHour];
        }
        self.weatherHours = [[NSArray alloc] initWithArray:weatherHours];
    }
}

@end
