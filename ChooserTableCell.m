/**
 * DockSwap by Nick Tatonetti
 * (c) 2007 TWC
 * com.tatonetti.iphone.dockswap
 * This code is released with absolutely no gauruntee and without any warranty.
 * It is being released in the hopes that it will be useful.  You are free to modify and
 * change the code as you see fit.  Aknowledgments are never a bad thing ;-)
**/

#import <Foundation/Foundation.h>
#import <CoreFoundation/CoreFoundation.h>
#import <UIKit/UIImageAndTextTableCell.h>
#import "ChooserTableCell.h"

@implementation ChooserTableCell : UIImageAndTextTableCell

- (id) init
{
	
	return [super init];
}
	

- (void) setFilepaths:(NSMutableArray*)fn
{
	_filepaths = fn;
}
- (NSMutableArray*) getFilepaths
{
	return _filepaths;
}

@end