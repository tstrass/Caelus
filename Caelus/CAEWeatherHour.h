//
//  CAEWeatherHour.h
//  Caelus
//
//  Created by Tom on 7/2/14.
//  Copyright (c) 2014 Enterprise Holdings, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  This object holds various fields describing weather conditions for an individual hour.
 *
 *  It should be initialized using the custom initializer.
 */
@interface CAEWeatherHour : NSObject
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

// Temperature
/** Temperature in farenheit */
@property (strong, nonatomic) NSNumber *fTemp;
/** Temperature in celsius */
@property (strong, nonatomic) NSNumber *cTemp;

// Wind
/** wind speed in miles per hour */
@property (strong, nonatomic) NSNumber *windSpeedMPH;
/** wind speed in kilometers per hour */
@property (strong, nonatomic) NSNumber *windSpeedKPH;
/** wind direction (e.g. ENE) */
@property (strong, nonatomic) NSString *windDir;

// Precipitation
/** scale of 0-100 */
@property (strong, nonatomic) NSNumber *probabilityOfPrecipitation;
/** predicted precipitation during the hour in inches */
@property (strong, nonatomic) NSNumber *precipIn;
/** predicted precipitation during the hour in millimeters */
@property (strong, nonatomic) NSNumber *precipMM;

// Sky
/** e.g. "Clear" */
@property (strong, nonatomic) NSString *condition;
/** percentage of sky covered by clouds */
@property (strong, nonatomic) NSNumber *cloudCover;

// Air

@end
