//
//  ServerResponceXMLParser.h
//  tvjam
//
//  Created by Eugene Zavalko on 18.07.11.
//  Copyright 2011 EaZySoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Response.h"

@interface ServerResponceXMLParser : NSObject <NSXMLParserDelegate>
{
@private	
	NSUInteger _page;
	NSUInteger _pages;
	NSUInteger _onPage;
	NSUInteger _count;
	NSInteger _status;
	
	NSString * _elementName;
	NSMutableString * _elementString;
	NSString * _elementCreatedByName;
	
	NSObject * _element;
	NSMutableArray * _arr;
	NSString * _urlString;
}

- (NSUInteger) GetPage;
- (NSUInteger) GetPages;
- (NSUInteger) GetOnPage;
- (NSUInteger) GetCount;
- (NSUInteger) GetStatus;

- (BOOL) ParseURLString:(NSString*)urlString withDataString:(NSString*)requestString toArray:(NSMutableArray*)arr;

@end
