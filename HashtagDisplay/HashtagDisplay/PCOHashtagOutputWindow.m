//
//  PCOHashtagOutputWindow.m
//  HashtagDisplay
//
//  Created by Jason Terhorst on 11/3/13.
//  Copyright (c) 2013 Planning Center. All rights reserved.
//

#import "PCOHashtagOutputWindow.h"

#import "PCOHashtagPost.h"

@interface PCOHashtagOutputWindow ()
{
	NSInteger currentSlideIndex;
}

@end


@implementation PCOHashtagOutputWindow

- (id)initWithScreenIndex:(NSUInteger)screenIndex posts:(NSMutableArray *)posts
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
		_screenIndex = screenIndex;

		_posts = posts;

		[[self contentView] setWantsLayer:YES];

		[self _createImageLayer];

		[self _createBodyTextLayer];

		[self _createFullNameLayer];
		
		[self _createUsernameLayer];

		[self _createHashtagLayer];

		[self _createDateLayer];


		self.flipTimer = [NSTimer scheduledTimerWithTimeInterval:7.0 target:self selector:@selector(changeSlide) userInfo:nil repeats:YES];

		currentSlideIndex = -1;
		if ([[NSUserDefaults standardUserDefaults] objectForKey:@"slide_index"])
		{
			currentSlideIndex = [[[NSUserDefaults standardUserDefaults] objectForKey:@"slide_index"] integerValue];
		}

		[self changeSlide];

	}

	return self;
}


- (void)_createHashtagLayer
{
	_hashtagLayer = [CATextLayer layer];
	_hashtagLayer.frame = CGRectMake(10, 0, [[self contentView] layer].bounds.size.width - 20, [[self contentView] layer].bounds.size.height - 20);
	_hashtagLayer.string = @"#xpressgratitude";
	_hashtagLayer.font = (__bridge CFTypeRef)([NSFont fontWithName:@"Helvetica" size:80]);
	_hashtagLayer.foregroundColor = (__bridge CGColorRef)([NSColor grayColor]);
	_hashtagLayer.alignmentMode = kCAAlignmentCenter;
	[_hashtagLayer setOpaque:NO];
	_hashtagLayer.backgroundColor = (__bridge CGColorRef)([NSColor clearColor]);
	_hashtagLayer.shadowColor = (__bridge CGColorRef)([NSColor blackColor]);
	_hashtagLayer.shadowOffset = CGSizeMake(1, 1);
	_hashtagLayer.shadowOpacity = 1.0;
	[[[self contentView] layer] addSublayer:_hashtagLayer];

	float bodySize = 80;
	NSFont * bodyFont = [NSFont fontWithName:@"Myriad Pro Bold" size:bodySize];
	if (!bodyFont)
	{
		bodyFont = [NSFont boldSystemFontOfSize:bodySize];
	}

	bodySize = [self actualFontSizeForText:_hashtagLayer.string withFont:bodyFont withOriginalSize:bodySize];
	bodyFont = [NSFont fontWithName:bodyFont.fontName size:bodySize];


	_hashtagLayer.font = (__bridge CFTypeRef)bodyFont;
	_hashtagLayer.fontSize = bodySize;
	_hashtagLayer.alignmentMode = kCAAlignmentLeft;
	_hashtagLayer.shadowOpacity = 1.0;
}

- (void)_createImageLayer
{
	_imageLayer = [CALayer layer];

	CGFloat imageWidth = ([[[self contentView] layer] bounds].size.width / 3);

	_imageLayer.frame = CGRectMake(10, ([[[self contentView] layer] bounds].size.height / 2) - (imageWidth / 2), imageWidth, imageWidth);
	_imageLayer.contentsGravity = kCAGravityResizeAspect;
	[[[self contentView] layer] addSublayer:_imageLayer];
}

