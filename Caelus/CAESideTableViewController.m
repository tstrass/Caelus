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
    
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
        // iOS 7
        [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
    }
    else {
        // iOS 6
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    }

    
    self.weatherVC = (CAEWeatherViewController *)self.slidingViewController.topViewController;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSArray *)menuItems {
    if (_menuItems) return _menuItems;
    
    _menuItems = @[@"Clayton", @"Tufts"];
    
    return _menuItems;
}

#pragma mark - Table view data source

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    return 1;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
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
    
    
    NSString *locationName = self.menuItems[indexPath.row];
    self.weatherVC.mockServiceLocation = [locationName lowercaseString];
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
