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
    if (hourDict) {
        NSDictionary *timeDict = [hourDict objectForKey:@"FCTTIME"];
        NSDictionary *tempDict = [hourDict objectForKey:@"temp"];
        
        [self setHour:[[timeDict objectForKey:@"hour"] integerValue]];
        [self setWeekdayNameAbbrev:[timeDict objectForKey:@"weekday_name_abbrev"]];
        [self setTemp:[[tempDict objectForKey:@"english"] integerValue]];
        [self setCondition:[hourDict objectForKey:@"condition"]];
        [self setCloudCover:[[hourDict objectForKey:@"sky"] integerValue]];
    }
}

@end
