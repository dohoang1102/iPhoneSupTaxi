//
//  ServerResponce.m
//  tvjam
//
//  Created by Eugene Zavalko on 18.07.11.
//  Copyright 2011 EaZySoft. All rights reserved.
//

#import "ServerResponce.h"
#import "ServerResponceXMLParser.h"


@interface ServerResponce(Private)

- (void) Clear;
- (BOOL) ProcessURLString:(NSString*)urlString;

@end



@implementation ServerResponce

- (NSArray *) GetDataItems
{
	return ((NSArray*)_dataItems);
}

- (BOOL) ProcessURLString:(NSString*)urlString
{
	_dataItems = [[NSMutableArray alloc] init];
	if (_dataItems) 
	{
		ServerResponceXMLParser * parser = [[ServerResponceXMLParser alloc] init];
		BOOL rslt = [parser ParseURLString:urlString toArray:_dataItems];
		if (rslt) 
		{
			//_navigateCount = [parser GetCount];
		}
		[parser release];
		return rslt;
	}
	return NO;
}

//Список каналов:
- (BOOL) OffersForOrderRequest:(NSString*)orderID
{
	[self Clear];
	NSString * urlString = [[ServerResponce GetRootURL] 
							stringByAppendingFormat:@""];
	if (urlString) 
	{
		return [self ProcessURLString:urlString];
	}
	return false;
}


- (void) Clear
{
	SAFE_RELEASE(_dataItems);
}

- (id)init
{
	self = [super init];
	if (self)
	{
		_dataItems = nil;
	}
	return self;
}

- (void)dealloc
{
	[self Clear];
	
	[super dealloc];
}

+ (NSString*)GetRootURL
{
	return @"";
}

@end
