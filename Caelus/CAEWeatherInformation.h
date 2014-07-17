//
//  CAEWeatherInformation.h
//  Caelus
//
//  Created by Tom on 7/10/14.
//  Copyright (c) 2014 Enterprise Holdings, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  This object holds information about an individual snapshot of weather.
 */
@interface CAEWeatherInformation : NSObject
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
/** predicted precipitation during an hour in inches */
@property (strong, nonatomic) NSNumber *precipIn;
/** predicted precipitation during an hour in millimeters */
@property (strong, nonatomic) NSNumber *precipMM;

// Miscellaneous
@property (strong, nonatomic) NSString *iconName;
@end
