//
//  CAEWeatherHour.m
//  Caelus
//
//  Created by Tom on 7/2/14.
//  Copyright (c) 2014 Enterprise Holdings, Inc. All rights reserved.
//
#import "CAEWeatherHour.h"
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

@implementation CAEWeatherHour

- (id)initWithHourDict:(NSDictionary *)hourDict {
	self = [super init];
	if (self) {
		[self parseHourDict:hourDict];
	}
	return self;
}

/**
 *  Parses information we are interested in about hourly weather. Using this information, this sets the corresponding
 *  public properties of the object.
 *
 *  @param hourDict is a dictionary containing information about a single hour of weather. This dictionary is parsed
 *                  out of the response data from the weather underground API hourly weather feature
 */
- (void)parseHourDict:(NSDictionary *)hourDict {
	NSDictionary *timeDict = [hourDict objectForKey:@"FCTTIME"];
	NSDictionary *tempDict = [hourDict objectForKey:@"temp"];
	NSDictionary *windSpeedDict = [hourDict objectForKey:@"wspd"];
	NSDictionary *windDirectionDict = [hourDict objectForKey:@"wdir"];
	NSDictionary *precipQuantityDict = [hourDict objectForKey:@"qpf"];
	NSDictionary *snowDict = [hourDict objectForKey:@"snow"];

	// Note: all of the following values are strings in the JSON response

	self.hour = [NSNumber numberWithInteger:[[timeDict objectForKey:@"hour"] integerValue]];
	self.weekdayNameAbbrev = [timeDict objectForKey:@"weekday_name_abbrev"];

	self.fTemp = [NSNumber numberWithInteger:[[tempDict objectForKey:@"english"] integerValue]];
	self.cTemp = [NSNumber numberWithInteger:[[tempDict objectForKey:@"metric"] integerValue]];

	self.windSpeedMPH = [NSNumber numberWithInteger:[[windSpeedDict objectForKey:@"english"] integerValue]];
	self.windSpeedKPH = [NSNumber numberWithInteger:[[windSpeedDict objectForKey:@"metric"] integerValue]];
	self.windDir = [windDirectionDict objectForKey:@"dir"];

	self.probabilityOfPrecipitation = [NSNumber numberWithInteger:[[hourDict objectForKey:@"pop"] integerValue]];
	self.precipIn = [NSNumber numberWithInteger:[[precipQuantityDict objectForKey:@"english"] floatValue]];
	self.precipMM = [NSNumber numberWithInteger:[[precipQuantityDict objectForKey:@"metric"] floatValue]];
	self.snowIn = [NSNumber numberWithInteger:[[snowDict objectForKey:@"english"] floatValue]];
	self.snowMM = [NSNumber numberWithInteger:[[snowDict objectForKey:@"metric"] floatValue]];

	self.condition = [hourDict objectForKey:@"condition"];
	self.cloudCover = [NSNumber numberWithInteger:[[hourDict objectForKey:@"sky"] integerValue]];
    
    self.iconName = [hourDict objectForKey:@"icon"];
}

@end
