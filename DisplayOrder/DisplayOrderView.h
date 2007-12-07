/**
 * DisplayOrderView.h
 * This file is part of Customize by The Spicy Chicken
**/

#import <Foundation/Foundation.h>
#import <CoreFoundation/CoreFoundation.h>
#import <UIKit/UIApplication.h>
#import <UIKit/UIView.h>
#import <UIKit/UINavBarButton.h>
#import "AppObject.h"
#import "ListSortView.h"
#import "../DeviceInfo.h"


@interface DisplayOrderView : UIView
{
	struct CGRect		_rect;
	float						_titlebarHeight;
	bool 						_built;
	
	ListSortView*		_listSortView;
	
	NSMutableArray*	_appObjects;
	
	int							_numberDockIcons;
	NSString*				_pathToDisplayOrder;
	
	UIApplication*	_application;
	
	DeviceInfo*			_deviceInfo;
	
  UINavBarButton* _toggleHidingButton;
  bool            _hidingActive;
  
  bool            _saveUponBuilding;
}

- (id) initWithApplication:(UIApplication*)app withFrame:(struct CGRect)rect;
- (void) buildTableIfNotBuilt;
- (void) initializeDisplayOrderView;
- (void) saveOrderToFile;
- (void) saveOnBuild;

@end