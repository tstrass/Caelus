//
//  CLDetailViewController.m
//  Caelus
//
//  Created by Thomas Strassner on 6/20/14.
//  Copyright (c) 2014 Enterprise Holdings, Inc. All rights reserved.
//
#import "CAEDetailViewController.h"
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// Model
#import "CAECurrentConditions.h"
#import "CAEAstronomy.h"
#import "CAEHourlyWeather.h"

@interface CAEDetailViewController ()
@property (strong, nonatomic) UIPopoverController *masterPopoverController;
- (void)configureView;

// UI objects in storyboard
@property (weak, nonatomic) IBOutlet UILabel *currentLocationLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentConditionsLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *hourlyScrollView;

// Requests
@property (strong, nonatomic) NSMutableArray *requestsArray;

// Current weather data
@property (strong, nonatomic) NSData *currentConditionsResponseData;
@property (strong, nonatomic) CAECurrentConditions *currentConditions;

// Astronomy data
@property (strong, nonatomic) NSData *astronomyResponseData;
@property (strong, nonatomic) NSDictionary *sunDict;
@property (strong, nonatomic) CAEAstronomy *astronomy;

// Hourly weather data
@property (strong, nonatomic) NSData *hourlyWeatherResponseData;
@property (strong, nonatomic) CAEHourlyWeather *hourlyWeather;

// Geolocation
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) NSString *location;
@end

@implementation CAEDetailViewController

#define DUSK_MINUTE = self.sunsetMinuteTime + 30;
#define DAWN_MINUTE = self.sunriseMinuteTime - 30;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Managing the detail item
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)configureView {
	// Update the user interface for the detail item.

	if (self.detailItem) {
		self.detailDescriptionLabel.text = [self.detailItem description];
	}
}

- (void)viewDidLoad {
	[super viewDidLoad];
	[self configureView];
//    self.locationManager = [[CLLocationManager alloc]init];
//    [self.locationManager setDelegate:self];
//    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
//    [self.locationManager startUpdatingLocation];

	self.requestsArray = [[NSMutableArray alloc] init];

	[self.view setBackgroundColor:[UIColor blackColor]];

	[self makeCurrentConditionsRequestWithLocation:nil];
	[self makeAstronomyRequestWithLocation:nil];
	[self makeHourlyWeatherRequestWithLocation:nil];

	[self sendRequestsAndParseData];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Format
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// temporary: to display raw current conditions weather data
- (void)layoutCurrentConditionsLabel {
	[self.currentConditionsLabel setText:[NSString stringWithFormat:@"Current conditions in %@, %@:\n   %d°F\n   Wind: %@\n   %f inches of rain", self.currentConditions.location.city, self.currentConditions.location.stateAbbrev, [self.currentConditions.fTemp intValue], self.currentConditions.windDescription, [self.currentConditions.precipHourIn floatValue]]];
	[self.currentConditionsLabel setNumberOfLines:4];
	[self.currentConditionsLabel setFont:[UIFont fontWithName:@"Times New Roman" size:12]];
}

// temporary: to display raw hourly weather data
- (void)layoutHourlyScrollView {
	[self.hourlyScrollView setBackgroundColor:[UIColor whiteColor]];
	CGFloat labelWidth = self.hourlyScrollView.frame.size.width - 10;
	int counter = 0;
	for (CAEWeatherHour *weatherHour in self.hourlyWeather.weatherHours) {
		UILabel *hourLabel = [[UILabel alloc] init];
		[hourLabel setNumberOfLines:2];
		[hourLabel setText:[NSString stringWithFormat:@"%@ %ld:00\n  %lu°F, %@ (%lu%% cloudy)", weatherHour.weekdayNameAbbrev, (long)weatherHour.hour, (long)weatherHour.temp, weatherHour.condition, (long)weatherHour.cloudCover]];
		[hourLabel setFont:[UIFont fontWithName:@"Times New Roman" size:10]];
		[hourLabel sizeToFit];
		[hourLabel setFrame:CGRectMake(5, 5, labelWidth, hourLabel.frame.size.height)];

		UIView *hourView = [[UIView alloc] initWithFrame:CGRectMake(0, counter * 30, labelWidth + 10, hourLabel.frame.size.height + 5)];
		[hourView addSubview:hourLabel];
		[self.hourlyScrollView addSubview:hourView];
		counter++;
	}
	[self.hourlyScrollView setContentSize:CGSizeMake(self.hourlyScrollView.frame.size.width, counter * 30)];
}

- (void)formatLocationLabel {
	[self.currentLocationLabel setText:[NSString stringWithFormat:@"Current Location: %@", self.location]];
	[self.currentLocationLabel setAdjustsFontSizeToFitWidth:YES];
	[self.currentLocationLabel setMinimumScaleFactor:0.3];
}

- (void)formatViewForWeather {
	[UIView animateWithDuration:1.0 animations: ^{
	    [self.view setBackgroundColor:[self backgroundColorFromWeatherData]];
	}];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - CLLocationManager Delegate Methods
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
	[self.locationManager stopUpdatingLocation];

	// get the city name from the location found by the Location Manager
	CLGeocoder *geoCoder = [[CLGeocoder alloc] init];
	[geoCoder reverseGeocodeLocation:[locations lastObject] completionHandler: ^(NSArray *placemarks, NSError *error) {
	    self.location = (placemarks.count > 0) ? [[placemarks objectAtIndex:0] locality] : @"Not Found";
	    [self formatLocationLabel];
	    if (![self.location isEqualToString:@"Not Found"]) [self makeCurrentConditionsRequestWithLocation:self.location];
	}];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
	NSLog(@"self.locationManager:%@ didFailWithError:%@", manager, error);
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
		        [self setCurrentConditionsResponseData:data];
		        [self parseCurrentWeatherJSON];
			}
		    else if ([self.requestsArray indexOfObject:request] == 1) {
		        [self setAstronomyResponseData:data];
		        [self parseAstronomyJSON];
			}
		    else if ([self.requestsArray indexOfObject:request] == 2) {
		        [self setHourlyWeatherResponseData:data];
		        [self parseHourlyWeatherJSON];
			}
		    outstandingRequests--;
		    if (outstandingRequests == 0) [self formatViewForWeather];
		}];
	}
}

