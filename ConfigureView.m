/**
 * ConfigureView.h
 * This file is part of Customize by The Spicy Chicken
 *
 * Allows the user to configure customize to match their system
**/

#import <UIKit/UINavigationBar.h>
#import <UIKit/UINavBarButton.h>
#import <UIKit/UINavigationItem.h>
#import "CSPreferencesTableCell.h"
#import "ConfigureView.h"

@implementation ConfigureView : UIView

- (id) initWithApplication:(UIApplication*)app withFrame:(struct CGRect)rect withDeviceInfo:(DeviceInfo*)deviceInfo
{
	_application = app;
	_built = NO;
	_deviceInfo  = deviceInfo;
	
	[super initWithFrame: rect];
	
	UINavigationBar *titlebar = [[UINavigationBar alloc] initWithFrame: CGRectMake(0.0f, 0.0f, 320.0f, 42.0f)];
	UINavigationItem* title = [[UINavigationItem alloc] initWithTitle:@"Configure"];
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
	
	[self addSubview: titlebar];
	[self addSubview: _table];
	
	return self;
}

/**
 * Builds the pref table if not yet built
**/
- (void) buildTableIfNotBuilt
{
	if (!_built)
	{
		_built = YES;
		[self buildPreferencesTable];
	}
}

/**
 * This builds of up the section list table, headers and all, with test data
**/
- (void) buildPreferencesTable
{
	[_prefCells release];
	_prefCells = [[NSMutableArray alloc] init];
	
	ConfigureTableCell* cell;
	
	// Create Group (Platform)
	[_prefCells addObject:[[NSMutableArray alloc] init]];
	
	cell = [[ConfigureTableCell alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 300.0f, 42.0f)];
	[cell setTitle:@"iPhone"];
	[cell setTitleValue:@"iphone"];
	[cell setShowDisclosure:NO];
	[cell setCellOutline:1];
	if ([_deviceInfo isIphone])
	{
		[cell setChecked:YES];
	}
	[[_prefCells objectAtIndex:([_prefCells count]-1)] addObject: cell];
	
	cell = [[ConfigureTableCell alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 300.0f, 42.0f)];
	[cell setTitle:@"iPod Touch"];
	[cell setTitleValue:@"ipod"];
	[cell setShowDisclosure:NO];
	[cell setCellOutline:1];
	if ([_deviceInfo isIpod])
	{
		[cell setChecked:YES];
	}
	[[_prefCells objectAtIndex:([_prefCells count]-1)] addObject: cell];
	
	// Create Group (Firmware)
	[_prefCells addObject:[[NSMutableArray alloc] init]];
	
	cell = [[ConfigureTableCell alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 300.0f, 42.0f)];
	[cell setTitle:@"1.0.2"];
	[cell setTitleValue:@"1.0.2"];
	[cell setShowDisclosure:NO];
	[cell setCellOutline:1];
	if ([[_deviceInfo firmware] isEqualToString:@"1.0.2"])
	{
		[cell setChecked:YES];
	}
	[[_prefCells objectAtIndex:([_prefCells count]-1)] addObject: cell];
	
	cell = [[ConfigureTableCell alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 300.0f, 42.0f)];
	[cell setTitle:@"1.1.1"];
	[cell setTitleValue:@"1.1.1"];
	[cell setShowDisclosure:NO];
	[cell setCellOutline:1];
	if ([[_deviceInfo firmware] isEqualToString:@"1.1.1"])
	{
		[cell setChecked:YES];
	}
	[[_prefCells objectAtIndex:([_prefCells count]-1)] addObject: cell];
	
	cell = [[ConfigureTableCell alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 300.0f, 42.0f)];
	[cell setTitle:@"1.1.2"];
	[cell setTitleValue:@"1.1.2"];
	[cell setShowDisclosure:NO];
	[cell setCellOutline:1];
	if ([[_deviceInfo firmware] isEqualToString:@"1.1.2"])
	{
		[cell setChecked:YES];
	}
	[[_prefCells objectAtIndex:([_prefCells count]-1)] addObject: cell];
	
	[_table reloadData];
}

/**
 * Unchecks all of the cells
**/
- (void) unCheckAllCellsInGroup:(int)group
{
	int j;
	
	for(j=0;j<[[_prefCells objectAtIndex:group] count];j++)
	{
			[[[_prefCells objectAtIndex:group] objectAtIndex:j] setChecked:NO];
	}
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

- (ConfigureTableCell*)preferencesTable:(UIPreferencesTable*)aTable cellForGroup:(int)group
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
	return FALSE;
}

- (ConfigureTableCell*)preferencesTable:(UIPreferencesTable*)aTable cellForRow:(int)row inGroup:(int)group
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
	[self unCheckAllCellsInGroup:group];
	[[[_prefCells objectAtIndex:group] objectAtIndex:row] setSelected:YES withFade:YES];
	[[[_prefCells objectAtIndex:group] objectAtIndex:row] setChecked:YES];
	
	switch(group)
	{
		case 0:
			// platform
			[_deviceInfo setPlatform:[[[_prefCells objectAtIndex:group] objectAtIndex:row] getValue]];
			break;
		case 1:
			// firmware
			[_deviceInfo setFirmware:[[[_prefCells objectAtIndex:group] objectAtIndex:row] getValue]];
			break;
	}
}

/**
 * Calls application method to transition to selection view
**/
- (void) transitionToSelectionView
{	
	[_application transitionToSelectionViewWith:2];
}

@end