- (void)_createBodyTextLayer
{
	_bodyTextLayer = [CATextLayer layer];
	_bodyTextLayer.frame = [[self contentView] layer].bounds;
	_bodyTextLayer.string = @"";
	_bodyTextLayer.font = (__bridge CFTypeRef)([NSFont fontWithName:@"Helvetica" size:40]);
	_bodyTextLayer.foregroundColor = (__bridge CGColorRef)([NSColor whiteColor]);
	_bodyTextLayer.alignmentMode = kCAAlignmentCenter;
	[_bodyTextLayer setOpaque:NO];
	_bodyTextLayer.backgroundColor = (__bridge CGColorRef)([NSColor clearColor]);
	_bodyTextLayer.shadowColor = (__bridge CGColorRef)([NSColor blackColor]);
	_bodyTextLayer.shadowOffset = CGSizeMake(1, 1);
	_bodyTextLayer.shadowOpacity = 1.0;
	[[[self contentView] layer] addSublayer:_bodyTextLayer];

	float bodySize = 35;
	NSFont * bodyFont = [NSFont fontWithName:@"Myriad Pro Bold" size:bodySize];
	if (!bodyFont)
	{
		bodyFont = [NSFont boldSystemFontOfSize:bodySize];
	}

	bodySize = [self actualFontSizeForText:_bodyTextLayer.string withFont:bodyFont withOriginalSize:bodySize];
	bodyFont = [NSFont fontWithName:bodyFont.fontName size:bodySize];

	NSRect bodyBox = [_bodyTextLayer.string boundingRectWithSize:NSMakeSize([[[self contentView] layer] bounds].size.width - _imageLayer.frame.origin.x - _imageLayer.frame.size.width - 20, NSIntegerMax) options:NSStringDrawingOneShot attributes:[NSDictionary dictionaryWithObject:bodyFont forKey:NSFontAttributeName]];
	NSSize bodyBoxSize = bodyBox.size;

	_bodyTextLayer.font = (__bridge CFTypeRef)bodyFont;
	_bodyTextLayer.fontSize = bodySize;
	_bodyTextLayer.alignmentMode = kCAAlignmentLeft;
	_bodyTextLayer.shadowOpacity = 1.0;
	_bodyTextLayer.wrapped = YES;
	_bodyTextLayer.frame = CGRectMake(_imageLayer.frame.origin.x + _imageLayer.frame.size.width + 50, ([[[self contentView] layer] bounds].size.height / 5) * 2, [[[self contentView] layer] bounds].size.width - _imageLayer.frame.origin.x - _imageLayer.frame.size.width - 20, bodyBoxSize.height * 6);
}

- (void)_createFullNameLayer
{
	_fullNameLayer = [CATextLayer layer];
	_fullNameLayer.frame = [[self contentView] layer].bounds;

	_fullNameLayer.string = @"";
	_fullNameLayer.font = (__bridge CFTypeRef)([NSFont fontWithName:@"Helvetica" size:40]);
	_fullNameLayer.foregroundColor = (__bridge CGColorRef)([NSColor whiteColor]);
	_fullNameLayer.alignmentMode = kCAAlignmentLeft;
	[_fullNameLayer setOpaque:NO];
	_fullNameLayer.backgroundColor = (__bridge CGColorRef)([NSColor clearColor]);
	_fullNameLayer.shadowColor = (__bridge CGColorRef)([NSColor blackColor]);
	_fullNameLayer.shadowOffset = CGSizeMake(1, 1);
	_fullNameLayer.shadowOpacity = 1.0;
	[[[self contentView] layer] addSublayer:_fullNameLayer];

	float bodySize = 35;
	NSFont * bodyFont = [NSFont fontWithName:@"Myriad Pro" size:bodySize];
	if (!bodyFont)
	{
		bodyFont = [NSFont boldSystemFontOfSize:bodySize];
	}

	bodySize = [self actualFontSizeForText:_fullNameLayer.string withFont:bodyFont withOriginalSize:bodySize];
	bodyFont = [NSFont fontWithName:bodyFont.fontName size:bodySize];

	NSRect bodyBox = [_fullNameLayer.string boundingRectWithSize:NSMakeSize(([[[self contentView] layer] bounds].size.width / 3) * 2, NSIntegerMax) options:NSStringDrawingOneShot attributes:[NSDictionary dictionaryWithObject:bodyFont forKey:NSFontAttributeName]];
	NSSize bodyBoxSize = bodyBox.size;

	_fullNameLayer.font = (__bridge CFTypeRef)bodyFont;
	_fullNameLayer.fontSize = bodySize;
	_fullNameLayer.alignmentMode = kCAAlignmentLeft;
	_fullNameLayer.shadowOpacity = 1.0;
	_fullNameLayer.wrapped = YES;
	_fullNameLayer.frame = CGRectMake(_bodyTextLayer.frame.origin.x, _bodyTextLayer.frame.origin.y + _bodyTextLayer.frame.size.height + bodyBoxSize.height + 10, ([[[self contentView] layer] bounds].size.width / 3) * 2, bodyBoxSize.height);

	[[[self contentView] layer] addSublayer:_fullNameLayer];
}

