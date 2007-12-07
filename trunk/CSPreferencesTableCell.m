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
#import <UIKit/UIPreferencesTableCell.h>
#import "ChooserTableCell.h"
#import "CSPreferencesTableCell.h"

@implementation ConfigureTableCell : UIPreferencesTableCell

- (void) setTitleValue:(NSString*)value
{
	_titleValue = value;
}

- (NSString*) getValue
{
	return _titleValue;
}

@end

@implementation CSPreferencesTableCell : UIPreferencesTableCell

- (void) setView:(id)view
{
	_view = view;
}
- (id) getView
{
	return _view;
}

@end

@implementation StringsTableCell : UIPreferencesTextTableCell

- (void) setKey:(NSString*)key
{
	_key = key;
}
- (NSString*) getKey
{
	return _key;
}

@end

@implementation AudioTableCell : UIPreferencesTableCell

- (void) setFilepath:(NSString*)filepath
{
	_filepath = filepath;
}

- (void) setAsDefault
{
	_default = YES;
}

- (void) setAsHeader
{
	_header = YES;
}

- (bool) isHeader
{
	return _header;
}

- (bool) isDefault
{
	if (_default) return TRUE;
	else return FALSE;
}

- (NSString*) getFilepath
{
	return _filepath;
}

@end