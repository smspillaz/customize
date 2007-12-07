/**
 * DeviceInfo.,
 * This file is part of Customize by The Spicy Chicken
 *
 * Represents an iphone/ipod
**/

#import <UIKit/UIHardware.h>
#import "DeviceInfo.h"

@implementation DeviceInfo : NSObject

- (id) initWithVersionPlistPath:(NSString*)versionPlistPath
{
	_versionPlistPath = versionPlistPath;
	
	NSString *firmware = [[[NSProcessInfo processInfo] operatingSystemVersionString] substringWithRange:NSMakeRange(8,5)];
	NSLog(@"OS: %@",firmware);
	
	NSString *platform = [UIHardware deviceName];
	NSLog(@"Platform %@",platform);
		
	if (firmware && platform) {
		_info = [[NSMutableDictionary alloc] init];
		[_info setObject:platform forKey:@"platform"];
		[_info setObject:firmware forKey:@"firmware"];
	} else {
		_info = [[NSMutableDictionary alloc] initWithContentsOfFile:@"/Applications/Customize.app/settings/version.plist"];
	}
	[self setPathToDisplayOrder];
	
	return self;
}

/**
 * Looks at the device info and sets the correct displayorder plist path
**/
- (void) setPathToDisplayOrder
{
	if ([self isIpod])
	{
		_pathToDisplayOrder = @"/System/Library/CoreServices/SpringBoard.app/N45AP.plist";
	} else if ([self isIphone] && [self firmareIs111Compatible])
	{
		_pathToDisplayOrder = @"/System/Library/CoreServices/SpringBoard.app/M68AP.plist";
	} else {
		_pathToDisplayOrder = @"/System/Library/CoreServices/SpringBoard.app/DisplayOrder.plist";
	}
}

/**
 * Returns the path to the display order plist file
**/
- (NSString*) pathToDisplayOrder
{
	return _pathToDisplayOrder;
}

- (void) setFirmware:(NSString*)firmware
{
	[_info setObject:firmware forKey:@"firmware"];
	[self saveVersionInfo];
}

- (NSString*) firmware
{
	return [_info objectForKey:@"firmware"];
}

/**
 * Retuns true if the user is running 1.1.1 or greater
**/
- (bool) firmareIs111Compatible
{
	if ([[self firmware] isEqualToString:@"1.1.1"] || [[self firmware] isEqualToString:@"1.1.2"])
	{
		return YES;
	} else {
		return NO;
	}
}

- (void) setPlatform:(NSString*)platform
{
	[_info setObject:platform forKey:@"platform"];
	[self saveVersionInfo];
}

- (NSString*) platform
{
	return [_info objectForKey:@"platform"];
}

/**
 * Returns true if the device is an iPhone
**/
- (bool) isIphone
{
	if ([[self platform] isEqualToString:@"iPhone"])
	{
		return YES;
	}
	return NO;
}

/**
 * Returns true if the device is an iPod
**/
- (bool) isIpod
{
	if ([[self platform] isEqualToString:@"iPod"])
	{
		return YES;
	}
	return NO;
}

/**
 * Saves the current settings
**/
- (void) saveVersionInfo
{
	NSLog(@"saving with firmware, %@, and platform, %@",[self firmware],[self platform]);
	[_info writeToFile:_versionPlistPath atomically:YES];
	[self setPathToDisplayOrder];
}

@end