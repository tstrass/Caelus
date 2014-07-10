//
//  CAEWeatherHour.h
//  Caelus
//
//  Created by Tom on 7/2/14.
//  Copyright (c) 2014 Enterprise Holdings, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CAEWeatherInformation.h"

/**
 *  This object holds various fields describing weather conditions for an individual hour. It inherits several weather
 *  properties from CAEWeatherInformation.
 *
 *  It should be initialized using the custom initializer.
 */
@interface CAEWeatherHour : CAEWeatherInformation
/**
 *  Sets properties of the CAEWeatherHour object based on values in hourDict
 *
 *  @param hourDict must be a dictionary parsed from the weather underground API hourly response JSON
 *
 *  @return initialized CAEWeatherHour object
 */
- (id)initWithHourDict:(NSDictionary *)hourDict;

// Date
/** Hour of the day in 24 hour time */
@property (strong, nonatomic) NSNumber *hour;
/** i.e. Sun, Mon, Tue, Wed, Thu, Fri, Sat */
@property (strong, nonatomic) NSString *weekdayNameAbbrev;

// Precipitation
/** scale of 0-100 */
@property (strong, nonatomic) NSNumber *probabilityOfPrecipitation;

// Sky
/** e.g. "Clear" */
@property (strong, nonatomic) NSString *condition;
/** percentage of sky covered by clouds */
@property (strong, nonatomic) NSNumber *cloudCover;

// Air

@end
