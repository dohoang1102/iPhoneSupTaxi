//
//  Response.h
//  SupTaxi
//
//  Created by Eugene Zavalko on 30.08.11.
//  Copyright 2011 EaZySoft. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Response : NSObject {

}

@property (nonatomic, copy) NSString *_responseType;
@property (nonatomic, copy) NSString *_result;
@property (nonatomic, copy) NSString *_guid;

- (id)initWithResponseType:(NSString *)responseType andResult:(NSString *)result;
- (id)initWithResponseType:(NSString *)responseType result:(NSString *)result andGuid:(NSString *)guid;

@end
