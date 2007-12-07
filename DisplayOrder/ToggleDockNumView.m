/**
 * SectionView implementation by Nick Tatonetti
 * (c) 2007 TWC
 * com.googlecode.mobilesandbox
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
#import <UIKit/UITable.h>
#import <UIKit/UITableCell.h>
#import <UIKit/UITableColumn.h>
#import <UIKit/UIPreferencesTableCell.h>
#import <UIKit/UIPreferencesTextTableCell.h>
#import <UIKit/UIPreferencesTable.h>
#import <UIKit/UIAlertSheet.h>
#import "ToggleDockNumView.h"

@implementation ToggleDockNumView : UIView

- (id) initWithFrame: (struct CGRect)rect withApp: (UIApplication*)app withDisplayOrderView: (DisplayOrderView*)displayOrderView
{
	//Init view with frame rect
	[super initWithFrame: rect];
  
  _application = app;
	_displayOrderView = displayOrderView;
	
	
	_table = [[UIPreferencesTable alloc] initWithFrame: rect];
	[_table setDataSource:self];
  [_table setDelegate:self];
  
	// Build Group
	_prefGroup = [[UIPreferencesTableCell alloc] initWithFrame:CGRectMake(0.0f, 5.0f, 300.0f, 20.0f)];
	[_prefGroup setTitle: @""];
	
	[self addSubview: _table];
	
  _built = NO;
	
	return self;
	
}

- (void) buildTableIfNotBuilt
{
  if (!_built)
  {
    [self buildPreferencesTable];
    _built = YES;
  }
}
/**
 * This builds of up the section list table, headers and all, with test data
**/
- (void) buildPreferencesTable
{
	[_tableCells release];
	_tableCells = [[NSMutableArray alloc] init];
	
	UIPreferencesTableCell* cell = [[UIPreferencesTableCell alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 300.0f, 42.0f)];
	[cell setTitle:@"Zero Icons"];
	[cell setCheckStyle:0];
	if ([_displayOrderView numberDockIcons] == 0) [cell setChecked:TRUE];
	[_tableCells addObject: cell];
	
	cell = [[UIPreferencesTableCell alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 300.0f, 42.0f)];
	[cell setTitle:@"One Icon"];
	[cell setCheckStyle:0];
	if ([_displayOrderView numberDockIcons] == 1) [cell setChecked:TRUE];
	[_tableCells addObject: cell];
	
	cell = [[UIPreferencesTableCell alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 300.0f, 42.0f)];
	[cell setTitle:@"Two Icons"];
	[cell setCheckStyle:0];
	if ([_displayOrderView numberDockIcons] == 2) [cell setChecked:TRUE];
	[_tableCells addObject: cell];
	
	cell = [[UIPreferencesTableCell alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 300.0f, 42.0f)];
	[cell setTitle:@"Three Icons"];
	[cell setCheckStyle:0];
	if ([_displayOrderView numberDockIcons] == 3) [cell setChecked:TRUE];
	[_tableCells addObject: cell];
	
	cell = [[UIPreferencesTableCell alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 300.0f, 42.0f)];
	[cell setTitle:@"Four Icons"];
	[cell setCheckStyle:0];
	if ([_displayOrderView numberDockIcons] == 4) [cell setChecked:TRUE];
	[_tableCells addObject: cell];
	
	cell = [[UIPreferencesTableCell alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 300.0f, 42.0f)];
	[cell setTitle:@"Five Icons"];
	[cell setCheckStyle:0];
	if ([_displayOrderView numberDockIcons] == 5) [cell setChecked:TRUE];
	[_tableCells addObject: cell];
	
	cell = [[UIPreferencesTableCell alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 300.0f, 42.0f)];
	[cell setTitle:@"Six Icons"];
	[cell setCheckStyle:0];
	if ([_displayOrderView numberDockIcons] == 6) [cell setChecked:TRUE];
	[_tableCells addObject: cell];
	
	cell = [[UIPreferencesTableCell alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 300.0f, 42.0f)];
	[cell setTitle:@"Seven Icons"];
	[cell setCheckStyle:0];
	if ([_displayOrderView numberDockIcons] == 7) [cell setChecked:TRUE];
	[_tableCells addObject: cell];
	
	cell = [[UIPreferencesTableCell alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 300.0f, 42.0f)];
	[cell setTitle:@"Eight Icons"];
	[cell setCheckStyle:0];
	if ([_displayOrderView numberDockIcons] == 8) [cell setChecked:TRUE];
	[_tableCells addObject: cell];
	
	cell = [[UIPreferencesTableCell alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 300.0f, 42.0f)];
	[cell setTitle:@"Nine Icons"];
	[cell setCheckStyle:0];
	if ([_displayOrderView numberDockIcons] == 9) [cell setChecked:TRUE];
	[_tableCells addObject: cell];
	
	//Refresh the fileview table
	[_table reloadData];
}

