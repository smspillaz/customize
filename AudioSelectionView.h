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

@interface AudioSelectionView : UIView
{
	UIPreferencesTable*				_table;
	UIApplication* 					_application;
	NSString* 							_applicationID;
	NSMutableArray*					_prefCells;
	id										_delegate;	
	CGRect								_rect;
	bool									_tableBuilt;
}

- (id) initWithApplication: (UIApplication*)app withAppID: (NSString*)appID withFrame: (struct CGRect)rect;
- (void) buildPreferencesTable;
- (void) setDelegate: (id)delegate;
- (void) transitionToSelectionView;
- (void) buildTableIfNotBuilt;

@end