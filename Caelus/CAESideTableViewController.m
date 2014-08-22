//
//  CAESideTableViewController.m
//  Caelus
//
//  Created by Thomas Strassner on 8/14/14.
//  Copyright (c) 2014 Enterprise Holdings, Inc. All rights reserved.
//

#import "CAESideTableViewController.h"

#import "UIViewController+ECSlidingViewController.h"
#import "CAEWeatherViewController.h"

@interface CAESideTableViewController ()
@property (nonatomic, strong) NSArray *menuItems;

//@property (nonatomic, strong) UINavigationController *weatherVC;
@property (nonatomic, strong) CAEWeatherViewController *weatherVC;
@end

@implementation CAESideTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // hide the status bar
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
        // iOS 7
        [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
    }
    else {
        // iOS 6
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    }

    // A promise that the top view controller will be a CAEWeatherViewController. This is determined in the xib
    self.weatherVC = (CAEWeatherViewController *)self.slidingViewController.topViewController;
}

- (NSArray *)menuItems {
    // Lazy instantiation
    
    if (_menuItems) return _menuItems;
    
    // locations for which mock service returns data
    _menuItems = @[@"Clayton", @"Tufts"];
    
    return _menuItems;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Table view data source
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.menuItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *reuseIdentifier = @"MenuCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    }
    
    NSString *menuItem = self.menuItems[indexPath.row];
    cell.textLabel.text = menuItem;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *menuItem = self.menuItems[indexPath.row];
    
    self.weatherVC.mockServiceLocation = [menuItem lowercaseString];
    self.slidingViewController.topViewController = self.weatherVC;
    
    [self.slidingViewController resetTopViewAnimated:YES];
}


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UIViewController delegate methods
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (BOOL)prefersStatusBarHidden {
    return YES;
}

@end
