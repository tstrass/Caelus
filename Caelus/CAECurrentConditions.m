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
	NSDictionary *currentObservation = [conditionsDict objectForKey:@"current_observation"];
	NSDictionary *displayLocation = [currentObservation objectForKey:@"display_location"];

	self.location = displayLocation ? [[CAELocationData alloc] initWithLocationDict:displayLocation] : nil;

	self.fTemp = [currentObservation objectForKey:@"temp_f"];
	self.cTemp = [currentObservation objectForKey:@"temp_c"];

	self.windSpeedMPH = [currentObservation objectForKey:@"wind_mph"];
	self.windSpeedKPH = [currentObservation objectForKey:@"wind_kph"];
	self.windDir = [currentObservation objectForKey:@"wind_dir"];
	self.windDescription = [currentObservation objectForKey:@"wind_string"];

	// Note: these values are strings in the JSON response
	self.precipIn = [NSNumber numberWithFloat:[[currentObservation objectForKey:@"precip_1hr_in"] floatValue]];
	self.precipMM = [NSNumber numberWithFloat:[[currentObservation objectForKey:@"precip_1hr_metric"] floatValue]];
}

@end
