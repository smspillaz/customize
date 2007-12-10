/**
 * DockSwap by Nick Tatonetti
 * (c) 2007 TWC
 * com.thespicychicken.customize
 * This code is released with absolutely no gauruntee and without any warranty.
 * It is being released in the hopes that it will be useful.  You are free to modify and
 * change the code as you see fit.  Aknowledgments are never a bad thing ;-)
**/

#import <CoreFoundation/CoreFoundation.h>
#import <Foundation/Foundation.h>
#import <UIKit/CDStructures.h>
#import <UIKit/UIApplication.h>
#import <UIKit/UINavigationBar.h>
#import <UIKit/UIWindow.h>
#import <UIKit/UIView-Hierarchy.h>
#import <UIKit/UIHardware.h>
#import <UIKit/UITable.h>
#import <UIKit/UITableCell.h>
#import <UIKit/UITableColumn.h>
#import <UIKit/UITile.h>
#import <UIKit/UITiledView.h>
#import <UIKit/UIPreferencesTable.h>
#import <UIKit/UINavBarButton.h>
#import <UIKit/UIGradientBar.h>
#import <UIKit/UISegmentedControl.h>
#import <UIKit/UICheckeredPatternView.h>
#import <UIKit/UINavigationItem.h>
#import "CustomizeApp.h"
#import "ChooserView.h"

@implementation CustomizeApp

