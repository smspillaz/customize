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
#import <UIKit/UIView.h>
#import <UIKit/UIView-Hierarchy.h>
#import <UIKit/UIHardware.h>
#import <UIKit/UINavBarButton.h>
#import <UIKit/UINavigationBar.h>
#import <UIKit/UINavigationItem.h>
#import <UIKit/UITable.h>
#import <UIKit/UITableCell.h>
#import <UIKit/UITableColumn.h>
#import <UIKit/UIImage.h>
#import <UIKit/UIImageView.h>
#import <UIKit/UISectionList.h>
#import <UIKit/UISectionTable.h>
#import <UIKit/UIImageAndTextTableCell.h>
#import <UIKit/UIAlertSheet.h>
#import "ChooserView.h"
#import "ChooserTableCell.h"

@implementation ChooserView : UIView

- (id) initWithApplication: (UIApplication*)app withAppID: (NSString*)appID withFrame: (struct CGRect)rect 
	withAlternateImagesPath:(NSString*)altImagesPath 
	withStockImagePaths:(NSMutableArray*)stockImagePaths
	withHeaderName:(NSString*)headerName 
	withTransformRatio:(float)transformRatio 
	withYOffset:(float)yOffset 
	withXOffset:(float)xOffset 
	withImageHeight:(float)imageHeight 
	withImageWidth:(float)imageWidth
	withRowHeight:(float)rowHeight
	withAlertHeight:(int)alertHeight
	withAlertTransformRatio:(float)alertTransformRatio
	withAlertTopPadding:(float)alertTopPadding
	showOnlyMainImage:(bool)showOnlyMainImage
	usePreviewIfAvailable:(bool)usePreview
{
	_altImagesPath = altImagesPath;
	_stockImagePaths = stockImagePaths;
	
	_showOnlyMainImage = showOnlyMainImage;
	_usePreview = usePreview;
	
	// set the number of images in the set
	_numInSet = [_stockImagePaths count];
	_transformRatio = transformRatio;
	_alertTransformRatio = alertTransformRatio;
	
	_headerName = headerName;
	
	_imageXOffset = xOffset;
	_imageYOffset = yOffset;
	_imageHeight = imageHeight;
	_imageWidth = imageWidth;
	_alertHeight = alertHeight;
	_alertTopPadding = alertTopPadding;
	
	//Init view with frame rect
	[super initWithFrame: rect];
	
	// Save application object and id
	_application = app;
	_applicationID = appID;
	
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
	
	_sectionList = [[UISectionList alloc] initWithFrame:CGRectMake(0.0f, 42.0f, rect.size.width, rect.size.height - 42.0f) showSectionIndex:NO];
	[_sectionList setDataSource:self];
	[_sectionList reloadData];
	
	[self addSubview:_sectionList];
	
	_table = [_sectionList table];
	[_table setShouldHideHeaderInShortLists:NO];
	
	UITableColumn * packageColumn = [[UITableColumn alloc] initWithTitle:@"Images" identifier:@"images" width:320.0f];
	[_table addTableColumn:packageColumn];
	
	[_table setSeparatorStyle:1];
	[_table setRowHeight:rowHeight];
	[_table setDelegate:self];
	[_table setControlTint:1]; // don't know ?
	[_table setAllowsScrollIndicators:YES];
	
	_tableBuilt = NO;
	
	return self;
	
}

- (void) buildTableIfNotBuilt
{
	if (!_tableBuilt)
	{
		[self buildSectionListTable];
		_tableBuilt = YES;
	} 
}

/**
 * Call application method
**/
- (void) transitionToSelectionView
{
	[_application transitionToSelectionViewWith:2];
}

/**
 * Checks if the string has a dash -
**/
- (bool) stringHasDash:(NSString*)str
{
	if ([[str componentsSeparatedByString:@"-"] count] > 1)
	{
		NSLog(@"%@ has a dash.",str);
		return TRUE;
	} else {
		NSLog(@"%@ does not have a dash.",str);
		return FALSE;
	}
}

