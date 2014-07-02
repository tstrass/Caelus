//
//  CLWeatherHour.h
//  Caelus
//
//  Created by Tom on 7/2/14.
//  Copyright (c) 2014 Enterprise Holdings, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CLWeatherHour : NSObject
- (id)initWithHourDict:(NSDictionary *)hourDict;

@property (nonatomic) NSInteger hour;                           // hour of the day in 24 hour time
@property (strong, nonatomic) NSString *weekdayNameAbbrev;      // i.e. Sun, Mon, Tue, Wed, Thu, Fri, Sat
@property (nonatomic) NSInteger temp;                           // temperature in farenheit
@property (strong, nonatomic) NSString *condition;              // e.g. Clear
@property (nonatomic) NSInteger cloudCover;                     // percentage of sky covered by clouds
@end
