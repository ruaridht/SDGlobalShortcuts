//
//  SDHotKeyController.m
//  ClassDumper
//
//  Created by Steven on 10/16/08.
//  Copyright 2008 Giant Robot Software. All rights reserved.
//

#import "SDGlobalShortcutsController.h"

#import <ShortcutRecorder/ShortcutRecorder.h>

#import "PTHotKey.h"
#import "PTHotKeyCenter.h"

#define kSDHotKeyKey @"hotKey"
#define kSDDefaultsKeyKey @"defaultsKey"
#define kSDRecorderControlKey @"recorderControl"

#define SDDefaults [NSUserDefaults standardUserDefaults]

@interface SDGlobalShortcutsController (Private)
- (void) setKeyCombo:(PTKeyCombo*)keyCombo forRecorderControl:(SRRecorderControl*)recorderControl;
@end

@implementation SDGlobalShortcutsController

static SDGlobalShortcutsController *sharedShortcutsController = nil;

- (id)init {
	Class myClass = [self class];
	@synchronized(myClass) {
		if (sharedShortcutsController == nil) {
			if (self = [super init]) {
				sharedShortcutsController = self;
				
				storedHotKeys = [[NSMutableArray array] retain];
				[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillTerminate:) name:NSApplicationWillTerminateNotification object:NSApp];
			}
		}
	}
	return sharedShortcutsController;
}

- (void) addShortcutFromDefaultsKey:(NSString*)defaultsKey target:(id)target selector:(SEL)action {
	[self addShortcutFromDefaultsKey:defaultsKey withControl:nil target:target selector:action];
}

- (void) addShortcutFromDefaultsKey:(NSString*)defaultsKey withControl:(SRRecorderControl*)recorderControl target:(id)target selector:(SEL)action {
	NSDictionary *dict = [SDDefaults dictionaryForKey:defaultsKey];
	PTKeyCombo *keyCombo = [[[PTKeyCombo alloc] initWithPlistRepresentation:dict] autorelease];
	
	PTHotKey *hotKey = hotKey = [[[PTHotKey alloc] initWithIdentifier:defaultsKey keyCombo:keyCombo] autorelease];
	[hotKey setTarget:target];
	[hotKey setAction:action];
	
	[[PTHotKeyCenter sharedCenter] registerHotKey:hotKey];
	
	NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
	[dictionary setObject:hotKey forKey:kSDHotKeyKey];
	[dictionary setObject:defaultsKey forKey:kSDDefaultsKeyKey];
	
	if (recorderControl) {
		[self setKeyCombo:keyCombo forRecorderControl:recorderControl];
		[dictionary setObject:recorderControl forKey:kSDRecorderControlKey];
	}
	
	[storedHotKeys addObject:dictionary];
}

- (void) attachControl:(SRRecorderControl*)recorderControl toDefaultsKey:(NSString*)defaultsKey {
	for (NSMutableDictionary *dictionary in storedHotKeys) {
		NSString *testingDefaultsKey = [dictionary objectForKey:kSDDefaultsKeyKey];
		if ([testingDefaultsKey isEqual: defaultsKey]) {
			[dictionary setObject:recorderControl forKey:kSDRecorderControlKey];
			PTHotKey *hotKey = [dictionary objectForKey:kSDHotKeyKey];
			[self setKeyCombo:[hotKey keyCombo] forRecorderControl:recorderControl];
		}
	}
}

- (void) setKeyCombo:(PTKeyCombo*)keyCombo forRecorderControl:(SRRecorderControl*)recorderControl {
	[(SRRecorderCell*)[recorderControl cell] setKeyCombo:SRMakeKeyCombo([keyCombo keyCode], [recorderControl carbonToCocoaFlags:[keyCombo modifiers]])];
	[recorderControl setStyle:1];
	[[recorderControl cell] setDelegate:self];
}

- (void) shortcutRecorderCell:(SRRecorderCell *)aRecorderCell keyComboDidChange:(KeyCombo)newCombo {
	PTHotKey *hotKey = nil;
	
	for (NSDictionary *dictionary in storedHotKeys) {
		SRRecorderControl *recorderControl = [dictionary objectForKey:kSDRecorderControlKey];
		if (aRecorderCell == [recorderControl cell]) {
			hotKey = [dictionary objectForKey:kSDHotKeyKey];
			break;
		}
	}
	
	[[PTHotKeyCenter sharedCenter] unregisterHotKey:hotKey];
	
	PTKeyCombo *keyCombo = [PTKeyCombo keyComboWithKeyCode:newCombo.code modifiers:[(id)[aRecorderCell controlView] cocoaToCarbonFlags:newCombo.flags]];
	[hotKey setKeyCombo:keyCombo];
	
	[[PTHotKeyCenter sharedCenter] registerHotKey:hotKey];
}

- (void) applicationWillTerminate:(NSNotification*)note {
	for (NSDictionary *dictionary in storedHotKeys) {
		PTHotKey *hotKey = [dictionary objectForKey:kSDHotKeyKey];
		NSString *defaultsKey = [dictionary objectForKey:kSDDefaultsKeyKey];
		[SDDefaults setObject:[[hotKey keyCombo] plistRepresentation] forKey:defaultsKey];
	}
}

// MARK: Singleton methods

+ (SDGlobalShortcutsController*) sharedShortcutsController {
	@synchronized(self) { if (sharedShortcutsController == nil) [[self alloc] init]; }
	return sharedShortcutsController;
}

+ (id) allocWithZone:(NSZone *)zone {
	@synchronized(self) { if (sharedShortcutsController == nil) return [super allocWithZone:zone]; }
	return sharedShortcutsController;
}

- (id) copyWithZone:(NSZone *)zone { return self; }
- (id) retain { return self; }
- (unsigned) retainCount { return UINT_MAX; }
- (void) release {}
- (id) autorelease { return self; }

@end
