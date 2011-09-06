//
//  GoogleServiceManagerDelegate.h
//  TestMapView
//
//  Created by DarkAn on 9/2/11.
//  Copyright 2011 DNK. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol GoogleServiceManagerDelegate <NSObject>

-(void)onRequestFail;
-(void)onCoordinateFound:(id)placeMark;

@end
