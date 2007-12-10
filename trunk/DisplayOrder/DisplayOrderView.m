/**
 * DisplayOrderView.m
 * This file is part of Customize by The Spicy Chicken
**/

#import <UIKit/UINavigationBar.h>
#import <UIKit/UINavigationItem.h>
#import "DisplayOrderView.h"
#import "ListSortView.h"
#import "RuleParser.h"

@implementation DisplayOrderView : UIView

- (id) initWithApplication:(UIApplication*)app withFrame:(struct CGRect)rect withDeviceInfo:(DeviceInfo*)deviceInfo
{
	_rect = rect;
	_application = app;
	_deviceInfo = deviceInfo;
	[super initWithFrame:rect];
	
	_built = NO;
	
	_titlebarHeight = 42.0f;
  _hidingActive = NO;
  _numberDockIcons = -1; // for uninitialized.
  _saveUponBuilding = NO;
  
	UINavigationBar* titlebar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0.0f,0.0f,rect.size.width, _titlebarHeight)];
	UINavigationItem* title = [[UINavigationItem alloc] initWithTitle:@"Custom"];
	[titlebar pushNavigationItem:title];
	[titlebar setBarStyle: 0];
	[titlebar enableAnimation];
	
	UINavBarButton* backButton = [[UINavBarButton alloc] initWithFrame: CGRectMake(0.0f, 7.0f, 110.0f, 32.0f)];
	[backButton setAutosizesToFit: FALSE];
	[backButton setTitle: @" Display Order"];
	[backButton addTarget: self action: @selector(transitionToPresetLoaderView) forEvents: 1];
	[backButton setNavBarButtonStyle: 2];
	
	UIImage* whiteHide = [UIImage imageAtPath:@"/Applications/Customize.app/icons/hide_white.png"];
  UIImageView * whiteHideImage = [[UIImageView alloc] initWithFrame:CGRectMake(8.0, 4.0, 23.0, 23.0)];
  [whiteHideImage setImage:whiteHide];
  
  _toggleHidingButton = [[UINavBarButton alloc] initWithFrame: CGRectMake(270.0f, 7.0f, 40.0f, 32.0f)];
  [_toggleHidingButton setAutosizesToFit: FALSE];
  [_toggleHidingButton setTitle:@""];
  [_toggleHidingButton addTarget: self action: @selector(toggleHiding) forEvents: 1];
	[_toggleHidingButton setNavBarButtonStyle: 0];
  [_toggleHidingButton addSubview:whiteHideImage];
  
  [titlebar addSubview:_toggleHidingButton];
	[titlebar addSubview:backButton];
	
	[self addSubview:titlebar];
	
	return self;
}

/**
 * Toggles the Hiding buttons on the appObjects
**/
- (void) toggleHiding
{
  int i;
  for (i=0;i<[_appObjects count];i++)
  {
    if (_hidingActive) [[_appObjects objectAtIndex:i] deactivateHideButton];
    else [[_appObjects objectAtIndex:i] activateHideButton];
  }
  
  if (_hidingActive)
  {
    [_toggleHidingButton setNavBarButtonStyle: 0];
    _hidingActive = NO;
  } else {
    [_toggleHidingButton setNavBarButtonStyle: 3];
    _hidingActive = YES;
  }
  
}

/**
 * Builds the _appObjects array and instantiates the reordering view
**/
- (void) buildTableIfNotBuilt
{
	if (!_built)
	{
    [self buildWithRules:NO pathToRules:Nil];
		
		_built = YES;
	}
}

/**
 * Build
**/
- (void) buildWithRules:(bool)withRules pathToRules:(NSString *)pathToRules
{
  // Tell Customize to restart the springboard
	[_application setRestartSpringBoard];
	
	// Builds a list of appObjects from the /Applications folder
	[self initializeDisplayOrderView];
	
	// Syncs the _appObjects array with the correct order found in the
	// displayOrder section of the system plist
	[self syncAppObjectsWithSavedOrder];
	
	if (withRules)
	{
    NSLog(@"Applying rules found at path, %@",pathToRules);
    RuleParser *rp = [[RuleParser alloc] init];
    _appObjects = [rp applyRules:pathToRules toArray:_appObjects];
    // Save the changes to file, in case the user exist immediately.
    if (!_saveUponBuilding) [self saveOrderToFile];
	}
	
	// Sometimes we may want to save as soon as we go in.
  if (_saveUponBuilding) 
  {
    [self saveOrderToFile];
  }
  
	// Lets peek at what we did
	//[self outputAppObjectsToLog];
	
	// Set up the sort view
  [_listSortView release];
	_listSortView = [[ListSortView alloc] initWithAppObjects:_appObjects
		withFrame:CGRectMake(0.0f,21.0f,_rect.size.width,_rect.size.height-_titlebarHeight)
		withNumberDockIcons:_numberDockIcons withPathToDisplayOrder:[_deviceInfo pathToDisplayOrder]
		withDisplayOrderView:self];
	[self addSubview:_listSortView];
	
	// Set up the sort view for reordering
	[_listSortView startReorderTable];
	
	// If this was called outside of the buildIfNotBuilt method then we need to set built to YES
  if (!_built) _built = YES;
}

