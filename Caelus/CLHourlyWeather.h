//
//  CLHourlyWeather.h
//  Caelus
//
//  Created by Tom on 7/2/14.
//  Copyright (c) 2014 Enterprise Holdings, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CLWeatherHour.h"

@interface CLHourlyWeather : NSObject

- (id)initWithJSONDict:(NSDictionary *)dict;

// Array of type ClWeatherHour
@property (strong, nonatomic) NSArray *weatherHours;
@end
