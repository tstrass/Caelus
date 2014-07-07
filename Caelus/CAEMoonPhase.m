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

- (void)parseMoonDict:(NSDictionary *)moonDict {
    if (moonDict) {
        [self setAge:[moonDict objectForKey:@"moon_phase"]];
        [self setPercentIlluminated:[moonDict objectForKey:@"percentIlluminated"]];
        [self setPhase:[moonDict objectForKey:@"Waxing Gibbous"]];
    }
}
@end