/**
 * Mutator for number of dock icons
**/
- (void) setNumberDockIcons:(int)num
{
  _numberDockIcons = num;
}

/**
 * Accessor method for number of dock icons
**/
- (int) numberDockIcons
{
  return _numberDockIcons;
}

/**
 * Save on build
**/
- (void) saveOnBuild
{
  _saveUponBuilding = YES;
}

/**
 * Return the current controllerView, just in case I ever want to change it out
**/
- (UIView*)controllerView {
	return _listSortView;
}

/**
 * Calls application method to transition to selection view
**/
- (void) transitionToPresetLoaderView
{
	NSLog(@"");
	NSLog(@"");
	NSLog(@"Order on exit:");
	[self outputAppObjectsToLog];
	
	[self saveOrderToFile];
	
	[_application transitionToChooserWith:2 toView:@"presetLoaderView"];
}

/**
 * Method saves the order of _appObjects to the displayOrder file
**/
- (void) saveOrderToFile
{
	NSLog(@"Saving order to file, %@",[_deviceInfo pathToDisplayOrder]);
	
	NSMutableDictionary* DOFileDict;
	NSMutableDictionary* NewDisplayOrder;
	
	if ([_deviceInfo firmareIs111Compatible])
	{
		DOFileDict = [[NSMutableDictionary alloc] initWithContentsOfFile: [_deviceInfo pathToDisplayOrder]];
		NewDisplayOrder = [DOFileDict objectForKey:@"displayOrder"];
	} else {
		NewDisplayOrder = [[NSMutableDictionary alloc] initWithContentsOfFile: [_deviceInfo pathToDisplayOrder]];
	}
	
	NSMutableArray* buttonBar = [[NSMutableArray alloc] init];
	NSMutableArray* iconList = [[NSMutableArray alloc] init];
	NSMutableArray* special = [[NSMutableArray alloc] init];
	
	int i;
	for (i=0;i<[_appObjects count];i++)
	{
		
		AppObject* app = [_appObjects objectAtIndex:i];
		
		NSMutableDictionary* orderEntry = [[NSMutableDictionary alloc] init];
		[orderEntry setObject:[app identifier] forKey:@"displayIdentifier"];
		
		if ([app hidden])
		{
			[special addObject:orderEntry];
		} else if (i < _numberDockIcons)
		{
			[buttonBar addObject:orderEntry];
		} else {
			[iconList addObject:orderEntry];
		}
	}
	
	[NewDisplayOrder setObject:buttonBar forKey:@"buttonBar"];
	[NewDisplayOrder setObject:iconList forKey:@"iconList"];
	[NewDisplayOrder setObject:special forKey:@"special"];
	
	if ([_deviceInfo firmareIs111Compatible])
	{
		[DOFileDict setObject:NewDisplayOrder forKey:@"displayOrder"];
		[DOFileDict writeToFile:[_deviceInfo pathToDisplayOrder] atomically:YES];
	} else {
		[NewDisplayOrder writeToFile:[_deviceInfo pathToDisplayOrder] atomically:YES];
	}
}

/**
 * Iterates through _appObjects and prints to log
**/
- (void) outputAppObjectsToLog
{
	int i;
	
	for (i=0;i<[_appObjects count];i++)
	{
		AppObject* app = [_appObjects objectAtIndex:i];
		
		NSLog(@"Name\t\t%@",[app name]);
		NSLog(@"Identifier\t\t%@",[app identifier]);
		NSLog(@"Path\t\t%@",[app path]);
		NSLog(@"Icon Path\t\t%@",[app iconPath]);
	}
}

