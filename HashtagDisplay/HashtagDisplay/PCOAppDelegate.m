//
//  PCOAppDelegate.m
//  HashtagDisplay
//
//  Created by Jason Terhorst on 11/3/13.
//  Copyright (c) 2013 Planning Center. All rights reserved.
//

#import "PCOAppDelegate.h"

#import "PCOHashtagOutputWindow.h"

@implementation PCOAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_updateScreens) name:PCOOutputScreenChangedNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_updateScreens) name:NSApplicationDidChangeScreenParametersNotification object:nil];

	if (![[NSUserDefaults standardUserDefaults] objectForKey:@"chosen_screen"])
	{
		[self.window makeKeyAndOrderFront:nil];
	}
	else
	{
		[self _updateScreens];
	}

	self.dataUpdateTimer = [NSTimer scheduledTimerWithTimeInterval:300 target:self selector:@selector(_updateData) userInfo:nil repeats:YES];
}

- (IBAction)showPreferences:(id)sender;
{
	[self.window makeKeyAndOrderFront:self];
}

- (void)_updateScreens
{
	NSInteger chosenScreenIndex = [[[NSUserDefaults standardUserDefaults] objectForKey:@"chosen_screen"] integerValue];

	if (self.outputWindow)
	{
		[self.outputWindow orderOut:nil];
		self.outputWindow = nil;
	}

	self.outputWindow = [[PCOHashtagOutputWindow alloc] initWithScreenIndex:chosenScreenIndex];
	self.outputWindow.posts = self.posts;
	[self.outputWindow setBackgroundColor:[NSColor clearColor]];
	[self.outputWindow setOpaque:NO];
	[self.outputWindow setHasShadow:NO];
	[self.outputWindow orderFront:nil];
}

- (void)_updateData
{
	
}


@end