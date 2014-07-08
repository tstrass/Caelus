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

    self.sunriseHour = [sunriseDict objectForKey:@"hour"];
    self.sunriseMinute = [sunriseDict objectForKey:@"minute"];

    self.sunsetHour = [sunsetDict objectForKey:@"hour"];
    self.sunsetMinute = [sunsetDict objectForKey:@"minute"];
}

@end
