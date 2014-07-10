//
//  CAECurrentConditions.h
//  Caelus
//
//  Created by Tom on 7/7/14.
//  Copyright (c) 2014 Enterprise Holdings, Inc. All rights reserved.
//
#import <Foundation/Foundation.h>
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

#import "CAEWeatherInformation.h"
#import "CAELocationData.h"

/**
 *  This object holds data about the current weather conditions in a certain location. It inherits several weather
 *  properties from CAEWeatherInformation.
 *
 *  It should be initialized using the custom initializer.
 */
@interface CAECurrentConditions : CAEWeatherInformation
/**
 *  Sets the properties of the CAECurrentConditions object based of values in conditionsDict
 *
 *  @param conditionsDict must be a dictionary serialized from the weather underground API conditions JSON response
 *
 *  @return initialized CAECurrentConditions object
 */
- (id)initWithConditionsDict:(NSDictionary *)conditionsDict;

/** location with these conditions */
@property (strong, nonatomic) CAELocationData *location;

//wind
/** phrase describing wind (e.g. "From the NE at 2.0 MPH" or "Calm") */
@property (strong, nonatomic) NSString *windDescription;
@end
