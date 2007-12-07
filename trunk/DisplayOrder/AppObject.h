/**
 * AppObject.h
 * This file is part of Customize by The Spicy Chicken
 *
 * Represents an Application in the user's /Applications folder
**/

#import <Foundation/Foundation.h>
#import <CoreFoundation/CoreFoundation.h>
#import <UIKit/CDStructures.h>
#import <UIKit/UIImage.h>
#import <UIKit/UIImageAndTextTableCell.h>
#import <UIKit/UIPushButton.h>


@interface AppObject : NSObject

{
	NSString*		_path;
	NSString*		_name;
	NSString*		_iconPath;
	NSString*		_identifier;
	bool				_hidden;
	
	UIImageView*	_hideImageView;
  UIImageView* _dimImageView;
	UIImageView*	_unhideImageView;
	
	UIPushButton*	_toggleButton;
  bool        _buttonActive;
	
	UIImageAndTextTableCell*	_tableCell;
	
	UIView*				_displayOrderView;
}

- (id) initWithPath:(NSString*)path withName:(NSString*)name withIconPath:(NSString*)iconPath withIdentifier:(NSString*)identifier isHidden:(bool)hidden;
- (NSString*) path;
- (NSString*) name;
- (NSString*) identifier;
- (NSString*) iconPath;
- (UIImageAndTextTableCell*) tableCell;
- (void) hide;
- (void) unhide;
- (bool) hidden;
- (void) activateHideButton;
- (void) deactivateHideButton;
- (void) toggleHiding;

@end