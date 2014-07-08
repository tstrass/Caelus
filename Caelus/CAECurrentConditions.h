//
//  CAECurrentConditions.h
//  Caelus
//
//  Created by Tom on 7/7/14.
//  Copyright (c) 2014 Enterprise Holdings, Inc. All rights reserved.
//
#import <Foundation/Foundation.h>
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

#import "CAELocationData.h"

/**
 *  This object holds data about the current weather conditions in a certain location.
 *
 *  It should be initialized using the custom initializer.
 */
@interface CAECurrentConditions : NSObject
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

//temperature
/** temperature in farenheit */
@property (strong, nonatomic) NSNumber *fTemp;
/** temperature in celsius */
@property (strong, nonatomic) NSNumber *cTemp;

//wind
/** wind speed in miles per hour */
@property (strong, nonatomic) NSNumber *windSpeedMPH;
/** wind speed in kilometers per hour */
@property (strong, nonatomic) NSNumber *windSpeedKPH;
/** wind direction (e.g. ENE) */
@property (strong, nonatomic) NSString *windDir;
/** phrase describing wind (e.g. "From the NE at 2.0 MPH" or "Calm") */
@property (strong, nonatomic) NSString *windDescription;

//precipitation
/** precipitation over last hour in inches */
@property (strong, nonatomic) NSNumber *precipHourIn;
/** precipitation over last hour in millimeters */
@property (strong, nonatomic) NSNumber *precipHourMM;
@end
