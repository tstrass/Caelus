//
//  CAEDetailViewController.m
//  Caelus
//
//  Created by Thomas Strassner on 6/20/14.
//  Copyright (c) 2014 Enterprise Holdings, Inc. All rights reserved.
//
#import "CAEDetailViewController.h"
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// Delegate
#import "CAECloudsDelegate.h"
#import "CAEPrecipitationDelegate.h"
#import "CAEHoursScrollViewDataSource.h"

// View
#import "CAEDiscreteMeterView.h"
#import "CAEHorizontalScrollView.h"

// Model
#import "CAECurrentConditions.h"
#import "CAEAstronomy.h"
#import "CAEHourlyWeather.h"
#import "CAEAstronomy+Tools.h"

@interface CAEDetailViewController () <CAEHorizontalScrollViewDelegate>
@property (strong, nonatomic) UIPopoverController *masterPopoverController;
- (void)configureView;

// UI objects in storyboard
@property (weak, nonatomic) IBOutlet UILabel *currentLocationLabel;
@property (weak, nonatomic) IBOutlet CAEDiscreteMeterView *cloudsMeterView;
@property (weak, nonatomic) IBOutlet CAEDiscreteMeterView *precipitationMeterView;
@property (weak, nonatomic) IBOutlet CAEHorizontalScrollView *hoursScrollView;
@property (weak, nonatomic) IBOutlet UILabel *temperatureLabel;
@property (weak, nonatomic) IBOutlet UIImageView *bottomShadow;
@property (weak, nonatomic) IBOutlet UIImageView *sunImageView;

@property (nonatomic) CGFloat startSunAngle;
@property (nonatomic) CGFloat endSunAngle;
@property (nonatomic) CGFloat arcRadius;
@property (nonatomic) CGPoint arcCenter;

// Requests
@property (strong, nonatomic) NSMutableArray *requestsArray;

// Current weather data
@property (strong, nonatomic) NSData *currentConditionsResponseData;
@property (strong, nonatomic) CAECurrentConditions *currentConditions;

// Astronomy data
@property (strong, nonatomic) NSData *astronomyResponseData;
@property (strong, nonatomic) CAEAstronomy *astronomy;

// Hourly weather data
@property (strong, nonatomic) NSData *hourlyWeatherResponseData;
@property (strong, nonatomic) CAEHourlyWeather *hourlyWeather;

// Geolocation
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) NSString *geolocation;

// Current UI state
@property (nonatomic) NSInteger currentHour;

// Delegates
@property (strong, nonatomic) CAECloudsDelegate *cloudsDelegate;
@property (strong, nonatomic) CAEPrecipitationDelegate *precipitationDelegate;
@end

@implementation CAEDetailViewController

#define DUSK_MINUTE = self.sunsetMinuteTime + 30;
#define DAWN_MINUTE = self.sunriseMinuteTime - 30;

/** if there's precipitation you know it will be raining at or above this farenheit value */
const int MIN_RAIN_SURE = 40;
/** if there's precipitation you know it will be frozen at or below this farenheit value */
const int MAX_SNOW_SURE = 28;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Managing the detail item
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)configureView {
	// Update the user interface for the detail item.

	if (self.detailItem) {
		self.detailDescriptionLabel.text = [self.detailItem description];
	}
	[self makeGradientOverlay];

    self.bottomShadow.transform = CGAffineTransformMakeRotation(M_PI);
}

