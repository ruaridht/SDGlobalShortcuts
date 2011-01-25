//
//  AppDelegate.h
//  SDGlobalHotKeys
//
//  Created by Steven on 3/1/09.
//  Copyright 2009 Thoughtful Tree Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import <SDGlobalShortcuts/SDGlobalShortcuts.h>
#import <ShortcutRecorder/ShortcutRecorder.h>

@interface AppDelegate : NSObject {
	IBOutlet NSWindow *window;
	IBOutlet SRRecorderControl *recorderControl;
}

- (IBAction) doSomething:(id)sender;
- (IBAction) doSomethingElse:(id)sender;

@end
