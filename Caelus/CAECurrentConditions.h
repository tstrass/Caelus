//
//  CLCurrentConditions.h
//  Caelus
//
//  Created by Tom on 7/7/14.
//  Copyright (c) 2014 Enterprise Holdings, Inc. All rights reserved.
//
#import <Foundation/Foundation.h>
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

#import "CAELocationData.h"

/**
 *  A CLCurrentConditions object should be initialized using the custom initializer. The NSDictionary it expects should
 *  contain information about current weather conditions in a certain place. This dictionary needs to be from the
 *  weather underground conditions feature.
 */
@interface CAECurrentConditions : NSObject
// custom initializer
- (id)initWithJSONDict:(NSDictionary *)dict;                // dict needs to be serialized JSON

@property (strong, nonatomic) CAELocationData *location;     // location with these conditions

//temperature
@property (strong, nonatomic) NSNumber *fTemp;              // temperature in farenheit
@property (strong, nonatomic) NSNumber *cTemp;              // temperature in celsius

//wind
@property (strong, nonatomic) NSNumber *windSpeedMPH;       // wind speed in miles per hour
@property (strong, nonatomic) NSNumber *windSpeedKPH;       // wind speed in kilometers per hour
@property (strong, nonatomic) NSString *windDir;            // wind direction (e.g. ENE)
@property (strong, nonatomic) NSString *windDescription;    // phrase describing wind (e.g. "From the NE at 2.0 MPH")

//precipitation
@property (strong, nonatomic) NSNumber *precipHourIn;       // precipitation over last hour in inches
@property (strong, nonatomic) NSNumber *precipHourMM;       // precipitation over last hour in millimeters
@end
