//
//  CAELocationData.m
//  Caelus
//
//  Created by Tom on 7/7/14.
//  Copyright (c) 2014 Enterprise Holdings, Inc. All rights reserved.
//
#import "CAELocationData.h"
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

@implementation CAELocationData

- (id)initWithLocationDict:(NSDictionary *)locationDict {
	self = [super init];
	if (self) {
		[self parseLocationDict:locationDict];
	}
	return self;
}

/**
 *  Parses information we are interested in about location. Using this information, this sets the corresponding
 *  public properties of the object.
 *
 *  @param locationDict is a dictionary containing information a location. This dictionary is parsed out of the response
 *                      data from the weather underground API conditions weather feature.
 */
- (void)parseLocationDict:(NSDictionary *)locationDict {
	if (locationDict) {
		[self setCity:[locationDict objectForKey:@"city"]];
		[self setState:[locationDict objectForKey:@"state_name"]];
		[self setStateAbbrev:[locationDict objectForKey:@"state"]];
		[self setFull:[locationDict objectForKey:@"full"]];
		[self setCountry:[locationDict objectForKey:@"country"]];
		[self setZip:[locationDict objectForKey:@"zip"]];
		[self setLat:[locationDict objectForKey:@"latitude"]];
		[self setLon:[locationDict objectForKey:@"longitude"]];
	}
}

@end
