//
//  Response.m
//  SupTaxi
//
//  Created by Eugene Zavalko on 30.08.11.
//  Copyright 2011 EaZySoft. All rights reserved.
//

#import "Response.h"


@implementation Response

@synthesize _responseType;
@synthesize _result;
@synthesize _guid;

- (id)initWithResponseType:(NSString *)responseType andResult:(NSString *)result{
    self = [super init];
    if (self != nil) {
        self._responseType = responseType;
        self._result = result;
    }
    
    return self;
}

- (id)initWithResponseType:(NSString *)responseType result:(NSString *)result andGuid:(NSString *)guid{
    self = [super init];
    if (self != nil) {
        self._responseType = responseType;
        self._result = result;
		self._guid = guid;
    }
    
    return self;
}

- (void)dealloc
{
    self._responseType = nil;
	self._result = nil;
	self._guid = nil;
    [super dealloc];
}

@end

@implementation ResponseLogin

@synthesize _firstName;
@synthesize _secondName;

- (void)dealloc
{
    self._firstName = nil;
	self._secondName = nil;
    [super dealloc];
}

@end