//
//  CAESunPhase.h
//  Caelus
//
//  Created by Tom on 7/7/14.
//  Copyright (c) 2014 Enterprise Holdings, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  A CAESunPhase object should be initialized using the custom initializer. The NSDictionary it expects should be
 *  a dictionary containing information about an the sun phase for the day, and it should be parsed out of the weather
 *  underground API response for astronomy data.
 */
@interface CAESunPhase : NSObject
// custom initializer
- (id)initWithSunPhaseDict:(NSDictionary *)sunPhaseDict;

// sunrise
@property (strong, nonatomic) NSNumber *sunriseHour;        // 24 hour time
@property (strong, nonatomic) NSNumber *sunriseMinute;      // minutes past the hour

// sunset
@property (strong, nonatomic) NSNumber *sunsetHour;         // 24 hour time
@property (strong, nonatomic) NSNumber *sunsetMinute;       // minutes past the hour
@end
