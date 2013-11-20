//
//  PCOHashtagPost.m
//  HashtagDisplay
//
//  Created by Jason Terhorst on 11/3/13.
//  Copyright (c) 2013 Planning Center. All rights reserved.
//

#import "PCOHashtagPost.h"

BOOL valueIsNotNull(id object)
{
	if (object)
	{
		if ([object isKindOfClass:[NSNull class]])
		{
			return NO;
		}

		return YES;
	}

	return NO;
};

@implementation PCOHashtagPost

- (id)initWithDictionary:(NSDictionary *)dict
{
	self = [super init];
	if (self)
	{
		if (valueIsNotNull([dict objectForKey:@"id"]))
		{
			[self setRemoteId:[dict objectForKey:@"id"]];
		}

		if (valueIsNotNull([dict objectForKey:@"link"]))
		{
			[self setLink:[dict objectForKey:@"link"]];
		}

		if (valueIsNotNull([dict objectForKey:@"body"]))
		{
			[self setBody:[dict objectForKey:@"body"]];
		}

		if (valueIsNotNull([dict objectForKey:@"image_url"]))
		{
			[self setImageUrl:[dict objectForKey:@"image_url"]];
		}

		if (valueIsNotNull([dict objectForKey:@"network"]))
		{
			switch ([[dict objectForKey:@"network"] integerValue]) {
				case 1:
					self.network = kNetworkTwitter;
					break;
				case 2:
					self.network = kNetworkFacebook;
					break;
				case 3:
					self.network = kNetworkInstagram;
					break;

				default:
					break;
			}
		}

		if (valueIsNotNull([dict objectForKey:@"user_name"]))
		{
			[self setUserName:[dict objectForKey:@"user_name"]];
		}

		if (valueIsNotNull([dict objectForKey:@"real_name"]))
		{
			[self setAltName:[dict objectForKey:@"real_name"]];
		}

		if (valueIsNotNull([dict objectForKey:@"post_date"]))
		{
			NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
			NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
			[formatter setLocale:locale];
			[formatter setDateFormat:@"EEE, dd MMM yyyy HH:mm:ss Z"];
			NSDate * convertedDate = [formatter dateFromString:[dict objectForKey:@"post_date"]];
			[self setPostDate:convertedDate];
		}
	}

	return self;
}

@end
