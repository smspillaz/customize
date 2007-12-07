/**
 * DeviceInfo.h
 * This file is part of Customize by The Spicy Chicken
 *
 * Represents an an iphone/ipod
**/

#import <Foundation/Foundation.h>
#import <CoreFoundation/CoreFoundation.h>
#import <UIKit/CDStructures.h>

@interface DeviceInfo : NSObject
{
	// Firmware info
	NSString*			_firmware;
	int						_firmwareAsInt;
	
	// Platform info
	NSString*			_platform;
	
	// Version plist path
	NSString*			_versionPlistPath;
	NSMutableDictionary*	_info;
	
	// Display order path
	NSString*			_pathToDisplayOrder;
	
}

- (id) initWithVersionPlistPath:(NSString*)versionPlistPath;

- (void) setFirmware:(NSString*)firmware;
- (NSString*) firmware;
- (bool) firmareIs111Compatible;

- (void) setPlatform:(NSString*)platform;
- (NSString*) platform;
- (bool) isIphone;
- (bool) isIpod;

- (NSString*) pathToDisplayOrder;

@end