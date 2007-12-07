/**
 * AppObject.m
 * This file is part of Customize by The Spicy Chicken
 *
 * Represents an Application in the user's /Applications folder
**/

#import "AppObject.h"
#import "DisplayOrderView.h"


@implementation AppObject : NSObject

- (id) initWithPath:(NSString*)path withName:(NSString*)name withIconPath:(NSString*)iconPath withIdentifier:(NSString*)identifier isHidden:(bool)hidden 
	withDisplayOrderView:(UIView*)displayOrderView
{
	_path = path;
	_name = name;
	_iconPath = iconPath;
	_identifier = identifier;
	_hidden = hidden;
	_displayOrderView = (DisplayOrderView*) displayOrderView;
	
	// Set up the table cell, used by the ListSortView
	_tableCell = [[UIImageAndTextTableCell alloc] init];
	[_tableCell setTitle:_name];
	
	UIImageView* iconView = [_tableCell iconImageView];
	UIImage* icon = [UIImage imageAtPath:_iconPath];
	[iconView setImage:icon];
	[iconView setFrame:CGRectMake(0.0f, 0.0f, 40.0f, 40.0f)];
	
	// Set up the "hide" image view.
	UIImage* hideImage = [UIImage imageAtPath:@"/Applications/Customize.app/icons/hide.png"];
	_hideImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5.0, 10.0, 23.0, 23.0)];
	[_hideImageView setImage:hideImage];
	
	// Set up the "hide_dim" image view
  UIImage* dimImage = [UIImage imageAtPath:@"/Applications/Customize.app/icons/hide_dim.png"];
  _dimImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5.0, 10.0, 23.0, 23.0)];
  [_dimImageView setImage:dimImage];
  
	_toggleButton = [[UIPushButton alloc] initWithFrame: CGRectMake(0.0, 0.0, 210.0, 45.0)];
	[_toggleButton setDrawsShadow: YES];
	[_toggleButton setEnabled:YES];
	[_toggleButton setStretchBackground:NO];
	[_toggleButton addTarget:self action: @selector(toggleView) forEvents:1];
	
	[_tableCell addSubview:_toggleButton];
  
  _buttonActive = NO;
  
	if (!_hidden) [self unhide];
	else [self hide];
	
	return self;
}

/**
 * Hide Button Pushed
**/
- (void) toggleView {
	
	if (_buttonActive)
	{
	  NSLog(@"App View being toggled.");
	  if (_hidden) [self unhide];
	  else [self hide];
	  
	  [_displayOrderView saveOrderToFile];
  }
}

/**
 * Hides the app by changing the image that's displayed to the
 * unhide button, and also setting the hidden flag to true.
**/
- (void) hide {
	[_hideImageView removeFromSuperview];
  [_dimImageView removeFromSuperview];
	_hidden = YES;
}
/**
 * UnHides the app by changed the image that's dispalyed to the
 * hide button, and also setting the hidden flag to false.
**/
- (void) unhide {
	[_hideImageView removeFromSuperview];
  [_dimImageView removeFromSuperview];
	
	if (_buttonActive)
	  [_tableCell addSubview:_hideImageView];
	else
    [_tableCell addSubview:_dimImageView];
  
	_hidden = NO;
}

- (void) toggleHiding
{
  if (_buttonActive) [self deactivateHideButton];
  else [self activateHideButton];
}

- (void) activateHideButton
{
  _buttonActive = YES;
  
  if (!_hidden) [self unhide];
}

- (void) deactivateHideButton
{
  _buttonActive = NO;
  
  if (!_hidden) [self unhide];
}

- (bool)hidden {
	return _hidden;
}

- (NSString*)identifier {
	return _identifier;
}

- (NSString*)name {
	return _name;
}

- (NSString*)iconPath {
	return _iconPath;
}

- (NSString*)path {
	return _path;
}

- (UIImageAndTextTableCell*)tableCell {
	return _tableCell;
}

- (BOOL)respondsToSelector:(SEL)selector {
  NSLog(@"respondsToSelector: %s", selector);
  return [super respondsToSelector:selector];
}

@end