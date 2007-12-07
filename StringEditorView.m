/**
 * Customize by Nick Tatonetti
 * (c) 2007 TWC
 * com.thespicychicken.customize
 * This code is released with absolutely no gauruntee and without any warranty.
 * It is being released in the hopes that it will be useful.  You are free to modify and
 * change the code as you see fit.  Aknowledgments are never a bad thing ;-)
**/
#include <unistd.h>

#import <Foundation/Foundation.h>
#import <CoreFoundation/CoreFoundation.h>
#import <UIKit/CDStructures.h>
#import <UIKit/UIApplication.h>
#import <UIKit/UINavigationBar.h>
#import <UIKit/UINavBarButton.h>
#import <UIKit/UIImage.h>
#import <UIKit/UIWindow.h>
#import <UIKit/UIView.h>
#import <UIKit/UIView-Hierarchy.h>
#import <UIKit/UIHardware.h>
#import <UIKit/UIPreferencesTableCell.h>
#import <UIKit/UIPreferencesTextTableCell.h>
#import <UIKit/UIPreferencesTable.h>
#import <UIKit/UINavigationItem.h>
#import <UIKit/UIAlertSheet.h>
#import "SelectionView.h"
#import "StringEditorView.h"
#import "CSPreferencesTableCell.h"


@implementation StringEditorView : UIView

- (id) initWithApplication: (UIApplication*)app withAppID: (NSString*)appID withFrame: (struct CGRect)rect
	withStringsPath:(NSString*)stringsPath
	withBackupStringsPath:(NSString*)buStringsPath
	withHeaderName:(NSString*)headerName
	withBetterKeys:(NSDictionary*)betterKeys
	withMode:(int)mode
	withKeyList:(NSArray*)keyList
{
	_rect = rect;
	//Init view with frame rect
	[super initWithFrame: rect];
	
	//Save application object
	_application = app;
	_applicationID = appID;
	
	// set up globals
	_stringsPath = stringsPath;
	_betterKeys = betterKeys;
	_keyList = keyList;
	_mode = mode;
	_buStringsPath = buStringsPath;
	
	// Setup _mainView
	UIView* mainView = [[UIView alloc] initWithFrame: rect];
	
	// Set up Title Bar
	UINavigationBar *titlebar = [[UINavigationBar alloc] initWithFrame: CGRectMake(0.0f, 0.0f, rect.size.width, 42.0f)];
	UINavigationItem* title = [[UINavigationItem alloc] initWithTitle:headerName];
	[titlebar pushNavigationItem:title];
	[titlebar setBarStyle: 0];
	[titlebar enableAnimation];
	
	UINavBarButton* backButton = [[UINavBarButton alloc] initWithFrame: CGRectMake(3.0f, 7.0f, 90.0f, 32.0f)];
	[backButton setAutosizesToFit: FALSE];
	[backButton setTitle: @" Customize"];
	[backButton addTarget: self action: @selector(transitionToSelectionView) forEvents: 1];
	[backButton setNavBarButtonStyle: 2];
	
	[titlebar addSubview:backButton];
	
	[self addSubview:titlebar];	
	
	_table = [[UIPreferencesTable alloc] initWithFrame: CGRectMake(0.0f, 42.0f, rect.size.width, rect.size.height - 42.0f)];
	[_table setDelegate:self];
	[_table setDataSource:self];
	
	[mainView addSubview: titlebar];
	[mainView addSubview: _table];
	
	_tableBuilt = NO;
	
	[self addSubview:mainView];
	
	return self;
}

- (void) buildTableIfNotBuilt
{
	NSLog(@"Building String Editor Table");
	if (!_tableBuilt)
	{
		[self buildPreferencesTable];
		[_application setRestartSpringBoard];
		_tableBuilt = YES;
	} 
}

/**
 * Call application method
**/
- (void) transitionToSelectionView
{
	int i,j;
	NSString* value;
	
	// On Exit, we Save the changes
	for(i=1;i<[_prefCells count];i++)
	{
		for(j=0;j<[[_prefCells objectAtIndex:i] count];j++)
		{
			value = [[[[_prefCells objectAtIndex:i] objectAtIndex:j] textField] text];
			if (![value isEqualToString:@""] && value)
			{
				NSLog(@"Value of cell at (%i,%i) = %@",i,j,value);
				[_strings setObject:value forKey:[[[_prefCells objectAtIndex:i] objectAtIndex:j] getKey]];
			}
		}
	}
	
	// Write the new _strings to file
	[_strings writeToFile:_stringsPath atomically:YES];
	
	[_application transitionToSelectionViewWith:2];
}

