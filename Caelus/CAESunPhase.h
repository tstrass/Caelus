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
/** minutes into the day, i.e. in the range [0, 1440] */
@property (nonatomic) CGFloat sunriseMinuteTime;

// sunset
/** 24 hour time */
@property (strong, nonatomic) NSNumber *sunsetHour;
/** minutes past the hour */
@property (strong, nonatomic) NSNumber *sunsetMinute;
/** time of sunset: minutes into the day, i.e. in the range [0, 1440] */
@property (nonatomic) CGFloat sunsetMinuteTime;


// endpoints of light intervals
/** time sunrise starts: minutes into the day, i.e. in the range [0, 1440] */
@property (nonatomic) CGFloat sunriseStartMinuteTime;
/** time day starts: minutes into the day, i.e. in the range [0, 1440] */
@property (nonatomic) CGFloat dayStartMinuteTime;
/** time sunset starts: minutes into the day, i.e. in the range [0, 1440] */
@property (nonatomic) CGFloat sunsetStartMinuteTime;
/** time night starts: minutes into the day, i.e. in the range [0, 1440] */
@property (nonatomic) CGFloat nightStartMinuteTime;
@end
