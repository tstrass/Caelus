//
//  CAEMoonPhase.h
//  Caelus
//
//  Created by Tom on 7/7/14.
//  Copyright (c) 2014 Enterprise Holdings, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CAEMoonPhase : NSObject
- (id)initWithMoonDict:(NSDictionary *)moonDict;

@property (strong, nonatomic) NSNumber *age;
@property (strong, nonatomic) NSNumber *percentIlluminated;
@property (strong, nonatomic) NSString *phase;
@end
