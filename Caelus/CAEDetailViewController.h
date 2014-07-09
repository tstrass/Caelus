//
//  CAEDetailViewController.h
//  Caelus
//
//  Created by Thomas Strassner on 6/20/14.
//  Copyright (c) 2014 Enterprise Holdings, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
typedef void (^weatherParsingComplete)(BOOL);
typedef void (^astronomyParsingComplete)(BOOL);

@interface CAEDetailViewController : UIViewController <UISplitViewControllerDelegate, NSURLConnectionDelegate, CLLocationManagerDelegate>

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end