/**
 * Method sorts the appObjects array so that it matches what has been saved in the
 * DisplayOrder plist
**/
- (void) syncAppObjectsWithSavedOrder
{
	int position,i;
	NSMutableDictionary* DOFileDict;
	NSMutableDictionary* DisplayOrder;
	
	if ([_deviceInfo firmareIs111Compatible])
	{
		DOFileDict = [[NSMutableDictionary alloc] initWithContentsOfFile: [_deviceInfo pathToDisplayOrder]];
		DisplayOrder = [DOFileDict objectForKey:@"displayOrder"];
	} else {
		DisplayOrder = [[NSMutableDictionary alloc] initWithContentsOfFile: [_deviceInfo pathToDisplayOrder]];
	}
	
	// Dock Icons (should be the first 4 or 5 icons)
	// TODO: Add support for changing number of dock icons, at this point we make the user
	// TODO: stick with what they've got
	NSArray* buttonBar = [DisplayOrder objectForKey:@"buttonBar"];
	position = 0;
	for(i=0;i<[buttonBar count];i++)
	{
		NSString* identifier = [[buttonBar objectAtIndex:i] objectForKey:@"displayIdentifier"];
		
		int index = [self searchAppObjectsForIdentifier:identifier];
		if (index != -1)
		{
			// We want index to match position, if it does not we swap them
			// to get this identifier into the correct order
			if (position != index && position < [_appObjects count])
			{
				[_appObjects exchangeObjectAtIndex:position withObjectAtIndex:index];
			}
			position += 1;
		}
	}
	
	// Now the icons that are on the springboard to be added
	NSArray* iconList = [DisplayOrder objectForKey:@"iconList"];
	
	// Let's save the number of dock icons, if the haven't already been set.
	if (_numberDockIcons == -1)
	  _numberDockIcons = [buttonBar count];
	
	for(i=0;i<[iconList count];i++)
	{
		NSString* identifier = [[iconList objectAtIndex:i] objectForKey:@"displayIdentifier"];
		
		int index = [self searchAppObjectsForIdentifier:identifier];
		if (index != -1)
		{
			// We want index to match position, if it does not we swap them
			// to get this identifier into the correct order
			if (position != index && position < [_appObjects count])
			{
				[_appObjects exchangeObjectAtIndex:position withObjectAtIndex:index];
			}
			position += 1;
		}
	}
	
	// We go through the special array, which contains hidden icons, and hide
	// those matches that we find in our appObjects list.
	NSArray* special = [DisplayOrder objectForKey:@"special"];
	
	for(i=0;i<[special count];i++)
	{
		NSString* identifier = [[special objectAtIndex:i] objectForKey:@"displayIdentifier"];
		
		int index = [self searchAppObjectsForIdentifier:identifier];
		if (index != -1)
		{
			[[_appObjects objectAtIndex:index] hide];
		}
	}
	
}

/**
 * Method creates a list of appObjects based on all the applications that the user
 * has in their /Applications folder
**/

