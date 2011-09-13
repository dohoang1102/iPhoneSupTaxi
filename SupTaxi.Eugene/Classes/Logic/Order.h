//
//  Order.h
//  SupTaxi
//
//  Created by Eugene Zavalko on 05.09.11.
//  Copyright 2011 EaZySoft. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Order : NSObject {

}

@property (nonatomic, copy) NSString *dateTime;
@property (nonatomic, copy) NSString *from;
@property (nonatomic, copy) NSString *to;
@property (nonatomic, copy) NSString *comment;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *carrier;
@property (nonatomic, copy) NSString *fromArea;
@property (nonatomic, copy) NSString *toArea;
@property (nonatomic, assign) float lat;
@property (nonatomic, assign) float lon;
@property (nonatomic, assign) float fromLat;
@property (nonatomic, assign) float toLat;
@property (nonatomic, assign) float fromLon;
@property (nonatomic, assign) float toLon;

- (id)initOrderWithDateTime:(NSString *)dateTime fromPlace:(NSString *)fromPlace toPlace:(NSString *)toPlace comment:(NSString *)comment
					 status:(NSString *)status carrier:(NSString *)carrier fromArea:(NSString *)fromArea toArea:(NSString *)toArea lat:(float)lat lon:(float)lon fromLat:(float)fromLat toLat:(float)toLat fromLon:(float)fromLon toLon:(float)toLon ;

@end