- (void)makeCurrentConditionsRequestWithLocation:(NSString *)location {
	// encode city search for URL and make URL request
	NSString *weatherRequest = [NSString stringWithFormat:@"http://api.wunderground.com/api/f29e980ec760f4cc/conditions/q/CA/San_Francisco.json"];
	NSURL *apiURL = [NSURL URLWithString:weatherRequest];
	NSURLRequest *request = [[NSURLRequest alloc] initWithURL:apiURL];
	[self.requestsArray addObject:request];
}

- (void)makeAstronomyRequestWithLocation:(NSString *)location {
	// encode city search for URL and make URL request
	NSString *astronomyRequest = [NSString stringWithFormat:@"http://api.wunderground.com/api/f29e980ec760f4cc/astronomy/q/CA/San_Francisco.json"];
	NSURL *apiURL = [NSURL URLWithString:astronomyRequest];
	NSURLRequest *request = [[NSURLRequest alloc] initWithURL:apiURL];
	[self.requestsArray addObject:request];
}

- (void)makeHourlyWeatherRequestWithLocation:(NSString *)location {
	// encode city search for URL and make URL request
	NSString *hourlyRequest = [NSString stringWithFormat:@"http://api.wunderground.com/api/f29e980ec760f4cc/hourly/q/CA/San_Francisco.json"];
	NSURL *apiURL = [NSURL URLWithString:hourlyRequest];
	NSURLRequest *request = [[NSURLRequest alloc] initWithURL:apiURL];
	[self.requestsArray addObject:request];
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
	NSLog(@"parsed current weather json:\n%@", dict);

	if (dict) {
		self.currentConditions = [[CAECurrentConditions alloc] initWithJSONDict:dict];
		[self layoutCurrentConditionsLabel];
	}
}

- (void)parseAstronomyJSON {
	// parse JSON, ensure that all fields we need are populated
	NSError *error;
	NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:self.astronomyResponseData
	                                                     options:kNilOptions
	                                                       error:&error];
	NSLog(@"parsed astronomy json:\n%@", dict);

	if (dict) {
		[self setSunDict:[dict objectForKey:@"sun_phase"]]; // We're only interested in data about the sun

		NSDictionary *sunriseDict = [self.sunDict objectForKey:@"sunrise"];
		NSDictionary *sunsetDict = [self.sunDict objectForKey:@"sunset"];

		self.astronomy = [[CAEAstronomy alloc] initWithSunriseHour:[sunriseDict objectForKey:@"hour"]
		                                             SunriseMinute:[sunriseDict objectForKey:@"minute"]
		                                                SunsetHour:[sunsetDict objectForKey:@"hour"]
		                                              SunsetMinute:[sunsetDict objectForKey:@"minute"]];
	}
}

- (void)parseHourlyWeatherJSON {
	NSError *error;
	NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:self.hourlyWeatherResponseData
	                                                     options:kNilOptions
	                                                       error:&error];
	if (dict) {
		self.hourlyWeather = [[CAEHourlyWeather alloc] initWithJSONDict:dict];
		[self layoutHourlyScrollView];
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Utilities for data presentation
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/**
 *  Determine the background color, based on temp and sunniness
 *
 *  @return background color
 */
- (UIColor *)backgroundColorFromWeatherData {
	NSLog(@"Determining background color with temp:%d, sunrise:%d:%d, sunset:%d:%d", [self.currentConditions.fTemp intValue], [self.astronomy.sunriseHour intValue], [self.astronomy.sunriseMinute intValue], [self.astronomy.sunsetHour intValue], [self.astronomy.sunsetMinute intValue]);

	UIColor *backgroundColor = [[UIColor alloc] init];

	backgroundColor = [UIColor colorWithRed:1.000 green:0.981 blue:0.273 alpha:1.00];
	return backgroundColor;
}

- (UIColor *)colorFromLightPeriod:(LightPeriod)lightPeriod {
	UIColor *color = [[UIColor alloc] init];
	switch (lightPeriod) {
		case NIGHT:

			break;

		case DAWN:

			break;

		case SUNRISE:

			break;

		case DAY:

			break;

		case SUNSET:

			break;

		case DUSK:

			break;

		default:
			break;
	}
	return color;
}

@end
