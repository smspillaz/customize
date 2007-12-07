/**
 * PresetLoaderView.m
 * This file is part of Customize by The Spicy Chicken
**/

#import <Foundation/Foundation.h>
#import <CoreFoundation/CoreFoundation.h>
#import <UIKit/CDStructures.h>
#import <UIKit/UIAlertSheet.h>
#import <UIKit/UINavigationItem.h>
#import <UIKit/UIView.h>
#import "RuleParser.h"
#import "PresetLoaderView.h"
#import "../CSPreferencesTableCell.h"

@implementation PresetLoaderView : UIView

- (id) initWithApplication:(UIApplication *)app withFrame:(struct CGRect)rect withDeviceInfo:(DeviceInfo *)deviceInfo
  withDisplayOrderView:(DisplayOrderView *)displayOrderView
{
  //Init view with frame rect
	[super initWithFrame: rect];
	
	_deviceInfo = deviceInfo;
  _rect = rect;
  _displayOrderView = displayOrderView;
  
  //Save application object
	_application = app;
	
	// Setup _mainView
	UIView* mainView = [[UIView alloc] initWithFrame: rect];
	UINavigationBar *titlebar = [[UINavigationBar alloc] initWithFrame: CGRectMake(0.0f, 0.0f, 320.0f, 42.0f)];
	UINavigationItem* title = [[UINavigationItem alloc] initWithTitle:@"Display Order"];
	[titlebar pushNavigationItem:title];
	[titlebar setBarStyle: 0];
	[titlebar enableAnimation];
	
	UINavBarButton* backButton = [[UINavBarButton alloc] initWithFrame: CGRectMake(0.0f, 7.0f, 90.0f, 32.0f)];
	[backButton setAutosizesToFit: FALSE];
	[backButton setTitle: @" Customize"];
	[backButton addTarget: self action: @selector(transitionToSelectionView) forEvents: 1];
	[backButton setNavBarButtonStyle: 2];
	
	[titlebar addSubview:backButton];
	
	_table = [[UIPreferencesTable alloc] initWithFrame: CGRectMake(0.0f, 42.0f, rect.size.width, rect.size.height - 42.0f)];
	[_table setDelegate:self];
	[_table setDataSource:self];
	
	[mainView addSubview: titlebar];
	[mainView addSubview: _table];
	
	_tableBuilt = NO;
	
	[self addSubview:mainView];
	
	return self;
  
}

/**
 * Calls application method to transition to selection view
**/
- (void) transitionToSelectionView
{
	[_application transitionToSelectionViewWith:2];
}

- (void) buildTableIfNotBuilt
{
  if (!_tableBuilt)
  {
    [self buildPreferencesTable];
    _tableBuilt = YES;
  }
}

- (void) buildPreferencesTable
{
  [_prefCells release];
	_prefCells = [[NSMutableArray alloc] init];
  CSPreferencesTableCell* cell;
  
  // Create Title Group
	[_prefCells addObject:[[NSMutableArray alloc] init]];
  
  // Add the title cell for the first group
  cell = [[CSPreferencesTableCell alloc] init];
  [cell setTitle:@"Settings"];
	[cell setEnabled:NO];
  [[_prefCells objectAtIndex:([_prefCells count]-1)] addObject: cell];
  
  // Create Group
	[_prefCells addObject:[[NSMutableArray alloc] init]];
  
  // Add cell to latest group
  cell = [[CSPreferencesTableCell alloc] initWithFrame:CGRectMake(0.0f, 0.0f, _rect.size.width, 42.0f)];
	[cell setTitle:@"Manual Reorder"];
	[cell setShowDisclosure:YES];
	[cell setCellOutline:1];
	[[_prefCells objectAtIndex:([_prefCells count]-1)] addObject: cell];
  
	// Create Title Group
	[_prefCells addObject:[[NSMutableArray alloc] init]];
  
  // Add the title cell for the first group
  cell = [[CSPreferencesTableCell alloc] init];
  [cell setTitle:@"Custom"];
	[cell setEnabled:NO];
  [[_prefCells objectAtIndex:([_prefCells count]-1)] addObject: cell];
  
  
  // Create Group
	[_prefCells addObject:[[NSMutableArray alloc] init]];
  
  // Add cell to latest group
  UIPreferencesTableCell* textCell = [[UIPreferencesTableCell alloc] init];
	[textCell setTitle:@"Number Dock Icons"];
  if ([_displayOrderView numberDockIcons] != -1)
    [textCell setValue:[[NSString alloc] initWithFormat:@"%i",[_displayOrderView numberDockIcons]]];
	[textCell setShowDisclosure:YES];
	[textCell setCellOutline:1];
  [[_prefCells objectAtIndex:([_prefCells count]-1)] addObject: textCell];
  
	
	// Create Second Title Group
	[_prefCells addObject:[[NSMutableArray alloc] init]];
  
  // Add the title cell for the second group
  cell = [[CSPreferencesTableCell alloc] init];
  [cell setTitle:@"Preset Orders"];
	[cell setEnabled:NO];
	[[_prefCells objectAtIndex:([_prefCells count]-1)] addObject: cell];
  
	// Create Second Group
	[_prefCells addObject:[[NSMutableArray alloc] init]];
  
  // Load presets from ~/Library/Customize/DOPresets
  NSFileManager* fm = [NSFileManager defaultManager];
	NSDirectoryEnumerator* dirEnumerator = [fm enumeratorAtPath: @"/var/root/Library/Customize/DOPresets"];
	
	NSString* filename;
	while (filename = [dirEnumerator nextObject])
	{
		[dirEnumerator skipDescendents];
    NSString *pathToRules = [[NSString alloc] initWithFormat:@"/var/root/Library/Customize/DOPresets/%@",filename];
		cell = [[CSPreferencesTableCell alloc] initWithFrame:CGRectMake(0.0f, 0.0f, _rect.size.width, 42.0f)];
  	[cell setTitle:[filename stringByDeletingPathExtension]];
  	[cell setShowDisclosure:YES];
  	[cell setCellOutline:1];
    [cell setView:pathToRules];
  	[[_prefCells objectAtIndex:([_prefCells count]-1)] addObject: cell];
		
	}
  
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
  if (group % 2 == 0) return 0;
	else return [[_prefCells objectAtIndex:group] count];
}

