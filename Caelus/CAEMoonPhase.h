//
//  CAEMoonPhase.h
//  Caelus
//
//  Created by Tom on 7/7/14.
//  Copyright (c) 2014 Enterprise Holdings, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  A CAEMoonPhase object should be initialized using the custom initializer. The NSDictionary it expects should be
 *  a dictionary containing information about an the moon phase for the day, and it should be parsed out of the weather
 *  underground API response for astronomy data.
 */
@interface CAEMoonPhase : NSObject
// custom initializer
- (id)initWithMoonDict:(NSDictionary *)moonDict;

@property (strong, nonatomic) NSNumber *age;                        // number of days since new moon
@property (strong, nonatomic) NSNumber *percentIlluminated;         // percent illuminated by the sun
@property (strong, nonatomic) NSString *phase;                      // current phase the moon is in
@end
