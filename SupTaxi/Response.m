//
//  Response.m
//  SupTaxi
//
//  Created by naceka on 19.08.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Response.h"


@implementation Response

@synthesize offers = offers_;

//@synthesize type = type_;
//@synthesize fromPoint = fromPoint_;
//@synthesize toPoint = toPoint_;

- (id)init
{
    self = [super init];
    if (self) {
        offers_ = [[NSMutableArray alloc] init];
        
//        type_ = [[NSString alloc] init];
//        fromPoint_ = [[NSString alloc] init];
//        toPoint_ = [[NSString alloc] init];
    }
    
    return self;
}

- (void)dealloc
{
    [offers_ release];
    
//    [type_ release];
//    [fromPoint_ release];
//    [toPoint_ release];
    
    [super dealloc];
}

@end
