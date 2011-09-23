//
//  MapViewControllerDelegate.h
//  TestMapView
//
//  Created by DarkAn on 9/3/11.
//  Copyright 2011 DNK. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol MapViewSearchBarDelegate <NSObject>

-(void)showPointsOnMap:(NSArray *)placeMarks shouldResizeMap:(BOOL)shouldResizeMap;
-(void)setSelfLocationSearchEnabled:(BOOL)enabled;

@end
