//
//  Constants.m
//  SupTaxi
//
//  Created by Eugene Zavalko on 08.09.11.
//  Copyright 2011 EaZySoft. All rights reserved.
//

#import "Constants.h"


@implementation Constants

+ (NSString *) historyStatusById:(NSString*)guid
{
	NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
	[dict setObject:@"Новый" forKey:@"0"];
	[dict setObject:@"Есть предложения" forKey:@"1"];
	[dict setObject:@"Подтверждено предложение" forKey:@"2"];
	[dict setObject:@"Отменен" forKey:@"3"];
	[dict setObject:@"Выполнен" forKey:@"4"];
	
	return [dict objectForKey: guid];
}

@end
