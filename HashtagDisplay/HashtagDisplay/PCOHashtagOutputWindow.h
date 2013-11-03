//
//  PCOHashtagOutputWindow.h
//  HashtagDisplay
//
//  Created by Jason Terhorst on 11/3/13.
//  Copyright (c) 2013 Planning Center. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface PCOHashtagOutputWindow : NSWindow

- (id)initWithScreenIndex:(NSUInteger)screenIndex;

@property (nonatomic, strong) NSMutableArray * posts;

@property (nonatomic, strong) NSTimer * flipTimer; // timer to change slides

@end

static NSString * PCOOutputScreenChangedNotification = @"PCOOutputScreenChanged";