//
//  CLHourlyWeather.h
//  Caelus
//
//  Created by Tom on 7/2/14.
//  Copyright (c) 2014 Enterprise Holdings, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CLWeatherHour.h"

/**
 *  The CLHourlyWeather object should be initialized using the custom initializer. The dictionary needs to be from
 *  the weather underground API hourly weather feature.
 */
@interface CLHourlyWeather : NSObject

- (id)initWithJSONDict:(NSDictionary *)dict;                //dict needs to be serialized JSON

@property (strong, nonatomic) NSArray *weatherHours;        // Array of type CLWeatherHour *
@end
