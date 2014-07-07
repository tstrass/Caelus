//
//  CAESunPhase.h
//  Caelus
//
//  Created by Tom on 7/7/14.
//  Copyright (c) 2014 Enterprise Holdings, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CAESunPhase : NSObject
- (id)initWithSunPhaseDict:(NSDictionary *)sunPhaseDict;

// sunrise
@property (strong, nonatomic) NSNumber *sunriseHour;
@property (strong, nonatomic) NSNumber *sunriseMinute;

// sunset
@property (strong, nonatomic) NSNumber *sunsetHour;
@property (strong, nonatomic) NSNumber *sunsetMinute;
@end