- (void)_createUsernameLayer
{
	_usernameLayer = [CATextLayer layer];
	_usernameLayer.frame = [[self contentView] layer].bounds;

	_usernameLayer = [CATextLayer layer];
	_usernameLayer.frame = [[self contentView] layer].bounds;

	_usernameLayer.string = @"";
	_usernameLayer.font = (__bridge CFTypeRef)([NSFont fontWithName:@"Helvetica" size:22]);
	_usernameLayer.foregroundColor = (__bridge CGColorRef)([NSColor whiteColor]);
	_usernameLayer.alignmentMode = kCAAlignmentLeft;
	[_usernameLayer setOpaque:NO];
	_usernameLayer.backgroundColor = (__bridge CGColorRef)([NSColor clearColor]);
	_usernameLayer.shadowColor = (__bridge CGColorRef)([NSColor blackColor]);
	_usernameLayer.shadowOffset = CGSizeMake(1, 1);
	_usernameLayer.shadowOpacity = 1.0;
	[[[self contentView] layer] addSublayer:_usernameLayer];

	float bodySize = 22;
	NSFont * bodyFont = [NSFont fontWithName:@"Myriad Pro" size:bodySize];
	if (!bodyFont)
	{
		bodyFont = [NSFont boldSystemFontOfSize:bodySize];
	}

	bodySize = [self actualFontSizeForText:_usernameLayer.string withFont:bodyFont withOriginalSize:bodySize];
	bodyFont = [NSFont fontWithName:bodyFont.fontName size:bodySize];

	NSRect bodyBox = [_usernameLayer.string boundingRectWithSize:NSMakeSize(([[[self contentView] layer] bounds].size.width / 3) * 2, NSIntegerMax) options:NSStringDrawingOneShot attributes:[NSDictionary dictionaryWithObject:bodyFont forKey:NSFontAttributeName]];
	NSSize bodyBoxSize = bodyBox.size;

	_usernameLayer.font = (__bridge CFTypeRef)bodyFont;
	_usernameLayer.fontSize = bodySize;
	_usernameLayer.alignmentMode = kCAAlignmentLeft;
	_usernameLayer.shadowOpacity = 1.0;
	_usernameLayer.wrapped = YES;
	_usernameLayer.frame = CGRectMake(_fullNameLayer.frame.origin.x, _fullNameLayer.frame.origin.y - bodyBoxSize.height, _fullNameLayer.frame.size.width, bodyBoxSize.height);

	[[[self contentView] layer] addSublayer:_usernameLayer];
}

