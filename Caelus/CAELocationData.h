//
//  CAELocationData.h
//  Caelus
//
//  Created by Tom on 7/7/14.
//  Copyright (c) 2014 Enterprise Holdings, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  This object holds data about a location.
 *
 *  It should be initialized using the custom initializer.
 */
@interface CAELocationData : NSObject
/**
*  Sets the properties of the CAELocationData object based on values in locationDict
*
*  @param locationDict must be a dictionary parsed from the weather underground API conditions JSON response
*
*  @return initialized CAELocationData object
*/
- (id)initWithLocationDict:(NSDictionary *)locationDict;

/** name of the city (e.g. "San Francisco") */
@property (strong, nonatomic) NSString *city;
/** state name (e.g. "California") */
@property (strong, nonatomic) NSString *state;
/** state name abbreviation (e.g. "CA") */
@property (strong, nonatomic) NSString *stateAbbrev;
/** city, state (e.g. "San Francisco, CA") */
@property (strong, nonatomic) NSString *full;
/** city, state (e.g. "San Francisco, CA") */
@property (strong, nonatomic) NSString *country;
/** zip code (e.g. "94101") */
@property (strong, nonatomic) NSString *zip;
/** latitude (e.g. 37.77500916) */
@property (strong, nonatomic) NSNumber *lat;
/** longitute (e.g. -122.4182567) */
@property (strong, nonatomic) NSNumber *lon;
@end
