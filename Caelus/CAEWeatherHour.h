//
//  CLWeatherHour.h
//  Caelus
//
//  Created by Tom on 7/2/14.
//  Copyright (c) 2014 Enterprise Holdings, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  A CLWeatherHour object should be initialized using the custom initializer. The NSDictionary it expects should be
 *  a dictionary containing information about an individual hour of weather, parsed out of the weather underground API
 *  response for hourly weather.
 *
 *  This object holds various fields describing weather conditions for an individual hour.
 */
@interface CAEWeatherHour : NSObject
// custom initializer
- (id)initWithHourDict:(NSDictionary *)hourDict;                // hourDict has to be from weather underground API

@property (nonatomic) NSInteger hour;                           // hour of the day in 24 hour time
@property (strong, nonatomic) NSString *weekdayNameAbbrev;      // i.e. Sun, Mon, Tue, Wed, Thu, Fri, Sat
@property (nonatomic) NSInteger temp;                           // temperature in farenheit
@property (strong, nonatomic) NSString *condition;              // e.g. Clear
@property (nonatomic) NSInteger cloudCover;                     // percentage of sky covered by clouds
@end
