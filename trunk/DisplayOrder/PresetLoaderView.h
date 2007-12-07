/**
 * PresetLoaderView.h
 * This file is part of Customize by The Spicy Chicken
**/

#import <Foundation/Foundation.h>
#import <CoreFoundation/CoreFoundation.h>
#import <UIKit/UIApplication.h>
#import <UIKit/UIView.h>
#import <UIKit/UITableCell.h>
#import <UIKit/UIImageAndTextTableCell.h>
#import <UIKit/UITable.h>
#import <UIKit/UITableColumn.h>
#import <UIKit/UINavigationBar.h>
#import <UIKit/UIPreferencesTable.h>
#import "DisplayOrderView.h"
#import "../DeviceInfo.h"

@interface PresetLoaderView : UIView
{
	struct CGRect		    _rect;
	float						    _titlebarHeight;
	bool 						    _tableBuilt;
  int                 _row,_group;
  
	UIApplication*	    _application;
	DeviceInfo*			    _deviceInfo;
	
  UIPreferencesTable* _table;
  NSMutableArray      *_prefCells;
  
  DisplayOrderView*   _displayOrderView;
  
}

- (id) initWithApplication:(UIApplication*)app withFrame:(struct CGRect)rect withDeviceInfo:(DeviceInfo *)deviceInfo 
  withDisplayOrderView:(DisplayOrderView *)displayOrderView;
- (void) buildTableIfNotBuilt;
- (void) buildPreferencesTable;

@end