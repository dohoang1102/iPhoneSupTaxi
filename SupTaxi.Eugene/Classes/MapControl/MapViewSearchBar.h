//
//  MapViewSearchBar.h
//  TestMapView
//
//  Created by DarkAn on 9/3/11.
//  Copyright 2011 DNK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoogleServiceManager.h"
#import "GoogleServiceManagerDelegate.h"
#import "GoogleResultPlacemark.h"
#import "MapViewSearchBarDelegate.h"
#import "MapViewBaseBar.h"

@interface MapViewSearchBar : MapViewBaseBar <UISearchBarDelegate> {
    BOOL searchingAddressFrom;	//true if searching from address, false if to address
}

@property (nonatomic, retain) IBOutlet UISearchBar *placeFrom;
@property (nonatomic, retain) IBOutlet UISearchBar *placeTo;
@property (nonatomic, retain) IBOutlet UILabel *distanceLabel;

@property (nonatomic, retain) GoogleResultPlacemark *placeMarkFrom;
@property (nonatomic, retain) GoogleResultPlacemark *placeMarkTo;

@end