- (void) initializeDisplayOrderView
{
	//NSLog(@"Initializing DisplayOrderView");
	
	_appObjects = [[NSMutableArray alloc] init];
	
	NSString* path = @"/Applications";
	NSFileManager* fm = [NSFileManager defaultManager];
	[fm changeCurrentDirectoryPath: path];
	NSDirectoryEnumerator* dirEnumerator = [fm enumeratorAtPath: path];
	
	NSString* filename;
	while (filename = [dirEnumerator nextObject])
	{
		//NSLog(@"");
		
		[dirEnumerator skipDescendents];
    if ([[filename pathExtension] isEqualToString:@"app"])
    {
      
      // Pull app information from the plist
  		NSString* infoPlistPath = [[NSString alloc] initWithFormat:@"/Applications/%@/Info.plist",filename];
  		NSDictionary* infoPlistDict = [NSDictionary dictionaryWithContentsOfFile: infoPlistPath];

  		NSString* appPath = [[NSString alloc] initWithFormat:@"/Applications/%@",filename];
  		// Check if this is an app that has more than one "role"
  		// meaning the same app can have multiple icons and functions
  		if ([self dictionary:infoPlistDict hasKey:@"UIRoleInfo"])
  		{
  			//NSLog(@"%@ has Multiple Roles",filename);

  			NSString* baseIdentifier = [infoPlistDict objectForKey:@"CFBundleIdentifier"];
  			NSArray* roles;
  			// TODO: Have this check for the actual platform name, rather than simply using the index.
  			if ([_deviceInfo isIphone]) roles = [[[infoPlistDict objectForKey:@"UIRoleInfo"] objectAtIndex:0] objectForKey:@"Roles"];
  			else roles = [[[infoPlistDict objectForKey:@"UIRoleInfo"] objectAtIndex:1] objectForKey:@"Roles"];

  			int i;
  			for(i=0;i<[roles count];i++)
  			{

  				NSString* name = [[roles objectAtIndex:i] objectForKey:@"UIRoleDisplayName"];
  				NSString*	idExtension = [[roles objectAtIndex:i] objectForKey:@"Role"];
  				NSString* identifier = [[NSString alloc] initWithFormat:@"%@-%@",baseIdentifier,idExtension];
  				NSString* iconPath = [[NSString alloc] initWithFormat:@"/Applications/%@/icon-%@.png",filename,idExtension];

  				// Create the app object and add to array
  				AppObject* appObject = [[AppObject alloc] initWithPath:appPath withName:name withIconPath:iconPath 
  					withIdentifier:identifier isHidden:NO withDisplayOrderView:self];
  				[_appObjects addObject:appObject];
  				//NSLog(@"(%@,%@,%@,%@)",appPath,name,iconPath,identifier);
  			}

  		} else {
  			//NSLog(@"%@ has only one role",filename);

  			// Set the app identifier
  			NSString* identifier = [[NSString alloc] initWithFormat:@"%@",[infoPlistDict objectForKey:@"CFBundleIdentifier"]];

  			// Apple uses SBDemoRole to override the app name, we check for that first
  			// Otherwise we use the trimmed down app name in CFBundleExecutable
  			NSString* name;
  			if ([self dictionary:infoPlistDict hasKey:@"SBDemoRole"])
  			{
  				name = [infoPlistDict objectForKey:@"SBDemoRole"];
  			} else {
  				// This was a nice idea, but just wasn't working, noone observed this convention
  				// TODO: Make all names very nice
  				//name = [infoPlistDict objectForKey:@"CFBundleExecutable"];
  				name = [self niceNameFor:[filename stringByDeletingPathExtension]];
  			}
  			// Set the app IconPath, default for this single role app
  			NSString* iconPath = [[NSString alloc] initWithFormat:@"/Applications/%@/icon.png",filename];

  			// Create the app object and add to array
  			AppObject* appObject = [[AppObject alloc] initWithPath:appPath withName:name withIconPath:iconPath 
  				withIdentifier:identifier isHidden:NO withDisplayOrderView:self];
  			[_appObjects addObject:appObject];
  			//NSLog(@"(%@,%@,%@,%@)",appPath,name,iconPath,identifier);
  		}

  		/*
  		// Go through all the keys are display the key/value pairs
  		NSEnumerator* infoEnumerator = [infoPlistDict keyEnumerator];
  		NSString* key;
  		while ((key = [infoEnumerator nextObject])) {
  			NSLog(@"%@ = %@",key,[infoPlistDict objectForKey:key]);
  		}
  		*/
  		
    } /* end check if pathExtension is equal to app */
		
		
	} /* end while loop through files in dir */
	
}

/**
 * Returns a "Nice" name if there is one in the array, otherwise
 * returns the name given.
**/
- (NSString*) niceNameFor:(NSString*)filename 
{
	NSMutableDictionary* niceNames = [[NSMutableDictionary alloc] init];
	[niceNames setObject:@"Phone" forKey:@"MobilePhone"];
	[niceNames setObject:@"Safari" forKey:@"MobileSafari"];
	[niceNames setObject:@"SMS" forKey:@"MobileSMS"];
	[niceNames setObject:@"Clock" forKey:@"MobileTimer"];
	[niceNames setObject:@"Mail" forKey:@"MobileMail"];
	[niceNames setObject:@"Contacts" forKey:@"MobileAddressBook"];
	[niceNames setObject:@"iTunes" forKey:@"MobileStore"];
	
	NSArray* keys = [niceNames allKeys];
	
	if ([keys containsObject:filename])
		return [niceNames objectForKey:filename];
	else
		return filename;
}

/**
 * Utility method for checking if dictionary has a key
**/
- (bool) dictionary:(NSDictionary*)dict hasKey:(NSString*)key
{
	NSArray* allKeys = [dict allKeys];
	bool found = NO;
	int i = 0;
	
	while (!found && i < [allKeys count]) {
		if ([[allKeys objectAtIndex:i] isEqualToString:key])
		{
			found = YES;
		}
		i += 1;
	}
	
	return found;
}
/**
 * Utility method, pulls the position where identifier is located in appObjects
 * returns -1 if not found.
**/
- (int) searchAppObjectsForIdentifier:(NSString*)identifier
{
	int pos = -1;
	bool found = NO;
	int i = 0;
	
	while (!found && i < [_appObjects count])
	{
		AppObject* app = [_appObjects objectAtIndex:i];
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