//
//  CAESunPhase.m
//  Caelus
//
//  Created by Tom on 7/7/14.
//  Copyright (c) 2014 Enterprise Holdings, Inc. All rights reserved.
//

#import "CAESunPhase.h"

@implementation CAESunPhase
- (id)initWithSunPhaseDict:(NSDictionary *)sunPhaseDict {
	self = [super init];
	if (self) {
		[self parseSunPhaseDict:sunPhaseDict];
	}
	return self;
}

/**
 *  Parses information we are interested in about the sun phase. Using this information, this sets the corresponding
 *  public properties of the object.
 *
 *  @param sunPhaseDict is a dictionary containing information about the sun phase. This dictionary is parsed out of the
 *                      response data from the weather underground API astronomy feature
 */
- (void)parseSunPhaseDict:(NSDictionary *)sunPhaseDict {
	NSDictionary *sunriseDict = [sunPhaseDict objectForKey:@"sunrise"];
	NSDictionary *sunsetDict = [sunPhaseDict objectForKey:@"sunset"];

	// Note: all the following values are strings in the JSON response

	self.sunriseHour = [NSNumber numberWithInteger:[[sunriseDict objectForKey:@"hour"] integerValue]];
	self.sunriseMinute = [NSNumber numberWithInteger:[[sunriseDict objectForKey:@"minute"] integerValue]];

	self.sunsetHour = [NSNumber numberWithInteger:[[sunsetDict objectForKey:@"hour"] integerValue]];
	self.sunsetMinute = [NSNumber numberWithInteger:[[sunsetDict objectForKey:@"minute"] integerValue]];
}

@end
