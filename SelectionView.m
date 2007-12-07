/**
 * Customize by Nick Tatonetti
 * (c) 2007 TWC
 * com.thespicychicken.customize
 * This code is released with absolutely no gauruntee and without any warranty.
 * It is being released in the hopes that it will be useful.  You are free to modify and
 * change the code as you see fit.  Aknowledgments are never a bad thing ;-)
**/

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
#include <unistd.h>
#include "SelectionView.h"
#import "CSPreferencesTableCell.h"

@implementation SelectionView : UIView

- (id) initWithApplication: (UIApplication*)app withAppID: (NSString*)appID withFrame: (struct CGRect)rect
{
	_rect = rect;
	//Init view with frame rect
	[super initWithFrame: rect];
	
	//Save application object
	_application = app;
	_applicationID = appID;
	
	// Setup _mainView
	UIView* mainView = [[UIView alloc] initWithFrame: rect];
	UINavigationBar *titlebar = [[UINavigationBar alloc] initWithFrame: CGRectMake(0.0f, 0.0f, 320.0f, 42.0f)];
	UINavigationItem* title = [[UINavigationItem alloc] initWithTitle:@"Customize"];
	[titlebar pushNavigationItem:title];
	[titlebar setBarStyle: 0];
	[titlebar enableAnimation];
	
	_table = [[UIPreferencesTable alloc] initWithFrame: CGRectMake(0.0f, 42.0f, rect.size.width, rect.size.height - 42.0f)];
	[_table setDelegate:self];
	[_table setDataSource:self];
	
	[mainView addSubview: titlebar];
	[mainView addSubview: _table];
	
	// Build Version Cell
	_versionGroup = [[CSPreferencesTableCell alloc] initWithFrame: CGRectMake(0.0f, 0.0f, rect.size.width, 24.0f)];
	[_versionGroup setTitle: [@"Version " stringByAppendingString:[_application version]]];
	[_versionGroup setEnabled:NO];
	
	_tableBuilt = NO;
	
	[self addSubview:mainView];
	
	return self;
}

- (void) buildTableIfNotBuilt
{
	if (!_tableBuilt)
	{
		[self buildPreferencesTable];
		_tableBuilt = YES;
	} 
}

/**
 * This builds of up the section list table, headers and all, with test data
**/
- (void) buildPreferencesTable
{
	[_prefCells release];
	_prefCells = [[NSMutableArray alloc] init];
	
	NSDictionary* listDict = [[NSDictionary alloc] initWithContentsOfFile:@"/Applications/Customize.app/settings/selectionList.plist"];
	NSArray* masterList = [listDict objectForKey:@"SectionList"];
	CSPreferencesTableCell* cell;
	
	int i,j;
	
	
	for(i=0;i<[masterList count];i++)
	{
		// Create Group
		[_prefCells addObject:[[NSMutableArray alloc] init]];
		
		NSArray* groupList = [masterList objectAtIndex:i];
		
		NSLog(@"groupList count = %i",[groupList count]);
		
		for(j=0;j<[groupList count];j++)
		{
			NSDictionary* cellDict = [groupList objectAtIndex:j];
			NSString* viewName = [[cellDict allKeys] objectAtIndex:0];
			
			// Validate the viewName as the user may not have it.
			if ([_application validViewListKey:viewName])
			{
			  NSString* niceName = [[cellDict objectForKey:viewName] objectForKey:@"name"];
  			NSString* iconPath = [[cellDict objectForKey:viewName] objectForKey:@"iconPath"];
        
  			cell = [[CSPreferencesTableCell alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 300.0f, 42.0f)];
  			UIImage* cellIcon = [UIImage imageAtPath:iconPath];
  			[cell setIcon:cellIcon];
  			[cell setTitle:niceName];
  			[cell setShowDisclosure:YES];
  			[cell setCellOutline:1];
  			[cell setView:viewName];
  			[[_prefCells objectAtIndex:([_prefCells count]-1)] addObject: cell];
			}
		}
	}
	
	// Version Group
	[_prefCells addObject:[[NSMutableArray alloc] init]];
	[[_prefCells objectAtIndex:([_prefCells count]-1)] addObject: _versionGroup];
	
	[_table reloadData];
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

- (CSPreferencesTableCell*)preferencesTable:(UIPreferencesTable*)aTable cellForGroup:(int)group
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
	if (group == ([_prefCells count] - 1)) return TRUE;
	else return FALSE;
}

- (CSPreferencesTableCell*)preferencesTable:(UIPreferencesTable*)aTable cellForRow:(int)row inGroup:(int)group
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
	
	[_application transitionToChooserWith:1 toView:[[[_prefCells objectAtIndex:group] objectAtIndex:row] getView]];
	[[[_prefCells objectAtIndex:group] objectAtIndex:row] setSelected:NO withFade:YES];
}

- (void) setDelegate: (id)delegate;
{
	_delegate = delegate;
	
	[self buildPreferencesTable];
}

@end