/**
 * DockSwap by Nick Tatonetti
 * (c) 2007 TWC
 * com.thespicychicken.customize
 * This code is released with absolutely no gauruntee and without any warranty.
 * It is being released in the hopes that it will be useful.  You are free to modify and
 * change the code as you see fit.  Aknowledgments are never a bad thing ;-)
**/

#import <CoreFoundation/CoreFoundation.h>
#import <Foundation/Foundation.h>
#import <UIKit/CDStructures.h>
#import <UIKit/UIWindow.h>
#import <UIKit/UIView-Hierarchy.h>
#import <UIKit/UIHardware.h>
#import <UIKit/UIKit.h>
#import <UIKit/UIApplication.h>
#import <UIKit/UITextView.h>
#import <UIKit/UIView.h>
#import <UIKit/UIGradientBar.h>
#import <UIKit/UITransitionView.h>
#import "SelectionView.h"
#import "AudioSelectionView.h"
#import "ChooserView.h"
#import "AudioChooserView.h"
#import "StringEditorView.h"
#import "DisplayOrder/PresetLoaderView.h"
#import "DisplayOrder/DisplayOrderView.h"
#import "DisplayOrder/ToggleDockNumView.h"

#import "ConfigureView.h"
#import "DeviceInfo.h"

@interface CustomizeApp : UIApplication {
		UIView*						_mainView;
		UIWindow*					_window;
		NSString* 					_applicationID;
		NSString*					_version;
		struct CGRect 				_rect;
		NSMutableArray*			fileArray;
		NSMutableDictionary*		_viewList;
		float							_fullHeight;
		float							_fullWidth;
		bool							_restartSpringBoard;
		NSMutableArray*			_backUpFromPaths;
		NSMutableArray*			_backUpToPaths;
		NSMutableArray*			_backUpDirs;
		UITransitionView*			_transView;
		SelectionView*				_selectionView;
		AudioSelectionView*		_audioSelectionView;
		ChooserView* 				_dockChooser;
		ChooserView*				_badgeChooser;
		ChooserView*				_carrierChooser;
		ChooserView*				_ringChooser;
		ChooserView*				_muteChooser;
		ChooserView*				_silentChooser;
		ChooserView*				_speakerChooser;
		ChooserView*				_batteryChooser;
		ChooserView*				_appleChooser;
		ChooserView*				_dialerChooser;
		ChooserView*				_wifiChooser;
		ChooserView*				_barsChooser;
		ChooserView*				_chat1Chooser;
		ChooserView*				_chat2Chooser;
		ChooserView*				_mainSliderChooser;
		ChooserView*				_powerSliderChooser;
		ChooserView*				_callSliderChooser;
		ChooserView*				_maskSliderChooser;
		AudioChooserView*			_unlockSoundChooser;
		AudioChooserView*			_lockSoundChooser;
		AudioChooserView*			_receivedSoundChooser;
		AudioChooserView*			_sentSoundChooser;
		AudioChooserView*			_voicemailSoundChooser;
		AudioChooserView*			_alarmSoundChooser;
		AudioChooserView*			_beepBeepSoundChooser;
		AudioChooserView*			_lowPowerSoundChooser;
		AudioChooserView*			_mailSentSoundChooser;
		AudioChooserView*			_newMailSoundChooser;
		AudioChooserView*			_photoSoundChooser;
		AudioChooserView*			_smsReceivedSoundChooser;
		StringEditorView*			_sbStringsEditor;
		PresetLoaderView*			_presetLoaderView;
    DisplayOrderView*     _displayOrderView;
    ToggleDockNumView*    _toggleDockNumView;
		ConfigureView*				_configure;
		DeviceInfo*						_deviceInfo;
}

- (void) initApplication;
- (NSString*) version;
- (void) raiseAlert: (NSString*)msg;
- (void) confirmLibraryFoldersExists;
- (void) setRestartSpringBoard;
- (void) transitionToChooserWith:(int)trans_type toView:(NSString *)viewKey;
- (void) transitionToSelectionViewWith:(int)trans_type;
- (void) confirmLibraryFolderExistsAtPath:(NSString*)filepath;
- (bool) validViewListKey:(NSString *)key;


@end