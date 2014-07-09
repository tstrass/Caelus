//
//  CAESunPhase.h
//  Caelus
//
//  Created by Tom on 7/7/14.
//  Copyright (c) 2014 Enterprise Holdings, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  This object holds data about the sun's current phase.
 *
 *  It should be initialized using the custom initializer.
 */
@interface CAESunPhase : NSObject
/**
 *  Sets the properties of the CAESunPhase object based on values in sunPhaseDict
 *
 *  @param sunPhaseDict must be a dictionary parsed from the
 *
 *  @return initialized CAESunPhase object
 */
- (id)initWithSunPhaseDict:(NSDictionary *)sunPhaseDict;

// sunrise
/** 24 hour time */
@property (strong, nonatomic) NSNumber *sunriseHour;
/** minutes past the hour */
@property (strong, nonatomic) NSNumber *sunriseMinute;

// sunset
/** 24 hour time */
@property (strong, nonatomic) NSNumber *sunsetHour;
/** minutes past the hour */
@property (strong, nonatomic) NSNumber *sunsetMinute;
@end
