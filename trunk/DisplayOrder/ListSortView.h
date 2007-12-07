/**
 * ListSortView.m
 * This file is part of Customize by The Spicy Chicken
**/

#import <Foundation/Foundation.h>
#import <CoreFoundation/CoreFoundation.h>
#import <UIKit/CDStructures.h>
#import <UIKit/UISectionList.h>
#import <UIKit/UISectionTable.h>

@interface ListSortView : UIView
{
	UIView*					_displayOrderView;
	
	int							_numberDockIcons;
	NSString*				_pathToDisplayOrder;
	
	int							_prevSelected;
	int							_movedRow;
	
	NSArray*				_appObjects;
	
	UISectionList*	_sectionList;
	NSMutableArray*	_listHeaders;
	UISectionTable*	_appTable;
}

- (id) initWithAppObjects:(NSArray*)appObjects withFrame:(struct CGRect)rect withNumberDockIcons:(int)numberDockIcons 
	withDisplayOrderView:(UIView*)displayOrderView;
- (void)startReorderTable;
- (void)reloadData;

@end