//
//  GoogleServiceDirectionsManagerDelegate.h
//  SupTaxi
//
//  Created by DarkAn on 9/6/11.
//  Copyright 2011 DNK. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol GoogleServiceDirectionsManagerDelegate <NSObject>

-(void)onRoutesCalculated:(NSArray *)routes distance:(NSString *)newDistance time:(NSString *)newTime;
-(void)onRequestFail;

@end
