//
//  CAEAstronomy+Tools.h
//  Caelus
//
//  Created by Tom on 7/30/14.
//  Copyright (c) 2014 Enterprise Holdings, Inc. All rights reserved.
//

#import "CAEAstronomy.h"
#import "CAEWeatherHour.h"

@interface CAEAstronomy (Tools)
- (UIColor *)backgroundColorFromWeatherHour:(CAEWeatherHour *)weatherHour hourPercentage:(CGFloat)hourPercentage;
@end
