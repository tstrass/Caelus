//
//  CAECloudsView.h
//  Caelus
//
//  Created by Thomas Strassner on 7/11/14.
//  Copyright (c) 2014 Enterprise Holdings, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CAECloudsViewDelegate;

@interface CAECloudsView : UIView
@property (weak) id<CAECloudsViewDelegate> delegate;

- (void)reload;
@end

@protocol CAECloudsViewDelegate <NSObject>
@required
- (NSInteger)maxNumberOfCloudsForCloudView:(CAECloudsView *)cloudView;
- (NSInteger)numberOfCloudsForCloudView:(CAECloudsView *)cloudView;

@optional

@end