/**
 * ConfigureView.h
 * This file is part of Customize by The Spicy Chicken
 *
 * Allows the user to configure customize to match their system
**/

#import <Foundation/Foundation.h>
#import <CoreFoundation/CoreFoundation.h>
#import <UIKit/CDStructures.h>
#import <UIKit/UIApplication.h>
#import <UIKit/UIPreferencesTable.h>
#import "DeviceInfo.h"

@interface ConfigureView : UIView
{
	UIApplication*		_application;
	
	bool							_built;
	
	NSMutableArray*		_prefCells;
	UIPreferencesTable* _table;
	
	NSMutableDictionary* _version;
	
	DeviceInfo*				_deviceInfo;
}

- (id) initWithApplication:(UIApplication*)app withFrame:(struct CGRect)rect;
- (void) buildTableIfNotBuilt;

@end