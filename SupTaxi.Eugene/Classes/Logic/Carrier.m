//
//  Carrier.m
//  SupTaxi
//
//  Created by Eugene Zavalko on 09.09.11.
//  Copyright 2011 EaZySoft. All rights reserved.
//

#import "Carrier.h"
#import "Constants.h"

@implementation Carrier

@synthesize carrierId;
@synthesize carrierName;
@synthesize carrierLogo;
@synthesize isPreferred;
@synthesize carrierDescription;

- (id)initWithCarrierId:(int)cId carrierName:(NSString *)cName carrierLogoStr:(NSString *)cLogoStr
			isPreferred:(BOOL) cIsPreferred carrierDescription:(NSString*)cDescription
{
	self = [super init];
    if (self != nil) {
        self.carrierId = cId;
        self.carrierName = cName;
        self.carrierLogo = [Constants getImageFromString:cLogoStr];
		self.isPreferred = cIsPreferred;
        self.carrierDescription = cDescription;
	}
	 return self;
}


- (void)dealloc
{	
    [carrierDescription release];
	[carrierName release];
    [carrierLogo release];
    [super dealloc];
}


@end