- (void)_createDateLayer
{
	_dateLayer = [CATextLayer layer];
	_dateLayer.frame = [[self contentView] layer].bounds;

	_dateLayer.string = @"Testing date";
	_dateLayer.font = (__bridge CFTypeRef)([NSFont fontWithName:@"Helvetica" size:22]);
	_dateLayer.foregroundColor = (__bridge CGColorRef)([NSColor grayColor]);
	_dateLayer.alignmentMode = kCAAlignmentLeft;
	[_dateLayer setOpaque:NO];
	_dateLayer.backgroundColor = (__bridge CGColorRef)([NSColor clearColor]);
	_dateLayer.shadowColor = (__bridge CGColorRef)([NSColor blackColor]);
	_dateLayer.shadowOffset = CGSizeMake(1, 1);
	_dateLayer.shadowOpacity = 1.0;
	[[[self contentView] layer] addSublayer:_dateLayer];

	float bodySize = 22;
	NSFont * bodyFont = [NSFont fontWithName:@"Myriad Pro" size:bodySize];
	if (!bodyFont)
	{
		bodyFont = [NSFont boldSystemFontOfSize:bodySize];
	}

	bodySize = [self actualFontSizeForText:_dateLayer.string withFont:bodyFont withOriginalSize:bodySize];
	bodyFont = [NSFont fontWithName:bodyFont.fontName size:bodySize];

	NSRect bodyBox = [_dateLayer.string boundingRectWithSize:NSMakeSize(([[[self contentView] layer] bounds].size.width / 3) * 2, NSIntegerMax) options:NSStringDrawingOneShot attributes:[NSDictionary dictionaryWithObject:bodyFont forKey:NSFontAttributeName]];
	NSSize bodyBoxSize = bodyBox.size;

	_dateLayer.font = (__bridge CFTypeRef)bodyFont;
	_dateLayer.fontSize = bodySize;
	_dateLayer.alignmentMode = kCAAlignmentLeft;
	_dateLayer.shadowOpacity = 1.0;
	_dateLayer.wrapped = YES;
	_dateLayer.frame = CGRectMake(_usernameLayer.frame.origin.x, _usernameLayer.frame.origin.y - bodyBoxSize.height, 500, bodyBoxSize.height);

	//[[[self contentView] layer] addSublayer:_dateLayer];
}


- (void)changeSlide
{
	NSScreen * selectedScreen = [NSScreen mainScreen];

	if (_screenIndex < [[NSScreen screens] count])
	{
		selectedScreen = [[NSScreen screens] objectAtIndex:_screenIndex];
	}

	NSRect screenRect = [selectedScreen frame];

	[self setFrame:screenRect display:YES];

	if ([_posts count] == 0)
	{
		NSLog(@"no posts");
		return;
	}
	else
	{
		NSLog(@"change slide");
	}

	if (currentSlideIndex >= [_posts count] - 1)
	{
		currentSlideIndex = 0;
	}
	else
	{
		currentSlideIndex++;
	}

	[[NSUserDefaults standardUserDefaults] setObject:@(currentSlideIndex) forKey:@"slide_index"];

	PCOHashtagPost * post = [_posts objectAtIndex:currentSlideIndex];

	NSString * socialNetwork = @"web";
	if (post.network == kNetworkFacebook)
	{
		socialNetwork = @"Facebook";
	}
	else if (post.network == kNetworkInstagram)
	{
		socialNetwork = @"Instagram";
	}
	else if (post.network == kNetworkTwitter)
	{
		socialNetwork = @"Twitter";
	}

	_bodyTextLayer.string = post.body;
	_fullNameLayer.string = post.altName;
	_usernameLayer.string = [NSString stringWithFormat:@"@%@ on %@", post.userName, socialNetwork];
	if (post.network == kNetworkFacebook)
	{
		_usernameLayer.string = @"on Facebook";
	}

	NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setLocale:[NSLocale currentLocale]];
	[dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
	[dateFormatter setDoesRelativeDateFormatting:YES];

	_dateLayer.string = [dateFormatter stringFromDate:post.postDate];

	CGFloat imageWidth = ([[[self contentView] layer] bounds].size.width / 3);

	CGFloat leftOffset = imageWidth + 50;

	if ([post.imageUrl length] > 0)
	{
		_imageLayer.frame = CGRectMake(10, ([[[self contentView] layer] bounds].size.height / 2) - (imageWidth / 2), imageWidth, imageWidth);
		_imageLayer.contents = [(id)[NSImage alloc] initWithContentsOfURL:[NSURL URLWithString:post.imageUrl]];
	}
	else
	{
		imageWidth = imageWidth * 0.75;
		leftOffset = imageWidth - (imageWidth / 2) + 20;

		_imageLayer.frame = CGRectMake(10, ([[[self contentView] layer] bounds].size.height / 2) - (imageWidth / 2), imageWidth, imageWidth);
		_imageLayer.contents = nil;
	}


	float bodySize = 35;
	NSFont * bodyFont = [NSFont fontWithName:@"Myriad Pro Bold" size:bodySize];
	if (!bodyFont)
	{
		bodyFont = [NSFont boldSystemFontOfSize:bodySize];
	}


	NSRect bodyBox = [_bodyTextLayer.string boundingRectWithSize:NSMakeSize([[[self contentView] layer] bounds].size.width - _imageLayer.frame.origin.x - _imageLayer.frame.size.width - 20, NSIntegerMax) options:NSStringDrawingOneShot attributes:[NSDictionary dictionaryWithObject:bodyFont forKey:NSFontAttributeName]];
	NSSize bodyBoxSize = bodyBox.size;

	_bodyTextLayer.font = (__bridge CFTypeRef)bodyFont;
	_bodyTextLayer.fontSize = bodySize;
	_bodyTextLayer.alignmentMode = kCAAlignmentLeft;
	_bodyTextLayer.shadowOpacity = 1.0;
	_bodyTextLayer.wrapped = YES;
	_bodyTextLayer.frame = CGRectMake(leftOffset, ([[[self contentView] layer] bounds].size.height / 5) * 2, [[[self contentView] layer] bounds].size.width - _imageLayer.frame.origin.x - _imageLayer.frame.size.width - 20, bodyBoxSize.height * 6);

	_fullNameLayer.frame = CGRectMake(_bodyTextLayer.frame.origin.x, _bodyTextLayer.frame.origin.y + _bodyTextLayer.frame.size.height + bodyBoxSize.height + 20, ([[[self contentView] layer] bounds].size.width / 3) * 2, _fullNameLayer.frame.size.height);

	_usernameLayer.frame = CGRectMake(_fullNameLayer.frame.origin.x, _fullNameLayer.frame.origin.y - bodyBoxSize.height + 10, _fullNameLayer.frame.size.width, _usernameLayer.frame.size.height);

	_dateLayer.frame = CGRectMake(_usernameLayer.frame.origin.x, _usernameLayer.frame.origin.y - bodyBoxSize.height, 500, bodyBoxSize.height);
}