/**
 * validKey - Returns YES if this key should be displayed, NO otherwise
**/
- (bool) validKey:(NSString*)key
{
	if (_mode == 0) return YES;
	
	// Only Mode
	if (_mode == 1 && [_keyList containsObject:key]) return YES;
	
	// Except Mode
	if (_mode == 2 && ![_keyList containsObject:key]) return YES;
	
	return NO;
}
/**
 * This builds of up the section list table, headers and all, with test data
**/
- (void) buildPreferencesTable
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	NSEnumerator *en;
	NSString* key;
	StringsTableCell* cell;
	int i;
	
	_strings = [[NSMutableDictionary alloc] initWithContentsOfFile:_stringsPath]; 
	en = [_strings keyEnumerator];
	
	[_prefCells release];
	_prefCells = [[NSMutableArray alloc] init];
	
	// Backup Group
	[_prefCells addObject:[[NSMutableArray alloc] init]];
	cell = [[UIPreferencesTableCell alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 300.0f, 42.0f)];
	[cell setTitle:@"Revert to Backup"];
	[cell setShowDisclosure:NO];
	[cell setCellOutline:1];
	
	
	[[_prefCells objectAtIndex:([_prefCells count]-1)] addObject: cell];
	
	// Strings Group
	[_prefCells addObject:[[NSMutableArray alloc] init]];
	
	while((key = [en nextObject]))
	{
		if ([self validKey:key])
		{
			cell = [[StringsTableCell alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 300.0f, 42.0f)];
			[cell setTitle:[_betterKeys objectForKey:key]];
			[cell setPlaceHolderValue:[_strings objectForKey:key]];
			[cell setKey:key];
			[cell setEnabled:YES];
			[cell setShowDisclosure:NO];
			[cell setCellOutline:1];
			
			[[cell textField] setText:@""];
			[[cell textField] setEnabled:YES];

			[[_prefCells objectAtIndex:([_prefCells count]-1)] addObject: cell];
		}
		
	}
	
	//Refresh the fileview table
	[_table reloadData];
	[pool release];
	
}

/**
 * Delegate Methods
**/
- (int)numberOfGroupsInPreferencesTable:(UIPreferencesTable*)aTable
{
	return [_prefCells count];
}

- (int)preferencesTable:(UIPreferencesTable*)aTable numberOfRowsInGroup:(int)group
{
	NSLog(@"calling for number of rows in group: %i",group);
	
	return [[_prefCells objectAtIndex:group] count];
}

- (StringsTableCell*)preferencesTable:(UIPreferencesTable*)aTable cellForGroup:(int)group
{
	NSLog(@"Calling for cell for group: %i",group);
	
	return Nil;
}

- (float)preferencesTable:(UIPreferencesTable*)aTable heightForRow:(int)row inGroup:(int)group withProposedHeight:(float)proposed
{
	return proposed;
}

- (BOOL)preferencesTable:(UIPreferencesTable*)aTable isLabelGroup:(int)group
{
	NSLog(@"isLabelGroup? %i",group);
	return false;
}

- (StringsTableCell*)preferencesTable:(UIPreferencesTable*)aTable cellForRow:(int)row inGroup:(int)group
{
	NSLog(@"Calling for cell for row: %i in group: %i",row,group);
	
	return [[_prefCells objectAtIndex:group] objectAtIndex:row];
}

- (void) tableRowSelected: (NSNotification*) notification 
{
	NSLog(@"Selected : %i", [_table selectedRow]);
	int i,j,group,row,c;
	c = 1;
	
	for(i=0;i<[_prefCells count];i++)
	{
		for(j=0;j<[[_prefCells objectAtIndex:i] count];j++)
		{
			if (c == [_table selectedRow])
			{
				group = i;
				row = j;
			}
			c += 1;
		}
		c += 1;
	}
	
	NSLog(@"Found group,row %i,%i",group,row);
	
	if (group == 0 && row == 0)
	{
		[[[_prefCells objectAtIndex:0] objectAtIndex:0] setSelected:NO withFade:YES];
		NSLog(@"Restoring backup.");
		//copyFile([_buStringsPath UTF8String],[_stringsPath UTF8String]);
    NSCopyFile(_buStringsPath,_stringsPath);
		[self buildPreferencesTable];
		[_table reloadData];
	}
}

- (void) setDelegate: (id)delegate;
{
	_delegate = delegate;
	
	[self buildPreferencesTable];
}

@end