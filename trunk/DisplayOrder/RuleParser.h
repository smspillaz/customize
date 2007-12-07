/**
 * RuleParser.h
 * This file is part of Customize by The Spicy Chicken
 *
 * Parses a rule file and performs tasks on an appObject array.
**/

#import <Foundation/Foundation.h>
#import <CoreFoundation/CoreFoundation.h>
#import <UIKit/CDStructures.h>

@interface RuleParser : NSObject
{
  
}

- (NSMutableArray *) applyRules:(NSString *)pathToRules toArray:(NSMutableArray *) appObjects;

- (NSMutableArray *) moveObjectsIn:(NSMutableArray *)appObjects toMatchArray:(NSArray *)order;

- (NSString *) textForRules:(NSString *)pathToRules;

- (int) searchAppObjects:(NSArray *)appObjects forIdentifier:(NSString*)identifier;

@end