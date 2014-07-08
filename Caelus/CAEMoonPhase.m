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
	if (moonDict) {
		[self setAge:[moonDict objectForKey:@"ageOfMoon"]];
		[self setPercentIlluminated:[moonDict objectForKey:@"percentIlluminated"]];
		[self setPhase:[moonDict objectForKey:@"phaseofMoon"]];
	}
}

@end
