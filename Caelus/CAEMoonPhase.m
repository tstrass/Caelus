//
//  CAEMoonPhase.m
//  Caelus
//
//  Created by Tom on 7/7/14.
//  Copyright (c) 2014 Enterprise Holdings, Inc. All rights reserved.
//

#import "CAEMoonPhase.h"

@implementation CAEMoonPhase
- (id)initWithMoonDict:(NSDictionary *)moonDict {
	self = [super init];
	if (self) {
		[self parseMoonDict:moonDict];
	}
	return self;
}

/**
 *  Parses information we are interested in about the moon phase. Using this information, this sets the corresponding
 *  public properties of the object.
 *
 *  @param moonPhaseDict is a dictionary containing information about the moon phase. This dictionary is parsed out of
 *                       the response data from the weather underground API astronomy feature
 */
- (void)parseMoonDict:(NSDictionary *)moonDict {
	// Note: all of the following values are strings in the JSON response
	self.age = [NSNumber numberWithInteger:[[moonDict objectForKey:@"ageOfMoon"] integerValue]];
	self.percentIlluminated = [NSNumber numberWithInteger:[[moonDict objectForKey:@"percentIlluminated"] integerValue]];
	self.phase = [moonDict objectForKey:@"phaseofMoon"];
}

@end
