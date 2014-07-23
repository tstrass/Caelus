//
//  CAEHorizontalScrollViewDelegate.m
//  Caelus
//
//  Created by Thomas Strassner on 7/18/14.
//  Copyright (c) 2014 Enterprise Holdings, Inc. All rights reserved.
//

#import "CAEHoursScrollViewDelegate.h"

@interface CAEHoursScrollViewDelegate ()
@property (strong, nonatomic) NSNumber *numberOfHours;
@property (strong, nonatomic) NSNumber *startHour;
@end

@implementation CAEHoursScrollViewDelegate
- (instancetype)initWithNumberOfHours:(NSNumber *)numberOfHours StartHour:(NSNumber *)startHour{
    self = [super init];
    if (self) {
        self.numberOfHours = numberOfHours;
        self.startHour = startHour;
    }
    return self;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - CAEHorizontalScrollView Delegate Methods
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (NSInteger)numberOfViewsForHorizonalScrollView:(CAEHorizontalScrollView *)horizontalScrollView {
    return [self.numberOfHours integerValue];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - CAEHorizontalScrollView Data Source Methods
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (UIView *)viewAtIndex:(NSInteger)index forHorizontalScrollView:(CAEHorizontalScrollView *)horizontalScrollView {
    UILabel *hourLabel = [[UILabel alloc] init];
    NSNumber *hourForIndex = [NSNumber numberWithInteger:[self.startHour integerValue] + index];
    hourLabel.text = [NSString stringWithFormat:@"%@:00", [hourForIndex stringValue]];
    hourLabel.frame = CGRectMake(0, 0, 60, horizontalScrollView.frame.size.height);
    hourLabel.textAlignment = NSTextAlignmentCenter;
    return hourLabel;
}

@end
