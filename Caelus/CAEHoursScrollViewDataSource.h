//
//  CAEHorizontalScrollViewDelegate.h
//  Caelus
//
//  Created by Thomas Strassner on 7/18/14.
//  Copyright (c) 2014 Enterprise Holdings, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CAEHorizontalScrollView.h"

@interface CAEHoursScrollViewDataSource : NSObject <CAEHorizontalScrollViewDataSource>
- (instancetype)initWithNumberOfHours:(NSNumber *)numberOfHours StartHour:(NSNumber *)startHour;
/** Array must be of type weatherHour* */
- (instancetype)initWithWeatherHoursArray:(NSArray *)weatherHours;
@end
