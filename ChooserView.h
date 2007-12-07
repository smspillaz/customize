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
#import <UIKit/UIView.h>
#import <UIKit/UITableCell.h>
#import <UIKit/UIImageAndTextTableCell.h>
#import <UIKit/UITable.h>
#import <UIKit/UITableColumn.h>
#import <UIKit/UISectionList.h>
#import <UIKit/UISectionTable.h>


@interface ChooserView : UIView
{
	UISectionList*				_sectionList;
	UISectionTable*			_table;
	UIApplication* 			_application;
	NSString* 					_applicationID;
	NSString*					_headerName;
	NSMutableArray*			_tableCells;
	NSMutableArray*			_tableHeaders; 			// sections, an array of dictionarys that hold @"title" and @"beginRow"
	int							_prevSelectedRow;
	int							_currSelectedRow;
	int							_movedRow;
	NSString*					_altImagesPath;			// path to directory containing alternate images
	NSMutableArray*			_stockImagePaths; 		// holds the stock image paths for where SB looks for these
	int							_numInSet;					// number of images in the set
	float							_imageXOffset;
	float							_imageYOffset;
	float							_imageHeight;
	float							_imageWidth;
	int							_alertHeight;
	float							_transformRatio;
	float							_alertTransformRatio;
	float							_alertTopPadding;
	bool							_showOnlyMainImage;
	bool							_usePreview;
	bool							_tableBuilt;
}

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
	showOnlyMainImage:(bool)showMainOnly
	usePreviewIfAvailable:(bool)usePreview;

- (void) buildSectionListTable;
- (void) buildTableIfNotBuilt;

@end