- (CSPreferencesTableCell*)preferencesTable:(UIPreferencesTable*)aTable cellForGroup:(int)group
{
	NSLog(@"Calling for cell for group: %i",group);
	
  if (group % 2 == 0) return [[_prefCells objectAtIndex:group] objectAtIndex:0];
  else return Nil;
}

- (float)preferencesTable:(UIPreferencesTable*)aTable heightForRow:(int)row inGroup:(int)group withProposedHeight:(float)proposed
{
  NSLog(@"Proposed size for group, %i, row, %i, is %f",group,row,proposed);
  if (group % 2 == 0) return 27.0f;
  else if (row == -1) return 5.0f; // padding
  else return proposed;
}

- (BOOL)preferencesTable:(UIPreferencesTable*)aTable isLabelGroup:(int)group
{
	if (group % 2 == 0) return TRUE;
	else 
	  return FALSE;
}

- (CSPreferencesTableCell*)preferencesTable:(UIPreferencesTable*)aTable cellForRow:(int)row inGroup:(int)group
{
	NSLog(@"Calling for cell for row: %i in group: %i",row,group);
	
	return [[_prefCells objectAtIndex:group] objectAtIndex:row];
}

- (void) tableRowSelected: (NSNotification*) notification 
{
	//NSLog(@"Selected : %i", [_table selectedRow]);
  
  if ([_table selectedRow] == 2)
  {
    _group = 1;
    _row = 0;
    // Go to DisplayOrderView
    [_application transitionToChooserWith:1 toView:@"displayOrderView"];
    
  } else if ([_table selectedRow] == 5)
  {
    _group = 3;
    _row = 0;
    // Go to the ToggleDockNumView
    [_application transitionToChooserWith:1 toView:@"toggleDockNumView"];
  } else if ([_table selectedRow] >= 8)
  {
    _group = 5;
    _row = [_table selectedRow] - 8;
    
    RuleParser *rp = [[RuleParser alloc] init];
    
    UIAlertSheet *sheet = [[UIAlertSheet alloc] initWithFrame: CGRectMake(0.0f, 0.0f, 320.0f, 340.0f)];
  	[sheet setTitle:[[NSString alloc] initWithFormat:@"%@ will order according to these rules:",[[[[[_prefCells objectAtIndex:_group] objectAtIndex:_row] getView] lastPathComponent] stringByDeletingPathExtension]]];
  	[sheet setBodyText:[rp textForRules:[[[_prefCells objectAtIndex:_group] objectAtIndex:_row] getView]]];
  	[sheet setDelegate: self];
  	
  	[sheet addButtonWithTitle:@"OK"];
  	[sheet addButtonWithTitle:@"Cancel"];
  	[sheet presentSheetFromAboveView: self];
  	
  }
  
	//NSLog(@"Found group,row %i,%i",group,row);
	
	[[[_prefCells objectAtIndex:_group] objectAtIndex:_row] setSelected:NO withFade:YES];
}

- (void)alertSheet:(UIAlertSheet *)sheet buttonClicked:(int)button 
{
	switch( button )
	{
		case 1:
			// OK
			[_displayOrderView buildWithRules:YES pathToRules:[[[_prefCells objectAtIndex:_group] objectAtIndex:_row] getView]];
      [_application transitionToChooserWith:1 toView:@"displayOrderView"];
			break;
		case 2:
			// Cancel
			break;
	}
	
	[sheet dismiss];
}

/*- (BOOL)respondsToSelector:(SEL)selector {
  NSLog(@"respondsToSelector: %s", selector);
  return [super respondsToSelector:selector];
}*/

@end