//
//  CAEHourlyWeather.h
//  Caelus
//
//  Created by Tom on 7/2/14.
//  Copyright (c) 2014 Enterprise Holdings, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CAEWeatherHour.h"

/**
 *  This object should be initialized using the custom initializer. The dictionary needs to be from
 *  the weather underground API hourly weather feature.
 */
@interface CAEHourlyWeather : NSObject
/**
 *  Sets the properties of the CAEHourlyWeather object based on values in hourlyDict
 *
 *  @param hourlyDict must be a dictionary serialized from the weather underground API hourly JSON response
 *
 *  @return initialized CAEHourlyWeather object
 */
- (id)initWithHourlyDict:(NSDictionary *)hourlyDict;

/** Array of type CAEWeatherHour * */
@property (strong, nonatomic) NSArray *weatherHours;
@end