/**
 * Delegate Methods
**/
- (int)numberOfGroupsInPreferencesTable:(UIPreferencesTable*)aTable
{
	return 4;
}

- (int)preferencesTable:(UIPreferencesTable*)aTable numberOfRowsInGroup:(int)group
{
	switch( group )
	{
		case 0: return 1;
		case 1: return [_tableCells count];
		default: return 0;
	}
}

- (UIPreferencesTableCell*)preferencesTable:(UIPreferencesTable*)aTable cellForGroup:(int)group
{
	switch ( group )
	{
		case 0: return _prefGroup;
		case 1: return _prefGroup;
		default: return Nil;
	}
}

- (float)preferencesTable:(UIPreferencesTable*)aTable heightForRow:(int)row inGroup:(int)group withProposedHeight:(float)proposed
{
	float groupLabelSize = 5.0f;
	switch( group )
	{
		case 0: return groupLabelSize;
		default: return proposed;
	}
}

- (BOOL)preferencesTable:(UIPreferencesTable*)aTable isLabelGroup:(int)group
{
	switch ( group )
	{
		case 0: return FALSE;
		case 1: return FALSE;
		default: return FALSE;
	}
}

- (UIPreferencesTableCell*)preferencesTable:(UIPreferencesTable*)aTable cellForRow:(int)row inGroup:(int)group
{
	switch( group )
	{
		case 0: return _prefGroup;
		case 1: return [_tableCells objectAtIndex:row];
	}
}

- (void) tableRowSelected: (NSNotification*) notification 
{
	switch( [_table selectedRow] )
	{
		case 3: NSLog(@"Selected Zero Icons"); [_displayOrderView setNumberDockIcons:0]; break;
		case 4: NSLog(@"Selected One Icon"); [_displayOrderView setNumberDockIcons:1]; break;
		case 5: NSLog(@"Selected Two Icons"); [_displayOrderView setNumberDockIcons:2]; break;
		case 6: NSLog(@"Selected Three Icons"); [_displayOrderView setNumberDockIcons:3]; break;
		case 7: NSLog(@"Selected Four Icons"); [_displayOrderView setNumberDockIcons:4]; break;
		case 8: NSLog(@"Selected Five Icons"); [_displayOrderView setNumberDockIcons:5]; break;
		case 9: NSLog(@"Selected Six Icons"); [_displayOrderView setNumberDockIcons:6]; break;
		case 10: NSLog(@"Selected Seven Icons"); [_displayOrderView setNumberDockIcons:7]; break;
		case 11: NSLog(@"Selected Eight Icons"); [_displayOrderView setNumberDockIcons:8]; break;
		case 12: NSLog(@"Selected Nine Icons"); [_displayOrderView setNumberDockIcons:9]; break;
		
	}
	
	[self buildPreferencesTable];
	// Warn user that the change won't go into effect until they look at the order.
	UIAlertSheet *sheet = [[UIAlertSheet alloc] initWithFrame: CGRectMake(0, 240, 320, 240)];
	[sheet setTitle:@"Please note:"];
	[sheet setBodyText:@"To save these changes load the Manual Reorder screen."];
	[sheet addButtonWithTitle:@"OK"];
	[sheet setDelegate: self];
	[sheet presentSheetFromAboveView: self];
	
	// Save the displayOrder when loaded.
  [_displayOrderView saveOnBuild];
  [_application transitionToChooserWith:2 toView:@"presetLoaderView"];
}

- (void)alertSheet:(UIAlertSheet *)sheet buttonClicked:(int)button 
{
	[sheet dismiss];
}


@end


	
