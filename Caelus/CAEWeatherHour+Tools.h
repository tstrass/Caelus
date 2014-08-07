//
//  CAEWeatherHour+Tools.h
//  Caelus
//
//  Created by Tom on 7/30/14.
//  Copyright (c) 2014 Enterprise Holdings, Inc. All rights reserved.
//

#import "CAEWeatherHour.h"

@interface CAEWeatherHour (Tools)
/**
 *  Uses the weatherHour property of a CAEWeatherHour to make a time string
 *
 *  @return NSString for the time, in the format h:mm, which is 12 hour format with no leading zero
 */
- (NSString *)timeStringFromWeatherHour;
@end
