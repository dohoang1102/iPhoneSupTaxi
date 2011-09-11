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
#import "Carrier.h"

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

- (id)initWithResponseType:(NSString *)responseType result:(BOOL)result guid:(NSString *)guid fName:(NSString *)fName sName:(NSString *)sName andWrongPass:(BOOL) wrongPass;

@end

@interface ResponseOffers : Response {
	
}

@property (nonatomic, copy) NSString *_from;
@property (nonatomic, copy) NSString *_to;
@property (nonatomic, assign) BOOL _status;
@property (nonatomic, retain) NSMutableArray * _offers; 

- (id)initWithResponseType:(NSString *)responseType result:(BOOL)result guid:(NSString *)guid from:(NSString *)from to:(NSString *)to andStatus:(BOOL) status;

- (void)addAnOffer:(Offer *)offer;

@end

@interface ResponseHistory : NSObject {
	
}
@property (nonatomic, assign) NSInteger _page;
@property (nonatomic, assign) NSInteger _pages;
@property (nonatomic, assign) NSInteger _onPage;
@property (nonatomic, assign) NSInteger _count;
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

@interface ResponsePreferred : NSObject {
	
}

@property (nonatomic, retain) NSMutableArray * _carriers; 

- (void)addCarrier:(Carrier *)carrier;

@end

