//
//  CAEDetailViewController.m
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
@property (weak, nonatomic) IBOutlet UILabel *astronomyLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *hourlyScrollView;

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

	[self setUpLocationManager];

	self.view.backgroundColor = [UIColor blackColor];

	//[self setUpAPIRequests];
	//[self sendRequestsAndParseData];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Set Up
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setUpLocationManager {
	self.locationManager = [[CLLocationManager alloc]init];
	self.locationManager.delegate = self;
	self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
	[self.locationManager startUpdatingLocation];
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

// temporary: to display raw current conditions weather data
- (void)layoutCurrentConditionsLabel {
	self.currentConditionsLabel.text = [NSString stringWithFormat:@"Current conditions in %@, %@:\n   %ld°F\n   Wind: %@\n   %f inches of rain", self.currentConditions.location.city, self.currentConditions.location.country, (long)[self.currentConditions.fTemp integerValue], self.currentConditions.windDescription, [self.currentConditions.precipHourIn floatValue]];
	self.currentConditionsLabel.numberOfLines = 4;
	self.currentConditionsLabel.font = [UIFont fontWithName:@"Times New Roman" size:12];
}

// temporary: to display raw astronomy data
- (void)layoutAstronomyLabel {
	self.astronomyLabel.text = [NSString stringWithFormat:@"Current Light Period: %@\nSunrise: %ld:%ld\nSunset: %ld:%ld\nMoon: %@\n            %ld%% illuminated\n             %ld days old", [self lightPeriodNameFromEnum], (long)[self.astronomy.sunPhase.sunriseHour integerValue], (long)[self.astronomy.sunPhase.sunriseMinute integerValue], (long)[self.astronomy.sunPhase.sunsetHour integerValue], (long)[self.astronomy.sunPhase.sunsetMinute integerValue], self.astronomy.moonPhase.phase, (long)[self.astronomy.moonPhase.percentIlluminated integerValue], (long)[self.astronomy.moonPhase.age integerValue]];
	self.astronomyLabel.numberOfLines = 6;
	self.astronomyLabel.font = [UIFont fontWithName:@"Times New Roman" size:12];
}

// temporary: to display raw hourly weather data
- (void)layoutHourlyScrollView {
	self.hourlyScrollView.backgroundColor = [UIColor whiteColor];
	CGFloat labelWidth = self.hourlyScrollView.frame.size.width - 10;
	int counter = 0;
	for (CAEWeatherHour *weatherHour in self.hourlyWeather.weatherHours) {
		UILabel *hourLabel = [[UILabel alloc] init];
		hourLabel.numberOfLines = 2;
		hourLabel.text = [NSString stringWithFormat:@"%@ %ld:00\n  %lu°F, %@ (%lu%% cloudy)", weatherHour.weekdayNameAbbrev, (long)weatherHour.hour, (long)weatherHour.temp, weatherHour.condition, (long)weatherHour.cloudCover];
		hourLabel.font = [UIFont fontWithName:@"Times New Roman" size:10];
		[hourLabel sizeToFit];
		hourLabel.frame = CGRectMake(5, 5, labelWidth, hourLabel.frame.size.height);

		UIView *hourView = [[UIView alloc] initWithFrame:CGRectMake(0, counter * 30, labelWidth + 10, hourLabel.frame.size.height + 5)];
		[hourView addSubview:hourLabel];
		[self.hourlyScrollView addSubview:hourView];
		counter++;
	}
	self.hourlyScrollView.contentSize = CGSizeMake(self.hourlyScrollView.frame.size.width, counter * 30);
}

- (void)formatLocationLabel {
	self.currentLocationLabel.text = [NSString stringWithFormat:@"Current Location: %@", self.geolocation];
	self.currentLocationLabel.font = [UIFont fontWithName:@"Times New Roman" size:12];
	self.currentLocationLabel.adjustsFontSizeToFitWidth = YES;
	self.currentLocationLabel.minimumScaleFactor = 0.3;
}

- (void)formatViewForWeather {
	[UIView animateWithDuration:1.0 animations: ^{
	    self.view.backgroundColor = [self backgroundColorFromWeatherData];
	}];
}

- (void)formatViewForFailedLocation {
    self.view.backgroundColor = [self backgroundColorFromWeatherData];
    self.currentLocationLabel.text = @"Where you at bra I can't tell";
    self.currentLocationLabel.font = [UIFont fontWithName:@"Times New Roman" size:12];
	self.currentLocationLabel.adjustsFontSizeToFitWidth = YES;
	self.currentLocationLabel.minimumScaleFactor = 0.3;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - CLLocationManager Delegate Methods
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
	[self.locationManager stopUpdatingLocation];

	CLGeocoder *geoCoder = [[CLGeocoder alloc] init];
	[geoCoder reverseGeocodeLocation:[locations lastObject] completionHandler: ^(NSArray *placemarks, NSError *error) {
	    self.geolocation = (placemarks.count > 0) ? [[placemarks objectAtIndex:0] locality]:@"Not Found";
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
	NSLog(@"parsed current weather json:\n%@", dict);

	if (dict) {
		self.currentConditions = [[CAECurrentConditions alloc] initWithConditionsDict:dict];
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
		self.astronomy = [[CAEAstronomy alloc] initWithAstronomyDict:dict];
		[self layoutAstronomyLabel];
	}
}

- (void)parseHourlyWeatherJSON {
	NSError *error;
	NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:self.hourlyWeatherResponseData
	                                                     options:kNilOptions
	                                                       error:&error];
	if (dict) {
		self.hourlyWeather = [[CAEHourlyWeather alloc] initWithHourlyDict:dict];
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
	NSLog(@"Determining background color with temp:%ld, sunrise:%ld:%ld, sunset:%ld:%ld", (long)[self.currentConditions.fTemp integerValue], (long)[self.astronomy.sunPhase.sunriseHour integerValue], (long)[self.astronomy.sunPhase.sunriseMinute integerValue], (long)[self.astronomy.sunPhase.sunsetHour integerValue], (long)[self.astronomy.sunPhase.sunsetMinute integerValue]);

	UIColor *backgroundColor = [[UIColor alloc] init];

	backgroundColor = [UIColor colorWithRed:0.561 green:0.883 blue:0.947 alpha:1.000];
	return backgroundColor;
}

- (UIColor *)colorFromLightPeriod:(LightPeriod)lightPeriod {
	UIColor *color = [[UIColor alloc] init];
	switch (lightPeriod) {
		case NIGHT :

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

- (NSString *)lightPeriodNameFromEnum {
	NSString *lightPeriodName;
	switch (self.astronomy.lightPeriod) {
		case NIGHT:
			lightPeriodName = @"Night";
			break;

		case DAWN:
			lightPeriodName = @"Dawn";
			break;

		case SUNRISE:
			lightPeriodName = @"Sunrise";
			break;

		case DAY:
			lightPeriodName = @"Day";
			break;

		case SUNSET:
			lightPeriodName = @"Sunset";
			break;

		case DUSK:
			lightPeriodName = @"Dusk";
			break;

		default:
			NSLog(@"Error: object does not have a valid lightPeriod");
			break;
	}
	return lightPeriodName;
}

@end
