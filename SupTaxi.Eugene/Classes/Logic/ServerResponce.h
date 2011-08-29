//
//  ServerResponce.h
//  tvjam
//
//  Created by Eugene Zavalko on 18.07.11.
//  Copyright 2011 EaZySoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ServerResponce : NSObject 
{
@private
	NSMutableArray * _dataItems;
}


- (NSArray *) GetDataItems;


- (BOOL) OffersForOrderRequest:(NSString*)orderID;

+ (NSString *)GetRootURL;


@end