/**
 * This builds of up the section list table, headers and all, with test data
**/
- (void) buildSectionListTable
{
	NSLog(@"Building Section List Table");
	[_tableCells release];
	_tableCells = [[NSMutableArray alloc] init];
	[_tableHeaders release];
	_tableHeaders = [[NSMutableArray alloc] init];
	
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	NSFileManager* fm = [NSFileManager defaultManager];
	NSDirectoryEnumerator* dir_en;
	NSDirectoryEnumerator* file_en;
	NSString* filename;
	NSString* filepath;
	NSString* filepath2;
	NSString* dirname;
	NSMutableDictionary* cellDict;
	ChooserTableCell* cell;
	UIImage* dockImage;
	UIImageView* dockView;
	int filecount = 0;
	int i;
	
	[fm changeCurrentDirectoryPath: _altImagesPath];
	
	dir_en = [fm enumeratorAtPath:_altImagesPath];
	
	while (dirname = [dir_en nextObject])
	{
		// Don't decend to that level
		[dir_en skipDescendents];	
		
		if ([dirname characterAtIndex:0] != '.')
		{
			NSMutableDictionary* cellDict = [[NSMutableDictionary alloc] initWithCapacity:2];
			[cellDict setObject:dirname forKey:@"title"];
			[cellDict setObject:[[NSNumber alloc] initWithInt:filecount] forKey:@"beginRow"];
			[_tableHeaders addObject: cellDict];

			file_en = [fm enumeratorAtPath:[_altImagesPath stringByAppendingPathComponent:dirname]];
			
			while (filename = [file_en nextObject])
			{
				// Check that this is the leader image file of the group
				if ([filename characterAtIndex:0] != '.' && ![self stringHasDash:filename])
				{
					
					// filename is the base name for _numInSet images in this set, we need to add each one of those to
					// the filepaths array
					NSMutableArray* filepaths = [[NSMutableArray alloc] init];
					
					// this is filename
					[filepaths addObject:[[[NSString alloc] initWithString:[[_altImagesPath stringByAppendingPathComponent:dirname] stringByAppendingPathComponent:filename]] autorelease]];
					
					NSString* baseFilePath = [[filepaths objectAtIndex:0] substringToIndex:[[filepaths objectAtIndex:0] length] - 4];
					NSLog(@"baseFilePath = %@",baseFilePath);
					
					for(i=1;i<_numInSet;i++)
					{
						[filepaths addObject:[baseFilePath stringByAppendingString:[[[NSString alloc] initWithFormat:@"-%i.png",i] autorelease]]];
					}
					
					cell = [[ChooserTableCell alloc] init];
					[cell setFilepaths: filepaths];
					[cell setSelectionStyle:0];
					[cell setShowSelection:NO];
					[cell setShowDisclosure:NO];
					
					NSString* previewPath = [[[filepaths objectAtIndex:0] stringByDeletingPathExtension] stringByAppendingString:@"-preview.png"];
					if (_usePreview && [fm fileExistsAtPath:previewPath])
					{
						dockImage = [UIImage imageAtPath:previewPath];
						dockView = [[UIImageView alloc] initWithFrame:CGRectMake(_imageXOffset, 40.0f + _imageYOffset, _imageWidth, _imageHeight)];
						[dockView setImage:dockImage];
						[dockView setTransform: CGAffineTransformScale(CGAffineTransformMakeTranslation(0.0f, 0.0f), _transformRatio, _transformRatio)];
						[cell addSubview:dockView];

					} else if(_showOnlyMainImage)
					{
						dockImage = [UIImage imageAtPath:[filepaths objectAtIndex:0]];
						dockView = [[UIImageView alloc] initWithFrame:CGRectMake(_imageXOffset, _imageYOffset, _imageWidth, _imageHeight)];
						[dockView setImage:dockImage];
						[dockView setTransform: CGAffineTransformScale(CGAffineTransformMakeTranslation(0.0f, 0.0f), _transformRatio, _transformRatio)];
						[cell addSubview:dockView];
					} else {
						for(i=0;i<[filepaths count];i++)
						{
							if ([fm fileExistsAtPath:[filepaths objectAtIndex:i]])
							{
								dockImage = [UIImage imageAtPath:[filepaths objectAtIndex:i]];
								dockView = [[UIImageView alloc] initWithFrame:CGRectMake(_imageXOffset + (_imageWidth * i), _imageYOffset, _imageWidth, _imageHeight)];
								[dockView setImage:dockImage];
								[dockView setTransform: CGAffineTransformScale(CGAffineTransformMakeTranslation(0.0f, 0.0f), _transformRatio, _transformRatio)];
								[cell addSubview:dockView];
							} else {
								NSLog(@"Expected to find image at %@ not found.",[filepaths objectAtIndex:i]);
							}
						}
					}
					
					[_tableCells addObject: cell];
					filecount += 1;
				}
			}
		}
		
	}
	
	//Refresh the fileview table
	[_sectionList reloadData];
	[pool release];
}

- (void) setDockAsSelected
{
	NSFileManager* fileManager = [NSFileManager defaultManager];
	ChooserTableCell* cell = [_tableCells objectAtIndex:[_table selectedRow]];
	NSMutableArray* filepaths = [cell getFilepaths];
	int i;
	
	for(i=0;i<[filepaths count];i++)
	{
		if ([fileManager fileExistsAtPath:[filepaths objectAtIndex:i]])
		{
      NSCopyFile([filepaths objectAtIndex:i],[_stockImagePaths objectAtIndex:i]);
			//copyFile([[filepaths objectAtIndex:i] UTF8String],[[_stockImagePaths objectAtIndex:i] UTF8String]);
		} else {
			NSLog(@"Could not find expected file, %@",[filepaths objectAtIndex:i]);
		}
	}
	
	[_application setRestartSpringBoard];
}

