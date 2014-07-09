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
 *  Divides the day into six different periods, with distinct sky brightness
 */
typedef NS_ENUM (NSInteger, LightPeriod) {
    /** From when the sun begins to brighten the sky till it is visible on the horizon */
    DAWN,
    /** From when the sun is first visible till when the sky is very bright */
    SUNRISE,
    /** When the sky is bright and relatively constant in brightness */
    DAY,
    /** From when the sky starts to dim till when the sun is no longer visible */
    SUNSET,
    /** From when the sun is no longer visible till when its light is no longer visible */
    DUSK,
    /** When no light is visible in the sky */
    NIGHT
};

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

/** Which light period it is based on astronomy data */
@property (nonatomic, readonly) LightPeriod lightPeriod;
@end
