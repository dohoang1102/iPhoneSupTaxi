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

- (id)initWithCarrierId:(int)cId carrierName:(NSString *)cName carrierLogoStr:(NSString *)cLogoStr
			isPreferred:(BOOL) cIsPreferred
{
	self = [super init];
    if (self != nil) {
        self.carrierId = cId;
        self.carrierName = cName;
        self.carrierLogo = [Constants getImageFromString:cLogoStr];
		self.isPreferred = cIsPreferred;
	}
	 return self;
}


- (void)dealloc
{	
	[carrierName release];
    [carrierLogo release];
    [super dealloc];
}


@end
