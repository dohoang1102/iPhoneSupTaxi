//
//  ParserClass.h
//  SupTaxi
//
//  Created by naceka on 19.08.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Response;

@interface ParserClass : NSObject {
    
}

// парсинг ответа от сервера на заказ такси
+ (Response *)loadResponseWithData:(NSData *)xmlData;

@end
