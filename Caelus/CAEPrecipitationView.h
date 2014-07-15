//
//  CAEPrecipitationView.h
//  Caelus
//
//  Created by Thomas Strassner on 7/15/14.
//  Copyright (c) 2014 Enterprise Holdings, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CAEPrecipitationViewDelegate;

typedef NS_ENUM(NSInteger, PrecipitationType) {
    RAIN,
    SNOW,
    HAIL
};

@interface CAEPrecipitationView : UIView
@property (weak) id<CAEPrecipitationViewDelegate> delegate;

- (void)reload;
@end

@protocol CAEPrecipitationViewDelegate <NSObject>
@required

/** percentage chance of precipitation, scale of 0-100 */
- (NSNumber *)propabilityOfPrecipitation;
/** must be one of: RAIN, SNOW, or HAIL */
- (PrecipitationType)precipitationType;

@end