- (void) initApplication
{
	_applicationID = @"com.thespicychicken.customize";
	_version = @"1.20";
	_restartSpringBoard = FALSE;
	
	_rect = [UIHardware fullScreenApplicationContentRect];
  _rect.origin.x = _rect.origin.y = 0.0f;
	
	_fullWidth = _rect.size.width;
	_fullHeight = _rect.size.height;
	
	// Set up window and main View
  	_window = [[UIWindow alloc] initWithContentRect: _rect];
  	_mainView = [[UIView alloc] initWithFrame: _rect];
  	
  	[_window orderFront: self];
  	[_window makeKey: self];
  	[_window _setHidden: NO];
  	[_window setContentView: _mainView];
	
	_transView = [[UITransitionView alloc] initWithFrame: _rect];
	[_mainView addSubview: _transView];
	
	// Holds all of the chooser/editor views
	_viewList = [[NSMutableDictionary alloc] init];
	
	// Backup Arrays
	_backUpFromPaths = [[NSMutableArray alloc] init];
	_backUpToPaths = [[NSMutableArray alloc] init];
	_backUpDirs = [[NSMutableArray alloc] init];
	
	// Confirm Customize library folder exists
	[self confirmLibraryFoldersExists];
	
	NSString* key;
	
	NSFileManager* fm = [NSFileManager defaultManager];
	
	// Set up an Unlock Audio Chooser View
	NSDictionary*	audioChooserViews = [[NSDictionary alloc] initWithContentsOfFile:@"/Applications/Customize.app/settings/audioChooserViews.plist"];
	NSEnumerator* audEn = [audioChooserViews keyEnumerator];
	// Confirm that the backup dir exists
	[self confirmLibraryFolderExistsAtPath:@"/var/root/Library/Customize/AudioBackup"];
	
	while((key = [audEn nextObject]))
	{
		NSDictionary* audioChooserViewDict = [audioChooserViews objectForKey:key];
		AudioChooserView* audioChooser = [[AudioChooserView alloc] initWithApplication:self withAppID:_applicationID withFrame:_rect
			withAlternateSoundFilesPath:[audioChooserViewDict objectForKey:@"AlternateSoundFilesPath"]
			withStockSoundFilePath:[audioChooserViewDict objectForKey:@"StockSoundFilePath"]
			withBackUpDirectoryPath:@"/var/root/Library/Customize/AudioBackup"
      withHeaderName:[audioChooserViewDict objectForKey:@"HeaderName"]];
		
		// Validate that this user has these files to change
		if ([fm fileExistsAtPath:[audioChooserViewDict objectForKey:@"StockSoundFilePath"]])
		{
		  [_viewList setObject:audioChooser forKey:key];

  		// Add to backup list
  		[_backUpDirs addObject:@"/var/root/Library/Customize/AudioBackup"];
  		[_backUpFromPaths addObject:[audioChooserViewDict objectForKey:@"StockSoundFilePath"]];
  		[_backUpToPaths addObject:[[audioChooserViewDict objectForKey:@"StockSoundFilePath"] lastPathComponent] ];

  		// Confirm library folder exists
  		[self confirmLibraryFolderExistsAtPath:[audioChooserViewDict objectForKey:@"AlternateSoundFilesPath"]];
		}
		
		
	}
	
	// We use the settings file "chooserViews.plist" to build the image chooser views
	NSDictionary* chooserViews = [[NSDictionary alloc] initWithContentsOfFile:@"/Applications/Customize.app/settings/chooserViews.plist"];
	NSEnumerator* en = [chooserViews keyEnumerator];
	while((key = [en nextObject]))
	{
    bool addObject = YES;
    
		NSDictionary* chooserViewDict = [chooserViews objectForKey:key];
		ChooserView* chooser = [[ChooserView alloc] initWithApplication: self withAppID: _applicationID withFrame: _rect
				withAlternateImagesPath:[chooserViewDict objectForKey:@"AlternateImagesPath"]
				withStockImagePaths:[chooserViewDict objectForKey:@"ImagePaths"] 
				withHeaderName:[chooserViewDict objectForKey:@"HeaderName"]
				withTransformRatio:[[chooserViewDict objectForKey:@"TransformRatio"] floatValue]
				withYOffset:[[chooserViewDict objectForKey:@"YOffset"] floatValue]
				withXOffset:[[chooserViewDict objectForKey:@"XOffset"] floatValue]
				withImageHeight:[[chooserViewDict objectForKey:@"ImageHeight"] floatValue]
				withImageWidth:[[chooserViewDict objectForKey:@"ImageWidth"] floatValue]
				withRowHeight:[[chooserViewDict objectForKey:@"RowHeight"] floatValue]
				withAlertHeight:[[chooserViewDict objectForKey:@"AlertHeight"] intValue]
				withAlertTransformRatio:[[chooserViewDict objectForKey:@"AlertTransformRatio"] floatValue]
				withAlertTopPadding:[[chooserViewDict objectForKey:@"AlertTopPadding"] floatValue]
				showOnlyMainImage:[[chooserViewDict objectForKey:@"ShowOnlyMainImage"] boolValue]
				usePreviewIfAvailable:[[chooserViewDict objectForKey:@"UsePreviewIfAvailable"] boolValue] ];
		
		
		// Add to backup lists
		int i;
		NSArray* images = [chooserViewDict objectForKey:@"ImagePaths"];
		for(i=0;i<[images count];i++)
		{
			// Validate that this user has these files to change
			if ([fm fileExistsAtPath:[images objectAtIndex:i]])
  		{
			  [_backUpDirs addObject:[[chooserViewDict objectForKey:@"AlternateImagesPath"] stringByAppendingPathComponent:@"BackUp"]];
  			[_backUpFromPaths addObject:[images objectAtIndex:i]];
        
			  if (i==0)
			  {
				  [_backUpToPaths addObject:@"backup.png"];
			  } else {
				  [_backUpToPaths addObject:[[NSString alloc] initWithFormat:@"backup-%i.png",i]];
			  }
		  } else {
		    // These files don't exist on this ipod/iphone so we won't add this one.
        addObject = NO;
		  }
		}
		
		// Confirm library folder exists
		[self confirmLibraryFolderExistsAtPath:[chooserViewDict objectForKey:@"AlternateImagesPath"]];
		
		if (addObject) [_viewList setObject:chooser forKey:key];
		
	}
	
	// We use the settings file "stringEditorViews.plist"
	// to build the stringsEditors
	NSDictionary* stringsEditors = [[NSDictionary alloc] initWithContentsOfFile:@"/Applications/Customize.app/settings/stringEditorViews.plist"];
	en = [stringsEditors keyEnumerator];
	
	while((key = [en nextObject]))
	{
		NSDictionary* stringEditorDict = [stringsEditors objectForKey:key];
		StringEditorView* stringEditor = [[StringEditorView alloc] initWithApplication:self withAppID:_applicationID withFrame:_rect
			withStringsPath:[stringEditorDict objectForKey:@"stringsPath"]
			withBackupStringsPath:[stringEditorDict objectForKey:@"backupStringsPath"]
			withHeaderName:[stringEditorDict objectForKey:@"headerName"]
			withBetterKeys:[stringEditorDict objectForKey:@"betterKeys"]
			withMode:[[stringEditorDict objectForKey:@"mode"] intValue]
			withKeyList:[stringEditorDict objectForKey:@"keyList"]];
		
		// Validate that this user has these files to change
		if ([fm fileExistsAtPath:[stringEditorDict objectForKey:@"stringsPath"]])
		{
		  [_viewList setObject:stringEditor forKey:key];

  		// Add to backup tasks
  		[_backUpDirs addObject:[[stringEditorDict objectForKey:@"stringsPath"] stringByDeletingLastPathComponent]];
  		[_backUpFromPaths addObject:[stringEditorDict objectForKey:@"stringsPath"]];
  		[_backUpToPaths addObject:[[stringEditorDict objectForKey:@"backupStringsPath"] lastPathComponent]];

  		// Confirm backup directory exists
      [self confirmLibraryFolderExistsAtPath:[[stringEditorDict objectForKey:@"stringsPath"] stringByDeletingLastPathComponent]];
		}
		
	}
	
	// Set up SelectionView
	_selectionView = [[SelectionView alloc] initWithApplication: self withAppID: _applicationID withFrame: _rect];

	// Set up AudioSelectionView
	_audioSelectionView = [[AudioSelectionView alloc] initWithApplication: self withAppID: _applicationID withFrame: _rect];
	
	// Set up DeviceInfo
	_deviceInfo = [[DeviceInfo alloc] initWithVersionPlistPath:@"/Applications/Customize.app/settings/version.plist"];
	
	// Set up DisplayOrderView
  _displayOrderView = [[DisplayOrderView alloc] initWithApplication:self withFrame: _rect withDeviceInfo:_deviceInfo];
  
  // Set up PresetLoaderView
  _presetLoaderView = [[PresetLoaderView alloc] initWithApplication:self withFrame: _rect withDeviceInfo:_deviceInfo withDisplayOrderView:_displayOrderView];
  // Confirm preset library folder exists
  [self confirmLibraryFolderExistsAtPath:@"/var/root/Library/Customize/DOPresets"];
  
	// Set up ConfigureView
	_configure = [[ConfigureView alloc] initWithApplication:self withFrame:_rect withDeviceInfo:_deviceInfo];
	
	// Set up ToggleDockNumView
  _toggleDockNumView = [[ToggleDockNumView alloc] initWithFrame:_rect withApp:self withDisplayOrderView:_displayOrderView];
	
	[_viewList setObject:_selectionView forKey:@"selectionView"];		          // Selection View		
	[_viewList setObject:_audioSelectionView forKey:@"audioSelectionView"];		// AudioSelection View		
	[_viewList setObject:_presetLoaderView forKey:@"presetLoaderView"];       // Preset Loader View
  [_viewList setObject:_displayOrderView forKey:@"displayOrderView"];       // Display Order View
  [_viewList setObject:_toggleDockNumView forKey:@"toggleDockNumView"];       // ToggleDockNumView
  
	[_viewList setObject:_configure forKey:@"configure"];
	
	// Make backups of files
	[self makeBackUpSets];
	
	[self transitionToSelectionViewWith:1];
	
}

