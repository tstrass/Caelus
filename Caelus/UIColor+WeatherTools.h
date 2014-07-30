//
//  UIColor+WeatherTools.h
//  Caelus
//
//  Created by Tom on 7/30/14.
//  Copyright (c) 2014 Enterprise Holdings, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CAEWeatherHour.h"
#import "CAEAstronomy.h"

@interface UIColor (WeatherTools)
+ (UIColor *)backgroundColorFromWeatherHour:(CAEWeatherHour *)weatherHour
                                  astronomy:(CAEAstronomy *)astronomy
                             hourPercentage:(CGFloat)hourPercentage;
@end