- (void)viewDidLoad {
	[super viewDidLoad];
	[self configureView];

	if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
		// iOS 7
		[self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
	}
	else {
		// iOS 6
		[[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
	}
    [self calculateSunAngles];
    
	[self setUpLocationManager];

	self.view.backgroundColor = [UIColor colorWithRed:0.400 green:0.800 blue:1.000 alpha:1.000];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Set Up
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setUpLocationManager {
	self.locationManager = [[CLLocationManager alloc]init];
	self.locationManager.delegate = self;
	self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    if ([CLLocationManager authorizationStatus] != kCLAuthorizationStatusNotDetermined) {
        [self.locationManager startUpdatingLocation];
    } else {
        [self.locationManager requestWhenInUseAuthorization];
    }
}

- (void)setUpAPIRequests {
	self.requestsArray = [[NSMutableArray alloc] init];
	[self makeCurrentConditionsRequestWithLocation:self.geolocation];
	[self makeAstronomyRequestWithLocation:self.geolocation];
	[self makeHourlyWeatherRequestWithLocation:self.geolocation];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Format
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)positionSunForWeatherHour:(CAEWeatherHour *)weatherHour hourPercentage:(CGFloat)percentage {
    CGFloat currentMinuteTime = [weatherHour.hour floatValue] * 60.0 + (percentage * 60.0);
    if (currentMinuteTime > self.astronomy.sunPhase.sunriseStartMinuteTime && currentMinuteTime < self.astronomy.sunPhase.nightStartMinuteTime) {
        CGFloat angleRange = self.startSunAngle - self.endSunAngle;
        CGFloat timeRange = self.astronomy.sunPhase.nightStartMinuteTime - self.astronomy.sunPhase.sunriseStartMinuteTime;
        CGFloat adjustedTime = self.astronomy.sunPhase.nightStartMinuteTime - (currentMinuteTime - self.astronomy.sunPhase.sunriseStartMinuteTime);
        CGFloat currentAngle = (adjustedTime - self.astronomy.sunPhase.sunriseStartMinuteTime) / timeRange * angleRange + self.endSunAngle;
        [self.sunImageView setCenter:CGPointMake(self.arcCenter.x + (self.arcRadius * cosf(currentAngle * M_PI / 180)), self.arcCenter.y - (self.arcRadius * sinf(currentAngle * M_PI / 180)))];
        NSLog(@"angle: %f", currentAngle);
        NSLog(@"sun center: (%f, %f)", self.sunImageView.center.x, self.sunImageView.center.y);
    }
    
}

- (void)formatLocationLabel {
	self.currentLocationLabel.text = [NSString stringWithFormat:@"Current Location: %@", self.geolocation];
	self.currentLocationLabel.font = [UIFont fontWithName:@"Times New Roman" size:12];
	self.currentLocationLabel.adjustsFontSizeToFitWidth = YES;
	self.currentLocationLabel.minimumScaleFactor = 0.3;
}

- (void)formatViewForWeather {
	CAEWeatherHour *firstHour = [self.hourlyWeather.weatherHours firstObject];
	self.view.backgroundColor = [self.astronomy backgroundColorFromWeatherHour:firstHour hourPercentage:0.5];
	[self formatTemperatureLabel];
	[self formatCloudsView];
	[self formatPrecpitationView];
	[self setUpHoursScrollView];
}

- (void)formatTemperatureLabel {
	self.temperatureLabel.text = [NSString stringWithFormat:@"%lu°F", [self.currentConditions.fTemp integerValue]];
}

- (void)formatCloudsView {
	CAEWeatherHour *firstHour = [self.hourlyWeather.weatherHours objectAtIndex:self.currentHour];
	NSNumber *propabilityOfPrecip = firstHour.probabilityOfPrecipitation;
	NSNumber *percentCloudy = firstHour.cloudCover;

	self.cloudsDelegate = [[CAECloudsDelegate alloc] initWithPercentCloudy:percentCloudy ChanceOfPrecipitation:propabilityOfPrecip];
	self.cloudsMeterView.dataSource = self.cloudsDelegate;
	self.cloudsMeterView.delegate = self.cloudsDelegate;
	[self.cloudsMeterView reload];
}

- (void)formatPrecpitationView {
	CAEWeatherHour *firstHour = [self.hourlyWeather.weatherHours objectAtIndex:self.currentHour];
	NSNumber *probabilityOfPrecip = firstHour.probabilityOfPrecipitation;
	PrecipType precipType = [self precipTypeFromIconName:firstHour.iconName Temperature:firstHour.fTemp];

	self.precipitationDelegate = [[CAEPrecipitationDelegate alloc] initWithPrecipType:precipType Probability:probabilityOfPrecip];
	self.precipitationMeterView.dataSource = self.precipitationDelegate;
	self.precipitationMeterView.delegate = self.precipitationDelegate;
	[self.precipitationMeterView reload];
}

- (void)setUpHoursScrollView {
	CAEHoursScrollViewDataSource *hoursScrollViewDataSource = [[CAEHoursScrollViewDataSource alloc] initWithWeatherHoursArray:self.hourlyWeather.weatherHours];
	self.hoursScrollView.dataSource = hoursScrollViewDataSource;
	self.hoursScrollView.delegate = self;
	[self.hoursScrollView reload];
}

- (void)formatViewForFailedLocation {
	self.view.backgroundColor = [UIColor colorWithRed:0.400 green:0.800 blue:1.000 alpha:1.000];
	self.currentLocationLabel.text = @"Cannot detect a location.";
	self.currentLocationLabel.textAlignment = NSTextAlignmentCenter;
	self.currentLocationLabel.font = [UIFont fontWithName:@"Times New Roman" size:12];
	self.currentLocationLabel.adjustsFontSizeToFitWidth = YES;
	self.currentLocationLabel.minimumScaleFactor = 0.3;
}

- (void)reloadViewsForWeather {
	CAEWeatherHour *weatherHour = [self.hourlyWeather.weatherHours objectAtIndex:self.currentHour];
	[self updateTemperatureLabelForHour:weatherHour];
	[self updateCloudsForHour:weatherHour];
	[self updatePrecipitation:weatherHour];
}

- (void)updateTemperatureLabelForHour:(CAEWeatherHour *)weatherHour {
	self.temperatureLabel.text = [NSString stringWithFormat:@"%lu°F", [weatherHour.fTemp integerValue]];
}

- (void)updateCloudsForHour:(CAEWeatherHour *)weatherHour {
	self.cloudsDelegate.percentCloudy = weatherHour.cloudCover;
	self.cloudsDelegate.probabilityOfPrecipitation = weatherHour.probabilityOfPrecipitation;
	[self.cloudsMeterView reload];
}

- (void)updatePrecipitation:(CAEWeatherHour *)weatherHour {
	self.precipitationDelegate.precipType = [self precipTypeFromIconName:weatherHour.iconName
	                                                         Temperature:weatherHour.fTemp];
	self.precipitationDelegate.probability = weatherHour.probabilityOfPrecipitation;
	[self.precipitationMeterView reload];
}

- (void)makeGradientOverlay {
	UIColor *topColor = [UIColor colorWithWhite:1.000 alpha:0.350];
	UIColor *bottomColor = [UIColor colorWithWhite:1.000 alpha:0.000];

	CAGradientLayer *gradient = [CAGradientLayer layer];
	gradient.colors = [NSArray arrayWithObjects:(id)topColor.CGColor, (id)bottomColor.CGColor, nil];
	gradient.frame = self.view.frame;
	[self.view.layer insertSublayer:gradient atIndex:0];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - CLLocationManager Delegate Methods
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
	[self.locationManager stopUpdatingLocation];

	CLGeocoder *geoCoder = [[CLGeocoder alloc] init];
	[geoCoder reverseGeocodeLocation:[locations lastObject] completionHandler: ^(NSArray *placemarks, NSError *error) {
	    self.geolocation = (placemarks.count > 0) ? [[placemarks objectAtIndex:0] locality] : @"Not Found";
	    [self formatLocationLabel];
	    if (![self.geolocation isEqualToString:@"Not Found"]) {
	        self.geolocation = [self requestStringWithCurrentLocation];
	        [self setUpAPIRequests];
	        [self sendRequestsAndParseData];
		}
	}];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
	NSLog(@"self.locationManager:%@ didFailWithError:%@", manager, error);
	[self formatViewForFailedLocation];
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    if (status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        [self.locationManager startUpdatingLocation];
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Request Set Up Methods
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// TODO: error handling
- (void)sendRequestsAndParseData {
	__block NSInteger outstandingRequests = self.requestsArray.count;

	for (NSURLRequest *request in self.requestsArray) {
		[NSURLConnection sendAsynchronousRequest:request
		                                   queue:[NSOperationQueue mainQueue]
		                       completionHandler: ^(NSURLResponse *response, NSData *data, NSError *connectionError) {
		    if ([self.requestsArray indexOfObject:request] == 0) {
		        self.currentConditionsResponseData = data;
		        [self parseCurrentWeatherJSON];
			}
		    else if ([self.requestsArray indexOfObject:request] == 1) {
		        self.astronomyResponseData = data;
		        [self parseAstronomyJSON];
			}
		    else if ([self.requestsArray indexOfObject:request] == 2) {
		        self.hourlyWeatherResponseData = data;
		        //NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
		        //NSLog(@"%@", string);
		        [self parseHourlyWeatherJSON];
			}
		    outstandingRequests--;
		    if (outstandingRequests == 0) [self formatViewForWeather];
		}];
	}
}

- (void)makeCurrentConditionsRequestWithLocation:(NSString *)location {
	// encode city search for URL and make URL request
	NSString *weatherRequest = [NSString stringWithFormat:@"http://api.wunderground.com/api/f29e980ec760f4cc/conditions/q/%@.json", location];
	NSLog(@"%@", weatherRequest);
	NSURL *apiURL = [NSURL URLWithString:weatherRequest];
	NSURLRequest *request = [[NSURLRequest alloc] initWithURL:apiURL];
	[self.requestsArray addObject:request];
}

- (void)makeAstronomyRequestWithLocation:(NSString *)location {
	// encode city search for URL and make URL request
	NSString *astronomyRequest = [NSString stringWithFormat:@"http://api.wunderground.com/api/f29e980ec760f4cc/astronomy/q/%@.json", location];
	NSURL *apiURL = [NSURL URLWithString:astronomyRequest];
	NSURLRequest *request = [[NSURLRequest alloc] initWithURL:apiURL];
	[self.requestsArray addObject:request];
}

- (void)makeHourlyWeatherRequestWithLocation:(NSString *)location {
	// encode city search for URL and make URL request
	NSString *hourlyRequest = [NSString stringWithFormat:@"http://api.wunderground.com/api/f29e980ec760f4cc/hourly/q/%@.json", location];
	NSURL *apiURL = [NSURL URLWithString:hourlyRequest];
	NSURLRequest *request = [[NSURLRequest alloc] initWithURL:apiURL];
	[self.requestsArray addObject:request];
}

- (NSString *)requestStringWithCurrentLocation {
	NSString *requestString = [[NSString alloc] initWithFormat:@"%f,%f",
	                           self.locationManager.location.coordinate.latitude,
	                           self.locationManager.location.coordinate.longitude];
	return requestString;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Data Parsing
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)parseCurrentWeatherJSON {
	// parse JSON, ensure that all fields we need are populated

	NSError *error;
	NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:self.currentConditionsResponseData
	                                                     options:kNilOptions
	                                                       error:&error];
	//NSLog(@"parsed current weather json:\n%@", dict);

	if (dict) {
		self.currentConditions = [[CAECurrentConditions alloc] initWithConditionsDict:dict];
		//[self layoutCurrentConditionsLabel];
	}
}

- (void)parseAstronomyJSON {
	// parse JSON, ensure that all fields we need are populated
	NSError *error;
	NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:self.astronomyResponseData
	                                                     options:kNilOptions
	                                                       error:&error];
	//NSLog(@"parsed astronomy json:\n%@", dict);

	if (dict) {
		self.astronomy = [[CAEAstronomy alloc] initWithAstronomyDict:dict];
		//[self layoutAstronomyLabel];
	}
}

- (void)parseHourlyWeatherJSON {
	NSError *error;
	NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:self.hourlyWeatherResponseData
	                                                     options:kNilOptions
	                                                       error:&error];
	if (dict) {
		self.hourlyWeather = [[CAEHourlyWeather alloc] initWithHourlyDict:dict];
		//[self layoutHourlyScrollView];
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Utilities for data presentation
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (PrecipType)precipTypeFromIconName:(NSString *)iconName Temperature:(NSNumber *)fTemp {
	if ([fTemp integerValue] >= MIN_RAIN_SURE) return RAIN;
	if ([fTemp integerValue] >= MAX_SNOW_SURE) return SNOW;

	if ([iconName isEqualToString:@"rain"] || [iconName isEqualToString:@"chancerain"] || [iconName isEqualToString:@"sleet"] || [iconName isEqualToString:@"chancesleet"] || [iconName isEqualToString:@"tstorms"] || [iconName isEqualToString:@"chancetstorms"]) {
		return RAIN;
	}
	else if ([iconName isEqualToString:@"snow"] || [iconName isEqualToString:@"flurries"] || [iconName isEqualToString:@"chancesnow"] || [iconName isEqualToString:@"chanceflurries"]) {
		return SNOW;
	}
	else {
		return ([fTemp integerValue] > 32) ? RAIN : SNOW;
	}
}

- (void)calculateSunAngles {
    CGRect arcRect = CGRectMake(0 - self.sunImageView.frame.size.width / 2, 220, 320 + self.sunImageView.frame.size.width, 100);
    self.arcRadius = (arcRect.size.height / 2) + powf(arcRect.size.width, 2)/(8 * arcRect.size.height);
    self.arcCenter = CGPointMake(arcRect.size.width / 2 + arcRect.origin.x, arcRect.origin.y + self.arcRadius);
    CGFloat arcAngle = cosf(arcRect.size.width / 2 / self.arcRadius) * (180 / M_PI);
    self.startSunAngle = 180 - arcAngle;
    self.endSunAngle = arcAngle;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - CAEHorizontalScrollView Delegate Methods
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)scrollViewSubviewDidChange:(NSInteger)index {
	self.currentHour = index;
	[self reloadViewsForWeather];
}

- (void)scrollViewPercentageAcrossSubview:(CGFloat)percentage {
	CAEWeatherHour *weatherHour = [self.hourlyWeather.weatherHours objectAtIndex:self.currentHour];
	self.view.backgroundColor = [self.astronomy backgroundColorFromWeatherHour:weatherHour hourPercentage:percentage];
    [self positionSunForWeatherHour:weatherHour hourPercentage:percentage];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UIViewController delegate methods
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (BOOL)prefersStatusBarHidden {
	return YES;
}

@end
