//
//  PTHotKey.m
//  Protein
//
//  Created by Quentin Carnicelli on Sat Aug 02 2003.
//  Copyright (c) 2003 Quentin D. Carnicelli. All rights reserved.
//

#import "PTHotKey.h"

#import "PTHotKeyCenter.h"
#import "PTKeyCombo.h"

@implementation PTHotKey

@synthesize identifier, actionDown, actionUp, name, target;

- (id)init {
	return [self initWithIdentifier: nil keyCombo: nil];
}

- (id)initWithIdentifier:(id)newIdentifier keyCombo:(PTKeyCombo*)combo {
	[super init];
	
	[self setIdentifier:newIdentifier];
	[self setKeyCombo:combo];
	
	return self;
}

- (NSString*)description {
	return [NSString stringWithFormat: @"<%@: %@, %@>", NSStringFromClass([self class]), [self identifier], [self keyCombo]];
}

#pragma mark -

- (void)setKeyCombo: (PTKeyCombo*)combo {
	if (combo == nil)
		combo = [PTKeyCombo clearKeyCombo];
	
	[combo retain];
	[keyCombo release];
	keyCombo = combo;
}

- (PTKeyCombo*)keyCombo {
	return keyCombo;
}

- (void)invokeDown {
	if (actionDown)
		[target performSelector:actionDown withObject:self];
}

- (void)invokeUp {
	if (actionUp)
		[target performSelector:actionUp withObject:self];
}

- (void)dealloc {
	[identifier release];
	[name release];
	[keyCombo release];
	
	[super dealloc];
}

@end