- (int)numberOfSectionsInSectionList:(UISectionList *)aSectionList {
	return [_tableHeaders count];
}
        
- (NSString *)sectionList:(UISectionList *)aSectionList titleForSection:(int)row {	
	return [[_tableHeaders objectAtIndex:row] objectForKey:@"title"];
}       
        
- (int)sectionList:(UISectionList *)aSectionList rowForSection:(int)row {
	// this is what determines the placement of the header
		return [[[_tableHeaders objectAtIndex:row] valueForKey:@"beginRow"] intValue];
}
 
- (UITableCell*) table: (UISectionTable*)table cellForRow: (int)row column: (int)col
{
	return [_tableCells objectAtIndex: row];
}

- (UITableCell*) table: (UISectionTable*)table cellForRow: (int)row column: (int)col
    reusing: (BOOL) reusing
{
	//What does this message do?
    return nil;
}

- (int) numberOfRowsInTable: (UISectionTable*)table
{
	return [_tableCells count];
}

- (void) tableRowSelected: (NSNotification*) notification 
{
	ChooserTableCell* cell = [_tableCells objectAtIndex:[_table selectedRow]];
	NSMutableArray* filepaths = [cell getFilepaths];
	NSFileManager* fm = [NSFileManager defaultManager];
	UIImage* dockImage;
	UIImageView* dockView;
	NSString* bodyText = [[NSString alloc] initWithString:@""];
	int i;
	
	UIAlertSheet *sheet = [[UIAlertSheet alloc] initWithFrame: CGRectMake(0.0f, 0.0f, 320.0f, 340.0f)];
	[sheet setTitle:[[NSString alloc] initWithFormat:@"Set as %@ Image?",_headerName]];
	
	for(i=0;i<_alertHeight;i++)
	{
		bodyText = [bodyText stringByAppendingString:@"\n"];
	}
	[sheet setBodyText:bodyText];
	[sheet setDelegate: self];
	
	NSString* previewPath = [[[filepaths objectAtIndex:0] stringByDeletingPathExtension] stringByAppendingString:@"-preview.png"];
	
	NSLog(@"Preview path = %@",previewPath);
	
	if (_usePreview && [fm fileExistsAtPath:previewPath])
	{
		dockImage = [UIImage imageAtPath:previewPath];
		dockView = [[UIImageView alloc] initWithFrame:CGRectMake(_imageXOffset, _alertTopPadding + _imageYOffset, _imageWidth, _imageHeight)];
		[dockView setImage:dockImage];
		[dockView setTransform: CGAffineTransformScale(CGAffineTransformMakeTranslation(0.0f, 0.0f), _alertTransformRatio, _alertTransformRatio)];
		[sheet addSubview:dockView];
		
	} else if(_showOnlyMainImage)
	{
		dockImage = [UIImage imageAtPath:[filepaths objectAtIndex:0]];
		dockView = [[UIImageView alloc] initWithFrame:CGRectMake(_imageXOffset, _alertTopPadding + _imageYOffset, _imageWidth, _imageHeight)];
		[dockView setImage:dockImage];
		[dockView setTransform: CGAffineTransformScale(CGAffineTransformMakeTranslation(0.0f, 0.0f), _alertTransformRatio, _alertTransformRatio)];
		[sheet addSubview:dockView];
		
	} else {
		for(i=0;i<[filepaths count];i++)
		{
			if ([fm fileExistsAtPath:[filepaths objectAtIndex:i]])
			{
				dockImage = [UIImage imageAtPath:[filepaths objectAtIndex:i]];
				dockView = [[UIImageView alloc] initWithFrame:CGRectMake(_imageXOffset + (_imageWidth * i), _alertTopPadding + _imageYOffset, _imageWidth, _imageHeight)];
				[dockView setImage:dockImage];
				[dockView setTransform: CGAffineTransformScale(CGAffineTransformMakeTranslation(0.0f, 0.0f), _alertTransformRatio, _alertTransformRatio)];
				[sheet addSubview:dockView];
			} else {
				NSLog(@"Expected to find image at %@ not found.",[filepaths objectAtIndex:i]);
			}
		}
	}
	
	[sheet addButtonWithTitle:@"OK"];
	[sheet addButtonWithTitle:@"Cancel"];
	[sheet presentSheetFromAboveView: self];
}

- (void)alertSheet:(UIAlertSheet *)sheet buttonClicked:(int)button 
{
	NSLog(@"Button : %i",button);
	
	switch( button )
	{
		case 1:
			// OK
			[self setDockAsSelected];
			break;
		case 2:
			// Cancel
			break;
	}
	
	[sheet dismiss];
}

@end

