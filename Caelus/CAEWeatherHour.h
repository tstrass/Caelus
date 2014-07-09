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

// TODO: change NSInteger properties to NSNumber for versatility and consitency with other classes
/** hour of the day in 24 hour time */
@property (nonatomic) NSInteger hour;
/** i.e. Sun, Mon, Tue, Wed, Thu, Fri, Sat */
@property (strong, nonatomic) NSString *weekdayNameAbbrev;
/** temperature in farenheit */
@property (nonatomic) NSInteger temp;
/** e.g. "Clear" */
@property (strong, nonatomic) NSString *condition;
/** percentage of sky covered by clouds */
@property (nonatomic) NSInteger cloudCover;
@end
