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
#import <UIKit/UINavigationBar.h>
#import <UIKit/UIPreferencesTable.h>

#import <Celestial/AVItem.h>
#import <Celestial/AVController.h>
#import <Celestial/AVQueue.h>

#import <WebCore/WebFontCache.h>

@interface AudioChooserView : UIView
{
	UIPreferencesTable*	_table;
	UIApplication* 		_application;
	NSString* 				_applicationID;
	NSMutableArray*		_prefCells;
	id							_delegate;	
	CGRect					_rect;
	NSString*				_altSoundFilesPath;			// path to directory containing alternate images
	NSString*				_stockSoundFilePath; 		// holds the stock image paths for where SB looks for these
  NSString*       _backUpDirectoryPath;   // path to the back up file
	bool						_tableBuilt;
	
	AVController*			_avc;
	AVQueue*					_avq;
	
}

- (id) initWithApplication: (UIApplication*)app withAppID: (NSString*)appID withFrame: (struct CGRect)rect
	withAlternateSoundFilesPath:(NSString*)altSoundFilesPath 
	withStockSoundFilePath:(NSString*)stockSoundFilePath
	withBackUpDirectoryPath:(NSString*)backUpDirectoryPath
	withHeaderName:(NSString*)headerName;
- (void) playFile:(NSString*)filepath;
- (void) buildPreferencesTable;
- (void) setDelegate: (id)delegate;
- (void) transitionToSelectionView;
- (void) buildTableIfNotBuilt;

@end