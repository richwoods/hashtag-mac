//
//  PCODisplayLayoutView.m
//  CountdownOverlay
//
//  Created by Jason Terhorst on 10/28/13.
//  Copyright (c) 2013 Planning Center. All rights reserved.
//

#import "PCODisplayLayoutView.h"

#import "PCOHashtagOutputWindow.h"

@implementation PCODisplayLayoutView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateScreens) name:NSApplicationDidChangeScreenParametersNotification object:nil];

		[self updateScreens];

		clickPoint = NSZeroPoint;
    }
    return self;
}

- (void)dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)updateScreens;
{


	[self setNeedsDisplay:YES];

	/*
	NSUInteger screenIndex = 0;

	for (NSScreen * screen in [NSScreen screens])
	{
		NSRect translatedScreenRect = NSMakeRect([self centerMonitorPoint].x + (screen.frame.origin.x / [self screenDrawScaleRatio]), [self centerMonitorPoint].y + (screen.frame.origin.y / [self screenDrawScaleRatio]), screen.frame.size.width / [self screenDrawScaleRatio], screen.frame.size.height / [self screenDrawScaleRatio]);



		screenIndex++;
	}
	*/
}

- (void)mouseUp:(NSEvent *)theEvent
{
	NSPoint location = [theEvent locationInWindow];
	location = [self convertPoint:location fromView:nil];

	clickPoint = location;

	for (NSScreen * screen in [NSScreen screens])
	{
		NSRect translatedScreenRect = NSMakeRect([self centerMonitorPoint].x + (screen.frame.origin.x / [self screenDrawScaleRatio]), [self centerMonitorPoint].y + (screen.frame.origin.y / [self screenDrawScaleRatio]), screen.frame.size.width / [self screenDrawScaleRatio], screen.frame.size.height / [self screenDrawScaleRatio]);

		if (NSPointInRect(clickPoint, translatedScreenRect))
		{
			NSInteger screenIndex = [[NSScreen screens] indexOfObject:screen];
			[[NSUserDefaults standardUserDefaults] setObject:@(screenIndex) forKey:@"chosen_screen"];

			[[NSNotificationCenter defaultCenter] postNotificationName:PCOOutputScreenChangedNotification object:nil];
		}

	}

	[self setNeedsDisplay:YES];
}


- (void)drawRect:(NSRect)dirtyRect
{
	[super drawRect:dirtyRect];



	[[NSColor whiteColor] set];
	[[NSBezierPath bezierPathWithRect:[self bounds]] fill];

	[[NSColor grayColor] set];
	[[NSBezierPath bezierPathWithRect:[self bounds]] stroke];


	[NSBezierPath setDefaultLineWidth:2];


	NSRect screenAreaRect = NSMakeRect((self.bounds.size.width - [self scaledSizeForScreens].width) / 2, (self.bounds.size.height - [self scaledSizeForScreens].height) / 2, [self scaledSizeForScreens].width, [self scaledSizeForScreens].height);
	screenAreaRect.origin.x = (self.bounds.size.width / 2) - (screenAreaRect.size.width / 2);
	screenAreaRect.origin.y = (self.bounds.size.height / 2) - (screenAreaRect.size.height / 2);


	NSInteger selectedScreenIndex = -1;
	if ([[NSUserDefaults standardUserDefaults] objectForKey:@"chosen_screen"])
	{
		selectedScreenIndex	= [[[NSUserDefaults standardUserDefaults] objectForKey:@"chosen_screen"] integerValue];
	}

	for (NSScreen * screen in [NSScreen screens])
	{
		NSRect translatedScreenRect = NSMakeRect([self centerMonitorPoint].x + (screen.frame.origin.x / [self screenDrawScaleRatio]), [self centerMonitorPoint].y + (screen.frame.origin.y / [self screenDrawScaleRatio]), screen.frame.size.width / [self screenDrawScaleRatio], screen.frame.size.height / [self screenDrawScaleRatio]);

		NSURL *imageURL = [[NSWorkspace sharedWorkspace] desktopImageURLForScreen:screen];

		NSImage * desktopImage = [[NSImage alloc] initWithContentsOfFile:[imageURL path]];

		[desktopImage drawInRect:translatedScreenRect fromRect:NSMakeRect(0, 0, desktopImage.size.width, desktopImage.size.height) operation:NSCompositeCopy fraction:1.0];

		[[NSColor purpleColor] set];
		
		[[NSBezierPath bezierPathWithRect:translatedScreenRect] stroke];

		NSInteger thisScreenIndex = [[NSScreen screens] indexOfObject:screen];
		if (thisScreenIndex != selectedScreenIndex)
		{
			[[NSColor colorWithCalibratedWhite:1.0 alpha:0.5] set];
			[[NSBezierPath bezierPathWithRect:translatedScreenRect] fill];
		}
	}


	[[NSColor redColor] set];
	[[NSBezierPath bezierPathWithRect:NSMakeRect(clickPoint.x, clickPoint.y, 1, 1)] fill];


}

