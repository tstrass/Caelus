//
//  CAECurrentConditions.m
//  Caelus
//
//  Created by Tom on 7/7/14.
//  Copyright (c) 2014 Enterprise Holdings, Inc. All rights reserved.
//

#import "CAECurrentConditions.h"

@implementation CAECurrentConditions

- (id)initWithConditionsDict:(NSDictionary *)dict {
	self = [super init];
	if (self) {
		[self parseConditionsDict:dict];
	}
	return self;
}

/**
 *  Parse the conditions dictionary from weather underground API for information we are interested in. Set the
 *  corresponding public properties. Send the contained location dictionary to the CAELocationData object.
 *
 *  @param dict needs to be the response from weather underground API conditions feature.
 */
- (void)parseConditionsDict:(NSDictionary *)conditionsDict {
    if (conditionsDict) {
        NSDictionary *currentObservation = [conditionsDict objectForKey:@"current_observation"];
        NSDictionary *displayLocation = [currentObservation objectForKey:@"display_location"];
        
        self.location = [[CAELocationData alloc] initWithLocationDict:displayLocation];
        
        [self setFTemp:[currentObservation objectForKey:@"temp_f"]];
        [self setCTemp:[currentObservation objectForKey:@"temp_c"]];
        
        [self setWindSpeedMPH:[currentObservation objectForKey:@"wind_mph"]];
        [self setWindSpeedKPH:[currentObservation objectForKey:@"wind_kph"]];
        [self setWindDir:[currentObservation objectForKey:@"wind_dir"]];
        [self setWindDescription:[currentObservation objectForKey:@"wind_string"]];
        
        [self setPrecipHourIn:[currentObservation objectForKey:@"precip_1hr_in"]];
        [self setPrecipHourMM:[currentObservation objectForKey:@"precip_1hr_metric"]];
    }
}

@end
