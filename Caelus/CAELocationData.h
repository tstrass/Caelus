//
//  CAELocationData.h
//  Caelus
//
//  Created by Tom on 7/7/14.
//  Copyright (c) 2014 Enterprise Holdings, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  A CAELocationData object should be initialized using the custom initializer. The NSDictionary it expects should
 *  contain information about a specific location. This dictionary needs to be from the display_location field of the
 *  weather underground conditions feature.
 */
@interface CAELocationData : NSObject
/**
 *  Custom initializer- should only be used if locationDict is the "display_location" dictionary parsed out of the
 *  weather underground API conditions response.
 */
- (id)initWithLocationDict:(NSDictionary *)locationDict;

@property (strong, nonatomic) NSString *city;           // name of the city (e.g. "San Francisco")
@property (strong, nonatomic) NSString *state;          // state name (e.g. "California")
@property (strong, nonatomic) NSString *stateAbbrev;    // state name abbreviation (e.g. "CA")
@property (strong, nonatomic) NSString *full;           // city, state (e.g. "San Francisco, CA")
@property (strong, nonatomic) NSString *country;        // country abbreviation (e.g. "US")
@property (strong, nonatomic) NSString *zip;            // zip code (e.g. "94101")
@property (strong, nonatomic) NSNumber *lat;            // latitude (e.g. 37.77500916)
@property (strong, nonatomic) NSNumber *lon;            // longitute (e.g. -122.4182567)
@end
