//
//  PTHotKey.h
//  Protein
//
//  Created by Quentin Carnicelli on Sat Aug 02 2003.
//  Copyright (c) 2003 Quentin D. Carnicelli. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "PTKeyCombo.h"

@interface PTHotKey : NSObject {
	NSString*		identifier;
	NSString*		name;
	PTKeyCombo*		keyCombo;
	id				target;
	SEL				actionDown;
	SEL				actionUp;
}

@property (assign) id target;
@property (retain) NSString* name;
@property (retain) id identifier;
@property (retain) PTKeyCombo *keyCombo;
@property SEL actionDown;
@property SEL actionUp;

- (id)initWithIdentifier:(id)newIdentifier keyCombo:(PTKeyCombo*)combo;
- (id)init;

- (void)invokeDown;
- (void)invokeUp;

@end
