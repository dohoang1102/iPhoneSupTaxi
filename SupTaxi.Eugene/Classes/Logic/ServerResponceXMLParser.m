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
	
	NSLog(@"\n elementName %@ \n", elementName);
	
	if ([elementName isEqualToString:@"Address"])
	{
		Address * address = [[Address alloc] initWithId:[[attributeDict objectForKey:@"Id"] intValue]  
                                                    name:[attributeDict objectForKey:@"Name"] 
                                                 address:[attributeDict objectForKey:@"Address"] 
                                             addressArea:[attributeDict objectForKey:@"District"]
                                                    type:[[attributeDict objectForKey:@"Subtype"] intValue]
                                                     lon:[[attributeDict objectForKey:@"Lon"] doubleValue] 
                                                     lat:[[attributeDict objectForKey:@"Lat"] doubleValue]]; 
		ResponseAddress * response = (ResponseAddress *) [_arr objectAtIndex:0];
		[response addAnAddress:address];
        [address release];
		[_arr insertObject:response atIndex:0];		
		
	}else if ([elementName isEqualToString:@"Offer"])
	{
		Offer * offer = [[Offer alloc] initWithCarrierName:[attributeDict objectForKey:@"CarrierName"]
											   arrivalTime:[[attributeDict objectForKey:@"ArrivalTime"] intValue] 
												  minPrice:[[attributeDict objectForKey:@"MinPrice"] intValue] 
												 carrierId:[[attributeDict objectForKey:@"CarrierId"] intValue] 
											carrierLogoStr:[attributeDict objectForKey:@"CarrierLogo"]
                                        carrierDescription:[attributeDict objectForKey:@"CarrierDescription"]]; 
		ResponseOffers * response = (ResponseOffers *) [_arr objectAtIndex:0];
		offer.orderId = [response._guid intValue];
		[response addAnOffer:offer];
		[_arr insertObject:response atIndex:0];
		[offer release];
		
	}else if ([elementName isEqualToString:@"Carrier"])
	{
		Carrier * carrier = [[Carrier alloc] initWithCarrierId:[[attributeDict objectForKey:@"Id"] intValue] 
                                                   carrierName:[attributeDict objectForKey:@"Name"] 
                                                carrierLogoStr:[attributeDict objectForKey:@"Logo"]
                                                   isPreferred:[[attributeDict objectForKey:@"IsPreferred"] boolValue]
                                            carrierDescription:[attributeDict objectForKey:@"Description"]]; 
		ResponsePreferred * response = (ResponsePreferred *) [_arr objectAtIndex:0];
		[response addCarrier:carrier];
		[_arr insertObject:response atIndex:0];
		[carrier release];
		
	}else if ([elementName isEqualToString:@"Order"])
	{
		Order * order = [[Order alloc] initOrderWithDateTime:[attributeDict objectForKey:@"DateTime"] 
												   fromPlace:[attributeDict objectForKey:@"From"] 
													 toPlace:[attributeDict objectForKey:@"To"] 
													 comment:[attributeDict objectForKey:@"Comment"]
													  status:[attributeDict objectForKey:@"Status"]
                                                     carrier:[attributeDict objectForKey:@"Carrier"]
                                                    fromArea:[attributeDict objectForKey:@"FromDistrict"]
                                                      toArea:[attributeDict objectForKey:@"ToDistrict"]
														 lat:[[attributeDict valueForKey:@"Lat"] floatValue]
														 lon:[[attributeDict valueForKey:@"Lon"] floatValue] 
													 fromLat:[[attributeDict valueForKey:@"FromLat"] floatValue]
													   toLat:[[attributeDict valueForKey:@"ToLat"] floatValue]
													 fromLon:[[attributeDict valueForKey:@"FromLon"] floatValue]
													   toLon:[[attributeDict valueForKey:@"ToLon"] floatValue]
                                                  finishedAt:[attributeDict objectForKey:@"FinishedAt"]
                                                    schedule:[attributeDict objectForKey:@"Schedule"]
                                                       vType:[[attributeDict valueForKey:@"VehicleTypeId"] intValue]];
        [order setOrderId:[[attributeDict valueForKey:@"Id"] intValue]];
		ResponseHistory * response = (ResponseHistory *) [_arr objectAtIndex:0];
		[response addAnOrder:order];
		[_arr insertObject:response atIndex:0];
		[order release];
		
	}else if ([elementName isEqualToString:@"Response"])
	{
		NSString * TypeString = [attributeDict objectForKey:@"Type"];
		BOOL Result = [[attributeDict objectForKey:@"Result"] boolValue];
		NSString * GuidString = [attributeDict objectForKey:@"Guid"];
		
		if ([TypeString isEqualToString:@"Login"]) {
			ResponseLogin * resp = [[ResponseLogin alloc] initWithResponseType:TypeString 
																		result:Result 
																		  guid:GuidString 
																		 fName:[attributeDict objectForKey:@"FirstName"] 
																		 sName:[attributeDict objectForKey:@"SecondName"] 
																     wrongPass:[[attributeDict objectForKey:@"WrongPassword"] boolValue]
                                                                          city:[attributeDict objectForKey:@"City"] 
                                                                       cNumber:[attributeDict objectForKey:@"ContractNumber"]
                                                                     cCustomer:[attributeDict objectForKey:@"ContractCustomer"]
                                                                      cCarrier:[attributeDict objectForKey:@"ContractCarrier"]];
			[_arr addObject:resp];
			[resp release];
		}else if ([TypeString isEqualToString:@"Order.Offers"]) {
			ResponseOffers * resp = [[ResponseOffers alloc] initWithResponseType:TypeString 
																		  result:Result 
																			guid:GuidString 
																			from:[attributeDict objectForKey:@"From"] 
																			  to:[attributeDict objectForKey:@"To"] 
																	   andStatus:[[attributeDict objectForKey:@"Status"] boolValue]];												
			[_arr addObject:resp];
			[resp release];
		}else if ([TypeString isEqualToString:@"Addresses.Add"]) {
			ResponseAddress * resp = [[ResponseAddress alloc] initWithResponseType:TypeString 
																			result:Result 
																	  andAddressId:[[attributeDict objectForKey:@"AddressId"] intValue]];	
			[_arr addObject:resp];
			[resp release];
		}else if ([TypeString isEqualToString:@"Addresses.List"]) {
			ResponseAddress * resp = [[ResponseAddress alloc] init];	
			[_arr addObject:resp];
			[resp release];
		}else if ([TypeString isEqualToString:@"Carriers.List"]) {
			ResponsePreferred * resp = [[ResponsePreferred alloc] init];	
			[_arr addObject:resp];
			[resp release];
		}else if ([TypeString isEqualToString:@"History"]) {
			ResponseHistory * resp = [[ResponseHistory alloc] init];
			[resp set_page:[[attributeDict objectForKey:@"Page"] intValue]];
			[resp set_pages:[[attributeDict objectForKey:@"Pages"] intValue]];
			[resp set_onPage:[[attributeDict objectForKey:@"OnPage"] intValue]];
			[resp set_count:[[attributeDict objectForKey:@"Count"] intValue]];
			
			_page = [[attributeDict objectForKey:@"Page"] intValue];
			_pages = [[attributeDict objectForKey:@"Pages"] intValue];
			_onPage = [[attributeDict objectForKey:@"OnPage"] intValue];
			_count = [[attributeDict objectForKey:@"Count"] intValue]; 
			
			[_arr addObject:resp];
			[resp release];
        }else if ([TypeString isEqualToString:@"Nearest.Get"]) {
			ResponseNearestAddress * resp = [[ResponseNearestAddress alloc] initWithResponseType:TypeString andResult:Result];
            if (Result) {
                Address * addr = [[Address alloc] initWithId:[[attributeDict objectForKey:@"Id"] intValue] 
                                                         name:[attributeDict objectForKey:@"Name"] 
                                                      address:[attributeDict objectForKey:@"Address"] 
                                                  addressArea:[attributeDict objectForKey:@"District"] 
                                                         type:[[attributeDict objectForKey:@"Subtype"]intValue] 
                                                          lon:[[attributeDict objectForKey:@"Lon"] doubleValue] 
                                                          lat:[[attributeDict objectForKey:@"Lat"] doubleValue]];
                [resp setAddress:addr];
                [addr release];
            }    
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
	if ([elementName isEqualToString:@"h1"]) 
	{
		NSLog(@"HTML H1 message : %@", elementString);
	}
	if ([elementName isEqualToString:@"p"]) 
	{
		NSLog(@"HTML P message : %@", elementString);
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
	_page = 0;
	_pages = 0;
	_onPage = 0;
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
			
			//requestString = [requestString string stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
			
			NSData *requestData = [NSData dataWithBytes: [requestString UTF8String] length:[requestString length]];
			
			// адрес сервера куда отправляется запрос
			NSString *URLString = [NSString stringWithString:urlString];
			
			NSLog(@"RequestString: %@  \n RequestData %@", requestString, requestData);
			
			NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:URLString]];
			[request setHTTPMethod:@"POST"];// метод отправки запроса
			[request setValue:@"application/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
			[request setHTTPBody:[requestString dataUsingEncoding:NSUTF8StringEncoding]];
			
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

- (NSUInteger) GetPage
{
	return _page;
}
- (NSUInteger) GetPages
{
	return _pages;
}
- (NSUInteger) GetOnPage
{
	return _onPage;
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
		_page = 0;
		_pages = 0;
		_onPage = 0;
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
