//
//  AppDelegate.m
//  SDGlobalHotKeys
//
//  Created by Steven on 3/1/09.
//  Copyright 2009 Thoughtful Tree Software. All rights reserved.
//

#import "AppDelegate.h"


@implementation AppDelegate

- (void) awakeFromNib {
	SDGlobalShortcutsController *shortcutsController = [SDGlobalShortcutsController sharedShortcutsController];
	[shortcutsController addShortcutFromDefaultsKey:@"JustSomeDefaultsKey"
										withControl:recorderControl
											 target:self
										   selector:@selector(doSomething:)];
}

- (IBAction) doSomething:(id)sender {
	[NSApp activateIgnoringOtherApps:YES];
	NSRunAlertPanelRelativeToWindow(@"You pressed it!", @"A hotkey was just pressed, thus bringing up this alert. Congrats!", @"OK", nil, nil, window);
}

@end
