/**
 * RuleParser.h
 * This file is part of Customize by The Spicy Chicken
 *
 * Parses a rule file and performs tasks on an appObject array.
**/

#import <Foundation/Foundation.h>
#import <CoreFoundation/CoreFoundation.h>
#import <UIKit/CDStructures.h>
#import "RuleParser.h"
#import "AppObject.h"

/**
 * Sorting function for AppObject name
**/
int alphaSortOnName(AppObject* one, AppObject* two, void *context)
{
  return [[one name] caseInsensitiveCompare:[two name]];
}

@implementation RuleParser : NSObject

/**
 * Parses the rules and returns text describing
 * the action to be taken.
**/
- (NSString *) textForRules:(NSString *)pathToRules
{
  NSString *text = [[NSString alloc] init];
  
  NSDictionary  *rules = [[NSDictionary alloc] initWithContentsOfFile:pathToRules];
  NSEnumerator *enumerator = [rules keyEnumerator];
  NSString *key;
  
  int i = 1;
  // Iterate through the rules, applying them as we go.
  while ((key = [enumerator nextObject]))
  {
    if ([key isEqualToString:@"sort"])
    {
      if ([[rules objectForKey:key] isEqualToString:@"NAME_ASCENDING"]) {
        
        text = [text stringByAppendingFormat:@"%i. Sort Apps by Name Ascending\n",i];
        i++;
        
      } else {
        
        text = [text stringByAppendingFormat:@"%i. Invalid Rule: %@\n",i,[rules objectForKey:key]];
        i++;
      }
    }
    
    if ([key isEqualToString:@"move"])
    {
      // The first string in the array is reserved for a description.
      text = [text stringByAppendingFormat:@"%i. %@\n",i,[[rules objectForKey:key] objectAtIndex:0]];
      i++;
    }
  }
  
  return text;
}

/**
 * Only method that needs to be called from the outside.  Will mutate the appObjects
 * array according to the rules found in the plist at the pathToRules
**/
- (NSMutableArray *) applyRules:(NSString *)pathToRules toArray:(NSMutableArray *) appObjects
{
  
  NSDictionary  *rules = [[NSDictionary alloc] initWithContentsOfFile:pathToRules];
  NSEnumerator *enumerator = [rules keyEnumerator];
  NSString *key;
  
  // Iterate through the rules, applying them as we go.
  while ((key = [enumerator nextObject]))
  {
    if ([key isEqualToString:@"sort"])
    {
      if ([[rules objectForKey:key] isEqualToString:@"NAME_ASCENDING"]) {
        NSLog(@"Sorted the appObjects by NAME_ASCENDING");
        appObjects = [appObjects sortedArrayUsingFunction:alphaSortOnName context:Nil];
      } else {
        NSLog(@"Unknown descriptor for sort rule: %@",[rules objectForKey:key]);
      }
    }
    
    if ([key isEqualToString:@"move"])
    {
      NSLog(@"Moving array to match %@",[rules objectForKey:key]);
      appObjects = [self moveObjectsIn:appObjects toMatchArray:[rules objectForKey:key]];
    }
  }
  
  return appObjects;
}

- (NSMutableArray *) moveObjectsIn:(NSMutableArray *)objects toMatchArray:(NSArray *)order
{
  int i;
  
  NSMutableArray *appObjects = [[NSMutableArray alloc] initWithArray:objects];
  
  for (i=1;i<[order count];i++)
  {
    // Load indentifier from the order array
    NSString *identifier = [order objectAtIndex:i];
    
    // Search for the identifier in the appObjects
    int position;
    if ((position = [self searchAppObjects:appObjects forIdentifier:identifier]) != -1)
    {
      // This identifier is in the list.  We move it to it's new position (i - 1).
      
      AppObject *copy = [appObjects objectAtIndex:position];
      
      [appObjects removeObjectAtIndex:position];
      
      [appObjects insertObject:copy atIndex:(i-1)];
    }
  }
  
  return appObjects;
}

/**
 * Utility method, pulls the position where identifier is located in appObjects
 * returns -1 if not found.
**/
- (int) searchAppObjects:(NSArray *)appObjects forIdentifier:(NSString*)identifier
{
	int pos = -1;
	bool found = NO;
	int i = 0;
	
	while (!found && i < [appObjects count])
	{
		AppObject* app = [appObjects objectAtIndex:i];
		if ([[app identifier] isEqualToString:identifier])
		{
			found = YES;
			pos = i;
		} 
		i += 1;	
	}
	return pos;
}

@end