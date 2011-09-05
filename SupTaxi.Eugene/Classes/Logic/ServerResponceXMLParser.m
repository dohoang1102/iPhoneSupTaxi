//
//  ServerResponceXMLParser.m
//  tvjam
//
//  Created by Eugene Zavalko on 18.07.11.
//  Copyright 2011 EaZySoft. All rights reserved.
//

#import "ServerResponceXMLParser.h"
#import "AditionalPrecompileds.h"

@implementation ServerResponceXMLParser

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
	
	//NSLog(@"\n elementName %@ \n", elementName);
	
	if ([elementName isEqualToString:@"Offer"])
	{
		Offer * offer = [[Offer alloc] initWithCarrierName:[attributeDict objectForKey:@"CarrierName"]
											   arrivalTime:[[attributeDict objectForKey:@"ArrivalTime"] intValue] 
												  minPrice:[[attributeDict objectForKey:@"MinPrice"] intValue] 
												 carrierId:[[attributeDict objectForKey:@"CarrierId"] intValue] 
											carrierLogoStr:[attributeDict objectForKey:@"CarrierLogo"]]; 
		ResponseOffers * response = (ResponseOffers *) [_arr objectAtIndex:0];
		offer.orderId = [response._guid intValue];
		[response addAnOffer:offer];
		[_arr insertObject:response atIndex:0];
		[offer release];
		[response release];
		
	}else if ([elementName isEqualToString:@"Order"])
	{
		Order * order = [[Order alloc] initOrderWithDateTime:[attributeDict objectForKey:@"DateTime"] 
												   fromPlace:[attributeDict objectForKey:@"From"] 
													 toPlace:[attributeDict objectForKey:@"To"] 
													 comment:[attributeDict objectForKey:@"Comment"]
													  status:[[attributeDict objectForKey:@"Status"] boolValue]
														 lat:[[attributeDict valueForKey:@"Lat"] floatValue]
														 lon:[[attributeDict valueForKey:@"Lon"] floatValue] 
													 fromLat:[[attributeDict valueForKey:@"FromLat"] floatValue]
													   toLat:[[attributeDict valueForKey:@"ToLat"] floatValue]
													 fromLon:[[attributeDict valueForKey:@"FromLon"] floatValue]
													   toLon:[[attributeDict valueForKey:@"ToLon"] floatValue]];
		ResponseHistory * response = (ResponseHistory *) [_arr objectAtIndex:0];
		[response addAnOrder:order];
		[_arr insertObject:response atIndex:0];
		[order release];
		[response release];
		
	}else if ([elementName isEqualToString:@"Response"])
	{
		NSString * TypeString = [attributeDict objectForKey:@"Type"];
		BOOL Result = [[attributeDict objectForKey:@"Result"] boolValue];
		NSString * GuidString = [attributeDict objectForKey:@"Guid"];
		
		if ([TypeString isEqualToString:@"Login"]) {
			ResponseLogin * resp = [[ResponseLogin alloc] initWithResponseType:TypeString result:Result andGuid:GuidString];
			resp._wrongPassword = [[attributeDict objectForKey:@"WrongPass"] boolValue];
			resp._firstName = [attributeDict objectForKey:@"FirstName"];
			resp._secondName = [attributeDict objectForKey:@"SecondName"];
			
			[_arr addObject:resp];
			[resp release];
		}else if ([TypeString isEqualToString:@"Order.Offers"]) {
			ResponseOffers * resp = [[ResponseOffers alloc] initWithResponseType:TypeString result:Result andGuid:GuidString];
			resp._status = [[attributeDict objectForKey:@"Status"] boolValue];
			resp._from = [attributeDict objectForKey:@"From"];
			resp._to = [attributeDict objectForKey:@"To"];
			
			[_arr addObject:resp];
			[resp release];
		}else if ([TypeString isEqualToString:@"History"]) {
			ResponseHistory * resp = [[ResponseHistory alloc] init];
			[_arr addObject:resp];
			[resp release];
		}else {
			Response * resp = [[Response alloc] initWithResponseType:TypeString result:Result andGuid:GuidString];
			[_arr addObject:resp];
			[resp release];
		}		
	}
	
	SAFE_REASSIGN(_elementCreatedByName, elementName);

}
- (void) parser:(NSXMLParser *)parser 
 didEndElement:(NSString *)elementName 
  namespaceURI:(NSString *)namespaceURI 
 qualifiedName:(NSString *)qName
{
	
	//TODO: check element
	NSString * elementString = [_elementString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];	
	
	if ([elementName isEqualToString:@"Message"]) 
	{
		NSLog(@"Error message : %@", elementString);
	}
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
