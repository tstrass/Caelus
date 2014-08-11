//
//  CAEAstronomy.m
//  Caelus
//
//  Created by Thomas Strassner on 7/1/14.
//  Copyright (c) 2014 Enterprise Holdings, Inc. All rights reserved.
//

#import "CAEAstronomy.h"

@implementation CAEAstronomy

- (id)initWithAstronomyDict:(NSDictionary *)astronomyDict {
	self = [super init];
	if (self) {
		[self parseAstronomyDict:astronomyDict];
	}
	return self;
}

- (void)parseAstronomyDict:(NSDictionary *)astronomyDict {
	NSDictionary *sunPhaseDict = [astronomyDict objectForKey:@"sun_phase"];
    NSDictionary *moonPhaseDict = [astronomyDict objectForKey:@"moon_phase"];

	self.sunPhase = sunPhaseDict ? [[CAESunPhase alloc] initWithSunPhaseDict:sunPhaseDict] : nil;
	self.moonPhase = moonPhaseDict ? [[CAEMoonPhase alloc] initWithMoonDict:moonPhaseDict] : nil;
}

@end
