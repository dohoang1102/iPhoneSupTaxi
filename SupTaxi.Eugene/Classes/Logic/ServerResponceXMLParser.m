//
//  ServerResponceXMLParser.m
//  tvjam
//
//  Created by Eugene Zavalko on 18.07.11.
//  Copyright 2011 EaZySoft. All rights reserved.
//

#import "ServerResponceXMLParser.h"

@interface ServerResponceXMLParser(Private)

- (void)ParseChannelElementName:(NSString *)name withStringValue:(NSString*)value;

@end


@implementation ServerResponceXMLParser

- (void)ParseOfferResponseElementName:(NSString *)name withStringValue:(NSString*)value
{
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
	if (_elementString) 
	{
		[_elementString appendString:string];
    }
	else
	{
		_elementString = [[NSMutableString alloc] initWithString:string];
	}
}

- (void)parser:(NSXMLParser *)parser 
didStartElement:(NSString *)elementName 
  namespaceURI:(NSString *)namespaceURI 
 qualifiedName:(NSString *)qName 
	attributes:(NSDictionary *)attributeDict
{
	SAFE_REASSIGN(_elementName, elementName);
	
	NSObject * newObject = [ResponceObject CreateNewObjectForXMLTag:elementName];
	if (newObject) 
	{
		[_arr addObject:newObject];
		[newObject release];
		_element = newObject;
		
		SAFE_REASSIGN(_elementCreatedByName, elementName);
	}
}

- (void)parser:(NSXMLParser *)parser 
 didEndElement:(NSString *)elementName 
  namespaceURI:(NSString *)namespaceURI 
 qualifiedName:(NSString *)qName
{
	//TODO: check element
	NSString * elementString = [_elementString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];	
	if ([elementName isEqualToString:@"Status"]) 
	{
		_status = [elementString integerValue];
	}
	else if ([elementName isEqualToString:@"Count"])
	{
		_count = (NSUInteger)[elementString integerValue];
	}
	else 
		
		
	if (_element)
	{
		
	}
	
	SAFE_RELEASE(_elementString);
}

- (void)parserDidStartDocument:(NSXMLParser *)parser
{
	NSLog(@"parserDidStartDocument URL=%@", _urlString);
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
	SAFE_RELEASE(_elementName);
	SAFE_RELEASE(_elementString);
	SAFE_RELEASE(_elementCreatedByName);
}


- (BOOL) ParseURLString:(NSString*)urlString toArray:(NSMutableArray*)arr
{
	_count = 0;
	_status = 0;
	_elementName = nil;
	_elementString = nil;
	_element = nil;
	_arr = nil;
	SAFE_REASSIGN(_urlString, urlString);
	if (urlString && arr) 
	{
		NSURL * url = [NSURL URLWithString:urlString];
		if (url)
		{
			[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
			//NSString * str = [NSString stringWithContentsOfURL:url 
			//										  encoding:NSUTF8StringEncoding 
			//											 error:nil];
			NSXMLParser * parser = [[NSXMLParser alloc] initWithContentsOfURL:url];
			//NSXMLParser * parser = [[NSXMLParser alloc] initWithData:[str dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES]];
			
			[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
			
			[parser setDelegate:self];
			BOOL rslt = NO;
			
			@try 
			{
				_arr = [[NSMutableArray alloc] init];
				rslt = [parser parse];
				if (rslt) 
				{
					[arr setArray:_arr];
				}
				
				[_arr release];
			}
			@catch (NSException *exception) 
			{
	
			}
			@finally 
			{
				
			}
			
			[parser release];
			return rslt;
		}
	}
	
	return NO;
}

- (NSUInteger) GetCount
{
	return _count;
}
- (NSUInteger) GetStatus
{
	return _status;
}

- (id)init
{
	self = [super init];
	if (self)
	{
		_count = 0;
		_status = 0;
		_elementName = nil;
		_elementString = nil;
		_element = nil;
		_urlString = nil;
	}
	return self;
}

- (void)dealloc
{
	SAFE_RELEASE(_elementName);
	SAFE_RELEASE(_elementString);
	SAFE_RELEASE(_urlString);
	
	[super dealloc];
}

@end