/**
 * Valide _viewList key
**/
- (bool) validViewListKey:(NSString *)key
{
  return [[_viewList allKeys] containsObject:key];
}

/**
 * Returns Version #
**/
- (NSString*) version
{
	return _version;
}

/**
 * Transitions
**/
- (void) transitionToChooserWith:(int)trans_type toView:(NSString *)viewKey
{
	[[_viewList objectForKey:viewKey] buildTableIfNotBuilt];
	[_transView transition:trans_type toView:[_viewList objectForKey:viewKey]];
}
- (void) transitionToSelectionViewWith:(int)trans_type
{
	[self transitionToChooserWith:trans_type toView:@"selectionView"];
}

/**
 * Toggle SB Restart
**/
- (void) setRestartSpringBoard
{
	_restartSpringBoard = TRUE;
}

- (void) confirmLibraryFoldersExists
{
	[self confirmLibraryFolderExistsAtPath:@"/var/root/Library/Customize"];
}

- (void) confirmLibraryFolderExistsAtPath:(NSString*)dspath
{
	NSFileManager* fm = [NSFileManager defaultManager];
	if (![fm fileExistsAtPath:dspath])
	{
		[fm createDirectoryAtPath:dspath attributes: nil];
	}
}



- (void) makeBackUpSets
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	int i;
	NSFileManager* fm = [NSFileManager defaultManager];
	
	// Add a preview for the backup keypad
	[_backUpDirs addObject:@"/var/root/Library/Customize/KeypadImages/BackUp/"];
	[_backUpFromPaths addObject:@"/Applications/Customize.app/files/backup-preview.png"];
	[_backUpToPaths addObject:@"backup-preview.png"];
	
	// Add a preview for the top battery
	[_backUpDirs addObject:@"/var/root/Library/Customize/HeaderBatteryImages/BackUp/"];
	[_backUpFromPaths addObject:@"/Applications/Customize.app/files/topheader-preview.png"];
	[_backUpToPaths addObject:@"backup-preview.png"];
	
	// Add a preview for the notepad
	[_backUpDirs addObject:@"/var/root/Library/Customize/NotePadImages/BackUp/"];
	[_backUpFromPaths addObject:@"/Applications/Customize.app/files/notepad-preview.png"];
	[_backUpToPaths addObject:@"backup-preview.png"];
	
	// Add a preview for the weather
	[_backUpDirs addObject:@"/var/root/Library/Customize/WeatherBackgroundImages/BackUp/"];
	[_backUpFromPaths addObject:@"/Applications/Customize.app/files/weather-preview.png"];
	[_backUpToPaths addObject:@"backup-preview.png"];
	
	// Loop through and make nec. backups.
	for(i=0;i<[_backUpFromPaths count];i++)
	{
		NSString* toPath = [[_backUpDirs objectAtIndex:i] stringByAppendingPathComponent:[_backUpToPaths objectAtIndex:i] ];
		
		if (![fm fileExistsAtPath:toPath])
		{
			NSLog(@"Making backups of %@",[_backUpFromPaths objectAtIndex:i]);
			[self confirmLibraryFolderExistsAtPath:[[_backUpDirs objectAtIndex:i] stringByDeletingLastPathComponent]];
      NSLog(@"Directory at %@ exists.",[[_backUpDirs objectAtIndex:i] stringByDeletingLastPathComponent]);
			[self confirmLibraryFolderExistsAtPath:[_backUpDirs objectAtIndex:i]];
      NSLog(@"Directory at %@ exists.",[_backUpDirs objectAtIndex:i]);
			NSString* fromPath = [_backUpFromPaths objectAtIndex:i];
      NSLog(@"Copying from %@ to %@",fromPath,toPath);
      NSCopyFile(fromPath,toPath);
			//copyFile([fromPath UTF8String],[toPath UTF8String]);
      NSLog(@"OK");
      
		} else {
			NSLog(@"BackUps already made at %@",[_backUpDirs objectAtIndex:i]);
		}
	}
	
	[pool release];
}

/**
 * Quick and dirty debugging tool
 * Simply send an NSString to this method and it will pop it up
**/
- (void) raiseAlert: (NSString*)msg
{
	NSArray* buttons = [NSArray arrayWithObjects:@"Close",nil];
	UIAlertSheet* popup = [[UIAlertSheet alloc] initWithTitle:@"Alert!" buttons:buttons defaultButtonIndex:0 delegate:self context:nil];
	[popup setBodyText: msg];
	[popup popupAlertAnimated: TRUE];
}

- (void) applicationDidFinishLaunching: (id) unused
{
  // Init App
	[self initApplication];
}

- (void) applicationWillTerminate
{
	// On applicaton termination do stuff
	if (_restartSpringBoard)
	{
		system("launchctl stop com.apple.SpringBoard");
	}
}

@end