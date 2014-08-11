//
//  CAEAstronomy.h
//  Caelus
//
//  Created by Thomas Strassner on 7/1/14.
//  Copyright (c) 2014 Enterprise Holdings, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CAESunPhase.h"
#import "CAEMoonPhase.h"

/**
 *  This object holds data about apparent behavior of the sun and moon, based off a single vantage point.
 *
 *  It should be initialized using the custom initializer.
 */
@interface CAEAstronomy : NSObject
/**
 *  Sets the properties of the CAEAstronomy object, based on values in astronomyDict
 *
 *  @param astronomyDict must be a dictionary serialized from the weather underground API astronomy JSON response
 *
 *  @return initialized CAEAstronomy object
 */
- (id)initWithAstronomyDict:(NSDictionary *)astronomyDict;

/** Holds data about the sun's behavior */
@property (strong, nonatomic)CAESunPhase *sunPhase;

/** Holds data about the moon's behavior */
@property (strong, nonatomic)CAEMoonPhase *moonPhase;
@end
