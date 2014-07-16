//
//  CAECloudsView.h
//  Caelus
//
//  Created by Thomas Strassner on 7/11/14.
//  Copyright (c) 2014 Enterprise Holdings, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CAEDiscreteMeterView.h"

@interface CAECloudsDataSource : NSObject <CAEDiscreteMeterViewDataSource>
- (instancetype)initWithChanceOfPrecipitation:(NSNumber *)probabilityOfPrecipitation;
@end

