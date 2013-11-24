//
//  PCOHashtagOutputWindow.h
//  HashtagDisplay
//
//  Created by Jason Terhorst on 11/3/13.
//  Copyright (c) 2013 Planning Center. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import <QuartzCore/QuartzCore.h>

@interface PCOHashtagOutputWindow : NSWindow

- (id)initWithScreenIndex:(NSUInteger)screenIndex posts:(NSMutableArray *)posts;

@property (nonatomic, assign) NSInteger screenIndex;

@property (nonatomic, strong) NSMutableArray * posts;

@property (nonatomic, strong) NSTimer * flipTimer; // timer to change slides


@property (nonatomic, strong) CATextLayer * hashtagLayer;

@property (nonatomic, strong) CALayer * imageLayer;
@property (nonatomic, strong) CATextLayer * bodyTextLayer;
@property (nonatomic, strong) CATextLayer * fullNameLayer;
@property (nonatomic, strong) CATextLayer * usernameLayer;
@property (nonatomic, strong) CATextLayer * dateLayer;

- (void)changeSlide;

@end

static NSString * PCOOutputScreenChangedNotification = @"PCOOutputScreenChanged";