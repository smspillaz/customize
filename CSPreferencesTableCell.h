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
#import <UIKit/UIPreferencesTextTableCell.h>

@interface ConfigureTableCell : UIPreferencesTableCell
{
	NSString* _titleValue;
}

- (void) setTitle:(NSString*)title;
- (NSString*) value;

@end

@interface CSPreferencesTableCell : UIPreferencesTableCell
{
	id	_view;
}

- (void) setView:(id)view;
- (id) getView;

@end

@interface StringsTableCell : UIPreferencesTextTableCell
{
	NSString*	_key;
}

- (void) setKey:(NSString*)key;
- (NSString*) getKey;

@end

@interface AudioTableCell : UIPreferencesTableCell
{
	NSString *_filepath;
	bool		_default;
	bool		_header;
}

- (void) setFilepath:(NSString*)filepath;
- (void) setAsDefault;
- (bool) isDefault;
- (void) setAsHeader;
- (bool) isHeader;
- (NSString*) getFilepath;

@end

