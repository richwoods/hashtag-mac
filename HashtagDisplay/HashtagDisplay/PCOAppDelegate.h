//
//  PCOAppDelegate.h
//  HashtagDisplay
//
//  Created by Jason Terhorst on 11/3/13.
//  Copyright (c) 2013 Planning Center. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class PCOHashtagOutputWindow;

@interface PCOAppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow * window;

@property (nonatomic, strong) PCOHashtagOutputWindow * outputWindow;

@property (nonatomic, strong) NSMutableArray * posts;
@property (nonatomic, strong) NSTimer * dataUpdateTimer;

- (IBAction)showPreferences:(id)sender;

@end
