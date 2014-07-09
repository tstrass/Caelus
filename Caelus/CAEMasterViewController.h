//
//  CAEMasterViewController.h
//  Caelus
//
//  Created by Thomas Strassner on 6/20/14.
//  Copyright (c) 2014 Enterprise Holdings, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CAEDetailViewController;

@interface CAEMasterViewController : UITableViewController

@property (strong, nonatomic) CAEDetailViewController *detailViewController;

@end
