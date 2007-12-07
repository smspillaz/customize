/**
 * ListSortView.m
 * This file is part of Customize by The Spicy Chicken
**/
#import <UIKit/UIImageAndTextTableCell.h>
#import <UIKit/UITableColumn.h>
#import <UIKit/UITableCell.h>
#import "ListSortView.h"
#import "AppObject.h"
#import "DisplayOrderView.h"

@implementation ListSortView : UIView

- (id) initWithAppObjects:(NSArray*)appObjects withFrame:(struct CGRect)rect withNumberDockIcons:(int)numberDockIcons withPathToDisplayOrder:(NSString*)pathToDisplayOrder
	withDisplayOrderView:(UIView*)displayOrderView
{
	[super initWithFrame:rect];
	
	_displayOrderView = (DisplayOrderView*) displayOrderView;
	_appObjects = appObjects;
	[_appObjects retain];
	_pathToDisplayOrder = pathToDisplayOrder;
	_numberDockIcons = numberDockIcons;
	
	_sectionList = [[UISectionList alloc] initWithFrame:rect showSectionIndex:NO];
	[_sectionList setDataSource:self];
	
	_appTable = [_sectionList table];
	[_appTable setShouldHideHeaderInShortLists:NO];
	
	UITableColumn * packageColumn = [[UITableColumn alloc] initWithTitle:@"Column 1" identifier:@"column1" width:320.0f];
	[_appTable addTableColumn:packageColumn];
	
	[_appTable setSeparatorStyle:1];
	[_appTable setRowHeight:45.0f];
	[_appTable setDelegate:self];
	[_appTable setAllowsReordering:YES];  
	[_appTable setControlTint:1]; // don't know ?
	[_appTable setAllowsScrollIndicators:YES];
	
	// Set up the list headers
	_listHeaders = [[NSMutableArray alloc] init];
	
	NSMutableDictionary* dockHeader = [[NSMutableDictionary alloc] initWithCapacity:2];
	NSMutableDictionary* iconHeader = [[NSMutableDictionary alloc] initWithCapacity:2];
	
	[dockHeader setObject:@"Dock" forKey:@"title"];
	[dockHeader setObject:[[NSNumber alloc] initWithInt:0] forKey:@"beginRow"];
	
	[iconHeader setObject:@"Spring Board" forKey:@"title"];
	[dockHeader setObject:[[NSNumber alloc] initWithInt:_numberDockIcons] forKey:@"beginRow"];
	NSLog(@"Number of dock icons is %i",_numberDockIcons);
	
	[_listHeaders addObject:dockHeader];
	[_listHeaders addObject:iconHeader];
	
	[_sectionList reloadData];
	[self addSubview:_sectionList];
	
	return self;
}
/**
 * Reload Table
**/
- (void) reloadData
{
	[_displayOrderView saveOrderToFile];
	[_sectionList reloadData];
}

/**
 * Start Reorder
 * This method must be called before reordering can take place.  It also must
 * be called outside of the initialize method.
**/
- (void)startReorderTable {
	
	// this must be done outside the initialization of the table for the reorder column to be displayed correctly
	[_appTable enableRowDeletion:YES animated:YES];
}

/**
 * Delegate Functions
**/

- (int)numberOfSectionsInSectionList:(UISectionList *)aSectionList {
	NSLog(@"The numberOfSectionsInSectionList : %i",[_listHeaders count]);
	return [_listHeaders count];
}
        
- (NSString *)sectionList:(UISectionList *)aSectionList titleForSection:(int)row {	
	NSLog(@"Return title, %@, for row, %i",[[_listHeaders objectAtIndex:row] objectForKey:@"title"],row);
	return [[_listHeaders objectAtIndex:row] objectForKey:@"title"];
}       
        
- (int)sectionList:(UISectionList *)aSectionList rowForSection:(int)row {
	// this is what determines the placement of the header
	// TODO: These are just return 0, instead of what they should be returning
	// TODO: WHY!!?
	//NSLog(@"Return row, %i, for section row, %i",[[[_listHeaders objectAtIndex:row] valueForKey:@"beginRow"] intValue],row);
	//return [[[_listHeaders objectAtIndex:row] valueForKey:@"beginRow"] intValue];
	
	switch(row)
	{
		case 0:
			return 0; // dock location
			break;
		case 1:
			return _numberDockIcons;	// springboard locations
			break;
	}
}

- (UITableCell*) table: (UISectionTable*)table cellForRow: (int)row column: (int)col
{
	return [[_appObjects objectAtIndex: row] tableCell];
}

- (UITableCell*) table: (UISectionTable*)table cellForRow: (int)row column: (int)col reusing: (BOOL) reusing
{
	return nil;
}

- (int) numberOfRowsInTable: (UISectionTable*)table
{
	return [_appObjects count];
}

- (void) tableRowSelected: (NSNotification*) notification 
{
	NSLog(@"Cell %i selected.",[_appTable selectedRow]);
	
}

/**
 * Reordering methods
**/
- (BOOL)table:(UISectionTable*)table canDeleteRow:( int)row {
	NSLog(@"canDeleteRow: %d",row);
	// Rows cannot be deleted.
	return NO;
}

/**
 * this method must be declared so that rows can be moved
 * if you don't want to delete rows, then return NO from table:canDeleteRow:
**/
- (void)table:(UISectionTable*)table deleteRow:(int)row {
	// the remove code
}

- (BOOL)table:(UISectionTable*)table canMoveRow:(int)row{
	// All rows can be moved.
	return YES;
}

- (int)table:(UISectionTable *)table movedRow:(int)row toRow:(int)toRow
{
	if (row < [_appObjects count])
	{
		NSLog(@"Exchanging row %i for row %i",row,toRow);
		AppObject* app = [_appObjects objectAtIndex:row];
		[_appObjects removeObjectAtIndex:row];
		[_appObjects insertObject:app atIndex:toRow];
		
		_movedRow = toRow;
		
		return toRow;
	}
}

- (int) table:(UISectionTable *) table moveDestinationForRow:(int)row withSuggestedDestinationRow:(int) suggestedRow 
{
	NSLog(@"For Row: %i Suggested Row: %i ",row,suggestedRow);
	
	return suggestedRow;
}

- (void) tableDidFinishMovingRow:(NSNotification*) notification
{
	NSLog(@"Finished moving row");
	
	[_sectionList reloadData];
	[_appTable selectRow:_movedRow byExtendingSelection:YES];
	
	// Save display list order
	[_displayOrderView saveOrderToFile];
}


@end