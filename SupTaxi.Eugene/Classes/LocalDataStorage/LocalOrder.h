//
//  LocalOrder.h
//  SupTaxi
//
//  Created by Eugene Zavalko on 31.08.11.
//  Copyright 2011 EaZySoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LocalOrder : NSManagedObject {
	
}

@property (nonatomic, retain) NSString * carrierId;
@property (nonatomic, retain) NSString * datetime;
@property (nonatomic, retain) NSString * from_place;
@property (nonatomic, retain) NSString * to_place;
@property (nonatomic, retain) NSString * orderId;
@property (nonatomic, retain) NSNumber * status;
@property (nonatomic, retain) NSNumber * vType;

@end
