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
 *  The CAEHourlyWeather object should be initialized using the custom initializer. The dictionary needs to be from
 *  the weather underground API hourly weather feature.
 */
@interface CAEHourlyWeather : NSObject
- (id)initWithJSONDict:(NSDictionary *)dict;                //dict needs to be serialized JSON

@property (strong, nonatomic) NSArray *weatherHours;        // Array of type CAEWeatherHour *
@end
