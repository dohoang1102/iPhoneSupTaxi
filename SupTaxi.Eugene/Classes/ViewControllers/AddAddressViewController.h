//
//  AddAddressViewController.h
//  SupTaxi
//
//  Created by DarkAn on 9/4/11. //Modified my Eugene Zavalko on 06.09.11
//  Copyright 2011 EaZySoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MapViewController.h"
#import "MapViewAddressSearchBar.h"
#import "Address.h"

#import	"Response.h"
#import "PreferencesManager.h"

@interface AddAddressViewController : UIViewController <UIActionSheetDelegate> {
    ResponseAddress	   *_addressResponse;
	PreferencesManager * prefManager;
}

@property (nonatomic, retain) MapViewController *mapController;
@property (nonatomic, retain) MapViewAddressSearchBar *addressSearchBar;

@property (nonatomic, retain) Address *address;

@property (nonatomic, retain) ResponseAddress * _addressResponse;

@end
