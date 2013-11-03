//
//  PCOHashtagPost.h
//  HashtagDisplay
//
//  Created by Jason Terhorst on 11/3/13.
//  Copyright (c) 2013 Planning Center. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
	kNetworkTwitter,
	kNetworkFacebook,
	kNetworkInstagram
} PCOHashtagNetwork;

@interface PCOHashtagPost : NSObject

@property (nonatomic, strong) NSNumber * remoteId;
@property (nonatomic, strong) NSString * link;
@property (nonatomic, strong) NSString * body;
@property (nonatomic, strong) NSString * imageUrl;
@property (nonatomic, assign) PCOHashtagNetwork network;
@property (nonatomic, strong) NSString * userName;
@property (nonatomic, strong) NSString * altName;
@property (nonatomic, strong) NSDate * postDate;

- (id)initWithDictionary:(NSDictionary *)dict;

@end
