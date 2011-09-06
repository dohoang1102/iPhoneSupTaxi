//
//  Response.h
//  SupTaxi
//
//  Created by Eugene Zavalko on 30.08.11.
//  Copyright 2011 EaZySoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Offer.h"
#import "Order.h"
#import "Address.h"

@interface Response : NSObject {

}

@property (nonatomic, copy) NSString *_responseType;
@property (nonatomic, assign) BOOL _result;
@property (nonatomic, copy) NSString *_guid;

- (id)initWithResponseType:(NSString *)responseType andResult:(BOOL)result;
- (id)initWithResponseType:(NSString *)responseType result:(BOOL)result andGuid:(NSString *)guid;

@end

@interface ResponseLogin : Response {
	
}

@property (nonatomic, copy) NSString *_firstName;
@property (nonatomic, copy) NSString *_secondName;
@property (nonatomic, assign) BOOL _wrongPassword;

@end

@interface ResponseOffers : Response {
	
}

@property (nonatomic, copy) NSString *_from;
@property (nonatomic, copy) NSString *_to;
@property (nonatomic, assign) BOOL _status;
@property (nonatomic, retain) NSMutableArray * _offers; 

- (void)addAnOffer:(Offer *)offer;

@end

@interface ResponseHistory : NSObject {
	
}
@property (nonatomic, retain) NSMutableArray * _orders; 

- (void)addAnOrder:(Order *)order;

@end

@interface ResponseAddress : Response {
	
}

@property (nonatomic, assign) NSInteger _addressId;
@property (nonatomic, retain) NSMutableArray * _addressList; 

- (id)initWithResponseType:(NSString *)responseType result:(BOOL)result andAddressId:(NSInteger)addressId;
- (void)addAnAddress:(Address *)address;

@end
