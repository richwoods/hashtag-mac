//
//  PCOHashtagOutputWindow.m
//  HashtagDisplay
//
//  Created by Jason Terhorst on 11/3/13.
//  Copyright (c) 2013 Planning Center. All rights reserved.
//

#import "PCOHashtagOutputWindow.h"

@interface PCOHashtagOutputWindow ()
{
	NSInteger currentSlideIndex;
}

@end


@implementation PCOHashtagOutputWindow

- (id)initWithScreenIndex:(NSUInteger)screenIndex
{
	NSScreen * selectedScreen = [NSScreen mainScreen];

	if (screenIndex < [[NSScreen screens] count])
	{
		selectedScreen = [[NSScreen screens] objectAtIndex:screenIndex];
	}

	NSRect screenRect = [selectedScreen frame];

	self = [super initWithContentRect:screenRect styleMask:NSBorderlessWindowMask backing:NSBackingStoreBuffered defer:NO screen:selectedScreen];
	if (self)
	{
		self.flipTimer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(_changeSlide) userInfo:nil repeats:YES];

		currentSlideIndex = -1;

		[self _changeSlide];
	}

	return self;
}

- (void)_changeSlide
{
	
}

@end
