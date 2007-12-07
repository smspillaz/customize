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
#import <UIKit/UIView.h>
#import <UIKit/UITableCell.h>
#import <UIKit/UIImageAndTextTableCell.h>
#import <UIKit/UITable.h>
#import <UIKit/UITableColumn.h>
#import <UIKit/UINavigationBar.h>
#import <UIKit/UITextView.h>
#import <UIKit/UIPreferencesTable.h>
#import "DisplayOrderView.h"

@interface ToggleDockNumView : UIView
{
	UIPreferencesTable*				_table;
	UIApplication* 						_application;
	NSString* 								_applicationID;
	NSMutableArray*						_tableCells;
	id												_delegate;	
	UIPreferencesTableCell* 	_prefGroup;
	DisplayOrderView*					_displayOrderView;
  bool                      _built;
}

- (id) initWithFrame: (struct CGRect)rect withApp: (UIApplication*)app withDisplayOrderView: (DisplayOrderView*)displayOrderView;
- (void) buildPreferencesTable;
- (void) buildTableIfNotBuilt;

@end