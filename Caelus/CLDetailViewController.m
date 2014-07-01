//
//  CLDetailViewController.m
//  Caelus
//
//  Created by Thomas Strassner on 6/20/14.
//  Copyright (c) 2014 Enterprise Holdings, Inc. All rights reserved.
//
#import "CLDetailViewController.h"
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

#import "CLAstronomy.h"

@interface CLDetailViewController ()
@property (strong, nonatomic) UIPopoverController *masterPopoverController;
- (void)configureView;

// UI objects in storyboard
@property (weak, nonatomic) IBOutlet UILabel *currentLocationLabel;
@property (weak, nonatomic) IBOutlet UILabel *tempLabel;

// Requests
@property (strong, nonatomic) NSMutableArray *requestsArray;

// Current weather data
@property (strong, nonatomic) NSURLConnection *currentWeatherConnection;
@property (strong, nonatomic) NSData *currentWeatherResponseData;
@property (strong, nonatomic) NSDictionary *currentWeatherDict;
@property (strong, nonatomic) NSNumber *fTemp;
@property (strong, nonatomic) NSString *city;
@property (strong, nonatomic) NSString *country;

// Astronomy data
@property (strong, nonatomic) NSURLConnection *astronomyConnection;
@property (strong, nonatomic) NSData *astronomyResponseData;
@property (strong, nonatomic) NSDictionary *sunDict;
@property (strong, nonatomic) CLAstronomy *astronomy;

@property (nonatomic) NSInteger currentMinuteTime;

// Geolocation
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) NSString *location;
@end

@implementation CLDetailViewController

#define DUSK_MINUTE = self.sunsetMinuteTime + 30;
#define DAWN_MINUTE = self.sunriseMinuteTime - 30;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Managing the detail item
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)configureView
{
    // Update the user interface for the detail item.

    if (self.detailItem) {
        self.detailDescriptionLabel.text = [self.detailItem description];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configureView];
//    self.locationManager = [[CLLocationManager alloc]init];
//    [self.locationManager setDelegate:self];
//    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
//    [self.locationManager startUpdatingLocation];
    
    self.requestsArray = [[NSMutableArray alloc] init];

    [self.view setBackgroundColor:[UIColor blackColor]];
    
    [self makeCurrentWeatherRequestWithLocation:nil];
    [self makeAstronomyRequestWithLocation:nil];
    
    [self sendRequestsAndParseData];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Format
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)formatLocationLabel {
    [self.currentLocationLabel setText:[NSString stringWithFormat:@"Current Location: %@", self.location]];
    [self.currentLocationLabel setAdjustsFontSizeToFitWidth:YES];
    [self.currentLocationLabel setMinimumScaleFactor:0.3];
}

- (void)layoutTempLabel {
    // make sure that we have a location and a temperature, alert user if not
    if ([self.location  isEqual: @""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Error: City name is invalid" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    } else if (!self.fTemp) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"Error: Could not retrieve temperature for %@", self.location] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    } else {
        [self.tempLabel setText:[NSString stringWithFormat:@"Current temperature in %@ is %d°F", self.location, [self.fTemp intValue]]];
        [self.tempLabel setAdjustsFontSizeToFitWidth:YES];
        [self.tempLabel setMinimumScaleFactor:0.3];
    }
}

- (void)formatViewForWeather {
    [UIView animateWithDuration:1.0 animations:^{
        [self.view setBackgroundColor:[self backgroundColorFromWeatherData]];
        [self layoutTempLabel];
    }];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - CLLocationManager Delegate Methods
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    [self.locationManager stopUpdatingLocation];
    
    // get the city name from the location found by the Location Manager
    CLGeocoder *geoCoder = [[CLGeocoder alloc] init];
    [geoCoder reverseGeocodeLocation:[locations lastObject] completionHandler:^(NSArray *placemarks, NSError *error) {
        self.location = (placemarks.count > 0) ? [[placemarks objectAtIndex:0] locality] : @"Not Found";
        [self formatLocationLabel];
        if (![self.location isEqualToString:@"Not Found"]) [self makeCurrentWeatherRequestWithLocation:self.location];
    }];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"self.locationManager:%@ didFailWithError:%@", manager, error);
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Request Set Up Methods
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)sendRequestsAndParseData {
    __block NSInteger outstandingRequests = self.requestsArray.count;
    for (NSURLRequest *request in self.requestsArray) {
        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            if ([self.requestsArray indexOfObject:request] == 0) {
                [self setCurrentWeatherResponseData:data];
                [self parseCurrentWeatherJSON];
            } else if ([self.requestsArray indexOfObject:request] == 1) {
                [self setAstronomyResponseData:data];
                [self parseAstronomyJSON];
            }
            outstandingRequests--;
            if (outstandingRequests == 0) [self formatViewForWeather];
        }];
    }
}

- (void)makeCurrentWeatherRequestWithLocation:(NSString *)location {
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

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Data Parsing
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)parseCurrentWeatherJSON {
    // parse JSON, ensure that all fields we need are populated
    NSError* error;
    NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:self.currentWeatherResponseData options:kNilOptions error:&error];
    NSLog(@"parsed current weather json:\n%@", dict);
    
    if (dict) {
        [self setCurrentWeatherDict:[dict objectForKey:@"current_observation"]];
        [self setFTemp:[self.currentWeatherDict objectForKey:@"temp_f"]];
    
        NSDictionary *displayLocation = [self.currentWeatherDict objectForKey:@"display_location"];
        [self setCity:[displayLocation objectForKey:@"city"]];
        [self setCountry:[displayLocation objectForKey:@"country"]];
        //only append the country abbreviation if the city and country both exist in the JSON
        if (![self.city isEqualToString:@""] && ![self.country isEqualToString:@""]) {
            [self setLocation:[NSString stringWithFormat:@"%@, %@", self.city, self.country]];
        } else {
            [self setLocation:self.city];
        }
    }
}

- (void)parseAstronomyJSON {
    // parse JSON, ensure that all fields we need are populated
    NSError* error;
    NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:self.astronomyResponseData options:kNilOptions error:&error];
    NSLog(@"parsed astronomy json:\n%@", dict);
    
    if (dict) {
        [self setSunDict:[dict objectForKey:@"sun_phase"]]; // We're only interested in data about the sun
        
        NSDictionary *sunriseDict = [self.sunDict objectForKey:@"sunrise"];
        NSDictionary *sunsetDict = [self.sunDict objectForKey:@"sunset"];
        
        self.astronomy = [[CLAstronomy alloc] initWithSunriseHour:[sunriseDict objectForKey:@"hour"]
                                                    SunriseMinute:[sunriseDict objectForKey:@"minute"]
                                                       SunsetHour:[sunsetDict objectForKey:@"hour"]
                                                     SunsetMinute:[sunsetDict objectForKey:@"minute"]];
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
    
    NSLog(@"Determining background color with temp:%d, sunrise:%d:%d, sunset:%d:%d", [self.fTemp intValue], [self.astronomy.sunriseHour intValue], [self.astronomy.sunriseMinute intValue], [self.astronomy.sunsetHour intValue], [self.astronomy.sunsetMinute intValue]);
    UIColor *backgroundColor = [[UIColor alloc] init];
    
    backgroundColor = [UIColor colorWithRed:1.000 green:0.981 blue:0.273 alpha:1.000];
    return backgroundColor;
}

@end
