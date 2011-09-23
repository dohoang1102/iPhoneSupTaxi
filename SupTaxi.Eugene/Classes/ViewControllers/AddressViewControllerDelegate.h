//
//  AddressViewControllerDelegate.h
//  SupTaxi
//
//  Created by DarkAn on 9/4/11.
//  Copyright 2011 DNK. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol AddressViewControllerDelegate <NSObject>

-(void)onAddressSelected:(id)address;
-(void)onPlaceMarksSelected:(NSArray*)placeMarks;

@end
