//
//  CLDetailViewController.m
//  Caelus
//
//  Created by Thomas Strassner on 6/20/14.
//  Copyright (c) 2014 Enterprise Holdings, Inc. All rights reserved.
//

#import "CLDetailViewController.h"

@interface CLDetailViewController ()
@property (strong, nonatomic) UIPopoverController *masterPopoverController;
- (void)configureView;

//UI objects in storyboard
@property (weak, nonatomic) IBOutlet UILabel *currentLocationLabel;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIButton *getTempButton;
@property (weak, nonatomic) IBOutlet UILabel *tempLabel;

//Data from API
@property (strong, nonatomic) NSMutableData *responseData;

//Geolocation
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) NSString *location;
@end

@implementation CLDetailViewController

#define OK 200

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }

    if (self.masterPopoverController != nil) {
        [self.masterPopoverController dismissPopoverAnimated:YES];
    }        
}

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
    
    [self.locationManager setDelegate:self];
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    [self.locationManager startUpdatingLocation];
    [self formatLocationLabel];
}

#pragma mark - Formatting Subviews
- (void)formatLocationLabel {
    [self.currentLocationLabel setText:[NSString stringWithFormat:@"Current Location: %@", self.location]];
    [self.currentLocationLabel setAdjustsFontSizeToFitWidth:YES];
    [self.currentLocationLabel setMinimumScaleFactor:0.3];
}

- (void)layoutTempLabelWithTemp:(NSNumber *)temp {
    // make sure that we have a location and a temperature
    if ([self.location  isEqual: @""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Error: City name is invalid" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    } else if (!temp) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"Error: Could not retrieve temperature for %@", self.location] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    } else {
        [self.tempLabel setText:[NSString stringWithFormat:@"Current temperature in %@ is %d°F", self.location, [temp intValue]]];
        [self.tempLabel setAdjustsFontSizeToFitWidth:YES];
        [self.tempLabel setMinimumScaleFactor:0.3];
    }
}

#pragma mark - Split view

- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController
{
    barButtonItem.title = NSLocalizedString(@"Master", @"Master");
    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    self.masterPopoverController = popoverController;
}

- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    // Called when the view is shown again in the split view, invalidating the button and popover controller.
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    self.masterPopoverController = nil;
}

#pragma mark - CLLocationManager Delegate Methods

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    [self.locationManager stopUpdatingLocation];
    
    CLGeocoder *geoCoder = [[CLGeocoder alloc] init];
    [geoCoder reverseGeocodeLocation:[locations lastObject] completionHandler:^(NSArray *placemarks, NSError *error) {
        self.location = (placemarks.count > 0) ? [[placemarks objectAtIndex:0] locality] : @"Not Found";
    }];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"self.locationManager:%@ didFailWithError:%@", manager, error);
}


#pragma mark - IBActions

- (IBAction)buttonPressed:(id)sender {
    NSString *location = self.textField.text;
    if (location.length > 0) {
        NSString *weatherRequest = [NSString stringWithFormat:@"http://api.openweathermap.org/data/2.5/weather?q=%@,usa", location];
        NSURL *apiURL = [NSURL URLWithString:weatherRequest];
        NSURLRequest *request = [NSURLRequest requestWithURL:apiURL];
        NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
        NSLog(@"connection: %@", connection);
    } else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"You must enter a city name in the text field." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }
}

#pragma mark - NSURLConnection Delegate Methods

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
    
    NSError* error;
    NSDictionary* json = [NSJSONSerialization
                          JSONObjectWithData:self.responseData
                          options:kNilOptions
                          error:&error];
    NSLog(@"parsed json:\n%@", json);
    [self parseJSONDict:json];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    // The request has failed for some reason!
    // Check the error var
}

#pragma mark - Data Parsing

- (void)parseJSONDict:(NSDictionary *)dict {
    if (dict) {
        NSNumber *statusCode = [dict objectForKey:@"cod"];
        if (statusCode.intValue != OK) {
            NSString *errorMessage = [dict objectForKey:@"message"];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:errorMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            [self.textField setText:@""];
        } else {
            NSDictionary *mainInfo = [dict objectForKey:@"main"];
            NSNumber *kelvinTemp = [mainInfo objectForKey:@"temp"];
            [self setLocation:[dict objectForKey:@"name"]];
            [self layoutTempLabelWithTemp:[self farenheitFromKelvin:kelvinTemp]];
        }
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"An error occured. Please try again." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}

- (NSNumber *)farenheitFromKelvin:(NSNumber *)kelvin {
    return [NSNumber numberWithFloat:([kelvin floatValue] - 273.15) * 1.8 + 32.0];
}

@end
