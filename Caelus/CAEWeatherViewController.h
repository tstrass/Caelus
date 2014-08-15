//
//  CAEWeatherViewController.h
//  Caelus
//
//  Created by Thomas Strassner on 6/20/14.
//  Copyright (c) 2014 Enterprise Holdings, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
typedef void (^weatherParsingComplete)(BOOL);
typedef void (^astronomyParsingComplete)(BOOL);

@interface CAEWeatherViewController : UIViewController <NSURLConnectionDelegate, CLLocationManagerDelegate>
/** Coordinates of location, i.e. @"(24.12,-9.2)"*/
@property (strong, nonatomic) NSString *geolocation;

// temporary property to facilitate use of mock service
@property (strong, nonatomic) NSString *mockServiceLocation;
@end
