//
//  CAEHorizontalScrollViewDelegate.m
//  Caelus
//
//  Created by Thomas Strassner on 7/18/14.
//  Copyright (c) 2014 Enterprise Holdings, Inc. All rights reserved.
//
#import "CAEHoursScrollViewDataSource.h"
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

#import "CAEWeatherHour.h"

@interface CAEHoursScrollViewDataSource ()
@property (strong, nonatomic) NSNumber *numberOfHours;
@property (strong, nonatomic) NSNumber *startHour;
@property (strong, nonatomic) NSArray *weatherHours;
@end

@implementation CAEHoursScrollViewDataSource
- (instancetype)initWithNumberOfHours:(NSNumber *)numberOfHours StartHour:(NSNumber *)startHour {
	self = [super init];
	if (self) {
		self.numberOfHours = numberOfHours;
		self.startHour = startHour;
	}
	return self;
}

- (instancetype)initWithWeatherHoursArray:(NSArray *)weatherHours {
	self = [super init];
	if (self) {
		self.weatherHours = weatherHours;
	}
	return self;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - CAEHorizontalScrollView Delegate Methods
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (NSInteger)numberOfViewsForHorizonalScrollView:(CAEHorizontalScrollView *)horizontalScrollView {
	return self.weatherHours.count;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - CAEHorizontalScrollView Data Source Methods
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (UIView *)viewAtIndex:(NSInteger)index forHorizontalScrollView:(CAEHorizontalScrollView *)horizontalScrollView {
	UILabel *hourLabel = [[UILabel alloc] init];
	hourLabel.numberOfLines = 2;
	hourLabel.text = [NSString stringWithFormat:@"%@\n%@", [self timeStringFromIndex:index], [self dayStringFromIndex:index]];
	hourLabel.frame = CGRectMake(0, 0, 60, horizontalScrollView.frame.size.height);
	hourLabel.textAlignment = NSTextAlignmentCenter;
	return hourLabel;
}

- (NSString *)timeStringFromIndex:(NSInteger)index {
	CAEWeatherHour *weatherHour = [self.weatherHours objectAtIndex:index];
	NSInteger hour = weatherHour.hour.integerValue;
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	dateFormatter.dateFormat = @"HH:mm";
	NSDate *date = [dateFormatter dateFromString:[NSString stringWithFormat:@"%lu:00", hour]];
	dateFormatter.dateFormat = @"h:mm a";
	return [dateFormatter stringFromDate:date];
}

- (NSString *)dayStringFromIndex:(NSInteger)index {
	CAEWeatherHour *weatherHour = [self.weatherHours objectAtIndex:index];
	return weatherHour.weekdayNameAbbrev;
}

@end
