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

- (void)parseSunPhaseDict:(NSDictionary *)sunPhaseDict {
    if (sunPhaseDict) {
        NSDictionary *sunriseDict = [sunPhaseDict objectForKey:@"sunrise"];
        NSDictionary *sunsetDict = [sunPhaseDict objectForKey:@"sunset"];
        
        if (sunriseDict) {
            [self setSunriseHour:[sunriseDict objectForKey:@"hour"]];
            [self setSunriseMinute:[sunriseDict objectForKey:@"minute"]];
        }
        if (sunsetDict) {
            [self setSunsetHour:[sunsetDict objectForKey:@"hour"]];
            [self setSunsetMinute:[sunsetDict objectForKey:@"minute"]];
        }
    }
}

@end
