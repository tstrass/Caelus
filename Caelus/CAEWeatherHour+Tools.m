//
//  CAEWeatherHour+Tools.m
//  Caelus
//
//  Created by Tom on 7/30/14.
//  Copyright (c) 2014 Enterprise Holdings, Inc. All rights reserved.
//

#import "CAEWeatherHour+Tools.h"

@implementation CAEWeatherHour (Tools)
- (NSString *)timeStringFromWeatherHour {
    NSInteger hour = self.hour.integerValue;
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	dateFormatter.dateFormat = @"HH:mm";
	NSDate *date = [dateFormatter dateFromString:[NSString stringWithFormat:@"%lu:00", hour]];
	dateFormatter.dateFormat = @"h:mm a";
	return [dateFormatter stringFromDate:date];
}
@end
