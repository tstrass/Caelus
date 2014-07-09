//
//  CAEMoonPhase.h
//  Caelus
//
//  Created by Tom on 7/7/14.
//  Copyright (c) 2014 Enterprise Holdings, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  This object holds data about the moon's current state.
 *
 *  It should be initialized using the custom initializer.
 */
@interface CAEMoonPhase : NSObject
/**
 *  Sets the properties of the CAESunPhase object based on values in sunPhaseDict
 *
 *  @param sunPhaseDict must be a dictionary parsed from the
 *
 *  @return initialized CAESunPhase object
 */
- (id)initWithMoonDict:(NSDictionary *)moonDict;

/** number of days since new moon */
@property (strong, nonatomic) NSNumber *age;
/** percent illuminated by the sun */
@property (strong, nonatomic) NSNumber *percentIlluminated;
/** current phase the moon is in */
@property (strong, nonatomic) NSString *phase;
@end