- (CGPoint)centerPoint
{
	return CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);
}

- (NSPoint)centerMonitorPoint
{
	/*
	NSSize centerMonitorSize = [NSScreen mainScreen].frame.size;
	centerMonitorSize.width = centerMonitorSize.width / [self screenDrawScaleRatio];
	centerMonitorSize.height = centerMonitorSize.height / [self screenDrawScaleRatio];

	return NSMakePoint([self centerPoint].x - ([NSScreen mainScreen].frame.origin.x / [self screenDrawScaleRatio]), [self centerPoint].y - ([NSScreen mainScreen].frame.origin.y / [self screenDrawScaleRatio]));
	*/

	CGFloat positiveWidth = ([self fullNormalizedActualPixelSizeOfScreens].size.width - (ABS([self fullNormalizedActualPixelSizeOfScreens].origin.x))) / [self screenDrawScaleRatio];
	CGFloat positiveHeight = ([self fullNormalizedActualPixelSizeOfScreens].size.height - (ABS([self fullNormalizedActualPixelSizeOfScreens].origin.y))) / [self screenDrawScaleRatio];

	CGFloat widthDifference = self.bounds.size.width - [self scaledSizeForScreens].width;
	CGFloat heightDifference = self.bounds.size.height - [self scaledSizeForScreens].height;

	return NSMakePoint(self.bounds.size.width - positiveWidth - (widthDifference / 2), self.bounds.size.height - positiveHeight - (heightDifference / 2));
}


- (NSRect)fullNormalizedActualPixelSizeOfScreens
{
	NSRect defaultRect = [NSScreen mainScreen].frame;

	for (NSScreen * screen in [NSScreen screens])
	{
		defaultRect = NSUnionRect(screen.frame, defaultRect);
	}

	//NSLog(@"screen frame: %@", NSStringFromRect(defaultRect));

	return defaultRect;
}

- (CGSize)scaledSizeForScreens
{
	CGSize currentSize = [self fullNormalizedActualPixelSizeOfScreens].size;
	float viewScaleRatio = currentSize.width / (self.bounds.size.width - 20);
	if ((currentSize.height / viewScaleRatio) > (self.bounds.size.height - 20))
	{
		viewScaleRatio = currentSize.height / (self.bounds.size.height - 20);
	}

	currentSize.width = currentSize.width / viewScaleRatio;
	currentSize.height = currentSize.height / viewScaleRatio;

	return currentSize;
}

- (CGFloat)screenDrawScaleRatio
{
	CGSize currentSize = [self fullNormalizedActualPixelSizeOfScreens].size;
	CGFloat viewScaleRatio = currentSize.width / (self.bounds.size.width - 20);
	if ((currentSize.height / viewScaleRatio) > (self.bounds.size.height - 20))
	{
		viewScaleRatio = currentSize.height / (self.bounds.size.height - 20);
	}

	return viewScaleRatio;
}

- (float)scaleRatioForWidth
{
	return [self fullNormalizedActualPixelSizeOfScreens].size.width / (self.frame.size.width - 50);
}

- (float)scaleRatioForHeight
{
	return [self fullNormalizedActualPixelSizeOfScreens].size.height / (self.frame.size.height - 50);
}

@end
