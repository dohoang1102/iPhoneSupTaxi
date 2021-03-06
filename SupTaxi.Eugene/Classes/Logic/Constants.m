//
//  Constants.m
//  SupTaxi
//
//  Created by Eugene Zavalko on 08.09.11.
//  Copyright 2011 EaZySoft. All rights reserved.
//

#import "Constants.h"
#import "NSDataAdditions.h"

@implementation Constants

+ (NSString *) historyStatusById:(NSString*)guid
{
	NSMutableDictionary *dict = [[[NSMutableDictionary alloc] init] autorelease];
	[dict setObject:@"Новый" forKey:@"0"];
	[dict setObject:@"Есть предложения" forKey:@"1"];
	[dict setObject:@"Подтверждено предложение" forKey:@"2"];
	[dict setObject:@"Отменен" forKey:@"3"];
	[dict setObject:@"Выполнен" forKey:@"4"];
	
	return [dict objectForKey: guid];
}

+ (UIImage *) getImageFromString: (NSString*) imageStr
{
	if ((imageStr == nil) || [imageStr isEqualToString:@""])return nil;
	NSData *dataObj = [NSData dataWithBase64EncodedString:imageStr];
	UIImage *stringImage = [UIImage imageWithData:dataObj];
	return stringImage;
}

+ (NSString *) getCarTypeString: (NSString *) carId
{
    NSMutableDictionary *dict = [[[NSMutableDictionary alloc] init] autorelease];
	[dict setObject:@"Эконом" forKey:@"1"];
	[dict setObject:@"Грузовые" forKey:@"2"];
	[dict setObject:@"VIP" forKey:@"3"];
	
	return [dict objectForKey: carId];
}

@end
