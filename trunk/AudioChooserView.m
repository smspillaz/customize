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
#import "CSPreferencesTableCell.h"
#import "AudioChooserView.h"

#import <Celestial/AVItem.h>
#import <Celestial/AVController.h>
#import <Celestial/AVQueue.h>

#import <WebCore/WebFontCache.h>

@implementation AudioChooserView : UIView

- (id) initWithApplication: (UIApplication*)app withAppID: (NSString*)appID withFrame: (struct CGRect)rect
	withAlternateSoundFilesPath:(NSString*)altSoundFilesPath 
	withStockSoundFilePath:(NSString*)stockSoundFilePath
	withHeaderName:(NSString*)headerName
{
	_rect = rect;
	//Init view with frame rect
	[super initWithFrame: rect];
	
	//Save application object
	_application = app;
	_applicationID = appID;
	
	// set up globals
	_altSoundFilesPath = altSoundFilesPath;
	_stockSoundFilePath = stockSoundFilePath;
	
	// Setup _mainView
	UIView* mainView = [[UIView alloc] initWithFrame: rect];
	
	// Set up Title Bar
	UINavigationBar *titlebar = [[UINavigationBar alloc] initWithFrame: CGRectMake(0.0f, 0.0f, rect.size.width, 42.0f)];
	UINavigationItem* title = [[UINavigationItem alloc] initWithTitle:headerName];
	[titlebar pushNavigationItem:title];
	[titlebar setBarStyle: 0];
	[titlebar enableAnimation];
	
	UINavBarButton* backButton = [[UINavBarButton alloc] initWithFrame: CGRectMake(3.0f, 7.0f, 75.0f, 32.0f)];
	[backButton setAutosizesToFit: FALSE];
	[backButton setTitle: @"  Sounds"];
	[backButton addTarget: self action: @selector(transitionToSelectionView) forEvents: 1];
	[backButton setNavBarButtonStyle: 2];
	
	[titlebar addSubview:backButton];
	
	[self addSubview:titlebar];	
	
	_table = [[UIPreferencesTable alloc] initWithFrame: CGRectMake(0.0f, 42.0f, rect.size.width, rect.size.height - 42.0f)];
	[_table setDelegate:self];
	[_table setDataSource:self];
	
	[mainView addSubview: titlebar];
	[mainView addSubview: _table];
	
	// Set up Audio Controller and Queue
	_avc = [[AVController alloc] init];
	_avq = [[AVQueue alloc] init];
	
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
 * Call application method
**/
- (void) transitionToSelectionView
{
	[_application transitionToChooserWith:2 toView:@"audioSelectionView"];
}

- (void) playFile:(NSString*)filepath
{
	NSString* error;
	AVController* avc = [[AVController alloc] init];
	AVQueue* avq = [[AVQueue alloc] init];
	
	[avc setDelegate:self];
	
	AVItem* avi = [[AVItem alloc] initWithPath:filepath error:&error];
	NSLog(@"Init AVItem with %@",error);
	[avq appendItem:avi error:&error];
	NSLog(@"appending with %@",error);
	
	[avc setQueue:avq];
	[avc play:nil];
}

/**
 * This builds of up the section list table, headers and all, with test data
**/
- (void) buildPreferencesTable
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	NSFileManager* fm = [NSFileManager defaultManager];
	NSDirectoryEnumerator *dir_en, *file_en;
	NSString *filename, *filepath, *dirname;
	AudioTableCell* cell;
	int i;
	
	[_prefCells release];
	_prefCells = [[NSMutableArray alloc] init];
	
	// Add the default choice
	[_prefCells addObject:[[NSMutableArray alloc] init]];
	
	cell = [[AudioTableCell alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 300.0f, 42.0f)];
	[cell setTitle:@"Revert to Backup"];
	[cell setShowDisclosure:NO];
	[cell setCellOutline:1];
	[cell setAsDefault];
	[cell setFilepath:[[NSString alloc] initWithFormat:@"%@.bu",_stockSoundFilePath]];
	[[_prefCells objectAtIndex:([_prefCells count]-1)] addObject: cell];
	
	[fm changeCurrentDirectoryPath: _altSoundFilesPath];
	
	dir_en = [fm enumeratorAtPath:_altSoundFilesPath];
	
	while (dirname = [dir_en nextObject])
	{
		// Don't decend to that level
		[dir_en skipDescendents];	
		
		if ([dirname characterAtIndex:0] != '.')
		{
			// Make a directory group
			[_prefCells addObject:[[NSMutableArray alloc] init]];
			cell = [[AudioTableCell alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 300.0f, 45.0f)];
			[cell setTitle:dirname];
			[cell setShowDisclosure:NO];
			[cell setCellOutline:1];
			[cell setAsHeader];
			[[_prefCells objectAtIndex:([_prefCells count]-1)] addObject: cell];
			
			// Group the sound files by directories
			[_prefCells addObject:[[NSMutableArray alloc] init]];
			
			file_en = [fm enumeratorAtPath:[_altSoundFilesPath stringByAppendingPathComponent:dirname]];
			
			while (filename = [file_en nextObject])
			{
				// Check that this is the leader image file of the group
				if ([filename characterAtIndex:0] != '.')
				{
					
					// this is filename
					filepath = [[NSString alloc] initWithString:[[_altSoundFilesPath stringByAppendingPathComponent:dirname] stringByAppendingPathComponent:filename]];
					
					NSLog(@"sound file path = %@",filepath);
					
					cell = [[AudioTableCell alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 300.0f, 42.0f)];
					[cell setTitle:[filename stringByDeletingPathExtension]];
					[cell setShowDisclosure:NO];
					[cell setCellOutline:1];
					[cell setFilepath:filepath];
					
					// add this cell to the growing prefCells
					[[_prefCells objectAtIndex:([_prefCells count]-1)] addObject: cell];
					
				}
			}
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

- (AudioTableCell*)preferencesTable:(UIPreferencesTable*)aTable cellForGroup:(int)group
{
	NSLog(@"Calling for cell for group: %i",group);
	
	return Nil;
}

- (float)preferencesTable:(UIPreferencesTable*)aTable heightForRow:(int)row inGroup:(int)group withProposedHeight:(float)proposed
{
	NSLog(@"Proposed: %f",proposed);
	if ([[[_prefCells objectAtIndex:group] objectAtIndex:0] isHeader])
		return 20.0f;
	else return proposed;
}

- (BOOL)preferencesTable:(UIPreferencesTable*)aTable isLabelGroup:(int)group
{
	NSLog(@"isLabelGroup? %i",group);
	return [[[_prefCells objectAtIndex:group] objectAtIndex:0] isHeader];
}

- (AudioTableCell*)preferencesTable:(UIPreferencesTable*)aTable cellForRow:(int)row inGroup:(int)group
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
	
	if (![[[_prefCells objectAtIndex:group] objectAtIndex:row] isHeader])
	{
		NSString* filepath = [[[_prefCells objectAtIndex:group] objectAtIndex:row] getFilepath];
		NSLog(@"Found group,row %i,%i with filepath %@",group,row, filepath);

		if (![[[_prefCells objectAtIndex:group] objectAtIndex:row] isDefault])
			[self playFile:filepath];

		[self unCheckAllCells];
		[[[_prefCells objectAtIndex:group] objectAtIndex:row] setChecked:YES];
		[[[_prefCells objectAtIndex:group] objectAtIndex:row] setSelected:NO withFade:YES];

		//copyFile([filepath UTF8String],[_stockSoundFilePath UTF8String]);
    NSCopyFile(filepath,_stockSoundFilePath);
		[_application setRestartSpringBoard];
	}
}

- (void) unCheckAllCells
{
	int i,j;
	
	for(i=0;i<[_prefCells count];i++)
	{
		for(j=0;j<[[_prefCells objectAtIndex:i] count];j++)
		{
			[[[_prefCells objectAtIndex:i] objectAtIndex:j] setChecked:NO];
		}
	}
}

- (void) setDelegate: (id)delegate;
{
	_delegate = delegate;
	
	[self buildPreferencesTable];
}

@end