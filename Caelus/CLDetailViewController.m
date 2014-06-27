//
//  CLDetailViewController.m
//  Caelus
//
//  Created by Thomas Strassner on 6/20/14.
//  Copyright (c) 2014 Enterprise Holdings, Inc. All rights reserved.
//
#import "CLDetailViewController.h"
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

@interface CLDetailViewController ()
@property (strong, nonatomic) UIPopoverController *masterPopoverController;
- (void)configureView;

// UI objects in storyboard
@property (weak, nonatomic) IBOutlet UILabel *currentLocationLabel;
@property (weak, nonatomic) IBOutlet UILabel *tempLabel;

// Data from weather API
@property (strong, nonatomic) NSMutableData *responseData;

// Current weather data
@property (strong, nonatomic) NSDictionary *currentWeatherDict;
@property (strong, nonatomic) NSNumber *fTemp;
@property (strong, nonatomic) NSString *city;
@property (strong, nonatomic) NSString *country;

// Astronomy data
@property (strong, nonatomic) NSDictionary *astronomyDict;
@property (strong, nonatomic) NSDictionary *sunrise;
@property (strong, nonatomic) NSDictionary *sunset;

// Geolocation
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) NSString *location;
@end

@implementation CLDetailViewController

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
    
    [self makeCurrentWeatherRequestWithLocation:nil]; // temporary, for testing
    [self parseCurrentWeatherJSON];
    
    [self makeAstronomyRequestWithLocation:nil];
    [self parseAstronomyJSON];
    
    [self formatViewForWeather];
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
    [self.view setBackgroundColor:[CLDetailViewController backgroundColorFromTemp:self.fTemp]];
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

- (void)makeCurrentWeatherRequestWithLocation:(NSString *)location {
    // encode city search for URL and make URL request
    NSString *weatherRequest = [NSString stringWithFormat:@"http://api.wunderground.com/api/f29e980ec760f4cc/conditions/q/CA/San_Francisco.json"];
    NSURL *apiURL = [NSURL URLWithString:weatherRequest];
    NSURLRequest *request = [NSURLRequest requestWithURL:apiURL];
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    NSLog(@"connection: %@", connection);
}

- (void)makeAstronomyRequestWithLocation:(NSString *)location {
    // encode city search for URL and make URL request
    NSString *astronomyRequest = [NSString stringWithFormat:@"http://api.wunderground.com/api/f29e980ec760f4cc/astronomy/q/CA/San_Francisco.json"];
    NSURL *apiURL = [NSURL URLWithString:astronomyRequest];
    NSURLRequest *request = [NSURLRequest requestWithURL:apiURL];
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    NSLog(@"connection: %@", connection);
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - NSURLConnection Delegate Methods
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    // A response has been received, this is where we initialize the instance var you created
    // so that we can append data to it in the didReceiveData method
    // Furthermore, this method is called each time there is a redirect so reinitializing it
    // also serves to clear it
    self.responseData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    // Append the new data to the instance variable you declared
    [self.responseData appendData:data];
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
                  willCacheResponse:(NSCachedURLResponse*)cachedResponse {
    // Return nil to indicate not necessary to store a cached response for this connection
    return nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    // The request is complete and data has been received
    // You can parse the stuff in your instance variable now
    
    NSLog(@"JSON is %@", self.responseData);
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    // The request has failed for some reason!
    // Check the error var
    NSLog(@"NSURLConnection:%@ didFailWithError:%@", connection, error);
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Data Parsing
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)parseCurrentWeatherJSON {
    // parse JSON, ensure that all fields we need are populated
    NSError* error;
    NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:self.responseData options:kNilOptions error:&error];
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
//        [self layoutTempLabel];
    }
}

- (void)parseAstronomyJSON {
    // parse JSON, ensure that all fields we need are populated
    NSError* error;
    NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:self.responseData options:kNilOptions error:&error];
    NSLog(@"parsed astronomy json:\n%@", dict);
    
    if (dict) {
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Utilities for data presentation
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/**
 *  Determine the background color, based on various weather attributes
 *
 *  @param temp - temperature in farenheit
 *
 *  @return background color
 */
+ (UIColor *)backgroundColorFromTemp:(NSNumber *)temp {
    UIColor *backgroundColor = [[UIColor alloc] init];
    backgroundColor = [UIColor colorWithRed:1.000 green:0.981 blue:0.273 alpha:1.000];
    return backgroundColor;
}


@end