- (float)portWidth
{
	return [[self contentView] layer].frame.size.width;
}

- (float)portHeight
{
	return [[self contentView] layer].frame.size.height;
}



- (float)textScaleRatio;
{
	return [self portWidth] / 1024;
}

- (float)actualFontSizeForText:(NSString *)text withFont:(NSFont *)aFont withOriginalSize:(float)originalSize;
{
	float scaledSize = originalSize * [self textScaleRatio];

	if (!aFont)
	{
		aFont = [NSFont systemFontOfSize:scaledSize];
	}
	aFont = [NSFont fontWithName:aFont.fontName size:scaledSize];

	float longestLineWidth = 1;

	NSArray * textComponents = [text componentsSeparatedByString:@"\n"];

	if ([textComponents count] < 2 || [text length] < 2)
	{
		NSDictionary * attribs = [NSDictionary dictionaryWithObject:aFont forKey:NSFontAttributeName];

		NSSize textSize = [text sizeWithAttributes:attribs];
		if (textSize.width > longestLineWidth)
			longestLineWidth = textSize.width;
	}
	else
	{
		for (NSString * line in textComponents)
		{
			NSDictionary * attribs = [NSDictionary dictionaryWithObject:aFont forKey:NSFontAttributeName];

			NSSize textSize = [line sizeWithAttributes:attribs];
			if (textSize.width > longestLineWidth)
				longestLineWidth = textSize.width;
		}
	}

	//NSLog(@"text width: %f, scaled text size: %f, original text size: %f", longestLineWidth, scaledSize, originalSize);

	if (longestLineWidth > [self portWidth] - ([self portWidth] * 0.1))
	{
		float ratio = ([self portWidth] - ([self portWidth] * 0.1)) / longestLineWidth;
		scaledSize = scaledSize * ratio;
	}

	//NSLog(@"final text size to fit: %f", scaledSize);

	return scaledSize;
}

@end
