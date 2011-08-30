//
//  ServerResponceXMLParser.m
//  tvjam
//
//  Created by Eugene Zavalko on 18.07.11.
//  Copyright 2011 EaZySoft. All rights reserved.
//

#import "ServerResponceXMLParser.h"
#import "AditionalPrecompileds.h"

@interface ServerResponceXMLParser(Private)

//- (void)ParseOfferResponseElementName:(NSString *)name withStringValue:(NSString*)value;

@end


@implementation ServerResponceXMLParser
/*
- (void)ParseOfferResponseElementName:(NSString *)name withStringValue:(NSString*)value
{
	
}
*/
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
	
	NSLog(@"\n elementName %@ \n", elementName);
	
	/*NSObject * newObject = [NSObject CreateNewObjectForXMLTag:elementName];
	if (newObject) 
	{
		
		*/
	if ([elementName isEqualToString:@"Offer"])
	{
		
		NSString * CarrierNameString = [attributeDict objectForKey:@"CarrierName"];
		NSString * ArrivalTimeString = [attributeDict objectForKey:@"ArrivalTime"];
		NSString * MinPriceString = [attributeDict objectForKey:@"MinPrice"];
		Offer * e = [[Offer alloc] initWithCarrierName:CarrierNameString arrivalTime:[ArrivalTimeString intValue] minPrice:[MinPriceString intValue]];
		[_arr addObject:e];
		[e release];
		//_element = e;
		
	}else if ([elementName isEqualToString:@"Response"])
	{
		NSString * TypeString = [attributeDict objectForKey:@"Type"];
		NSString * ResultString = [attributeDict objectForKey:@"Result"];
		NSString * GuidString = [attributeDict objectForKey:@"Guid"];
		Response * resp = [[Response alloc] initWithResponseType:TypeString result:ResultString andGuid:GuidString];
		[_arr addObject:resp];
		[resp release];
		//_element = resp;
	}
	
	SAFE_REASSIGN(_elementCreatedByName, elementName);
	//}
}
- (void) parser:(NSXMLParser *)parser 
 didEndElement:(NSString *)elementName 
  namespaceURI:(NSString *)namespaceURI 
 qualifiedName:(NSString *)qName
{
	//TODO: check element
	/*NSString * elementString = [_elementString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];	
	
	if ([elementName isEqualToString:@"Request"]) 
	{
		NSLog(@"Element string : %@", elementString);
	}*/
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


- (BOOL) ParseURLString:(NSString*)urlString withDataString:(NSString*)requestString toArray:(NSMutableArray*)arr
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
			
			NSData *requestData = [NSData dataWithBytes: [requestString UTF8String] length:[requestString length]];
			
			// адрес сервера куда отправляется запрос
			NSString *URLString = [NSString stringWithString:urlString];
			
			NSLog(@"RequestString: %@  \n RequestData %@", requestString, requestData);
			
			NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:URLString]];
			[request setHTTPMethod:@"POST"];// метод отправки запроса
			[request setHTTPBody:requestData];
			
			NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
			
			[request release];
				
			//NSLog(@"\n ResponseData %@", responseData);
			NSXMLParser * parser = [[NSXMLParser alloc] initWithData:responseData];
			//NSXMLParser * parser = [[NSXMLParser alloc] initWithData:[responseData dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES]];
			
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
