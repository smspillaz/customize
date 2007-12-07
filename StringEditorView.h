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

@interface StringEditorView : UIView
{
	UIPreferencesTable*	_table;
	UIApplication* 		_application;
	NSString* 				_applicationID;
	NSMutableArray*		_prefCells;
	id							_delegate;	
	CGRect					_rect;
	NSString*				_stringsPath;
	NSString*				_buStringsPath;
	bool						_tableBuilt;
	NSMutableDictionary*	_strings;
	NSDictionary*			_betterKeys;	// key matches key in strings dictionary, but value is a string that is user friendly
	int						_mode; 			// 0 => All, 1 => Only, 2 => Except
	NSArray*					_keyList;		// List of keys, that correspond to mode
}

- (id) initWithApplication: (UIApplication*)app withAppID: (NSString*)appID withFrame: (struct CGRect)rect
	withStringsPath:(NSString*)stringsPath
	withBackupStringsPath:(NSString*)buStringsPath
	withHeaderName:(NSString*)headerName
	withBetterKeys:(NSDictionary*)betterKeys
	withMode:(int)mode
	withKeyList:(NSArray*)keyList;
	
- (void) buildPreferencesTable;
- (void) setDelegate: (id)delegate;
- (void) transitionToSelectionView;
- (void) buildTableIfNotBuilt;

@end